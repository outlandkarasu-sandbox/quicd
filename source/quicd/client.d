/**
クライアントモジュール
*/
module quicd.client;

import std.stdio : writeln, writefln;

import std.socket :
    Address,
    AddressFamily,
    InternetAddress,
    Socket,
    SocketSet,
    UdpSocket;

/**
クライアントのメイン関数
*/
void clientMain()
{
    auto address = new InternetAddress("127.0.0.1", 8443);
    scope socket = new UdpSocket(AddressFamily.INET);

    scope checkReadWrite = new SocketSet(1);
    scope checkError = new SocketSet(1);

    void resetSocketSets()
    {
        foreach (socketSet; [checkReadWrite, checkError])
        {
            socketSet.reset();
            socketSet.add(socket);
        }
    }

    resetSocketSets();
    immutable writeResult = Socket.select(null, checkReadWrite, checkError);
    if (writeResult < 0)
    {
        writeln("interrupted.");
        return;
    }
    else if (writeResult == 0)
    {
        writeln("timeout");
        return;
    }

    if (checkReadWrite.isSet(socket))
    {
        immutable data = "test";
        immutable sentLength = socket.sendTo(data, address);
        if (sentLength == Socket.ERROR)
        {
            writeln("error");
            return;
        }

        writefln("sent: %s", data[0 .. sentLength]);
    }

    resetSocketSets();
    immutable readResult = Socket.select(checkReadWrite, null, checkError);
    if (readResult < 0)
    {
        writeln("interrupted.");
        return;
    }
    else if (readResult == 0)
    {
        writeln("timeout");
        return;
    }

    if (checkReadWrite.isSet(socket))
    {
        ubyte[16] buffer;
        Address fromAddress;
        immutable receiveLength = socket.receiveFrom(buffer[], fromAddress);
        if (receiveLength == Socket.ERROR)
        {
            writeln("error");
            return;
        }

        writefln("receive: (%s) %s", fromAddress, buffer[0 .. receiveLength]);
    }
}

