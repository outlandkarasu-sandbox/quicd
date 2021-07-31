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
    通信終了
    */
    void close();
}

/**
データ受信時に行える処理
*/
interface SocketReceiveOperations : SocketOperations
{
    /**
    データ受信

    Params:
        data = 受信データ
    Returns:
        受信できたサイズ
    */
    size_t receive(scope void[] data);
}

/**
データ送信時に行える処理
*/
interface SocketSendOperations : SocketOperations
{
    /**
    データ送信

    Params:
        data = 送信データ
    Returns:
        送信できたサイズ
    */
    size_t send(scope const(void)[] data);
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
    void onReceivable(scope SocketReceiveOperations operations);

    /**
    データ送信可能時の処理

    Params:
        operations = 行える操作
    */
    void onSendable(scope SocketSendOperations operations);

    /**
    エラー発生時の処理

    Params:
        errorMessage = 発生したエラーのメッセージ
        operations = 行える操作
    */
    void onError(string errorMessage, scope SocketOperations operations);

    /**
    データ送信可能時の処理

    Params:
        operations = 行える操作
    */
    void onIdle(scope SocketOperations operations);
}

