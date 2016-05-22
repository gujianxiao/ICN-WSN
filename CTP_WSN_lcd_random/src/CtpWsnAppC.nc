configuration CtpWsnAppC{
}
implementation{
	components MainC,CtpWsnC;
	components ActiveMessageC;
	
	components new AMSenderC(3);
	
//	components new AMSenderC(7) as dataSend;
	
	components new AMSenderC(4) as topoSend;
	
//	components new AMReceiverC(7) as DataRec;
	components new AMReceiverC(6) as ParentRec;
	components new AMReceiverC(3) as MsgRec;
	//components new AMReceiverC(3) as SetRoot;
	components new AMReceiverC(4) as topoRec;
	
	components new AMReceiverC(5) as InfoRec;
	
  	components new AMSenderC(5) as infoSend;
  	
  	components new AMSenderC(6) as BroSend; 
	
	components CollectionC as Collector;
	
	components new TimerMilliC() as BroTimer;
	components new TimerMilliC() as ReadTimer;
	components new TimerMilliC() as FibTimer;
	components new TimerMilliC() as CsTimer;

	
	components new TimerMilliC() as InfoTimer;
	components new TimerMilliC() as RouterTimer;
	components LedsC;
	
	//components new SensirionSht11C(); //for telosb
	//components new HamamatsuS1087ParC();//for telosb
	components new myPoolC(message_t,30);
	//components new QueueC(message_t*,30);
	components new DemoSensorC(); //for debug 
	
	components SerialStartC;
	components PrintfC; //仿真时不可用，要注释掉
	
	CtpWsnC.Boot -> MainC;
	CtpWsnC.AMControl -> ActiveMessageC;
	CtpWsnC.AMPacket -> AMSenderC;
	CtpWsnC.AMSend -> AMSenderC;
	CtpWsnC.BroTimer -> BroTimer;
	CtpWsnC.CollectionPacket -> Collector;
	CtpWsnC.CtpInfo -> Collector;
	//CtpWsnC.HumidityRead -> SensirionSht11C.Humidity;
	//CtpWsnC.LightRead -> HamamatsuS1087ParC;
	CtpWsnC.MsgRec -> MsgRec;
	CtpWsnC.Packet -> AMSenderC;
	CtpWsnC.ParentRec -> ParentRec;
	CtpWsnC.ReadTimer -> ReadTimer;
	CtpWsnC.RootControl -> Collector;
	CtpWsnC.RoutControl -> Collector;
	//CtpWsnC.TempRead -> SensirionSht11C.Temperature;
	CtpWsnC.FibRefresh -> FibTimer;
	CtpWsnC.CsRefresh -> CsTimer;
	CtpWsnC.InfoSend -> infoSend;
	CtpWsnC.InfoRec -> InfoRec;
	CtpWsnC.InfoTimer -> InfoTimer;
	CtpWsnC.RouterTimer -> RouterTimer;
	CtpWsnC.topoSend -> topoSend;
	CtpWsnC.routeRec -> topoRec;
	CtpWsnC.sendPool -> myPoolC;
	CtpWsnC.FibSend -> AMSenderC;
	CtpWsnC.BroSend -> BroSend;
	
//	CtpWsnC.DataSend->dataSend;
//	CtpWsnC.DataRec->DataRec;
	
	CtpWsnC.Leds -> LedsC;
	
	CtpWsnC.HumidityRead -> DemoSensorC.Read;
	CtpWsnC.LightRead -> DemoSensorC.Read;
	CtpWsnC.TempRead -> DemoSensorC.Read;
}
