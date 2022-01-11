#!/usr/bin/python

from sys import stdout
import json
import asyncio
import websockets


async def send_ws(ws, data):
    json_data = json.dumps(data)
    await ws.send(json_data)


async def _send_pings(ws, interval=45):
    while True:
        await asyncio.sleep(interval)
        msg = {'op': 9}
        await send_ws(ws, msg)


async def main(loop):
    url = 'wss://listen.moe/gateway_v2'
    ws = await websockets.connect(url)

    while True:
        data = json.loads(await ws.recv())

        if data['op'] == 0:
            heartbeat = data['d']['heartbeat'] / 1000
            loop.create_task(_send_pings(ws, heartbeat))
        elif data['op'] == 1:
            if data['d']:
                title = data['d']['song']['title']
                artist = data['d']['song']['artists'][0]['name']
                stdout.write(f'title{title}artist{artist}end\n')
                stdout.flush()
# Now we do with data as we wish.

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main(loop))
