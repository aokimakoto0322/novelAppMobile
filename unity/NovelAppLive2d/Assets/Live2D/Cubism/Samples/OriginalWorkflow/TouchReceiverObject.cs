using UnityEngine;
using UnityEngine.UI;

public class TouchReceiverObject : MonoBehaviour
{
    private Text _debugText;

    void Start()
    {
        GameObject textObj = GameObject.Find("DebugText");
        if (textObj != null)
        {
            _debugText = textObj.GetComponent<Text>();
        }

        ShowLog("初期化完了！パラメータ制御準備OK");
    }

    public void OnScreenTouch(string message)
    {
        ShowLog("受信: " + message);

        string[] coords = message.Split(',');
        if (coords.Length == 2)
        {
            if (float.TryParse(coords[0], out float x) && float.TryParse(coords[1], out float y))
            {
                UpdateCharacterGaze(x, y);
            }
        }
    }

    private void UpdateCharacterGaze(float screenX, float screenY)
    {
        float normalizedX = (screenX / 960.0f) * 2.0f - 1.0f;

        // Cubismのパラメータを直接操作する（Valueではなくビルトインの制御用プロパティを更新）
        var parameters = GetComponentsInChildren<Live2D.Cubism.Core.CubismParameter>();
        foreach (var param in parameters)
        {
            if (param.Id == "ParamAngleX")
            {
                // 加算や直接代入がコンポーネントに上書きされないよう、強制的に値を設定する
                param.Value = normalizedX * 30.0f;
            }
            else if (param.Id == "ParamEyeBallX")
            {
                param.Value = normalizedX;
            }
        }

        ShowLog("角度X設定: " + (normalizedX * 30.0f));
    }

    private void ShowLog(string msg)
    {
        Debug.Log("【Unityデバッグ】" + msg);
        if (_debugText != null)
        {
            _debugText.text = msg;
        }
    }
}