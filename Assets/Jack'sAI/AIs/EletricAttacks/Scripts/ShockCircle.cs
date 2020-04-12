using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Opsive.UltimateCharacterController.Traits
{
    public class ShockCircle : MonoBehaviour
    {
        public float time;
        PlayerController player;
        // Start is called before the first frame update
        void Start()
        {
            StartCoroutine("spawned");
            player = FindObjectOfType<PlayerController>();
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
        private void OnTriggerEnter(Collider other)
        {
            if (other.CompareTag("Player"))
            {
                player.gameObject.GetComponent<CharacterHealth>().Damage(10);

            }
        }
    }
}
