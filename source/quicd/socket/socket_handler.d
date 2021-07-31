/**
ソケット用インターフェイス定義.
*/
module quicd.socket.socket_handler;

/**
ソケットに対して行える処理
*/
interface SocketOperations
{
    /**
    データ送信

    Params:
        data = 送信データ
    Returns:
        送信できたサイズ
    */
    size_t send(scope const(void)[] data);

    /**
    データ受信

    Params:
        data = 受信データ
    Returns:
        受信できたサイズ
    */
    size_t receive(scope void[] data);

    /**
    通信終了
    */
    void close();
}

/**
ソケットのイベントハンドラー
*/
interface ScoketHandler
{
    /**
    データ受信可能時の処理

    Params:
        operations = 行える操作
    */
    void onReceivable(scope SocketOperations operations);

    /**
    データ送信可能時の処理

    Params:
        operations = 行える操作
    */
    void onSendable(scope SocketOperations operations);
}

