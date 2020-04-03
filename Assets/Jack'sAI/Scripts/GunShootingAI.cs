﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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
        speed = 500;
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
                break;
            case States.Move:
                Fire();
                break;
            default:
                break;
        }


    }
    // Update is called once per frame
    void Update()
    {
        MoveForward();
        if (dis < 75) {
            CurrentState = States.Idle;
        }
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
        CoolDownTimer();
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
        }
    }
}
