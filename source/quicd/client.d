/**
クライアントモジュール
*/
module quicd.client;

import std.stdio : writeln, writefln;

import std.socket :
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

    scope checkWrite = new SocketSet(1);
    scope checkError = new SocketSet(1);

    foreach (socketSet; [checkWrite, checkError])
    {
        socketSet.reset();
        socketSet.add(socket);
    }

    immutable result = Socket.select(null, checkWrite, checkError);
    if (result < 0)
    {
        writeln("interrupted.");
        return;
    }
    else if (result == 0)
    {
        writeln("timeout");
        return;
    }

    if (checkWrite.isSet(socket))
    {
        immutable data = "test";
        immutable received = socket.sendTo(data, address);
        if (received == Socket.ERROR)
        {
            writeln("error");
            return;
        }

        writefln("sent: %s", data[0 .. received]);
    }
}

