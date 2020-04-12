using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Opsive.UltimateCharacterController.Traits
{
    public class EletricGrenade : MonoBehaviour
    {
        public GameObject shockCircle;
        public float radius = 20f;
        CharacterHealth playerController;

        // Start is called before the first frame update
        void Start()
        {
            playerController = GameObject.FindWithTag("Player").GetComponent<CharacterHealth>();

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

        }

        IEnumerator SpawnShockCircle()
        {

            yield return new WaitForSeconds(1.0f);

            for (int i = 0; i < 8; i++)
            {
                float angle = i * Mathf.PI * 2f / 8;
                Vector3 newPos = new Vector3((Mathf.Cos(angle) * radius) * 2 + transform.position.x, transform.position.y, (Mathf.Sin(angle) * radius) * 2 + transform.position.z);
                Instantiate(shockCircle, newPos, transform.rotation);
            }
            Destroy(this.gameObject);
        }
        private void OnCollisionEnter(Collision collision)
        {
            if (collision.gameObject.CompareTag("Ground"))
            {
                StartCoroutine("SpawnShockCircle");
            }

        }
    }
}
