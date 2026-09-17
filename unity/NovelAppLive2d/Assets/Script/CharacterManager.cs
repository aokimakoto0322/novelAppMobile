using System.Collections;
using UnityEngine;

public class CharacterManager : MonoBehaviour
{
    [SerializeField] private GameObject live2dCharacterObject; // Live2Dのモデルオブジェクト

    private Vector3 defaultPosition;
    private Vector2 defaultAnchoredPosition;
    private Vector3 defaultScale;
    private Coroutine currentEffectCoroutine;
    private CanvasGroup canvasGroup;
    private RectTransform rectTransform;

    private string activeCharacterName = "";
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

            Debug.Log($"<color=cyan>[CharEffect]</color> Awake -> Object: '{live2dCharacterObject.name}', defaultPos: {defaultPosition}, defaultAnchoredPos: {defaultAnchoredPosition}");
        }
        else
        {
            Debug.LogError("<color=red>[CharEffect]</color> Awake ERROR: live2dCharacterObject is NOT assigned in Inspector!");
        }
    }

    // WebGL (index.html) の SendMessage から呼ばれるメソッド
    // 引数データ形式: "characterName,effectIn,effectOut"
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
        string effectIn = parts.Length > 1 ? parts[1] : "";
        string effectOut = parts.Length > 2 ? parts[2] : "";

        PlayCharacterEffect(characterName, effectIn, effectOut);
    }

    // 従来互換のメソッド
    public void SetCharacter(string characterName)
    {
        Debug.Log($"<color=cyan>[CharEffect]</color> SetCharacter called with name: '{characterName}'");
        PlayCharacterEffect(characterName, "", "");
    }

    private void PlayCharacterEffect(string characterName, string effectIn, string effectOut)
    {
        if (live2dCharacterObject == null)
        {
            Debug.LogError("<color=red>[CharEffect]</color> ERROR: live2dCharacterObject is Null!");
            return;
        }

        if (string.IsNullOrEmpty(characterName))
        {
            Debug.Log("<color=yellow>[CharEffect]</color> Character name is empty -> Hiding character.");
            if (currentEffectCoroutine != null) StopCoroutine(currentEffectCoroutine);
            isAnimating = false;
            activeCharacterName = "";
            live2dCharacterObject.SetActive(false);
            return;
        }

        // ガード処理: 同一キャラクター表示中にアニメーション再生中であり、後続の空エフェクト("")が連投された場合は上書きキャンセルしない！
        if (isAnimating && activeCharacterName == characterName && string.IsNullOrEmpty(effectIn))
        {
            Debug.Log("<color=orange>[CharEffect]</color> Guard: Ignored empty effect override while animation is playing for same character.");
            return;
        }

        if (currentEffectCoroutine != null)
        {
            StopCoroutine(currentEffectCoroutine);
        }

        activeCharacterName = characterName;
        live2dCharacterObject.SetActive(true);

        Debug.Log($"<color=green>[CharEffect]</color> Play -> Char: '{characterName}', EffectIn: '{effectIn}'");

        // 登場エフェクトのコルーチンを開始
        currentEffectCoroutine = StartCoroutine(AnimateEffectIn(effectIn));
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
        if (canvasGroup != null) canvasGroup.alpha = 1f;

        if (string.IsNullOrEmpty(effectIn) || effectIn == "none")
        {
            Debug.Log("<color=yellow>[CharEffect]</color> No effect specified (Instant display).");
            isAnimating = false;
            yield break;
        }

        string trimmedEffect = effectIn.ToLower().Trim();
        Debug.Log($"<color=green>[CharEffect]</color> Starting Animation Routine for: '{trimmedEffect}'");

        // 移動オフセット（UI Canvasかワールド座標かにより調整）
        float offsetX = (rectTransform != null) ? 500f : 3.0f;
        float offsetY = (rectTransform != null) ? 300f : 2.0f;

        switch (trimmedEffect)
        {
            case "fade_in":
                if (canvasGroup != null) canvasGroup.alpha = 0f;
                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    if (canvasGroup != null) canvasGroup.alpha = Mathf.SmoothStep(0f, 1f, t);
                    yield return null;
                }
                break;

            case "slide_up_in":
                Vector3 startPosUp = defaultPosition + new Vector3(0, -offsetY, 0);
                Vector2 startAnchoredUp = defaultAnchoredPosition + new Vector2(0, -offsetY);
                if (canvasGroup != null) canvasGroup.alpha = 0f;

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    Vector3 curPos = Vector3.Lerp(startPosUp, defaultPosition, smoothT);
                    Vector2 curAnchored = Vector2.Lerp(startAnchoredUp, defaultAnchoredPosition, smoothT);
                    SetPosition(curPos, curAnchored);

                    if (canvasGroup != null) canvasGroup.alpha = smoothT;
                    yield return null;
                }
                break;

            case "slide_left_in":
                Vector3 startPosLeft = defaultPosition + new Vector3(-offsetX, 0, 0);
                Vector2 startAnchoredLeft = defaultAnchoredPosition + new Vector2(-offsetX, 0);
                if (canvasGroup != null) canvasGroup.alpha = 0f;

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    Vector3 curPos = Vector3.Lerp(startPosLeft, defaultPosition, smoothT);
                    Vector2 curAnchored = Vector2.Lerp(startAnchoredLeft, defaultAnchoredPosition, smoothT);
                    SetPosition(curPos, curAnchored);

                    if (canvasGroup != null) canvasGroup.alpha = smoothT;
                    yield return null;
                }
                break;

            case "slide_right_in":
                Vector3 startPosRight = defaultPosition + new Vector3(offsetX, 0, 0);
                Vector2 startAnchoredRight = defaultAnchoredPosition + new Vector2(offsetX, 0);
                if (canvasGroup != null) canvasGroup.alpha = 0f;

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    Vector3 curPos = Vector3.Lerp(startPosRight, defaultPosition, smoothT);
                    Vector2 curAnchored = Vector2.Lerp(startAnchoredRight, defaultAnchoredPosition, smoothT);
                    SetPosition(curPos, curAnchored);

                    if (canvasGroup != null) canvasGroup.alpha = smoothT;
                    yield return null;
                }
                break;

            case "zoom_in":
                Vector3 startScale = defaultScale * 0.7f;
                live2dCharacterObject.transform.localScale = startScale;
                if (canvasGroup != null) canvasGroup.alpha = 0f;

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    live2dCharacterObject.transform.localScale = Vector3.Lerp(startScale, defaultScale, smoothT);
                    if (canvasGroup != null) canvasGroup.alpha = smoothT;
                    yield return null;
                }
                break;

            case "blur_in":
            case "focus_in":
                Vector3 blurStartScale = defaultScale * 1.15f;
                live2dCharacterObject.transform.localScale = blurStartScale;
                if (canvasGroup != null) canvasGroup.alpha = 0f;

                while (elapsed < duration)
                {
                    elapsed += Time.deltaTime;
                    float t = Mathf.Clamp01(elapsed / duration);
                    float smoothT = Mathf.SmoothStep(0f, 1f, t);

                    live2dCharacterObject.transform.localScale = Vector3.Lerp(blurStartScale, defaultScale, smoothT);
                    if (canvasGroup != null) canvasGroup.alpha = smoothT;
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
        if (canvasGroup != null) canvasGroup.alpha = 1f;

        isAnimating = false;
        Debug.Log($"<color=green>[CharEffect]</color> Finished Animation for '{effectIn}'");
    }
}