using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeactivateOnTimer : MonoBehaviour
{
    public float sec = 14f;
    void Start()
    {
       

        StartCoroutine(LateCall());
    }

    IEnumerator LateCall()
    {

        gameObject.SetActive(true);
        //Do Function here...


        yield return new WaitForSeconds(sec);

        gameObject.SetActive(false);
        //Do Function here...
    }




    // Update is called once per frame
    void Update()
    {
        
    }
}
