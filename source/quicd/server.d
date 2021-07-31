/**
サーバーモジュール
*/
module quicd.server;

import std.stdio : writeln, writefln;

import std.socket :
    AddressFamily,
    InternetAddress,
    Socket,
    SocketSet,
    UdpSocket;

/**
サーバーのメイン関数
*/
void serverMain()
{
    auto address = new InternetAddress("127.0.0.1", 8443);
    scope socket = new UdpSocket(AddressFamily.INET);
    socket.bind(address);

    scope checkRead = new SocketSet(1);
    scope checkError = new SocketSet(1);

    foreach (socketSet; [checkRead, checkError])
    {
        socketSet.reset();
        socketSet.add(socket);
    }

    immutable result = Socket.select(checkRead, null, checkError);
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

    if (checkRead.isSet(socket))
    {
        char[1024] buffer;
        immutable received = socket.receive(buffer);
        if (received == Socket.ERROR)
        {
            writeln("error");
            return;
        }

        writefln("received: %s", buffer[0 .. received]);
    }
}

