import std.stdio;

import quicd.server : serverMain;
import quicd.client : clientMain;

void main()
{
    version(QuicdServer)
    {
        serverMain();
    }

    version(QuicdClient)
    {
        clientMain();
    }
}
