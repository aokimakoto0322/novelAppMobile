using UnityEngine;
using UnityEngine.UI;

public class BackgroundManager : MonoBehaviour
{
    [SerializeField] private Image backgroundImage;       // 背景を表示する UI Image
    [SerializeField] private Sprite[] backgroundSprites; // Inspectorで登録する背景画像(Sprite)一覧

    private void Awake()
    {
        // 起動時はとりあえず初期化
        if (backgroundImage != null && backgroundImage.sprite == null)
        {
            backgroundImage.gameObject.SetActive(false);
        }
    }

    // Flutterから呼ばれるメソッド
    public void SetBackground(string imageName)
    {
        Debug.Log($"[BackgroundManager] 受信した画像名: {imageName}");

        if (string.IsNullOrEmpty(imageName))
        {
            if (backgroundImage != null)
            {
                backgroundImage.gameObject.SetActive(false);
            }
            return;
        }

        if (backgroundImage != null)
        {
            backgroundImage.gameObject.SetActive(true);

            if (backgroundSprites != null && backgroundSprites.Length > 0)
            {
                // 配列から名前が一致するSpriteを検索
                Sprite targetSprite = System.Array.Find(backgroundSprites, sprite => sprite != null && sprite.name == imageName);
                
                if (targetSprite != null)
                {
                    backgroundImage.sprite = targetSprite;
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
    }
}