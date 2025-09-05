using UnityEngine;

public class LampController : MonoBehaviour
{
    Material mat;

    public void Start()
    {
        InitObject();
    }

    private void Update()
    {
        float asdf = Mathf.Sin(Time.time);
        SetLight(asdf);
         Debug.Log( mat.GetFloat("EmissionIntensity"));
    }

    public void InitObject()
    {
        mat = transform.GetChild(0).GetComponent<MeshRenderer>().material;

    }

    public void SetLight(float intensity)
    {
        mat.SetFloat("EmissionIntensity", intensity);
    }

}
