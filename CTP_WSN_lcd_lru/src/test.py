import TOSSIM
import sys
from InterestMsg import *
import time

t = TOSSIM.Tossim([])
r = t.radio()

f = open("topo.txt","r")
ff = open("log.txt", "w")
fff = open("test.txt","w")
noise = open("meyer-heavy.txt","r")

#t.addChannel("Boot", sys.stdout)
#t.addChannel("BroTimer", sys.stdout)
#t.addChannel("ability_print",sys.stdout)
#t.addChannel("InfoTimer", sys.stdout)
#t.addChannel("RouterTimer", sys.stdout)
#t.addChannel("MsgRec", sys.stdout)
#t.addChannel("CsRefresh",sys.stdout)
#t.addChannel("FibRefresh",sys.stdout)
t.addChannel("fib_send",sys.stdout)
t.addChannel("DataSend", sys.stdout)
t.addChannel("DataRec",sys.stdout)
#t.addChannel("cs_query_IN",sys.stdout)
#t.addChannel("AMSend",sys.stdout)
#fLines = f.readlines()
#noiseLines = noise.readlines()

        
for i in range(1,21):
    m = t.getNode(i)
    m.bootAtTime(4 * t.ticksPerSecond() + 242119)


for line in f:
    s = line.split()
    if s:
        r.add(int(s[0]),int(s[1]),float(s[2]))
f.close()
      
for line in noise:
    str1 = line.strip()
    if str1:
        val = int(str1)
        for i in range(1,21):
            t.getNode(i).addNoiseTraceReading(val)
noise.close()
            
for i in range(1,21):
    t.getNode(i).createNoiseModel()



#while 1: 
for i in range(0,500000):
    t.runNextEvent()
    

msg=InterestMsg()

msg.set_msgType(2)
msg.set_msgName_ability_leftUp_x(3219)
msg.set_msgName_ability_leftUp_y(7365)
msg.set_msgName_ability_rightDown_x(4607)
msg.set_msgName_ability_rightDown_y(6563)
msg.set_msgName_dataType(1)
#msg.set_data(0)


pkt=t.newPacket()
pkt.setData(msg.data)
pkt.setType(msg.get_amType())
pkt.setDestination(1)

print "Delivering" + str(msg) + "to 1 at " + str(10 * t.ticksPerSecond() + 242119)
pkt.deliver(1,10 * t.ticksPerSecond() + 242119)
while 1:
    t.runNextEvent()
