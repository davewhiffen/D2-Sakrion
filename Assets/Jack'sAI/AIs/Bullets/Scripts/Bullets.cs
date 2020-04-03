using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullets : MonoBehaviour
{
    public float speed;
    // Start is called before the first frame update
    public float time;
    Rigidbody rBody;
    void Start()
    {
        rBody = GetComponent<Rigidbody>();
        StartCoroutine("DestroySelf");
    }

    // Update is called once per frame
    void Update()
    {
        rBody.AddForce(transform.forward * speed);
    }
    IEnumerator DestroySelf()
    {

        yield return new WaitForSeconds(time);

        Destroy(this.gameObject);
    }
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player")) {
            //take dmg
            
        }
        Destroy(this.gameObject);
    }

}
