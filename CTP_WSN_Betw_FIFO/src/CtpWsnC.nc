#include "CTPWSN.h"

module CtpWsnC {

	uses interface Boot;

	uses interface SplitControl as AMControl;
	uses interface StdControl as RoutControl;
	uses interface RootControl;

	uses interface AMPacket;
	uses interface AMSend;
	uses interface Packet;
	
	uses interface Leds;

	uses interface AMSend as topoSend;

	uses interface AMSend as FibSend;
	uses interface AMSend as BroSend;

	uses interface AMSend as DataSend;
	
	uses interface AMSend as InfoSend;
	uses interface Receive as InfoRec;

	uses interface Receive as ParentRec;

	uses interface Receive as MsgRec;
	uses interface Receive as routeRec;
	
	uses interface Receive as DataRec;

	uses interface CollectionPacket;
	uses interface CtpInfo;

	uses interface Read<uint16_t> as LightRead;
	uses interface Read<uint16_t> as TempRead;
	uses interface Read<uint16_t> as HumidityRead;

	uses interface Timer<TMilli> as ReadTimer;
	uses interface Timer<TMilli> as InfoTimer;
	uses interface Timer<TMilli> as BroTimer;
	uses interface Timer<TMilli> as RouterTimer;

	uses interface Timer<TMilli> as FibRefresh;
	uses interface Timer<TMilli> as CsRefresh;

	uses interface myPool<message_t> as sendPool;

}
implementation {

	am_addr_t addr;

	BroMsg * broSend;
	BroMsg * broRec;

	Msg * send;
	Msg * receive;
//	Msg * dataReceive;//DataRec接收数据

	message_t packet; 
//	bool busy=FALSE;
	
	uint8_t fibCount;

	nodeInfo * infoSend;
	nodeInfo * infoRec;

	routerMsg * routerReceive;
	routerMsg * Routersend;

	am_addr_t parent = 0;//节点的父亲节点信息           

	uint8_t fibNum = 0;
	uint8_t fibFlag;
	uint8_t fibMin =3;

	uint8_t csNum = 0;
	uint8_t csFlag;
	uint8_t csMin =3;

	uint8_t flag;

	uint8_t pitNum = 0;
	uint8_t pitFlag;
	uint8_t pitMin =3;

	fibIt fibTable[FIBMAX];
	csIt csTable[CSMAX];
	pitIt pitTable[PITMAX];

	//modify by cb
//	cmIt test;
//	uint8_t mapFlag;
    uint8_t interestCount=0;
    uint8_t allTouchedCount=0;
	uint16_t asCount=0;
	uint16_t arCount=0;
	//end
	
	uint8_t i, j;

	uint16_t LightData;
	uint16_t TempData;
	uint16_t HumidityData;

	uint16_t routerData[10];

	readType currentType = lightType;

	Type type0, type1;
	node thisNode;
	uint16_t data;

	//初始化节点
//	#ifndef DEBUG
	uint8_t k;
//	void node_init();
//	void ability_print(location a);
//	#endif


	void node_init();
	void ability_print(location a);
	void nodeInit() {
		node_init();
		thisNode.nodeAbility = thisNode.nodeLocation;
//		ability_print(thisNode.nodeAbility);
	}

	bool fib_update(am_addr_t Addr, location ability);
	bool cs_query_In(Msg * Rec, message_t * rec);
	bool pit_query_In(Msg * Rec, message_t * rec);
	bool cs_query_Data(Msg * Rec, message_t * rec);
//	bool pit_query_Data(Msg * Rec, message_t * rec);

	/**
	 * 当节点收到一个interest包查询fib表的函数
	 * return：TRUE或FALSE
	 * TRUE：fib表中有相匹配的项目，根据fib条目消息继续转发interest包
	 * FALSE：没有想匹配的项目
	 */
	 
	 task void fib_send() {
//		location a=(receive->msgName).ability;	
//				dbg("fib_send","fib_send: The receive->msgName range:/(%d,%d)/(%d,%d)\n", a.leftUp.x, a.leftUp.y, a
//				.rightDown.x, a.rightDown.y);
				
		while(fibCount < fibNum) {
			if(location_belong((receive->msgName).ability, fibTable[fibCount].fibAbility) || 
			location_belong(fibTable[fibCount].fibAbility, (receive->msgName).ability)
			|| location_across(fibTable[fibCount].fibAbility,(receive->msgName).ability)) {
//				dbg("fib_send","fib_send : fibcount= %d\n",fibCount);
				send = (Msg * )(call Packet.getPayload(&packet, sizeof(Msg)));
				memset(send, 0, sizeof(Msg));
				memcpy(&(send->msgName), &(receive->msgName), sizeof(name));
				send->msgType = IN;
				fibTable[fibCount].weight++;
	//			dbg("fib_send","fib_send : send to %d\n",fibTable[fibCount].goId);
				if(call FibSend.send(fibTable[fibCount].goId, &packet, sizeof(Msg)) == SUCCESS) {
					#ifndef DEBUG
					printf("find the matched item in the fib table,transmit the IN to:%d\n",
							fibTable[fibCount].goId);
				//	printfflush();
					dbg("fib_send","fib_send : send to %d\n",fibTable[fibCount].goId);
					#endif
					return;
				}
				
			}
			fibCount++;
		}
	}

/**
	 * 当节点收到一个data包，查询pit表的函数
	 * return：TRUE或FALSE
	 * TRUE：pit表中有匹配的条目，构造一个data包根据pit表中的条目返回数据
	 * FALSE：没有匹配条目
	 */
   bool	pit_query_Data(Msg* receive,message_t* msg) {
		#ifndef DEBUG
//		printf("query the pit table when get a DATA!\n");
//		printfflush();
		#endif
		for(i = 0; i < pitNum; i++) {
			if(ability_equal((receive->msgName).ability, (pitTable[i].pitName)
					.ability)||location_belong((receive->msgName).ability,(pitTable[i].pitName)
					.ability)) {
				type0 = (receive->msgName).dataType;
				type1 = pitTable[i].pitName.dataType;
				if(type0 == type1) {
//					send = (Msg * )(call Packet.getPayload(rec, sizeof(Msg)));
//					data = ndwRec->data;
//					memset(send, 0, sizeof(Msg));
//					send->data = data;
//					send->msgType = DATA;
//					memcpy(&(send->msgName), &(pitTable[i].pitName), sizeof(name));
					if((call DataSend.send(pitTable[i].comeId, msg, sizeof(Msg))) == SUCCESS) {
						#ifndef DEBUG
						printf("find the matched item in the pit table,transmit the packet to :%d\n", pitTable[i].comeId);
						printfflush();
						#endif
						dbg("DataSend","DataSend : in pit_query_Data,send to parent %d\n",pitTable[i].comeId);
					}
//					j = i;
//					for(j = i; j < pitNum - 1; j++) {
//						pitTable[j] = pitTable[j + 1];
//					}
//					memset(&pitTable[pitNum - 1], 0, sizeof(pitIt));
//					pitNum--;
					return TRUE;
				}
			}
		}
		return FALSE;
	}



	event void Boot.booted() {
		// TODO Auto-generated method stub
		dbg("Boot","Application booted!!!\n");
		call AMControl.start();
		nodeInit();
		call ReadTimer.startPeriodic(READTIME);
	}

	event void AMControl.startDone(error_t error) {
		// TODO Auto-generated method stub
		if(error != SUCCESS) {
			call AMControl.start();
		}
		else {
			call RoutControl.start();
			if(TOS_NODE_ID == 1) {
				call RootControl.setRoot();
			}
			else {
				call RootControl.unsetRoot();
			}
			call BroTimer.startPeriodic(BROTIME);
			call FibRefresh.startPeriodic(FIBTIME);
			call CsRefresh.startPeriodic(CSTIME);
			call InfoTimer.startPeriodic(50000);
			call RouterTimer.startPeriodic(80000);
		}
	}

	event void AMControl.stopDone(error_t error) {
		// TODO Auto-generated method stub
	}

	event void AMSend.sendDone(message_t * msg, error_t error) {
		// TODO Auto-generated method stub 
		if(&packet!=msg)
		{
			asCount++;
			dbg("AMSend","AMSend : AMSend done\n");
		}
		
		//call sendPool.put(msg);
	}
	
	event void DataSend.sendDone(message_t * msg, error_t error) {
		// TODO Auto-generated method stub 
//		if(&packet==msg)
//		{
			asCount++;
			dbg("DataSend","DataSend : DataSend done\n");
//		}
		
		//call sendPool.put(msg);
	}

	event void BroTimer.fired() {
		// TODO Auto-generated method stub
		message_t * broPacket;
		broPacket = call sendPool.get();
		if(broPacket == NULL) {
			call sendPool.refresh();
			broPacket = call sendPool.get();
		}
		broSend = (BroMsg * )(call Packet.getPayload(broPacket, sizeof(BroMsg)));
		broSend->msgType = BRO;
		memcpy(&(broSend->nodeAbility), &(thisNode.nodeAbility), sizeof(location));
		call CtpInfo.getParent(&parent);
		thisNode.parent = parent;
		#ifndef DEBUG
		//printf("The parent is :%d\n", thisNode.parent);
		//printfflush();
		#endif
		dbg("BroTimer","BroTimer : The parent is :%d\n", thisNode.parent);
		if((call BroSend.send(thisNode.parent, broPacket, sizeof(BroMsg))) == SUCCESS) {
		}
	}

	event void FibRefresh.fired() {
		// TODO Auto-generated method stub
		memset(fibTable, 0, sizeof(fibIt) * FIBMAX);
		fibNum = 0;
		thisNode.nodeAbility = thisNode.nodeLocation;
//		ability_print(thisNode.nodeAbility);
		#ifndef DEBUG
//		printf("refresh the fib table!\n");
//		printfflush();
		#endif
		dbg("FibRefresh","FibRefresh : refresh the fib table!\n");
	}

	event void LightRead.readDone(error_t result, uint16_t val) {
		// TODO Auto-generated method stub
		if(result == SUCCESS) {
			LightData = val;
			currentType = humidityType;
			csTable[0].csName.ability = thisNode.nodeLocation;
			csTable[0].csName.dataType = Light;
			csTable[0].weight = 3;
			csTable[0].data = LightData;
			if(csNum == 0) {
				csNum++;
			}
		}
	}

	event void HumidityRead.readDone(error_t result, uint16_t val) {
		// TODO Auto-generated method stub
		if(result == SUCCESS) {
			HumidityData = -4 + 0.0405 * val + (-2.8 / 1000000) * (val * val);
			currentType = tempType;
			csTable[1].csName.ability = thisNode.nodeLocation;
			csTable[1].csName.dataType = Humidity;
			csTable[1].weight = 3;
			csTable[1].data = HumidityData;
			if(csNum == 1) {
				csNum++;
			}
		}
	}

	event void TempRead.readDone(error_t result, uint16_t val) {
		// TODO Auto-generated method stub
		if(result == SUCCESS) {
			TempData = -39.6 + 0.01 * val;
			currentType = lightType;
			csTable[2].csName.ability = thisNode.nodeLocation;
			csTable[2].csName.dataType = Temp;
			csTable[2].weight = 3;
			csTable[2].data = TempData;
			if(csNum == 2) {
				csNum++;
			}
		}
	}

	event void ReadTimer.fired() {
		// TODO Auto-generated method stub
		
		if(currentType == lightType) {
			call LightRead.read();
		}
		if(currentType == humidityType) {
			call HumidityRead.read();
		}
		if(currentType == tempType) {
			call TempRead.read();
		}
	}

	event void CsRefresh.fired() {
		// TODO Auto-generated method stub
		for(i = 3; i < CSMAX; i++) 
			memset(&csTable[i], 0, sizeof(csIt));
		memset(pitTable, 0, sizeof(pitIt) * PITMAX);
		pitNum = 0;
		csNum = 3;
		#ifndef DEBUG
//		printf("refresh the cstable!\n");
//		printfflush();
		#endif
		dbg("CsRefresh","CsRefresh　: refresh the cstable!\n");
	}

	event message_t * ParentRec.receive(message_t * msg, void * payload,
			uint8_t len) {
		// TODO Auto-generated method stub
		arCount++;
		printf("%d node all receive count: %d\n",TOS_NODE_ID,arCount);
		broRec = (BroMsg * ) payload;
		addr = call AMPacket.source(msg);
		if(len == sizeof(BroMsg)) {
			if(broRec->msgType == BRO) {
				location_merge(thisNode.nodeAbility, broRec->nodeAbility, &(thisNode
						.nodeAbility));
				#ifndef DEBUG
				ability_print(thisNode.nodeAbility);
//				printfflush();
				#endif
				fib_update(addr, broRec->nodeAbility);
			}
		}
		return msg;
	}

	event message_t * DataRec.receive(message_t * msg, void * payload,
			uint8_t len) 
	{
		
		message_t * nextRec = NULL;
		addr = call AMPacket.source(msg);
		receive = (Msg * )(payload);
		arCount++;
		printf("%d node all receive count: %d\n",TOS_NODE_ID,arCount);	
//		dbg("DataRec","DataRec : data receive!\n");
		if(len == sizeof(Msg)) {
			if(receive->msgType == DATA) {
				#ifndef DEBUG
				location a=(receive->msgName).ability;
				printf("receive a data Packet!\n");
//				call Leds.led2Toggle();
				
				dbg("DataRec","DataRec: receive a  DATA packet from %d\n",addr);
				dbg("DataRec","DataRec: The DATA's range:/(%d,%d)/(%d,%d)\n", a.leftUp.x, a.leftUp.y, a
				.rightDown.x, a.rightDown.y);
				printf("name:/(%d,%d)/(%d,%d)/%d/\n",
				(receive->msgName).ability.leftUp.x, (receive->msgName).ability.leftUp.y,
						(receive->msgName).ability.rightDown.x, (receive->msgName).ability
						.rightDown.y, (receive->msgName).dataType);
				printf("data:%d\n",receive->data);
				printfflush();
				#endif 
				if(cs_query_Data(receive, msg)) {
					return msg;
				}
				else {
					pit_query_Data(receive,msg) ;
					nextRec = call sendPool.get();
					if(nextRec == NULL) {
						call sendPool.refresh();
						return(call sendPool.get());
					}
					else {
						return nextRec;
					}
				}
			}//==DATA
		}//len
		return msg;
				
	}
	
	

	event message_t * MsgRec.receive(message_t * msg, void * payload,
			uint8_t len) {
		// TODO Auto-generated method stub	
		message_t * nextRec = NULL;
		location a=(receive->msgName).ability;
		addr = call AMPacket.source(msg);
		receive = (Msg * )(payload);
		
		arCount++;
		printf("%d node all receive count: %d\n",TOS_NODE_ID,arCount);	
//		printf("receive a Interest Packet1!\n");
//		printf("The IN's range:/(%d,%d)/(%d,%d)\n", a.leftUp.x, a.leftUp.y, a
//				.rightDown.x, a.rightDown.y);
//				
		
//		printf("len = %d\n",sizeof(Msg));
//		printf("receive IN = %d\n",receive->msgType);
//		printfflush();
//		dbg("MsgRec","MsgRec: receive a packet!!!\n");
//		dbg("MsgRec","IN = %d\n",IN);name msgName;
//		dbg("MsgRec","receive IN = %d\n",receive->msgType);
//		dbg("MsgRec","len = %d\n",len);
//		dbg("MsgRec","sizeof(Msg) = %d\n",sizeof(Msg));
		if(len == sizeof(Msg)) {
			if(receive->msgType == IN) {
				location a=(receive->msgName).ability;
				#ifndef DEBUG
				printf("receive a Interest Packet!\n");
				printf("The IN's range:/(%d,%d)/(%d,%d)\n", a.leftUp.x, a.leftUp.y, a
				.rightDown.x, a.rightDown.y);
				printf("the addr is %d\n",call AMPacket.source(msg));
				printfflush();
//				call Leds.led1Toggle();
				
				dbg("MsgRec","MsgRec: receive a  IN packet!!!\n");
				dbg("MsgRec","MsgRec: The IN's range:/(%d,%d)/(%d,%d)\n", a.leftUp.x, a.leftUp.y, a
				.rightDown.x, a.rightDown.y);
				dbg("MsgRec","MsgRec: the addr is %d\n",call AMPacket.source(msg));
//				ability_print((receive->msgName).ability);
//				printfflush();
				#endif
				if(cs_query_In(receive, msg)) {
					nextRec = call sendPool.get();
					if(nextRec == NULL) {
						call sendPool.refresh();
						return(call sendPool.get());
					}
					else {
						return nextRec;
					}
				}
				else 
					if(pit_query_In(receive, msg)) {
					return msg;
				}
				else {
					for(i = 0; i < fibNum; i++) {
						if(fibTable[i].weight != 0) {
							fibTable[i].weight--;
						}
					}
					fibCount = 0;
					post fib_send();
					return msg;
				}
			}
			
		}
		return msg;
	}
	/**
	 * 添加条目到fib表中，fib初始化函数。
	 * return： FALSE或TRUE
	 * FALSE：如果fib表中已经有这条条目
	 * TRUE：fib表中没有该fib条目，将该消息加入到fib表中
	 */
	bool fib_update(am_addr_t Addr, location ability) {
		for(i = 0; i < fibNum; i++) {
			if(ability_equal(fibTable[i].fibAbility, ability)) {
				return TRUE;
			}
		}
		for(i = 0; i < fibNum; i++)
		{
			if(fibTable[i].goId==addr)
			{
				memset(&fibTable[i], 0, sizeof(fibIt));
				memcpy(&(fibTable[i].fibAbility), &ability, sizeof(location));
				fibTable[i].goId = Addr;
				fibTable[i].weight = 3;
				#ifndef DEBUG
				printf("replace a fib item from %d!,fibNum:%d\n", fibTable[i].goId, i 
					+ 1);
				printf("fib item range is /(%d,%d)/(%d,%d)\n", fibTable[i].fibAbility.leftUp.x,fibTable[i].fibAbility.leftUp.y,
				fibTable[i].fibAbility.rightDown.x,fibTable[i].fibAbility.rightDown.y);
				printfflush();
				#endif
				return TRUE;
			}
		}
		if(fibNum < FIBMAX) {
			memset(&fibTable[fibNum], 0, sizeof(fibIt));
			memcpy(&(fibTable[fibNum].fibAbility), &ability, sizeof(location));
			fibTable[fibNum].goId = Addr;
			fibTable[fibNum].weight = 3;
			#ifndef DEBUG
			printf("add a fib item from %d!,fibNum:%d\n", fibTable[fibNum].goId, fibNum 
					+ 1);
			printf("fib item range is /(%d,%d)/(%d,%d)\n", fibTable[fibNum].fibAbility.leftUp.x,fibTable[fibNum].fibAbility.leftUp.y,
			fibTable[fibNum].fibAbility.rightDown.x,fibTable[fibNum].fibAbility.rightDown.y);
			printfflush();
			#endif
			fibNum++;
		}
		else 
			if(fibNum >= FIBMAX) {
			for(i = 0; i < fibNum; i++) {
				//如果fib表已经满了，删除权值最小的一条条目。
				if(fibTable[i].weight == 0) {
					memset(&fibTable[i], 0, sizeof(fibIt));
					memcpy(&(fibTable[i].fibAbility), &ability, sizeof(location));
					fibTable[i].goId = Addr;
					fibTable[i].weight = 3;
					return FALSE;
				}
				if(fibTable[i].weight < fibMin) {
					fibFlag = i;
					fibMin = fibTable[i].weight;
				}
			}
			memset(&fibTable[fibFlag], 0, sizeof(fibIt));
			memcpy(&(fibTable[fibFlag].fibAbility), &ability, sizeof(location));
			fibTable[fibFlag].goId = Addr;
			fibTable[fibFlag].weight = 3;
			#ifndef DEBUG
			printf("add a fib item from %d!\n", fibTable[fibFlag].goId);
			printfflush();
			#endif
		}
		return FALSE;
	}
	
	task void cs_query_return()
	{
		if(call DataSend.send(addr, &packet, sizeof(Msg)) == SUCCESS) {
						
						dbg("DataSend","DataSend:in cs_query_IN ,find the matched item in cs table!Send the Data msg to %d\n",addr);
						#ifndef DEBUIG
//						printf("find the matched item in cs table!Send the Data msg to %d\n", addr);
//						printf("the data:%d", csTable[i].data);
//						printfflush();
						#endif
						
		}
					
	}
	
	
	/**
	 * 节点收到Interest包，查询cs表的函数。
	 * return：TRUE或FALSE
	 * TRUE：当找到相匹配的cs条目，构造data包返回
	 * FALSE：没有相匹配的条目
	 */
	bool cs_query_In(Msg * Rec, message_t * rec) {
		addr = call AMPacket.source(rec);
		for(i = 0; i < csNum; i++) {
			if(csTable[i].weight != 0) {
				csTable[i].weight--;
			}
		}
		interestCount++;
		for(i = 0; i < csNum; i++) {
			if(ability_equal((Rec->msgName).ability, (csTable[i].csName).ability)
			|| location_belong((csTable[i].csName).ability,(Rec->msgName).ability)) {
				type0 = (Rec->msgName).dataType;
				type1 = csTable[i].csName.dataType;
				if(type1 == type0) {
					
					send = (Msg * )(call Packet.getPayload(&packet , sizeof(Msg)));
					memset(send, 0, sizeof(Msg));
					send->msgType = DATA;
					memcpy(&(send->msgName), &(csTable[i].csName), sizeof(name));
					send->data = csTable[i].data;
					csTable[i].weight++;
					csTable[i].touched++;
                    allTouchedCount++;
                    printf("%d node receive %d Interest been touched %d\n",TOS_NODE_ID,interestCount,allTouchedCount);
					printfflush();
					//modify by cb for lru
					/*for(j=i;j>0;j--)
					{
						memcpy(&(csTable[j].csName), &(csTable[j-1].csName), sizeof(name));
						csTable[j].data = csTable[j-1].data;
						csTable[j].weight =csTable[j-1].weight;
					}
					memcpy(&(csTable[0].csName),&(send->msgName),  sizeof(name));
					csTable[0].data=send->data;
					csTable[0].weight=3;
					*/
					
					//modify end
					
					
					
					
//					if(call DataSend.send(addr, &packet, sizeof(Msg)) == SUCCESS) {
//						
//						dbg("DataSend","DataSend:in cs_query_IN ,find the matched item in cs table!Send the Data msg to %d\n",addr);
						#ifndef DEBUIG
					printf("find the matched item in cs table!Send the Data msg to %d\n", addr);
////						printf("the data:%d", csTable[i].data);
////						printfflush();
						#endif
//						
//					    }
					post cs_query_return();
					return FALSE;
					}
				
			}
		}
		printf("%d node receive %d Interest been touched %d\n",TOS_NODE_ID,interestCount,allTouchedCount);
		printfflush();
		return FALSE;
	}
	/**
	 * 节点收到Interest数据包时，查询pit表的函数
	 * return： TRUE或FALSE
	 * TRUE:pit表中已经有相应的条目，丢弃这个interest包
	 * FALSE：pit表中没有这个条目，将这个条目添加到pit表中
	 */
	bool pit_query_In(Msg * Rec, message_t * rec) {
		addr = call AMPacket.source(rec);
		for(i = 0; i < pitNum; i++) {
			if(pitTable[i].weight != 0) {
				pitTable[i].weight--;
			}
		}
		for(i = 0; i < pitNum; i++) {
			if(ability_equal((Rec->msgName).ability, (pitTable[i].pitName).ability)) {
				type0 = (Rec->msgName).dataType;
				type1 = pitTable[i].pitName.dataType;
				if(type0 == type1) {
					pitTable[i].weight++;
					#ifndef DEBUIG
//					printf("find the matched item in Pit table,discard the Interest packet!\n");
//					printfflush();
					#endif
					return TRUE;
				}
			}
		}
		if(pitNum < PITMAX) {
			memset(&(pitTable[pitNum]), 0, sizeof(pitIt));
			memcpy(&(pitTable[pitNum].pitName), &(Rec->msgName), sizeof(name));
			pitTable[pitNum].comeId = addr;
			pitTable[pitNum].weight = 3;
			#ifndef DEBUG
//			printf("add a new pit item from :%d\n", addr);
//			printfflush();
			#endif
			pitNum++;
		}
		else if(pitNum >= PITMAX) {
			for(i = 0; i < pitNum; i++) {
				if(pitTable[i].weight == 0) {
					memset(&pitTable[i], 0, sizeof(pitIt));
					memcpy(&(pitTable[i].pitName), &(Rec->msgName), sizeof(name));
					pitTable[i].comeId = addr;
					pitTable[i].weight = 3;
					return FALSE;
				}
				if(pitTable[i].weight < pitMin) {
					pitFlag = i;
					pitMin = pitTable[i].weight;
				}
			}
			memset(&pitTable[pitFlag], 0, sizeof(pitIt));
			memcpy(&(pitTable[pitFlag].pitName), &(Rec->msgName), sizeof(name));
			pitTable[pitFlag].comeId = addr;
			pitTable[pitFlag].weight = 3;
		}
		return FALSE;
	}
	/**
	 * 当节点收一条data消息后，查询cs表的函数
	 * return：TRUE或FALSE
	 * TRUE：cs表中已经有相同的条目了，丢弃这条cs消息
	 * FALSE：cs表种没有相应的条目，将该CS保存到cs表中
	 */
	bool cs_query_Data(Msg * ndwRec, message_t * rec) {//leave cache everywhere
		for(i = 0; i < csNum; i++) {
			if(ability_equal((ndwRec->msgName).ability, (csTable[i].csName).ability)) {
				type0 = (ndwRec->msgName).dataType;
				type1 = csTable[i].csName.dataType;
				if(type0 == type1) {
					return TRUE;
					#ifndef DEBUG
//					printf("find the matched item in the cs table,discard the cs packet!\n");
//					printfflush();
					#endif
				}
			}
		}
                if(TOS_NODE_ID!=1) return TRUE;//cache decision algorithm:cache in maxinum betweenness
		

		
		if(csNum < CSMAX) {
			memset(&(csTable[csNum]), 0, sizeof(csIt));
			memcpy(&(csTable[csNum].csName), &(ndwRec->msgName), sizeof(name));
			csTable[csNum].weight = 3;
			csTable[csNum].data = ndwRec->data;
			csNum++;
		}
		if(csNum >= CSMAX) {//cache replacement algorithm：FIFO
			for(i=0;i<CSMAX-1;i){							
				memcpy(&csTable[i],&csTable[i+1],sizeof(csIt));
				csTable[i].data = csTable[i+1].data;
				csTable[i].weight =csTable[i+1].weight;
			}
			memset(&(csTable[CSMAX-1]), 0, sizeof(csIt));
			memcpy(&(csTable[CSMAX-1].csName), &(ndwRec->msgName), sizeof(name));
			csTable[CSMAX-1].data = ndwRec->data;
			csTable[CSMAX-1].weight = 3;
			
			
			
//			for(i=csNum-1;i>0;i--){							
//				memcpy(&csTable[i],&csTable[i-1],sizeof(csIt));
//				csTable[i].data = csTable[i-1].data;
//				csTable[i].weight =csTable[i-1].weight;
//			}			
//			memset(&(csTable[0]), 0, sizeof(csIt));
//			memcpy(&(csTable[0].csName), &(ndwRec->msgName), sizeof(name));
//			csTable[0].data = ndwRec->data;
//			csTable[0].weight = 3;
			
			
//			for(i = 0; i < csNum; i++) {
//				if(csTable[i].weight == 0) {
//					memset(&csTable[i], 0, sizeof(csIt));
//					memcpy(&(csTable[i].csName), &(ndwRec->msgName), sizeof(name));
//					csTable[i].data = ndwRec->data;
//					csTable[i].weight = 3;
//					return FALSE;
//				}
//				if(csTable[i].weight < csMin) {
//					csFlag = i;
//					csMin = csTable[i].weight;
//				}
//			}
//			memset(&csTable[csFlag], 0, sizeof(csIt));
//			memcpy(&(csTable[csFlag].csName), &(ndwRec->msgName), sizeof(name));
//			csTable[csFlag].data = ndwRec->data;
//			csTable[csFlag].weight = 3;
		}
		#ifndef DEBUG
//		printf("add a cs item,csNum:%d\n", csNum);
//		printfflush();
		#endif 
		return FALSE;
	}
	

	#ifndef DBUEG
	location create_location(uint16_t x, uint16_t y) {
		location a;
		point p, q;
		p.x = x;
		p.y = y;
		q.x = x;
		q.y = y;
		a.leftUp = p;
		a.rightDown = q;
		return a;
	}

	void node_init() {
		switch(TOS_NODE_ID) {
			case(1) : thisNode.nodeLocation = create_location(2505,7116);
			break;
			case(2) : thisNode.nodeLocation = create_location(2496,6767);
			break;
			case(3) : thisNode.nodeLocation = create_location(2806,7172);
			break;
			case(4) : thisNode.nodeLocation = create_location(2792,6985);
			break;
			case(5) : thisNode.nodeLocation = create_location(2967,6788);
			break;
			case(6) : thisNode.nodeLocation = create_location(3179,7089);
			break;
			case(7) : thisNode.nodeLocation = create_location(3286,6899);
			break;
			case(8) : thisNode.nodeLocation = create_location(3264,6674);
			break;
			case(9) : thisNode.nodeLocation = create_location(3515, 7186);
			break;
			case(10) : thisNode.nodeLocation = create_location(3569, 6919);
			break;
			case(11) : thisNode.nodeLocation = create_location(4373, 7341);
			break;
			case(12) : thisNode.nodeLocation = create_location(4490, 6691);
			break;
			case(13) : thisNode.nodeLocation = create_location(4059, 6653);
			break;
			case(14) : thisNode.nodeLocation = create_location(3399, 6615);
			break;
			case(15) : thisNode.nodeLocation = create_location(3089, 6553);
			break;
			case(16) : thisNode.nodeLocation = create_location(2276, 6567);
			break;
			case(17) : thisNode.nodeLocation = create_location(2240, 7331);
			break;
			case(18) : thisNode.nodeLocation = create_location(3219, 7365);
			break;
			case(19) : thisNode.nodeLocation = create_location(4607, 6563);
			break;
			case(20) : thisNode.nodeLocation = create_location(2213, 6508);
			break;
//			case(21) : thisNode.nodeLocation = create_location(21, 10);
//			break;
//			case(22) : thisNode.nodeLocation = create_location(22, 10);
//			break;
//			case(23) : thisNode.nodeLocation = create_location(23, 10);
//			break;
//			case(24) : thisNode.nodeLocation = create_location(24, 10);
//			break;
//			case(25) : thisNode.nodeLocation = create_location(25, 10);
//			break;
//			case(26) : thisNode.nodeLocation = create_location(26, 10);
//			break;
//			case(27) : thisNode.nodeLocation = create_location(27, 10);
//			break;
//			case(28) : thisNode.nodeLocation = create_location(28, 10);
//			break;
//			case(29) : thisNode.nodeLocation = create_location(29, 10);
//			break;
//			case(30) : thisNode.nodeLocation = create_location(30, 10);
//			break;
		}
	}

	void ability_print(location a) {
//		printf("The node's ability:/(%d,%d)/(%d,%d)\n", a.leftUp.x, a.leftUp.y, a
//				.rightDown.x, a.rightDown.y);
//		printfflush();
		dbg("ability_print","The node's ability:/(%d,%d)/(%d,%d)\n", a.leftUp.x, a.leftUp.y, a
				.rightDown.x, a.rightDown.y);
	}
	#endif

	event void InfoTimer.fired() {
		// TODO Auto-generated method stub
		message_t * infomsg = call sendPool.get();
		if(infomsg == NULL) {
			call sendPool.refresh();
			infomsg = call sendPool.get();
		}
		if(infomsg) {
			infoSend = (nodeInfo * )(call Packet.getPayload(infomsg, sizeof(nodeInfo)));
			memset(infoSend, 0, sizeof(nodeInfo));
			infoSend->type = Info;
			infoSend->nodeId = TOS_NODE_ID;
			memcpy(&(infoSend->nodeLocation), &(thisNode.nodeLocation),sizeof(location));
			if(TOS_NODE_ID != 1) {
				if((call InfoSend.send(thisNode.parent, infomsg, sizeof(nodeInfo))) == SUCCESS) {
					//printf("the node send the location packet!\n");
					//printfflush();
					dbg("InfoTimer","InfoTimer : the node send the location packet!\n");
				}
			}
			if(TOS_NODE_ID == 1){
				if((call InfoSend.send(0, infomsg, sizeof(nodeInfo))) == SUCCESS) {
					//printf("the root node send the location packet to basesatation!\n");
					//printfflush();
					dbg("InfoTimer","InfoTimer : the root node send the location packet to basesatation!\n");
				}
			}
		}
	}

	event void InfoSend.sendDone(message_t * msg, error_t error) {
		// TODO Auto-generated method stub
		asCount++;
		printf("%d node all send count: %d\n",TOS_NODE_ID,asCount);
		call sendPool.put(msg);
	}

	event message_t * InfoRec.receive(message_t * msg, void * payload,
			uint8_t len) {
		// TODO Auto-generated method stub
		
		message_t * nextRec = NULL;
		arCount++;
		printf("%d node all receive count: %d\n",TOS_NODE_ID,arCount);
		//printf("the send pool's size:%d\n", call sendPool.size());
		//printfflush();
		
		if(call sendPool.empty()) {
			call sendPool.refresh();
			return msg;
		}

		if(TOS_NODE_ID != 1) {
			if((call InfoSend.send(thisNode.parent, msg, sizeof(nodeInfo))) == SUCCESS) {
				#ifndef DEBUG
				//printf("send the node location to the parent:%d\n", thisNode.parent);
				//printfflush();
				#endif
			}
		}
		else {
			if((call InfoSend.send(0, msg, sizeof(nodeInfo))) == SUCCESS) {
				#ifndef DEBUG
				//printf("send the node location to the basestation\n");
				//printfflush();
				#endif 
			}
		}

		nextRec = call sendPool.get();
		if(nextRec == NULL) {
			call sendPool.refresh();
			return(call sendPool.get());
		}
		else {
			return nextRec;
		}
	}

	event void RouterTimer.fired() {
		// TODO Auto-generated method stub
		if(is_point(thisNode.nodeAbility)) {
			message_t * routePacket;
			routePacket = call sendPool.get();
			if(routePacket == NULL) {
				call sendPool.refresh();
				routePacket = call sendPool.get();
			}
			if(routePacket) {
				Routersend = (routerMsg * )(call Packet.getPayload(routePacket,
						sizeof(routerMsg)));
				memset(Routersend, 0, sizeof(routerMsg));
				Routersend->msgType = Router;
				Routersend->num = 1;
				(Routersend->data)[0] = TOS_NODE_ID;
				if((call topoSend.send(thisNode.parent, routePacket, sizeof(routerMsg))) == SUCCESS) {
//					printf("leaf node send the topo info!\n");
//					printfflush();
					dbg("RouterTimer","RouterTimer : leaf node send the topo info!\n");
				}
			}
		}
	}

	event void topoSend.sendDone(message_t * msg, error_t error) {
		// TODO Auto-generated method stub
		if(error == SUCCESS) {
			asCount++;
			call sendPool.put(msg);
			//printf("topo send success!\n");
			//printfflush();
		}
	}

	event message_t * routeRec.receive(message_t * msg, void * payload,
			uint8_t len) {
		// TODO Auto-generated method stub	
		message_t * nextRec = NULL;
		//printf("the send pool's size:%d\n", call sendPool.size());
		//printfflush();
		arCount++;
		if(call sendPool.empty()){
			call sendPool.refresh();
			return msg;
		}
		routerReceive = (routerMsg * )(payload);
		if((len == sizeof(routerMsg))&&(routerReceive->msgType == Router)) {
			flag = routerReceive->num;
			memset(routerData, 0, sizeof(uint16_t) * 10);
			memcpy(routerData, routerReceive->data, sizeof(uint16_t) * 10);
			routerData[flag] = TOS_NODE_ID;
			flag++;
			Routersend = (routerMsg * )(call Packet.getPayload(msg, sizeof(routerMsg)));
			memset(Routersend, 0, sizeof(routerMsg));
			Routersend->msgType = Router;
			Routersend->num = flag;
			memcpy(Routersend->data, routerData, sizeof(uint16_t) * 10);
			#ifndef DEBUG
			//printf("topo:");
			for(k = 0; k < flag; k++) {
				//printf("%d ", (Routersend->data)[k]);
			}
			//printf("\n");
			//printfflush();
			#endif
			if(TOS_NODE_ID == 1) {
				if(call topoSend.send(0, msg, sizeof(routerMsg)) == SUCCESS) {
					#ifndef DEBUG
					//printf("the root send the topo packet to the basestation!\n");
					//printfflush();
					#endif 
				}
			}
			else 
				if(TOS_NODE_ID != 1) {
				if(call topoSend.send(thisNode.parent, msg, sizeof(routerMsg)) == SUCCESS) {
				}
			}
		}
		nextRec = call sendPool.get();
		if(nextRec == NULL) {
			call sendPool.refresh();
			return(call sendPool.get());
		}
		else {
			return nextRec;
		}
	}

	event void FibSend.sendDone(message_t * msg, error_t error) {
		// TODO Auto-generated method stub
		if(&packet==msg) {
			asCount++;
//			dbg("fib_send","fib_send : send done\n");
			if(fibCount < fibNum) {
				fibCount++;
			    post fib_send();
			}
		}
	}

	event void BroSend.sendDone(message_t * msg, error_t error) {
		// TODO Auto-generated method stub
		asCount++;
		printf("%d node all send count: %d\n",TOS_NODE_ID,asCount);
		call sendPool.put(msg);
	}

}
