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


public class TestSerial_point implements MessageListener {

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

  public static int InPkt[][]={{2505,7116,2505,7116,9,9,IN,Light},{2505,7116,2505,7116,6,6,IN,Humidity},{2505,7116,2505,7116,5,5,IN,Temp}
  ,{2496,6767,2496,6767,2,2,IN,Temp},{2496,6767,2496,6767,1,1,IN,Humidity},{2496,6767,2496,6767,16,16,IN,Light},
  {2806,7172,2806,7172,15,15,IN,Light},{2806,7172,2806,7172,13,13,IN,Humidity},{2806,7172,2806,7172,12,12,IN,Temp}
  ,{2792,6985,2792,6985,10,10,IN,Light},{2792,6985,2792,6985,3,3,IN,Humidity},{2792,6985,2792,6985,4,4,IN,Temp},
  {2967,6788,2967,6788,7,7,IN,Humidity},{2967,6788,2967,6788,8,8,IN,Light},{2967,6788,2967,6788,15,15,IN,Temp}
  ,{3179,7089,3179,7089,16,16,IN,Humidity},{3179,7089,3179,7089,14,14,IN,Temp},{3179,7089,3179,7089,17,17,IN,Light},
  {3286,6899,3286,6899,20,20,IN,Temp},{3286,6899,3286,6899,11,11,IN,Humidity},{3286,6899,3286,6899,18,18,IN,Light},
  {3264,6674,3264,6674,19,19,IN,Light},{3264,6674,3264,6674,21,21,IN,Temp},{3264,6674,3264,6674,22,22,IN,Humidity},
  {3515, 7186,3515,7186,23,23,IN,Light},{3515, 7186,3515, 7186,24,24,IN,Temp},{3515, 7186,3515, 7186,1,1,IN,Humidity}
  ,{3569, 6919,3569, 6919,2,2,IN,Light},{3569, 6919,3569, 6919,3,3,IN,Temp},{3569, 6919,3569, 6919,4,4,IN,Humidity},
  {4373, 7341,4373, 7341,5,5,IN,Temp},{4373, 7341,4373, 7341,6,6,IN,Light},{4373, 7341,4373, 7341,7,7,IN,Humidity},
  {4490, 6691,4490, 6691,8,8,IN,Light},{4490, 6691,4490, 6691,9,9,IN,Temp},{4490, 6691,4490, 6691,10,10,IN,Humidity}
  ,{4059, 6653,4059, 6653,11,11,IN,Temp},{4059, 6653,4059, 6653,12,12,IN,Light},{4059, 6653,4059, 6653,13,13,IN,Temp},
  {3399, 6615,3399, 6615,14,14,IN,Humidity},{3399, 6615,3399, 6615,15,15,IN,Light},{3399, 6615,3399, 6615,16,16,IN,Humidity}
  ,{3089, 6553,3089, 6553,17,17,IN,Humidity},{3089, 6553,3089, 6553,18,18,IN,Temp},{3089, 6553,3089, 6553,19,19,IN,Light}
  };

  public static double b[]={
  0.2223,0.1111,0.0741,0.0556,0.0445,0.0370,0.0318,0.0278,0.0247,0.0222,
  0.0202,0.0185,0.0171,0.0159,0.0148,0.0139,0.0131,0.0123,0.0117,0.0111,
  0.0106,0.0101,0.0097,0.0093,0.0089,0.0085,0.0082,0.0079,0.0077,0.0074,
  0.0072,0.0069,0.0067,0.0065,0.0064,0.0062,0.0060,0.0058,0.0057,0.0056,
  0.0054,0.0053,0.0052,0.0051,0.0049
};
  public TestSerial_point(MoteIF moteIF) {
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
      for(i=0;i<probabilities.length-1;i++)
      {
        cumulative_probability+=probabilities[i];
        if (f<cumulative_probability)
          break;
      }
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
	  //     System.out.println("Sending packet " + counter);
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

        
	//payload.set_counter(counter);
	       moteIF.send(1, payload);
         System.out.printf("Sending packet (%d,%d)/(%d,%d)/%d\n" ,payload.get_leftUp_x(),payload.get_leftUp_y(),
         payload.get_rightDown_x(),payload.get_rightDown_y(),counter);
	//javaSystem.out.println(payload.get_downLeft_Lon());
	       
         counter++;

         double val=Double.valueOf(tempString);
         long val1=(long)val*3500;
         
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
    int leftUp_x=msg.get_leftUp_x();
    int leftUp_y=msg.get_leftUp_y();
    int rightDown_x=msg.get_rightDown_x();
    int rightDown_y=msg.get_rightDown_y();

  //  System.out.println("Received packet sequence number " + counter);
    System.out.printf("Received packet (%d,%d)/(%d,%d)\n",leftUp_x,leftUp_y,rightDown_x,rightDown_y);
    System.out.printf("Received packet is %d\n",msg.get_msgType());
    System.out.printf("Received packet data is %d\n",msg.get_data());
    
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
    TestSerial_point serial = new TestSerial_point(mif);
    serial.sendPackets();
  }

}
