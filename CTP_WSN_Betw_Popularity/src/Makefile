COMPONENT=CtpWsnAppC
CFLAGS += -DCC2420_DEF_RFPOWER=4
CFLAGS += -DCC2420_NO_ACKNOWLEDGEMENTS
CFLAGS += -DCC2420_NO_ADDRESS_RECOGNITION
CFLAGS += -I$(TOSDIR)/lib/printf

CFLAGS += -I$(TOSDIR)/lib/net \
          -I$(TOSDIR)/lib/net/drip \
          -I$(TOSDIR)/lib/net/4bitle \
          -I$(TOSDIR)/lib/net/ctp #-DDEBUG


TFLAGS += -I$(TOSDIR)/../apps/tests/TestDissemination \
          -I$(TOSDIR)/../support/sdk/c \
          -I$(TOSDIR)/types \
          -I.

PLATFORM_BUILD_FLAGS= -fpic *-shared* -W1,--enabled-auto-image-base

BUILD_EXTRA_DEPS = InterestMsg.py InterestMsg.class CTPWSN.class
CLEAN_EXTRA = InterestMsg.py InterestMsg.class InterestMsg.java CTPWSN.java CTPWSN.class

InterestMsg.py: Interest.h
	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=InterestMsg Interest.h message -o $@

InterestMsg.class: InterestMsg.java
	javac InterestMsg.java

InterestMsg.java: Interest.h
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=InterestMsg Interest.h message -o $@


CTPWSN.class: CTPWSN.java 
	javac CTPWSN.java

CTPWSN.java:
	mig java -target=null $(CFLAGS) -java-classname=CTPWSN CTPWSN_for_mig.h message -o $@

#tn-listener.o: tn-listener.c
#	gcc $(TFLAGS) $(CFLAGS) -c -o $@ $<


#test_network_msg.c:
#	mig -o test_network_msg.h c -target=$(PLATFORM) $(CFLAGS) $(TFLAGS) TestNetwork.h TestNetworkMsg 

#set_rate_msg.c:
#	mig -o set_rate_msg.h c -target=$(PLATFORM) $(CFLAGS) $(TFLAGS) $(TOSDIR)/lib/net/DisseminationEngine.h dissemination_message

#set_rate_msg.o: set_rate_msg.c
#	gcc $(CFLAGS) $(TFLAGS) -c -o $@ $<

#test_network_msg.o: test_network_msg.c
#	gcc $(CFLAGS) $(TFLAGS) -c -o $@ $<

#collection_msg.c:
#	mig -o collection_msg.h c -target=$(PLATFORM) $(CFLAGS) $(TFLAGS) $(TOSDIR)/lib/net/collection/ForwardingEngine.h collection_header

include $(MAKERULES)

