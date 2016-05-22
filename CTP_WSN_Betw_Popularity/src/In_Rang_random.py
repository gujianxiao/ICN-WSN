import random
node_location=[[2505,7116],[2496,6767],[2806,7172],[2792,6985],[2967,6788],[3179,7089],
[3286,6899],[3264,6674],[3515,7186],[3569,3919],[4373,7341],[4490,6691],[4059,6653],[3399,6615],
[3089,6653]]
pkt_num=0;
rang_list=[]

def chose(range):
	for nl in node_location:
		if range[0]<=nl[0]<=range[2] and range[3]<=nl[1]<=range[1] :
			return True
	return False

while pkt_num<30:
	leftUp_x=random.randint(2213,4607) 
	leftUp_y=random.randint(6508,7365)
	rightDown_x=random.randint(2213,4607) 
	rightDown_y=random.randint(6508,7365)
	if leftUp_x<rightDown_x and leftUp_y>rightDown_y:
		# pkt_num+=1
		# rang_list.extend([leftUp_x,leftUp_y,rightDown_x,rightDown_y])
		if chose([leftUp_x,leftUp_y,rightDown_x,rightDown_y]):
			print str(leftUp_x)+","+str(leftUp_y)+","+str(rightDown_x)+","+str(rightDown_y)
			pkt_num+=1
#print rang_list

