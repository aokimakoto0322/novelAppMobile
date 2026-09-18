using System.Collections;
using UnityEngine;
using UnityEngine.UI;

public class BackgroundManager : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private Image mainBackgroundImage; // 前面：アスペクト比維持用 (Preserve Aspect = true)
    [SerializeField] private Image blurBackgroundImage; // 背面：画面全域埋め用 (Preserve Aspect = false)

    [Header("Data")]
    [SerializeField] private Sprite[] backgroundSprites; // Inspectorで登録する背景画像(Sprite)一覧

    [Header("Transition Settings")]
    [SerializeField] private float fadeDuration = 1.5f; // メイン背景のフェード時間（秒）
    [SerializeField] private float blurFadeLeadTime = 0.3f; // 背面ブラー背景が前面より早くフェード開始/完了する時間（秒）

    private Image overlayMainImage;
    private Image overlayBlurImage;
    private CanvasGroup overlayMainCanvasGroup;
    private CanvasGroup overlayBlurCanvasGroup;
    private Coroutine fadeCoroutine;
    private Sprite blackSprite;
    private string currentImageName = ""; // 現在表示中（またはフェード先）の画像名

    private void Awake()
    {
        InitOverlayImages();
        SetVisible(false);
    }

    private void InitOverlayImages()
    {
        if (mainBackgroundImage != null && overlayMainImage == null)
        {
            GameObject obj = Instantiate(mainBackgroundImage.gameObject, mainBackgroundImage.transform.parent);
            obj.name = mainBackgroundImage.gameObject.name + "_Overlay";
            overlayMainImage = obj.GetComponent<Image>();
            overlayMainCanvasGroup = obj.GetComponent<CanvasGroup>();
            if (overlayMainCanvasGroup == null)
            {
                overlayMainCanvasGroup = obj.AddComponent<CanvasGroup>();
            }
            obj.transform.SetSiblingIndex(mainBackgroundImage.transform.GetSiblingIndex() + 1);
        }

        if (blurBackgroundImage != null && overlayBlurImage == null)
        {
            GameObject obj = Instantiate(blurBackgroundImage.gameObject, blurBackgroundImage.transform.parent);
            obj.name = blurBackgroundImage.gameObject.name + "_Overlay";
            overlayBlurImage = obj.GetComponent<Image>();
            overlayBlurCanvasGroup = obj.GetComponent<CanvasGroup>();
            if (overlayBlurCanvasGroup == null)
            {
                overlayBlurCanvasGroup = obj.AddComponent<CanvasGroup>();
            }
            obj.transform.SetSiblingIndex(blurBackgroundImage.transform.GetSiblingIndex() + 1);
        }

        SetOverlayAlpha(0f, 0f);
        SetOverlayActive(false);
    }

    // Flutterから呼ばれるメソッド
    public void SetBackground(string imageName)
    {
        if (string.IsNullOrEmpty(imageName))
        {
            currentImageName = "";
            SetVisible(false);
            return;
        }

        // 現在表示中（またはフェード先）の画像名と全く同じ場合はクロスフェードを行わずスキップ
        if (string.Equals(currentImageName, imageName, System.StringComparison.OrdinalIgnoreCase))
        {
            return;
        }

        Sprite targetSprite = null;

        // "black" が指定された場合は黒画像を動的に自動生成する
        if (imageName.Equals("black", System.StringComparison.OrdinalIgnoreCase))
        {
            targetSprite = GetOrCreateBlackSprite();
        }
        else if (backgroundSprites != null && backgroundSprites.Length > 0)
        {
            // 配列から名前が一致するSpriteを検索
            targetSprite = System.Array.Find(backgroundSprites, sprite => sprite != null && sprite.name == imageName);
        }

        if (targetSprite != null)
        {
            // 現在の画像名を更新
            currentImageName = imageName;

            // 前のフェードが進行中なら中断し、直前のターゲット画像をベースに確定させてから次を開始
            if (fadeCoroutine != null)
            {
                StopCoroutine(fadeCoroutine);
                fadeCoroutine = null;
                if (overlayMainImage != null && overlayMainImage.sprite != null)
                {
                    ApplySpriteToBase(overlayMainImage.sprite);
                }
                SetOverlayAlpha(0f, 0f);
                SetOverlayActive(false);
            }

            // 初期表示時またはまだ画像が設定されていない場合は即時表示
            if (mainBackgroundImage != null && (!mainBackgroundImage.gameObject.activeSelf || mainBackgroundImage.sprite == null))
            {
                ApplySpriteToBase(targetSprite);
                SetVisible(true);
                SetOverlayAlpha(0f, 0f);
                SetOverlayActive(false);
                return;
            }

            // 背景クロスフェードアニメーションの開始
            fadeCoroutine = StartCoroutine(CrossFadeCoroutine(targetSprite, fadeDuration));
        }
    }

    private Sprite GetOrCreateBlackSprite()
    {
        if (blackSprite == null)
        {
            Texture2D blackTex = new Texture2D(2, 2);
            Color[] pixels = new Color[4];
            for (int i = 0; i < pixels.Length; i++) pixels[i] = Color.black;
            blackTex.SetPixels(pixels);
            blackTex.Apply();
            blackSprite = Sprite.Create(blackTex, new Rect(0, 0, 2, 2), new Vector2(0.5f, 0.5f));
            blackSprite.name = "black";
        }
        return blackSprite;
    }

    private IEnumerator CrossFadeCoroutine(Sprite targetSprite, float duration)
    {
        if (overlayMainImage != null)
        {
            overlayMainImage.sprite = targetSprite;
            overlayMainImage.preserveAspect = true;
        }

        if (overlayBlurImage != null)
        {
            overlayBlurImage.sprite = targetSprite;
            overlayBlurImage.preserveAspect = false;
        }

        SetOverlayAlpha(0f, 0f);
        SetOverlayActive(true);
        SetVisible(true);

        float timer = 0f;
        while (timer < duration)
        {
            timer += Time.deltaTime;

            // メイン背景の進行度
            float mainProgress = Mathf.Clamp01(timer / duration);
            float mainAlpha = Mathf.SmoothStep(0f, 1f, mainProgress);

            // ブラー（背面）背景の進行度（メイン背景より先行して変化させる）
            float blurProgress = Mathf.Clamp01((timer + blurFadeLeadTime) / duration);
            float blurAlpha = Mathf.SmoothStep(0f, 1f, blurProgress);

            SetOverlayAlpha(mainAlpha, blurAlpha);
            yield return null;
        }

        // フェード完了：ベース画像を新しいSpriteへ差し替え、オーバーレイを透明に戻して非アクティブ化
        ApplySpriteToBase(targetSprite);
        SetOverlayAlpha(0f, 0f);
        SetOverlayActive(false);
        fadeCoroutine = null;
    }

    private void ApplySpriteToBase(Sprite sprite)
    {
        if (mainBackgroundImage != null)
        {
            mainBackgroundImage.sprite = sprite;
            mainBackgroundImage.preserveAspect = true;
        }

        if (blurBackgroundImage != null)
        {
            blurBackgroundImage.sprite = sprite;
            blurBackgroundImage.preserveAspect = false;
        }
    }

    private void SetOverlayAlpha(float mainAlpha, float blurAlpha)
    {
        if (overlayMainCanvasGroup != null) overlayMainCanvasGroup.alpha = mainAlpha;
        if (overlayBlurCanvasGroup != null) overlayBlurCanvasGroup.alpha = blurAlpha;
    }

    private void SetOverlayActive(bool active)
    {
        if (overlayMainImage != null) overlayMainImage.gameObject.SetActive(active);
        if (overlayBlurImage != null) overlayBlurImage.gameObject.SetActive(active);
    }

    private void SetVisible(bool visible)
    {
        if (mainBackgroundImage != null) mainBackgroundImage.gameObject.SetActive(visible);
        if (blurBackgroundImage != null) blurBackgroundImage.gameObject.SetActive(visible);
        if (!visible)
        {
            currentImageName = "";
            SetOverlayAlpha(0f, 0f);
            SetOverlayActive(false);
        }
    }
}