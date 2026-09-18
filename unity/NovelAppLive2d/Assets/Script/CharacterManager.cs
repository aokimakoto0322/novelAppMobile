using System.Collections;
using UnityEngine;
using Live2D.Cubism.Rendering;

public class CharacterManager : MonoBehaviour
{
    [SerializeField] private GameObject live2dCharacterObject; // Live2Dのモデルオブジェクト

    private Vector3 defaultPosition;
    private Vector2 defaultAnchoredPosition;
    private Vector3 defaultScale;
    private Coroutine currentEffectCoroutine;
    private CanvasGroup canvasGroup;
    private RectTransform rectTransform;
    private CubismRenderController[] cubismRenderControllers;
    private SpriteRenderer[] spriteRenderers;

    private string activeCharacterName = "";
    private string activeCharacterEffect = "";
    private bool isAnimating = false;

    private void Awake()
    {
        if (live2dCharacterObject != null)
        {
            rectTransform = live2dCharacterObject.GetComponent<RectTransform>();
            if (rectTransform != null)
            {
                defaultAnchoredPosition = rectTransform.anchoredPosition;
            }

            defaultPosition = live2dCharacterObject.transform.localPosition;
            defaultScale = live2dCharacterObject.transform.localScale;

            canvasGroup = live2dCharacterObject.GetComponent<CanvasGroup>();
            if (canvasGroup == null)
            {
                canvasGroup = live2dCharacterObject.AddComponent<CanvasGroup>();
            }

            cubismRenderControllers = live2dCharacterObject.GetComponentsInChildren<CubismRenderController>(true);
            spriteRenderers = live2dCharacterObject.GetComponentsInChildren<SpriteRenderer>(true);

            Debug.Log($"<color=cyan>[CharEffect]</color> Awake -> Object: '{live2dCharacterObject.name}', CubismCtrls: {cubismRenderControllers?.Length ?? 0}");
        }
        else
        {
            Debug.LogError("<color=red>[CharEffect]</color> Awake ERROR: live2dCharacterObject is NOT assigned in Inspector!");
        }
    }

    private void SetAlpha(float alpha)
    {
        if (live2dCharacterObject == null) return;

        if (canvasGroup != null)
        {
            canvasGroup.alpha = alpha;
        }

        if (cubismRenderControllers == null || cubismRenderControllers.Length == 0)
        {
            cubismRenderControllers = live2dCharacterObject.GetComponentsInChildren<CubismRenderController>(true);
        }
        if (cubismRenderControllers != null)
        {
            for (int i = 0; i < cubismRenderControllers.Length; i++)
            {
                if (cubismRenderControllers[i] != null)
                {
                    cubismRenderControllers[i].Opacity = alpha;
                }
            }
        }

        if (spriteRenderers == null || spriteRenderers.Length == 0)
        {
            spriteRenderers = live2dCharacterObject.GetComponentsInChildren<SpriteRenderer>(true);
        }
        if (spriteRenderers != null)
        {
            for (int i = 0; i < spriteRenderers.Length; i++)
            {
                if (spriteRenderers[i] != null)
                {
                    Color c = spriteRenderers[i].color;
                    c.a = alpha;
                    spriteRenderers[i].color = c;
                }
            }
        }
    }

    // WebGL (index.html) の SendMessage から呼ばれるメソッド
    // 引数データ形式: "characterName,effect"
    public void SetCharacterWithEffect(string dataStr)
    {
        Debug.Log($"<color=cyan>[CharEffect]</color> Received from Web: '{dataStr}'");

        if (string.IsNullOrEmpty(dataStr))
        {
            SetCharacter("");
            return;
        }

        string[] parts = dataStr.Split(',');
        string characterName = parts.Length > 0 ? parts[0] : "";
        string effect = parts.Length > 1 ? parts[1] : "";

        PlayCharacterEffect(characterName, effect);
    }

    // 従来互換のメソッド
    public void SetCharacter(string characterName)
    {
        Debug.Log($"<color=cyan>[CharEffect]</color> SetCharacter called with name: '{characterName}'");
        PlayCharacterEffect(characterName, "");
    }

    private bool IsOutEffect(string effect)
    {
        if (string.IsNullOrEmpty(effect)) return false;
        string trimmed = effect.ToLower().Trim();
        return trimmed.EndsWith("_out") ||
               trimmed == "fade_out" ||
               trimmed == "slide_down_out" ||
               trimmed == "slide_left_out" ||
               trimmed == "slide_right_out" ||
               trimmed == "zoom_out" ||
               trimmed == "blur_out";
    }

    private void PlayCharacterEffect(string characterName, string effect)
    {
        if (live2dCharacterObject == null)
        {
            Debug.LogError("<color=red>[CharEffect]</color> ERROR: live2dCharacterObject is Null!");
            return;
        }

        bool isOut = IsOutEffect(effect);

        // 退場エフェクトの場合
        if (isOut)
        {
            // キャラクターが非表示中、またはすでに退場済みの場合
            if (!live2dCharacterObject.activeSelf)
            {
                Debug.Log("<color=yellow>[CharEffect]</color> Out effect requested, but character is already inactive.");
                activeCharacterName = "";
                activeCharacterEffect = "";
                return;
            }

            // ガード処理: すでに退場アニメーション再生中であり、同一の退場エフェクトが連投された場合はキャンセルせずに継続
            if (isAnimating && string.Equals(effect, activeCharacterEffect, System.StringComparison.OrdinalIgnoreCase))
            {
                Debug.Log("<color=orange>[CharEffect]</color> Guard: Ignored duplicate out effect call while animating.");
                return;
            }

            if (currentEffectCoroutine != null) StopCoroutine(currentEffectCoroutine);

            activeCharacterEffect = effect;
            Debug.Log($"<color=green>[CharEffect]</color> Play Out Effect -> Effect: '{effect}'");
            currentEffectCoroutine = StartCoroutine(AnimateEffectOut(effect));
            return;
        }

        // キャラクター名が空で、かつ退場エフェクトでもない場合 -> 即時非表示
        if (string.IsNullOrEmpty(characterName))
        {
            Debug.Log("<color=yellow>[CharEffect]</color> Character name is empty -> Hiding character immediately.");
            if (currentEffectCoroutine != null) StopCoroutine(currentEffectCoroutine);
            isAnimating = false;
            activeCharacterName = "";
            activeCharacterEffect = "";
            live2dCharacterObject.SetActive(false);
            return;
        }

        // ガード処理: 同一キャラクター表示中にアニメーション再生中であり、後続の空エフェクト("")が連投された場合は上書きキャンセルしない！
        if (isAnimating && activeCharacterName == characterName && string.IsNullOrEmpty(effect))
        {
            Debug.Log("<color=orange>[CharEffect]</color> Guard: Ignored empty effect override while animation is playing for same character.");
            return;
        }

        if (currentEffectCoroutine != null)
        {
            StopCoroutine(currentEffectCoroutine);
        }

        activeCharacterName = characterName;
        activeCharacterEffect = effect;
        live2dCharacterObject.SetActive(true);

        Debug.Log($"<color=green>[CharEffect]</color> Play -> Char: '{characterName}', Effect: '{effect}'");

        // 登場エフェクトのコルーチンを開始
        currentEffectCoroutine = StartCoroutine(AnimateEffectIn(effect));
    }

    private void SetPosition(Vector3 pos, Vector2 anchoredPos)
    {
        if (rectTransform != null)
        {
            rectTransform.anchoredPosition = anchoredPos;
        }
        live2dCharacterObject.transform.localPosition = pos;
    }

    private IEnumerator AnimateEffectIn(string effectIn)
    {
        float duration = 0.65f;
        float elapsed = 0f;

        isAnimating = true;

        // 初期状態に確定
        SetPosition(defaultPosition, defaultAnchoredPosition);
        live2dCharacterObject.transform.localScale = defaultScale;

        string trimmedEffect = string.IsNullOrEmpty(effectIn) ? "" : effectIn.ToLower().Trim();

        if (string.IsNullOrEmpty(trimmedEffect) || trimmedEffect == "none")
        {
            SetAlpha(1f);
            Debug.Log("<color=yellow>[CharEffect]</color> No effect specified (Instant display).");
            isAnimating = false;
            yield break;
        }

        // 登場演出の開始時は透明(0f)からスタートする
        SetAlpha(0f);
        Debug.Log($"<color=green>[CharEffect]</color> Starting Animation Routine for: '{trimmedEffect}'");

        // 移動オフセット（UI Canvasかワールド座標かにより調整）
        float offsetX = (rectTransform != null) ? 1200f : 6.0f;
        float offsetY = (rectTransform != null) ? 800f : 4.0f;

        switch (trimmedEffect)
        {
            case "fade_in":
                SetAlpha(0f);
                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    SetAlpha(Mathf.SmoothStep(0f, 1f, t));
                    yield return null;
                }
                break;

            case "slide_up_in":
                Vector3 startPosUp = defaultPosition + new Vector3(0, -offsetY, 0);
                Vector2 startAnchoredUp = defaultAnchoredPosition + new Vector2(0, -offsetY);
                SetAlpha(0f);

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    Vector3 curPos = Vector3.Lerp(startPosUp, defaultPosition, smoothT);
                    Vector2 curAnchored = Vector2.Lerp(startAnchoredUp, defaultAnchoredPosition, smoothT);
                    SetPosition(curPos, curAnchored);

                    SetAlpha(smoothT);
                    yield return null;
                }
                break;

            case "slide_left_in":
                Vector3 startPosLeft = defaultPosition + new Vector3(-offsetX, 0, 0);
                Vector2 startAnchoredLeft = defaultAnchoredPosition + new Vector2(-offsetX, 0);
                SetAlpha(0f);

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    Vector3 curPos = Vector3.Lerp(startPosLeft, defaultPosition, smoothT);
                    Vector2 curAnchored = Vector2.Lerp(startAnchoredLeft, defaultAnchoredPosition, smoothT);
                    SetPosition(curPos, curAnchored);

                    SetAlpha(smoothT);
                    yield return null;
                }
                break;

            case "slide_right_in":
                Vector3 startPosRight = defaultPosition + new Vector3(offsetX, 0, 0);
                Vector2 startAnchoredRight = defaultAnchoredPosition + new Vector2(offsetX, 0);
                SetAlpha(0f);

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    Vector3 curPos = Vector3.Lerp(startPosRight, defaultPosition, smoothT);
                    Vector2 curAnchored = Vector2.Lerp(startAnchoredRight, defaultAnchoredPosition, smoothT);
                    SetPosition(curPos, curAnchored);

                    SetAlpha(smoothT);
                    yield return null;
                }
                break;

            case "zoom_in":
                Vector3 startScale = defaultScale * 0.7f;
                live2dCharacterObject.transform.localScale = startScale;
                SetAlpha(0f);

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    live2dCharacterObject.transform.localScale = Vector3.Lerp(startScale, defaultScale, smoothT);
                    SetAlpha(smoothT);
                    yield return null;
                }
                break;

            case "blur_in":
            case "focus_in":
                Vector3 blurStartScale = defaultScale * 1.15f;
                live2dCharacterObject.transform.localScale = blurStartScale;
                SetAlpha(0f);

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    live2dCharacterObject.transform.localScale = Vector3.Lerp(blurStartScale, defaultScale, smoothT);
                    SetAlpha(smoothT);
                    yield return null;
                }
                break;

            default:
                Debug.LogWarning($"<color=orange>[CharEffect]</color> Unknown effect name: '{trimmedEffect}'");
                break;
        }

        // 演出完了後の最終位置・状態確定
        SetPosition(defaultPosition, defaultAnchoredPosition);
        live2dCharacterObject.transform.localScale = defaultScale;
        SetAlpha(1f);

        isAnimating = false;
        Debug.Log($"<color=green>[CharEffect]</color> Finished Animation for '{effectIn}'");
    }

    private IEnumerator AnimateEffectOut(string effectOut)
    {
        float duration = 0.65f;
        float elapsed = 0f;

        isAnimating = true;

        string trimmedEffect = effectOut.ToLower().Trim();
        Debug.Log($"<color=green>[CharEffect]</color> Starting Out Animation Routine for: '{trimmedEffect}'");

        float offsetX = (rectTransform != null) ? 1200f : 6.0f;
        float offsetY = (rectTransform != null) ? 800f : 4.0f;

        // アニメーション開始直前にアルファを1fに確定
        SetAlpha(1f);

        switch (trimmedEffect)
        {
            case "fade_out":
                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    SetAlpha(Mathf.SmoothStep(1f, 0f, t));
                    yield return null;
                }
                SetAlpha(0f);
                break;

            case "slide_down_out":
                Vector3 targetPosDown = defaultPosition + new Vector3(0, -offsetY, 0);
                Vector2 targetAnchoredDown = defaultAnchoredPosition + new Vector2(0, -offsetY);

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    Vector3 curPos = Vector3.Lerp(defaultPosition, targetPosDown, smoothT);
                    Vector2 curAnchored = Vector2.Lerp(defaultAnchoredPosition, targetAnchoredDown, smoothT);
                    SetPosition(curPos, curAnchored);

                    SetAlpha(Mathf.SmoothStep(1f, 0f, smoothT));
                    yield return null;
                }
                break;

            case "slide_left_out":
                Vector3 targetPosLeft = defaultPosition + new Vector3(-offsetX, 0, 0);
                Vector2 targetAnchoredLeft = defaultAnchoredPosition + new Vector2(-offsetX, 0);

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    Vector3 curPos = Vector3.Lerp(defaultPosition, targetPosLeft, smoothT);
                    Vector2 curAnchored = Vector2.Lerp(defaultAnchoredPosition, targetAnchoredLeft, smoothT);
                    SetPosition(curPos, curAnchored);

                    SetAlpha(Mathf.SmoothStep(1f, 0f, smoothT));
                    yield return null;
                }
                break;

            case "slide_right_out":
                Vector3 targetPosRight = defaultPosition + new Vector3(offsetX, 0, 0);
                Vector2 targetAnchoredRight = defaultAnchoredPosition + new Vector2(offsetX, 0);

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    Vector3 curPos = Vector3.Lerp(defaultPosition, targetPosRight, smoothT);
                    Vector2 curAnchored = Vector2.Lerp(defaultAnchoredPosition, targetAnchoredRight, smoothT);
                    SetPosition(curPos, curAnchored);

                    SetAlpha(Mathf.SmoothStep(1f, 0f, smoothT));
                    yield return null;
                }
                break;

            case "zoom_out":
                Vector3 targetScaleZoom = defaultScale * 0.7f;

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    live2dCharacterObject.transform.localScale = Vector3.Lerp(defaultScale, targetScaleZoom, smoothT);
                    SetAlpha(Mathf.SmoothStep(1f, 0f, smoothT));
                    yield return null;
                }
                break;

            case "blur_out":
                Vector3 targetScaleBlur = defaultScale * 1.15f;

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    live2dCharacterObject.transform.localScale = Vector3.Lerp(defaultScale, targetScaleBlur, smoothT);
                    SetAlpha(Mathf.SmoothStep(1f, 0f, smoothT));
                    yield return null;
                }
                break;

            default:
                Debug.LogWarning($"<color=orange>[CharEffect]</color> Unknown out effect name: '{trimmedEffect}'");
                break;
        }

        // 退場完了処理
        live2dCharacterObject.SetActive(false);
        activeCharacterName = "";
        activeCharacterEffect = "";

        // 次回表示時のために状態をデフォルトにリセット
        SetPosition(defaultPosition, defaultAnchoredPosition);
        live2dCharacterObject.transform.localScale = defaultScale;
        SetAlpha(1f);

        isAnimating = false;
        Debug.Log($"<color=green>[CharEffect]</color> Finished Out Animation for '{effectOut}'");
    }
}