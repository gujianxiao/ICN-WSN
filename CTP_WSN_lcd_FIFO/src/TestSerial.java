/*									tab:4
 * Copyright (c) 2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

/**
 * Java-side application for testing serial port communication.
 * 
 *
 * @author Phil Levis <pal@cs.berkeley.edu>
 * @date August 12 2005
 */

import java.io.IOException;
import java.util.Random;

import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;

import java.util.HashSet;  
import java.util.Iterator;  
import java.util.Set;  
import java.util.Random;
import java.io.*;


public class TestSerial implements MessageListener {

  private MoteIF moteIF;
  int a[][] = new int[5][2];
  int counter=0;
  
  // public enum dataType{
  //   Light,Temp,Humidity;
  // }
  
  // public enum pktType{
  //   Nouse,Bro,IN,DATA
  // }
  public static int IN=0x02;
  public static int Light=0x00;
  public static int Temp=0x01;
  public static int Humidity=0x02;

  public static int InPkt[][]={{2787,6802,3641,6627,9,9,IN,Light},{4339,7322,4583,6721,6,6,IN,Humidity},{3523,7307,4418,6722,5,5,IN,Light}
  ,{3448,6962,4377,6534,2,2,IN,Temp},{2698,6884,3994,6780,1,1,IN,Humidity},{2769,7047,3136,6770,16,16,IN,Temp},
  {3494,7253,3952,6612,15,15,IN,Light},{3195,7208,4428,6795,13,13,IN,Humidity},{3087,7334,4356,7207,12,12,IN,Humidity}
  ,{2999,7300,3340,7043,10,10,IN,Temp},{3308,6982,4019,6919,3,3,IN,Humidity},{2479,6882,4082,6574,4,4,IN,Temp},
  {3048,6512,3471,6757,7,7,IN,Humidity},{3403,6995,4167,7441,8,8,IN,Light},{3947,7205,4144,7395,15,15,IN,Temp}
  ,{2524,7004,4109,6521,16,16,IN,Humidity},{2553,7162,2986,7084,14,14,IN,Temp},{3161,7139,3656,7110,17,17,IN,Temp},
  {3134,7301,4263,6712,20,20,IN,Temp},{2886,7245,3111,6580,11,11,IN,Humidity},{2586,7332,2957,6881,18,18,IN,Temp},
  {2392,7264,4051,7020,19,19,IN,Light},{3575,7242,3816,7167,21,21,IN,Temp},{2914,7239,3756,6929,22,22,IN,Humidity},
  {2439,7105,4133,6779,23,23,IN,Light},{3677,7321,4548,6558,24,24,IN,Light},{3121,7037,4145,6687,1,1,IN,Humidity}
  ,{2724,7150,4603,6584,2,2,IN,Light},{2279,7126,2303,7093,3,3,IN,Light},{4373,7195,4494,6636,4,4,IN,Light},
  {2923,6885,4185,6514,5,5,IN,Temp},{2625,7075,3811,6913,6,6,IN,Light},{2948,6953,3938,6586,7,7,IN,Temp},
  {2484,6937,4121,6792,8,8,IN,Humidity},{2340,6872,2617,6537,9,9,IN,Temp},{3578,7031,4058,6777,10,10,IN,Humidity}
  ,{3572,7341,4066,7067,11,11,IN,Temp},{2745,6793,4047,6750,12,12,IN,Light},{2844,6810,2876,6661,13,13,IN,Temp},
  {3354,7255,3457,7125,14,14,IN,Humidity},{3028,7306,4499,7174,15,15,IN,Light},{2377,7053,4314,6532,16,16,IN,Humidity}
  ,{3479,7249,3706,7173,17,17,IN,Humidity},{3042,6838,3341,6546,18,18,IN,Temp},{3287,7025,4171,6746,19,19,IN,Light},
  {2315,7318,3701,6782,20,20,IN,Light},{3244,6818,3789,6747,21,21,IN,Humidity},{2811,7085,3105,6828,22,22,IN,Temp},
  {3901,7326,4210,6551,23,23,IN,Light},{2832,7246,4290,7152,10,10,IN,Temp}};

  public static double b[]={
  0.2223,0.1111,0.0741,0.0556,0.0445,0.0370,0.0318,0.0278,0.0247,0.0222,
  0.0202,0.0185,0.0171,0.0159,0.0148,0.0139,0.0131,0.0123,0.0117,0.0111,
  0.0106,0.0101,0.0097,0.0093,0.0089,0.0085,0.0082,0.0079,0.0077,0.0074,
  0.0072,0.0069,0.0067,0.0065,0.0064,0.0062,0.0060,0.0058,0.0057,0.0056,
  0.0054,0.0053,0.0052,0.0051,0.0049,0.0048,0.0047,0.0046,0.0045,0.0044
};
  public TestSerial(MoteIF moteIF) {
    this.moteIF = moteIF;
//    this.moteIF.registerListener(new TestSerialMsg(), this);
    this.moteIF.registerListener(new CTPWSN(), this);
  }

  public static int[] random_pick(int somelist[][],double probabilities[])
  {
      Random rand=new Random();
      double f=rand.nextDouble();
      double cumulative_probability = 0.0;
      int i;
      for(i=0;i<=probabilities.length;i++)
      {
        cumulative_probability+=probabilities[i];
        if (f<cumulative_probability)
          break;
      }MessageListener
      return somelist[i];
  }

  public int set_payload_LL()
  {
    int random = new Random().nextInt(5);
    return random;
  }

  public void sendPackets() {
    int counter = 0;
    // int i = 0;
    // a[0][0] = 2967;
    // a[0][1] = 6919;
    // a[1][0] = 3569;
    // a[1][1] = 6788;
    // a[2][0] = 2806;
    // a[2][1] = 7172;
    // a[3][0] = 2792;
    // a[3][1] = 6985;
    // a[4][0] = 2967;
    // a[4][1] = 6788;
    //TestSerialMsg payload = new TestSerialMsg();
    //System.out.println("in sendPackets");

    CTPWSN payload = new CTPWSN();
    File file = new File("poisson_mu10_500.txt");
    BufferedReader reader = null;
    
    try {
       reader = new BufferedReader(new FileReader(file));
       String tempString = null;
       while ((tempString = reader.readLine()) != null) {
      // while(true){
	       System.out.println("Sending packet " + counter);
         int ChosePkt[]=random_pick(InPkt,b);
	       payload.set_msgType(2);
	       payload.set_leftUp_x(ChosePkt[0]);
	       payload.set_leftUp_y(ChosePkt[1]);
	       payload.set_rightDown_x(ChosePkt[2]);
	       payload.set_rightDown_y(ChosePkt[3]);

         // payload.set_leftUp_x(2967);
         // payload.set_leftUp_y(6919);
         // payload.set_rightDown_x(3569);
         // payload.set_rightDown_y(6788);

	       payload.set_dataType(ChosePkt[7]);
	       payload.set_data(0);
         payload.set_hop((short)0);

         System.out.println("Sending packet  beforedone" + counter);
	//payload.set_counter(counter);
	       moteIF.send(1, payload);
         
         System.out.println("Sending packet  done" + counter);
	//javaSystem.out.println(payload.get_downLeft_Lon());
	       
         counter++;

         double val=Double.valueOf(tempString);
         long val1=(long)val*3200;
         
	       try {Thread.sleep(val1);}
	       catch (InterruptedException exception) {}
      }
       reader.close();
    }
    catch (IOException exception) {
      System.err.println("Exception thrown when sending packets. Exiting.");
      System.err.println(exception);
    }
  }

  public void messageReceived(int to, Message message) {
    
    CTPWSN msg = (CTPWSN)message;
    counter++;
    System.out.println("Received packet sequence number " + counter);
    
  }
  
  private static void usage() {
    System.err.println("usage: TestSerial [-comm <source>]");
  }
  
  public static void main(String[] args) throws Exception {
    String source = null;
 //   Set<int []> listofInts=new HashSet<int[]>();
    if (args.length == 2) {
      if (!args[0].equals("-comm")) {
	  usage();
	  System.exit(1);
      }
      source = args[1];
    }
    else if (args.length != 0) {
      usage();
      System.exit(1);
    }
    
    PhoenixSource phoenix;
    
    if (source == null) {
      phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
    }
    else {
      phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
    }

    MoteIF mif = new MoteIF(phoenix);
    TestSerial serial = new TestSerial(mif);
    serial.sendPackets();
  }

}
