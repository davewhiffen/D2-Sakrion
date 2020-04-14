using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class SetActive : MonoBehaviour
{
    public GameObject room;
    public GameObject[] OtherRooms;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            room.SetActive(true);
            for (int i = 0; i < OtherRooms.Length; i++)
            {
                OtherRooms[i].SetActive(false);
            }


        }
    }









    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}


