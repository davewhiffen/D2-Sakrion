using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShockCircle : MonoBehaviour
{
    public float time;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine("spawned");
    }

    // Update is called once per frame
    void Update()
    {

    }
    IEnumerator spawned()
    {

        yield return new WaitForSeconds(time);

        Destroy(this.gameObject);
    }
}
