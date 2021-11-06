/**
Long header packet.
*/
module quicd.packets.long_header_packet;

public:

/**
Long header packet.
*/
struct LongHeaderPacket
{
    /**
    Long packet type.
    */
    enum Type
    {
        initial = 0x00,
        zeroRTT = 0x01,
        handshake = 0x02,
        retry = 0x03,
    };

    Type longPacketType;
    ubyte typeSpecificBits;
    uint protocolVersion;

    ubyte destinationConnectionIDLength;
    ubyte[20] destinationConnectionID;

    ubyte sourceConnectionIDLength;
    ubyte[20] sourceConnectionID;
}

