/**
サーバーモジュール
*/
module quicd.server;

import std.array : Appender;
import std.stdio : writeln, writefln;
import std.experimental.logger : errorf, info, infof;

import std.socket :
    Address,
    AddressFamily,
    InternetAddress,
    Socket,
    UdpSocket;

import quicd.socket :
    socketLoop,
    SocketHandler,
    SocketOperations,
    SocketSendOperations,
    SocketReceiveOperations;

/**
サーバーのメイン関数
*/
void serverMain()
{
    auto address = new InternetAddress("127.0.0.1", 8443);
    scope socket = new UdpSocket(AddressFamily.INET);
    socket.bind(address);
    scope handler = new ServerSocketHandler();

    socketLoop(socket, handler);
}

private:

class ServerSocketHandler : SocketHandler
{
    override void onReceivable(scope SocketReceiveOperations operations)
    {
        ubyte[1024] data = void;
        Address address;
        immutable result = operations.receive(data[], address);
        if (result == Socket.ERROR)
        {
            errorf("socket error");
            return;
        }

        if (result == 0)
        {
            info("close socket");
            return;
        }

        infof("receive(%s): %s", address, data[0 .. result]);

        buffer_ ~= data[0 .. result];
    }

    override void onSendable(scope SocketSendOperations operations)
    {
    }

    override void onError(string errorMessage, scope SocketOperations operations)
    {
        errorf("socket error: %s", errorMessage);
    }

    override void onIdle(scope SocketOperations operations)
    {
    }
private:
    Appender!(ubyte[]) buffer_;
}

