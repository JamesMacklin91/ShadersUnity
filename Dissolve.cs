using UnityEngine;
using System.Collections;

public class Dissolve : MonoBehaviour {

    Renderer rend;

	// Use this for initialization
	void Start () {
         rend = GetComponent<Renderer>();
         rend.material.shader = Shader.Find("Custom/Dissolving");
	
	}
	
	// Update is called once per frame
	void Update () {
        
        float sliceAmount = Mathf.PingPong(Time.time, 1.0f);
        rend.material.SetFloat("_SliceAmount", sliceAmount);
	
	}
}
