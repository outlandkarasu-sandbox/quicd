/**
ソケット通信ループのモジュール
*/
module quicd.socket.socket_loop;

import core.time : msecs;

import std.socket :
    Address,
    Socket,
    SocketException,
    SocketSet,
    UdpSocket;

import quicd.socket.socket_handler :
    SocketSendOperations,
    SocketReceiveOperations,
    SocketHandler;

/**
ソケットの通信ループを行う

Params:
    socket = 通信を行うソケット
    handler = 送受信可能時に行う処理
*/
void socketLoop(scope UdpSocket socket, scope SocketHandler handler)
    in (socket)
    in (handler)
{
    immutable selectTimeout = 10.msecs;
    scope checkRead = new SocketSet(1);
    scope checkWrite = new SocketSet(1);
    scope checkError = new SocketSet(1);
    scope holder = new SocketHolder(socket);

    for (;;)
    {
        foreach (socketSet; [checkRead, checkWrite, checkError])
        {
            socketSet.reset();
            socketSet.add(socket);
        }

        immutable result = Socket.select(
            checkRead, checkWrite, checkError, selectTimeout);
        if (result < 0)
        {
            throw new SocketException("Intterupted");
        }
        else if (result == 0)
        {
            handler.onIdle(holder);
            continue;
        }

        if (checkRead.isSet(socket))
        {
            handler.onReceivable(holder);
            if (holder.closed)
            {
                break;
            }
        }

        if (checkWrite.isSet(socket))
        {
            handler.onSendable(holder);
            if (holder.closed)
            {
                break;
            }
        }

        if (checkError.isSet(socket))
        {
            handler.onError(socket.getErrorText(), holder);
            if (holder.closed)
            {
                break;
            }
        }
    }
}

private:

final class SocketHolder : SocketSendOperations, SocketReceiveOperations
{
    this(UdpSocket socket) @nogc nothrow pure @safe scope
        in (socket)
    {
        this.socket_ = socket;
        this.closed_ = false;
    }

    size_t send(scope const(void)[] data, Address to)
    {
        immutable result = socket_.sendTo(data, to);
        if (result == Socket.ERROR)
        {
            throw new SocketException(socket_.getErrorText());
        }

        return result;
    }

    size_t receive(scope void[] data, ref Address from)
    {
        immutable result = socket_.receiveFrom(data, from);
        if (result == Socket.ERROR)
        {
            throw new SocketException(socket_.getErrorText());
        }

        return result;
    }

    void close()
    {
        socket_.close();
        closed_ = true;
    }

    @property bool closed() const @nogc nothrow pure @safe scope
    {
        return closed_;
    }

private:
    UdpSocket socket_;
    bool closed_;
}

