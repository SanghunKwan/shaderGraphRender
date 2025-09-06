using UnityEngine;

public class LampController : MonoBehaviour
{
    Material mat;
    Light lampLight;

    float maxIntensity;
    float maxRange;

    public void Start()
    {
        InitObject();
    }

    private void Update()
    {
        float asdf = Mathf.Abs( Mathf.Sin(Time.time));
        SetLight(asdf);

    }

    public void InitObject()
    {
        mat = transform.GetChild(0).GetComponent<MeshRenderer>().material;
        lampLight = transform.GetChild(1).GetComponent<Light>();

        maxIntensity = lampLight.intensity;
        maxRange = lampLight.range;
    }

    public void SetLight(float intensity)
    {
        mat.SetFloat("_EmissionIntensity", intensity);
        lampLight.intensity = intensity * maxIntensity;
        lampLight.range = intensity * maxRange;
    }

}
