import random

pkt_num=0;
rang_list=[]
while pkt_num<30:
	leftUp_x=random.randint(2213,4607) 
	leftUp_y=random.randint(6508,7365)
	rightDown_x=random.randint(2213,4607) 
	rightDown_y=random.randint(6508,7365)
	if leftUp_x<rightDown_x and leftUp_y>rightDown_y:
		pkt_num+=1
		rang_list.extend([leftUp_x,leftUp_y,rightDown_x,rightDown_y])
		print str(leftUp_x)+","+str(leftUp_y)+","+str(rightDown_x)+","+str(rightDown_y)
#print rang_list