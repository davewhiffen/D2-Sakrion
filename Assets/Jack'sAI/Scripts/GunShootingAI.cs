using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Opsive.UltimateCharacterController.Traits
{
    public class GunShootingAI : AI
    {
        public enum States
        {
            Idle,
            Move,
        }
        float dis;
        public States CurrentState { set; get; } = States.Move;
        // Start is called before the first frame update
        void Start()
        {
            speed = 1000;
            StartCoroutine(RunAI());
            this.transform.LookAt(playerController.gameObject.transform);
        }
        void HandleStates()
        {
            StartCoroutine(Timer());
            dis = Vector3.Distance(this.transform.position, playerController.gameObject.transform.position);
            switch (CurrentState)
            {
                case States.Idle:
                    Fire();
                    CoolDownTimer();
                    break;
                case States.Move:
                    MoveForward();
                    Fire();
                    CoolDownTimer();
                    break;
                default:
                    break;
            }


        }
        // Update is called once per frame
        void Update()
        {
            //MoveForward();
            if (dis < 75)
            {
                CurrentState = States.Idle;
            }
            else
                CurrentState = States.Move;
        }
        void MoveForward()
        {
            rBody.velocity = transform.forward * speed * Time.deltaTime;
            if (CoolDownStarted == false)
            {
                StartCoroutine(Rotate());
            }
        }

        IEnumerator RunAI()
        {

            yield return new WaitForSeconds(1f);
            HandleStates();

        }

        IEnumerator Rotate()
        {
            yield return new WaitForSeconds(0.5f);
            this.transform.LookAt(playerController.gameObject.transform);
            StopCoroutine(Rotate());
        }

        void Fire()
        {
            spawnPoint.transform.LookAt(playerController.gameObject.transform);
            if (CoolDownStarted == false)
            {
                Instantiate(spawningAttacks, spawnPoint.transform.position, spawnPoint.transform.rotation);
                cooldown = Random.Range(15, 20);
            }
            StartCoroutine(RunAI());
        }
    }
}