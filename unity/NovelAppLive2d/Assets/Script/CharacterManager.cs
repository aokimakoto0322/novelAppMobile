using UnityEngine;

public class CharacterManager : MonoBehaviour
{
    [SerializeField] private GameObject live2dCharacterObject; // Live2Dのモデルオブジェクト

    // WebGL(index.html)の SendMessage から呼ばれるメソッド
    public void SetCharacter(string characterName)
    {
        if (string.IsNullOrEmpty(characterName))
        {
            // 文字列が空の場合はキャラクターを非表示にする
            if (live2dCharacterObject != null)
            {
                live2dCharacterObject.SetActive(false);
            }
        }
        else
        {
            // 文字列が入っている場合はキャラクターを表示する
            if (live2dCharacterObject != null)
            {
                live2dCharacterObject.SetActive(true);
            }

            // 必要に応じて表情やポーズの切り替え処理をここに追加
            // 例: PlayExpression(characterName);
        }
    }
}