#ifndef INTEREST_H
#define INTEREST_H //仿真用

typedef enum messageType{
	SETROOT,
	BRO,
	IN,
	DATA,
	Info,
	Router
}messageType;

typedef struct point{
	uint16_t x; //经度
	uint16_t y; //维度
}point;

typedef struct location{
	point leftUp; //矩形左上角节点
	point rightDown; //矩形右下角节点
}location;

typedef enum Type{
 	Light,
 	Temp,
 	Humidity,
 }Type;

typedef struct name{
	location ability;
	uint32_t dataType;
}name;

typedef struct message{
 	uint32_t msgType;
 	name msgName;
 	uint16_t data;
 	uint16_t nouse;   /*测试为了凑齐结构体，无用数据*/
 }Msg;

#endif /* INTEREST_H */
