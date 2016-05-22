import os
import time
os.system('sudo chmod 666 /dev/ttyUSB*')
tmp=os.popen('motelist').readlines()
num=1
for a in tmp[2:]:
	print '*************************************************'
	print 'make telosb install.'+str(num)+" bsl,"+a[11:24]
	print '*************************************************'
	time.sleep(2)
	os.system('make telosb install.'+str(num)+" bsl,"+a[11:24])
	num+=1;