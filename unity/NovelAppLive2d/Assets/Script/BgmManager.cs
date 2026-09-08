using System.Collections;
using UnityEngine;

public class BgmManager : MonoBehaviour
{
    [SerializeField] private AudioSource audioSource;
    [SerializeField] private AudioClip[] bgmClips;
    [SerializeField] private float fadeDuration = 1.5f; // フェードアウトの時間（秒）

    private Coroutine fadeCoroutine;
    private float defaultVolume = 1.0f;

    private void Awake()
    {
        if (audioSource != null)
        {
            defaultVolume = audioSource.volume;
        }
    }

    // Flutter (index.html) から呼ばれるメソッド
    public void PlayBgm(string bgmName)
    {
        if (string.IsNullOrEmpty(bgmName))
        {
            StopBgm("");
            return;
        }

        if (bgmClips == null || bgmClips.Length == 0 || audioSource == null) return;

        // BGM名に対応するAudioClipを検索
        AudioClip targetClip = System.Array.Find(bgmClips, clip => clip != null && clip.name == bgmName);

        if (targetClip != null)
        {
            // 既に同じ曲が再生中でフェードアウトも行われていない場合はリセットしない
            if (audioSource.clip == targetClip && audioSource.isPlaying && fadeCoroutine == null) return;

            if (fadeCoroutine != null)
            {
                StopCoroutine(fadeCoroutine);
                fadeCoroutine = null;
            }

            audioSource.clip = targetClip;
            audioSource.loop = true;
            audioSource.volume = defaultVolume;
            audioSource.Play();
        }
        else
        {
            Debug.LogWarning($"[BgmManager] Clip not found: {bgmName}");
        }
    }

    // FlutterからBGM停止命令が来た場合に呼ばれるメソッド
    public void StopBgm(string dummy)
    {
        if (audioSource != null && audioSource.isPlaying)
        {
            if (fadeCoroutine != null)
            {
                StopCoroutine(fadeCoroutine);
            }
            fadeCoroutine = StartCoroutine(FadeOutCoroutine(fadeDuration));
        }
    }

    private IEnumerator FadeOutCoroutine(float duration)
    {
        float startVolume = audioSource.volume;
        float timer = 0f;

        while (timer < duration)
        {
            timer += Time.deltaTime;
            audioSource.volume = Mathf.Lerp(startVolume, 0f, timer / duration);
            yield return null;
        }

        audioSource.Stop();
        audioSource.volume = defaultVolume; // 次回再生用に音量を戻しておく
        fadeCoroutine = null;
    }
}