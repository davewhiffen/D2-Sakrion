using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RopeAttack : MonoBehaviour
{
    PlayerController playerController;
    bool Started;
    float spinx = 0;
    float spiny = 0;
    float spinz = 3;
    // Start is called before the first frame update
    void Start()
    {
        this.transform.rotation = Quaternion.Euler(-90, 0, 0);
        playerController = GameObject.FindWithTag("Player").GetComponent<PlayerController>();

        float initialAngle = 45;
        var rigid = GetComponent<Rigidbody>();

        Vector3 p = playerController.gameObject.transform.position;

        float gravity = Physics.gravity.magnitude;

        float angle = initialAngle * Mathf.Deg2Rad;

        Vector3 planarTarget = new Vector3(p.x, 0, p.z);
        Vector3 planarPostion = new Vector3(transform.position.x, 0, transform.position.z);

        float distance = Vector3.Distance(planarTarget, planarPostion);

        float yOffset = transform.position.y - p.y;

        float initialVelocity = (1 / Mathf.Cos(angle)) * Mathf.Sqrt((0.5f * gravity * Mathf.Pow(distance, 2)) / (distance * Mathf.Tan(angle) + yOffset));

        Vector3 velocity = new Vector3(0, initialVelocity * Mathf.Sin(angle), initialVelocity * Mathf.Cos(angle));


        float angleBetweenObjects = Vector3.Angle(Vector3.forward, planarTarget - planarPostion);
        Vector3 finalVelocity = Quaternion.AngleAxis(angleBetweenObjects, Vector3.up) * velocity;

        rigid.velocity = finalVelocity;
    }
    // Update is called once per frame
    void Update()
    {
        this.transform.Rotate(spinx, spiny, spinz);
        if (Started)
        {
           
            StartCoroutine(DestroySelf());
        }

    }

    IEnumerator DestroySelf()
    {
        yield return new WaitForSeconds(6.0f);
        Destroy(this.gameObject);
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Ground"))
        {
            Started = true;
        }

    }
}
