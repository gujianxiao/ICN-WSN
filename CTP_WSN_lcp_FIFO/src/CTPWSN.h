#ifndef CTPWSN_H
#define CTPWSN_H

//#define DEBUG


#ifndef DEBUG
#include "printf.h"
#include <stdio.h>
#endif
typedef enum messageType{
	SETROOT,
	BRO,
	IN,
	DATA,
	Info,
	Router
}messageType;

typedef enum nodeType{
	LEAF,
	MID
}nodeType;

/**
 * 各个时间信息
 */
enum Time{
	BROTIME =80001,
	FIBTIME = 9073100,
	READTIME = 50491,
	//TESTTIME = 93003,
	CSTIME = 501234,
	//CSUPDATE = 901234,
	//CSHOLDE = 901234,
};
/**
 * 读取数据的类型
 */
typedef enum readType{
	lightType,
	tempType,
	humidityType
}readType;
/**
 * 获取数据的类型
 */
typedef enum Type{
 	Light,
 	Temp,
 	Humidity,
 }Type;
/**
 * fib表，cs表，pit表的容量
 */
enum tableVolume{
 	FIBMAX = 15,
 	CSMAX = 15,
 	PITMAX = 15,
	CMMAX =15,
 };
/**
 * 经纬度结构
 */
typedef struct point{
	uint16_t x; //经度
	uint16_t y; //维度
}point;

/**
 * 范围结构，用来当作路由能力，进行前缀匹配
 * 范围用矩形表示
 */
typedef struct location{
	point leftUp; //矩形左上角节点
	point rightDown; //矩形右下角节点
}location;

/**
 * name的结构
 * dataType:
 * Temp,Light,Energy
 */ 
typedef struct name{
	location ability;
	Type dataType;
}name;

/**
 * cs条目的结构
 */
typedef struct cs_item{
    name csName;
 	uint8_t weight;
 	uint16_t data;
 }csIt;
 



/**
  * fib条目的结构
  */
typedef struct fib_item{
  	location fibAbility;
  	uint8_t weight;
  	uint16_t goId;
 }fibIt;
 
/**
  * pit条目的结构
  */
typedef struct pit_item{
  	name pitName;
  	uint8_t weight;
  	uint16_t comeId;
  }pitIt;
  
/**
 * 节点的结构
 * id：节点的TOS_NODE_ID
 * degree：节点的层次
 * nodeType：节点类型，LEAF或者MID
 */
typedef struct Node{
  	uint16_t id;
  	uint16_t parent;
  	uint16_t degree;
  	nodeType nodetype;
  	location nodeAbility;
  	location nodeLocation;
  }node; 
  
/**
 * basestation发送过来的消息，用来确定Ctp网络中的root节点
 * type：消息的类型
 */
typedef struct SetRootMSG{
	uint8_t type;
}SetRootMsg;
/**
 * 广播消息格式
 */
typedef struct BroMsg{
	messageType msgType;
	location nodeAbility;
}BroMsg;

/**
 * 传感器之间发送和接收的数据
 * msgType:发送数据的类型
 * msgName:消息的命名，包含地理信息
 * data:返回采集数据的载体
 */
typedef struct message{
 	messageType msgType;
 	name msgName;
 	uint16_t data;
 }Msg;
 /**
  * 返回传感器拓扑网络结构
  */
typedef struct routerMsg{
	messageType msgType;
	uint8_t num;
	uint16_t data[10];
}routerMsg;
/**
 * 节点的节点号和节点的地理位置
 * 数据包
 */
typedef struct nodeInfo{
	messageType type;
	location nodeLocation;
	uint16_t nodeId;
}nodeInfo;
 /**
  * 判断location a是不是等于location b
  */
 bool ability_equal(location a,location b){
 	if((a.leftUp.x == b.leftUp.x) && (a.leftUp.y == b.leftUp.y)){
 		if((a.rightDown.x == b.rightDown.x) && (a.rightDown.y == b.rightDown.y)){
 			return TRUE;
 			}
 		}
 		return FALSE;
 }
 /**
  * 判断location a是否属于location b
  * return: TRUE or FALSE
  * TRUE: location a属于location b
  * FALSE：location a不属于location b
  */
 bool location_belong(location a,location b){
 	if((a.leftUp.x >= b.leftUp.x) && (a.leftUp.y <= b.leftUp.y)){
 		if((a.rightDown.x <= b.rightDown.x) && (a.rightDown.y >= b.rightDown.y)){
 			return TRUE;
 			}
 		}
 	return FALSE;
 }
 /**
  * 判断是一个点还是一个区域
  */
 bool is_point(location a){
 	 if((a.leftUp.x == a.rightDown.x) && (a.leftUp.y == a.rightDown.y)){
 	 	return TRUE;
 		}
 	return FALSE;
 }
 /**
  * 合并区域
  */
 bool location_merge(location a,location b,location * c){
 	if(ability_equal(a,b)) return FALSE;
 	if((is_point(a) && is_point(b)) || (!is_point(a) && !is_point(b))){
 		if(a.leftUp.x<b.leftUp.x) c->leftUp.x = a.leftUp.x;
 		else c->leftUp.x = b.leftUp.x;
 		if(a.leftUp.y<b.leftUp.y) c->leftUp.y = b.leftUp.y;
 		else c->leftUp.y = a.leftUp.y;
 		if(a.rightDown.x < b.rightDown.x) c->rightDown.x = b.rightDown.x;
 		else c->rightDown.x = a.rightDown.x;
 		if(a.rightDown.y < b.rightDown.y) c->rightDown.y = a.rightDown.y;
 		else c->rightDown.y = b.rightDown.y;
 		return TRUE;
 		}
 	if((!is_point(a) && is_point(b)) || (is_point(a) && !is_point(b))){
 		location d = is_point(a)?a:b;
 		location e = !is_point(a)?a:b;
 		if(location_belong(d,e)){
 			*c = e;
 			return TRUE;
 			}
 		else{
 			if(d.leftUp.x<e.leftUp.x) c->leftUp.x = d.leftUp.x;
 			else c->leftUp.x = e.leftUp.x;
 			if(d.leftUp.y<e.leftUp.y) c->leftUp.y = e.leftUp.y;
 			else c->leftUp.y = d.leftUp.y;
 			if(d.rightDown.x < e.rightDown.x) c->rightDown.x = e.rightDown.x;
 			else c->rightDown.x = d.rightDown.x;
 			if(d.rightDown.y < e.rightDown.y) c->rightDown.y = d.rightDown.y;
 			else c->rightDown.y = e.rightDown.y;
 			return TRUE;
 			}
 		}
 	return FALSE;
 }
 
 
 bool location_across(location a,location b)
 {
 	float FibRectangle_central_x=(a.leftUp.x+a.rightDown.x)/2;
 	float FibRectangle_central_y=(a.leftUp.y+a.rightDown.y)/2;
 	float InRectangle_central_x=(b.leftUp.x+b.rightDown.x)/2;
 	float InReactangle_central_y=(b.leftUp.y+b.rightDown.y)/2;
 	float x_distance=abs(FibRectangle_central_x-InRectangle_central_x);
 	float y_distance=abs(FibRectangle_central_y-InReactangle_central_y);
 	int FibRectangle_width=(a.rightDown.x-a.leftUp.x);
 	int FibRectangle_height=(a.leftUp.y-a.rightDown.y);
 	int InRectangle_width=(b.rightDown.x-b.leftUp.x);
 	int InRectangle_height=(b.leftUp.y-b.rightDown.y);
 	float half_width=(FibRectangle_width+InRectangle_width)/2;
 	float half_height=(FibRectangle_height+InRectangle_height)/2;
 	
 	if(x_distance<half_width  &&  y_distance<half_height)
 	{
 		return TRUE;
 	}
 	else
 		return FALSE;
 
 }
 
#endif /* CTPWSN_H */
