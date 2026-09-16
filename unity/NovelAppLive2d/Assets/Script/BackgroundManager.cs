using UnityEngine;
using UnityEngine.UI;

public class BackgroundManager : MonoBehaviour
{
    [Header("UI References")]
    [SerializeField] private Image mainBackgroundImage; // 前面：アスペクト比維持用 (Preserve Aspect = true)
    [SerializeField] private Image blurBackgroundImage; // 背面：画面全域埋め用 (Preserve Aspect = false)

    [Header("Data")]
    [SerializeField] private Sprite[] backgroundSprites; // Inspectorで登録する背景画像(Sprite)一覧

    private void Awake()
    {
        // 起動時は非表示に初期化
        SetVisible(false);
    }

    // Flutterから呼ばれるメソッド
    public void SetBackground(string imageName)
    {
        Debug.Log($"[BackgroundManager] 受信した画像名: {imageName}");

        if (string.IsNullOrEmpty(imageName))
        {
            SetVisible(false);
            return;
        }

        if (backgroundSprites != null && backgroundSprites.Length > 0)
        {
            // 配列から名前が一致するSpriteを検索
            Sprite targetSprite = System.Array.Find(backgroundSprites, sprite => sprite != null && sprite.name == imageName);
            
            if (targetSprite != null)
            {
                // 前面：元のアスペクト比を維持して中央表示 (Fit)
                if (mainBackgroundImage != null)
                {
                    mainBackgroundImage.sprite = targetSprite;
                    mainBackgroundImage.preserveAspect = true;
                }

                // 背面：アスペクト比を無視して画面全域に引き伸ばす (Cover/Fill)
                if (blurBackgroundImage != null)
                {
                    blurBackgroundImage.sprite = targetSprite;
                    blurBackgroundImage.preserveAspect = false;
                }

                SetVisible(true);
                Debug.Log($"[BackgroundManager] 背景画像を '{imageName}' に変更しました！");
            }
            else
            {
                Debug.LogError($"[BackgroundManager] '{imageName}' という名前のSpriteがInspectorの配列に見つかりません！");
            }
        }
        else
        {
            Debug.LogError("[BackgroundManager] Background Sprites の配列が空です！");
        }
    }

    private void SetVisible(bool visible)
    {
        if (mainBackgroundImage != null) mainBackgroundImage.gameObject.SetActive(visible);
        if (blurBackgroundImage != null) blurBackgroundImage.gameObject.SetActive(visible);
    }
}