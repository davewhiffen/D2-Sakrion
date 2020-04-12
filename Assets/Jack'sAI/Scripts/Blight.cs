using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Opsive.UltimateCharacterController.Traits
{
    public class Blight : MonoBehaviour
    {
        GameObject player;
        public GameObject Orb;
        public GameObject charge;
        public GameObject explosion;
        float dis;
        // Start is called before the first frame update
        void Start()
        {
            player = FindObjectOfType<CharacterHealth>().gameObject;
        }

        // Update is called once per frame
        void Update()
        {
            dis = Vector3.Distance(this.transform.position, player.gameObject.transform.position);
            if (dis > 30 && GetComponent<Health>().HealthValue != 0)
            {
                GetComponent<Health>().Heal(20);
            }
            if (GetComponent<Health>().HealthValue == 0) {
                Orb.gameObject.SetActive(false);
                StartCoroutine(Explostion());
            }
        }

        IEnumerator Explostion() {
            charge.SetActive(true);
            yield return new WaitForSeconds(2);
            charge.SetActive(false);
            explosion.SetActive(true);
            StopCoroutine(Explostion());
            StartCoroutine(destroySelf());
        }

        IEnumerator destroySelf()
        {
            yield return new WaitForSeconds(2);
            Destroy(this.gameObject);

        }
    }
}
