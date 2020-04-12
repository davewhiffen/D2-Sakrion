using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Opsive.UltimateCharacterController.Traits
{
    public class Bullets : MonoBehaviour
    {
        public float speed;
        // Start is called before the first frame update
        public float time;
        Rigidbody rBody;
        CharacterHealth player;
        void Start()
        {
            rBody = GetComponent<Rigidbody>();
            StartCoroutine("DestroySelf");
            player = FindObjectOfType<CharacterHealth>();
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
            if (other.CompareTag("Player"))
            {
                player.gameObject.GetComponent<CharacterHealth>().Damage(5);
                Destroy(this.gameObject);
            }
            else
            {
                Destroy(this.gameObject);
            }
        }

    }
}