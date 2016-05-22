#
# This class is automatically generated by mig. DO NOT EDIT THIS FILE.
# This class implements a Python interface to the 'InterestMsg'
# message type.
#

import tinyos.message.Message

# The default size of this message type in bytes.
DEFAULT_MESSAGE_SIZE = 20

# The Active Message type associated with this message.
AM_TYPE = -1

class InterestMsg(tinyos.message.Message.Message):
    # Create a new InterestMsg of size 20.
    def __init__(self, data="", addr=None, gid=None, base_offset=0, data_length=20):
        tinyos.message.Message.Message.__init__(self, data, addr, gid, base_offset, data_length)
        self.amTypeSet(AM_TYPE)
    
    # Get AM_TYPE
    def get_amType(cls):
        return AM_TYPE
    
    get_amType = classmethod(get_amType)
    
    #
    # Return a String representation of this message. Includes the
    # message type name and the non-indexed field values.
    #
    def __str__(self):
        s = "Message <InterestMsg> \n"
        try:
            s += "  [msgType=0x%x]\n" % (self.get_msgType())
        except:
            pass
        try:
            s += "  [msgName.ability.leftUp.x=0x%x]\n" % (self.get_msgName_ability_leftUp_x())
        except:
            pass
        try:
            s += "  [msgName.ability.leftUp.y=0x%x]\n" % (self.get_msgName_ability_leftUp_y())
        except:
            pass
        try:
            s += "  [msgName.ability.rightDown.x=0x%x]\n" % (self.get_msgName_ability_rightDown_x())
        except:
            pass
        try:
            s += "  [msgName.ability.rightDown.y=0x%x]\n" % (self.get_msgName_ability_rightDown_y())
        except:
            pass
        try:
            s += "  [msgName.dataType=0x%x]\n" % (self.get_msgName_dataType())
        except:
            pass
        try:
            s += "  [data=0x%x]\n" % (self.get_data())
        except:
            pass
        try:
            s += "  [nouse=0x%x]\n" % (self.get_nouse())
        except:
            pass
        return s

    # Message-type-specific access methods appear below.

    #
    # Accessor methods for field: msgType
    #   Field type: long, unsigned
    #   Offset (bits): 0
    #   Size (bits): 32
    #

    #
    # Return whether the field 'msgType' is signed (False).
    #
    def isSigned_msgType(self):
        return False
    
    #
    # Return whether the field 'msgType' is an array (False).
    #
    def isArray_msgType(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'msgType'
    #
    def offset_msgType(self):
        return (0 / 8)
    
    #
    # Return the offset (in bits) of the field 'msgType'
    #
    def offsetBits_msgType(self):
        return 0
    
    #
    # Return the value (as a long) of the field 'msgType'
    #
    def get_msgType(self):
        return self.getUIntElement(self.offsetBits_msgType(), 32, 0)
    
    #
    # Set the value of the field 'msgType'
    #
    def set_msgType(self, value):
        self.setUIntElement(self.offsetBits_msgType(), 32, value, 0)
    
    #
    # Return the size, in bytes, of the field 'msgType'
    #
    def size_msgType(self):
        return (32 / 8)
    
    #
    # Return the size, in bits, of the field 'msgType'
    #
    def sizeBits_msgType(self):
        return 32
    
    #
    # Accessor methods for field: msgName.ability.leftUp.x
    #   Field type: int, unsigned
    #   Offset (bits): 32
    #   Size (bits): 16
    #

    #
    # Return whether the field 'msgName.ability.leftUp.x' is signed (False).
    #
    def isSigned_msgName_ability_leftUp_x(self):
        return False
    
    #
    # Return whether the field 'msgName.ability.leftUp.x' is an array (False).
    #
    def isArray_msgName_ability_leftUp_x(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'msgName.ability.leftUp.x'
    #
    def offset_msgName_ability_leftUp_x(self):
        return (32 / 8)
    
    #
    # Return the offset (in bits) of the field 'msgName.ability.leftUp.x'
    #
    def offsetBits_msgName_ability_leftUp_x(self):
        return 32
    
    #
    # Return the value (as a int) of the field 'msgName.ability.leftUp.x'
    #
    def get_msgName_ability_leftUp_x(self):
        return self.getUIntElement(self.offsetBits_msgName_ability_leftUp_x(), 16, 0)
    
    #
    # Set the value of the field 'msgName.ability.leftUp.x'
    #
    def set_msgName_ability_leftUp_x(self, value):
        self.setUIntElement(self.offsetBits_msgName_ability_leftUp_x(), 16, value, 0)
    
    #
    # Return the size, in bytes, of the field 'msgName.ability.leftUp.x'
    #
    def size_msgName_ability_leftUp_x(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'msgName.ability.leftUp.x'
    #
    def sizeBits_msgName_ability_leftUp_x(self):
        return 16
    
    #
    # Accessor methods for field: msgName.ability.leftUp.y
    #   Field type: int, unsigned
    #   Offset (bits): 48
    #   Size (bits): 16
    #

    #
    # Return whether the field 'msgName.ability.leftUp.y' is signed (False).
    #
    def isSigned_msgName_ability_leftUp_y(self):
        return False
    
    #
    # Return whether the field 'msgName.ability.leftUp.y' is an array (False).
    #
    def isArray_msgName_ability_leftUp_y(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'msgName.ability.leftUp.y'
    #
    def offset_msgName_ability_leftUp_y(self):
        return (48 / 8)
    
    #
    # Return the offset (in bits) of the field 'msgName.ability.leftUp.y'
    #
    def offsetBits_msgName_ability_leftUp_y(self):
        return 48
    
    #
    # Return the value (as a int) of the field 'msgName.ability.leftUp.y'
    #
    def get_msgName_ability_leftUp_y(self):
        return self.getUIntElement(self.offsetBits_msgName_ability_leftUp_y(), 16, 0)
    
    #
    # Set the value of the field 'msgName.ability.leftUp.y'
    #
    def set_msgName_ability_leftUp_y(self, value):
        self.setUIntElement(self.offsetBits_msgName_ability_leftUp_y(), 16, value, 0)
    
    #
    # Return the size, in bytes, of the field 'msgName.ability.leftUp.y'
    #
    def size_msgName_ability_leftUp_y(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'msgName.ability.leftUp.y'
    #
    def sizeBits_msgName_ability_leftUp_y(self):
        return 16
    
    #
    # Accessor methods for field: msgName.ability.rightDown.x
    #   Field type: int, unsigned
    #   Offset (bits): 64
    #   Size (bits): 16
    #

    #
    # Return whether the field 'msgName.ability.rightDown.x' is signed (False).
    #
    def isSigned_msgName_ability_rightDown_x(self):
        return False
    
    #
    # Return whether the field 'msgName.ability.rightDown.x' is an array (False).
    #
    def isArray_msgName_ability_rightDown_x(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'msgName.ability.rightDown.x'
    #
    def offset_msgName_ability_rightDown_x(self):
        return (64 / 8)
    
    #
    # Return the offset (in bits) of the field 'msgName.ability.rightDown.x'
    #
    def offsetBits_msgName_ability_rightDown_x(self):
        return 64
    
    #
    # Return the value (as a int) of the field 'msgName.ability.rightDown.x'
    #
    def get_msgName_ability_rightDown_x(self):
        return self.getUIntElement(self.offsetBits_msgName_ability_rightDown_x(), 16, 0)
    
    #
    # Set the value of the field 'msgName.ability.rightDown.x'
    #
    def set_msgName_ability_rightDown_x(self, value):
        self.setUIntElement(self.offsetBits_msgName_ability_rightDown_x(), 16, value, 0)
    
    #
    # Return the size, in bytes, of the field 'msgName.ability.rightDown.x'
    #
    def size_msgName_ability_rightDown_x(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'msgName.ability.rightDown.x'
    #
    def sizeBits_msgName_ability_rightDown_x(self):
        return 16
    
    #
    # Accessor methods for field: msgName.ability.rightDown.y
    #   Field type: int, unsigned
    #   Offset (bits): 80
    #   Size (bits): 16
    #

    #
    # Return whether the field 'msgName.ability.rightDown.y' is signed (False).
    #
    def isSigned_msgName_ability_rightDown_y(self):
        return False
    
    #
    # Return whether the field 'msgName.ability.rightDown.y' is an array (False).
    #
    def isArray_msgName_ability_rightDown_y(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'msgName.ability.rightDown.y'
    #
    def offset_msgName_ability_rightDown_y(self):
        return (80 / 8)
    
    #
    # Return the offset (in bits) of the field 'msgName.ability.rightDown.y'
    #
    def offsetBits_msgName_ability_rightDown_y(self):
        return 80
    
    #
    # Return the value (as a int) of the field 'msgName.ability.rightDown.y'
    #
    def get_msgName_ability_rightDown_y(self):
        return self.getUIntElement(self.offsetBits_msgName_ability_rightDown_y(), 16, 0)
    
    #
    # Set the value of the field 'msgName.ability.rightDown.y'
    #
    def set_msgName_ability_rightDown_y(self, value):
        self.setUIntElement(self.offsetBits_msgName_ability_rightDown_y(), 16, value, 0)
    
    #
    # Return the size, in bytes, of the field 'msgName.ability.rightDown.y'
    #
    def size_msgName_ability_rightDown_y(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'msgName.ability.rightDown.y'
    #
    def sizeBits_msgName_ability_rightDown_y(self):
        return 16
    
    #
    # Accessor methods for field: msgName.dataType
    #   Field type: long, unsigned
    #   Offset (bits): 96
    #   Size (bits): 32
    #

    #
    # Return whether the field 'msgName.dataType' is signed (False).
    #
    def isSigned_msgName_dataType(self):
        return False
    
    #
    # Return whether the field 'msgName.dataType' is an array (False).
    #
    def isArray_msgName_dataType(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'msgName.dataType'
    #
    def offset_msgName_dataType(self):
        return (96 / 8)
    
    #
    # Return the offset (in bits) of the field 'msgName.dataType'
    #
    def offsetBits_msgName_dataType(self):
        return 96
    
    #
    # Return the value (as a long) of the field 'msgName.dataType'
    #
    def get_msgName_dataType(self):
        return self.getUIntElement(self.offsetBits_msgName_dataType(), 32, 0)
    
    #
    # Set the value of the field 'msgName.dataType'
    #
    def set_msgName_dataType(self, value):
        self.setUIntElement(self.offsetBits_msgName_dataType(), 32, value, 0)
    
    #
    # Return the size, in bytes, of the field 'msgName.dataType'
    #
    def size_msgName_dataType(self):
        return (32 / 8)
    
    #
    # Return the size, in bits, of the field 'msgName.dataType'
    #
    def sizeBits_msgName_dataType(self):
        return 32
    
    #
    # Accessor methods for field: data
    #   Field type: int, unsigned
    #   Offset (bits): 128
    #   Size (bits): 16
    #

    #
    # Return whether the field 'data' is signed (False).
    #
    def isSigned_data(self):
        return False
    
    #
    # Return whether the field 'data' is an array (False).
    #
    def isArray_data(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'data'
    #
    def offset_data(self):
        return (128 / 8)
    
    #
    # Return the offset (in bits) of the field 'data'
    #
    def offsetBits_data(self):
        return 128
    
    #
    # Return the value (as a int) of the field 'data'
    #
    def get_data(self):
        return self.getUIntElement(self.offsetBits_data(), 16, 0)
    
    #
    # Set the value of the field 'data'
    #
    def set_data(self, value):
        self.setUIntElement(self.offsetBits_data(), 16, value, 0)
    
    #
    # Return the size, in bytes, of the field 'data'
    #
    def size_data(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'data'
    #
    def sizeBits_data(self):
        return 16
    
    #
    # Accessor methods for field: nouse
    #   Field type: int, unsigned
    #   Offset (bits): 144
    #   Size (bits): 16
    #

    #
    # Return whether the field 'nouse' is signed (False).
    #
    def isSigned_nouse(self):
        return False
    
    #
    # Return whether the field 'nouse' is an array (False).
    #
    def isArray_nouse(self):
        return False
    
    #
    # Return the offset (in bytes) of the field 'nouse'
    #
    def offset_nouse(self):
        return (144 / 8)
    
    #
    # Return the offset (in bits) of the field 'nouse'
    #
    def offsetBits_nouse(self):
        return 144
    
    #
    # Return the value (as a int) of the field 'nouse'
    #
    def get_nouse(self):
        return self.getUIntElement(self.offsetBits_nouse(), 16, 0)
    
    #
    # Set the value of the field 'nouse'
    #
    def set_nouse(self, value):
        self.setUIntElement(self.offsetBits_nouse(), 16, value, 0)
    
    #
    # Return the size, in bytes, of the field 'nouse'
    #
    def size_nouse(self):
        return (16 / 8)
    
    #
    # Return the size, in bits, of the field 'nouse'
    #
    def sizeBits_nouse(self):
        return 16
    
