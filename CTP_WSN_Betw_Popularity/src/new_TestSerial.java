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
import java.util.TreeMap;
import java.util.Map.Entry;




public class new_TestSerial implements MessageListener {

  private MoteIF moteIF;
  int a[][] = new int[5][2];
  int counter=0;
  static long[] time_diff=new long[300];
  TreeMap <Integer,WSN_Message> In_pkt = new TreeMap<Integer,WSN_Message>();
  static File delay_file=new File("time_delay.txt");
  int touch_count=0;
  long total_time=0;

  public static int IN=0x02;
  public static int Light=0x00;
  public static int Temp=0x01;
  public static int Humidity=0x02;

  public static int InPkt[][]={{2812,6876,3524,6574,9,9,IN,Light},{3087,7304,3374,6874,6,6,IN,Humidity},{2343,7083,3192,6962,5,5,IN,Light}
  ,{2311,6866,2733,6636,2,2,IN,Temp},{3132,7338,3363,6615,1,1,IN,Humidity},{2386,7286,4591,7019,16,16,IN,Temp},
  {3037,7331,3464,7025,15,15,IN,Light},{2351,7233,3184,6680,13,13,IN,Humidity},{2521,7335,3424,6593,12,12,IN,Humidity}
  ,{3509,7327,4023,6776,10,10,IN,Temp},{2665,6880,3423,6609,3,3,IN,Humidity},{2421,7138,3376,7082,4,4,IN,Temp},
  {2709,7176,4191,7075,7,7,IN,Humidity},{2749,6900,3892,6704,8,8,IN,Light},{33236,7306,4314,7014,15,15,IN,Temp}
  ,{3328,7287,4589,7170,16,16,IN,Humidity},{2374,7141,4167,6725,14,14,IN,Temp},{2426,6929,4149,6857,17,17,IN,Temp},
  {3302,7316,4173,7134,20,20,IN,Temp},{2951,6764,3934,6663,11,11,IN,Humidity},{2474,6922,3271,6745,18,18,IN,Temp},
  {2461,7273,2949,6767,19,19,IN,Light},{2905,6976,3719,6731,21,21,IN,Temp},{2422,7260,2574,7044,22,22,IN,Humidity},
  {3569,7345,4212,6508,23,23,IN,Light},{3037,7328,4127,6993,24,24,IN,Light},{3472,6715,4179,6610,6687,1,1,IN,Humidity}
  ,{2493,7032,3088,6728,2,2,IN,Light},{2354,7253,3182,7126,3,3,IN,Light},{3319,6952,3577,6532,4,4,IN,Light},
  {2865,7010,3291,6838,5,5,IN,Temp},{2515,7167,2948,6812,6,6,IN,Light},{2878,6966,3944,6594,7,7,IN,Temp},
  {3031,6837,3509,6539,8,8,IN,Humidity},{2360,7247,4524,6730,9,9,IN,Temp},{2544,7350,3601,6886,10,10,IN,Humidity}
  ,{2960,6749,3581,6673,11,11,IN,Temp},{2909,7167,3104,6621,12,12,IN,Light},{3500,7315,3806,6670,13,13,IN,Temp},
  {2957,7355,4115,7143,14,14,IN,Humidity},{2896,7015,3550,6567,15,15,IN,Light},{3161,6903,4274,6744,16,16,IN,Humidity}
  ,{2393,7167,2624,6621,17,17,IN,Humidity},{2406,7257,4466,6773,18,18,IN,Temp},{3053,7149,3915,6701,19,19,IN,Light},
  {2437,7051,3414,6802,20,20,IN,Light},{2307,7325,3328,6833,21,21,IN,Humidity},{3371,7002,3806,6565,22,22,IN,Temp},
  {2652,7327,3797,7142,23,23,IN,Light},{4130,7352,4606,6647,10,10,IN,Temp}};

  public static double b[]={
  0.2223,0.1111,0.0741,0.0556,0.0445,0.0370,0.0318,0.0278,0.0247,0.0222,
  0.0202,0.0185,0.0171,0.0159,0.0148,0.0139,0.0131,0.0123,0.0117,0.0111,
  0.0106,0.0101,0.0097,0.0093,0.0089,0.0085,0.0082,0.0079,0.0077,0.0074,
  0.0072,0.0069,0.0067,0.0065,0.0064,0.0062,0.0060,0.0058,0.0057,0.0056,
  0.0054,0.0053,0.0052,0.0051,0.0049,0.0048,0.0047,0.0046,0.0045,0.0044
};
  public new_TestSerial (MoteIF moteIF) {
    this.moteIF = moteIF;
//    this.moteIF.registerListener(new TestSerialMsg(), this);
    this.moteIF.registerListener(new CTPWSN(), this);
  }


  public class WSN_Message{
  public CTPWSN message;
  public boolean touched;

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
      }
      return somelist[i];
  }

  public int set_payload_LL()
  {
    int random = new Random().nextInt(5);
    return random;
  }

  public void sendPackets() {
    CTPWSN payload = new CTPWSN();
    File file = new File("poisson_mu10_500.txt");
    BufferedReader reader = null;
   
    
    try {
       reader = new BufferedReader(new FileReader(file));
       String tempString = null;
       while ((tempString = reader.readLine()) != null) {
      // while(true){
   //      System.out.println("Sending packet " + counter);
         touch_count=0;
         total_time=0;
         int ChosePkt[]=random_pick(InPkt,b);
         WSN_Message tempMsg=new WSN_Message();
         tempMsg.message=new CTPWSN();
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
//         payload.set_hop((short)1);




         tempMsg.message.set_msgType(2);
         tempMsg.message.set_leftUp_x(ChosePkt[0]);
         tempMsg.message.set_leftUp_y(ChosePkt[1]);
         tempMsg.message.set_rightDown_x(ChosePkt[2]);
         tempMsg.message.set_rightDown_y(ChosePkt[3]);
         tempMsg.message.set_dataType(ChosePkt[7]);
         tempMsg.message.set_data(0);
//         tempMsg.message.set_hop((short)0);


         tempMsg.touched=false;
         In_pkt.put(counter,tempMsg);
//         System.out.printf("the In_pkt %d is(%d,%d)/(%d,%d)\n",counter,In_pkt[counter].message.get_leftUp_x(),In_pkt[counter].message.get_leftUp_y(),
//            In_pkt[counter].message.get_rightDown_x(),In_pkt[counter].message.get_rightDown_y());
         moteIF.send(1, payload);
         System.out.printf("the In_pkt"+counter+"  is("+In_pkt.get(counter).message.get_leftUp_x()+","+In_pkt.get(counter).message.get_leftUp_y()+")/("+In_pkt.get(counter).message.get_rightDown_x()+","+In_pkt.get(counter).message.get_rightDown_y()+")\n");
         time_diff[counter]= System.currentTimeMillis(); 
         
//         for(int i=0;i<=counter;i++)
//         {
//            System.out.printf("the In_pkt %d is(%d,%d)/(%d,%d)\n",i,In_pkt[i].message.get_leftUp_x(),In_pkt[i].message.get_leftUp_y(),
//            In_pkt[i].message.get_rightDown_x(),In_pkt[i].message.get_rightDown_y());
//         }
      // Set<Entry<Integer, WSN_Message>> sset =In_pkt.entrySet();
      // for(Entry<Integer, WSN_Message>  entry : sset){
      //   System.out.printf("the In_pkt"+entry.getKey()+"is ("+entry.getValue().message.get_leftUp_x()+","+entry.getValue().message.get_leftUp_y()+")/("+entry.getValue().message.get_rightDown_x()+","+entry.getValue().message.get_rightDown_y()+")\n");
      // }
  //javaSystem.out.println(payload.get_downLeft_Lon());
         for (int k=0;k<=counter;k++)
         {
          if(In_pkt.get(k).touched==true)
          { 
            touch_count++;
            total_time+=time_diff[k];
          }
         }
         System.out.printf("touched packet %d\n",touch_count);
         System.out.printf("total_time:%d\n",total_time);
         counter++;

         double val=Double.valueOf(tempString);
         long val1=(long)val*3000;
         
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

  public boolean is_belong(CTPWSN point,CTPWSN range)
  {
    // System.out.printf("point is (%d,%d)/(%d,%d)\n",point.get_leftUp_x(),point.get_leftUp_y(),
    //   point.get_rightDown_x(),point.get_rightDown_y());
    // System.out.printf("range is (%d,%d)/(%d,%d)\n",range.get_leftUp_x(),range.get_leftUp_y(),
    //   range.get_rightDown_x(),range.get_rightDown_y());
    if(range.get_leftUp_x()<=point.get_leftUp_x()&& range.get_rightDown_x()>=point.get_leftUp_x()
      && range.get_rightDown_y() <=point.get_leftUp_y() && range.get_leftUp_y() >= point.get_leftUp_y())
        return true;
    else 
        return false;
  }

  public void messageReceived(int to, Message message) {
    
    CTPWSN msg = (CTPWSN)message;
    FileWriter fileWritter;
    BufferedWriter bufferWritter;
  try{
    fileWritter = new FileWriter(delay_file.getName(),true);
    bufferWritter = new BufferedWriter(fileWritter);
    // int leftUp_x=msg.get_leftUp_x();
    // int leftUp_y=msg.get_leftUp_y();
    // int rightDown_x=msg.get_rightDown_x();
    // int rightDown_y=msg.get_rightDown_y();
    
  //   System.out.printf("Received packet (%d,%d)/(%d,%d)\n",leftUp_x,leftUp_y,rightDown_x,rightDown_y);
  //   System.out.printf("Received packet is %d\n",msg.get_msgType());
  // //  System.out.printf("Received packet data is %d\n",msg.get_data());
    if(msg.get_msgType()==3){
    for (int k=counter-1;k>=counter-3 && k >=0 ;k--)
    {
     // System.out.printf("the k is %d\n",k);
      if (is_belong(msg,In_pkt.get(k).message))
      {
         if(In_pkt.get(k).touched==false)
         {
           In_pkt.get(k).touched=true;
           long current_time=System.currentTimeMillis();
           // System.out.printf("current time is %d\n",current_time);
           // System.out.printf("start time is %d\n",time_diff[k]);
           time_diff[k]=current_time-time_diff[k];
           System.out.printf("Received packet (%d,%d)/(%d,%d) Belong %d\n",msg.get_leftUp_x(),msg.get_leftUp_y(),msg.get_rightDown_x()
          ,msg.get_rightDown_y(),k);

           System.out.printf("Received packet time_diff is %d\n",time_diff[k]);
 //          System.out.printf("Received packet hop is %d\n",msg.get_hop());
           bufferWritter.write(Long.toString(time_diff[k])+"\t");
           // bufferWritter.write(String.valueOf(msg.get_hop())+"\n");
           bufferWritter.close();
           break;
         }
      }
       else
        ;
        // System.out.printf("Received packet  NOT Belong %d\n",k);
    }
  }
   }catch(IOException e){
    // bufferWritter.write("touched packet "+String.valueOf(touch_count)+"\n");
    // bufferWritter.write("total time "+String.valueOf(total_time)+"\n");
    e.printStackTrace();
   }
  }
  
  private static void usage() {
    System.err.println("usage: TestSerial [-comm <source>]");
  }
  
  public static void main(String[] args) throws Exception {
    String source = null;
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
    new_TestSerial serial = new new_TestSerial(mif);

    
    if(!delay_file.exists())
        delay_file.createNewFile();

    serial.sendPackets();
  }

}