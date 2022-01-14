#!/usr/bin/python

from sys import stdout
from os.path import exists
from time import sleep
import json
import asyncio
import websockets
import wget

path = '/home/lucifer/projects/'
album_cover_url = 'https://cdn.listen.moe/covers/'
artist_cover_url = 'https://cdn.listen.moe/artists/'


async def send_ws(ws, data):
    json_data = json.dumps(data)
    await ws.send(json_data)


async def _send_pings(ws, interval=45):
    while True:
        await asyncio.sleep(interval)
        msg = {'op': 9}
        await send_ws(ws, msg)


def _save_cover(cover, URL):
    PATH = path + cover
    if not exists(PATH):
        try:
            wget.download(URL, out=PATH, bar=None)
            return True
        except:
            return False
    else:
        return True


async def main(loop):
    url = 'wss://listen.moe/gateway_v2'
    count = ""
    cover = 'blank.png'
    artist = 'Not Available'
    title = 'Not Available'
    while True:
        try:
            ws = await websockets.connect(url)
            break
        except:
            sleep(30)

    while True:
        data = json.loads(await ws.recv())

        if data['op'] == 0:
            heartbeat = data['d']['heartbeat'] / 1000
            loop.create_task(_send_pings(ws, heartbeat))
        elif data['op'] == 1:
            if data['d']:

                if data['d']['listeners']:
                    count = str(data['d']['listeners'])

                if data['d']['song']['title']:
                    title = data['d']['song']['title']

                if data['d']['song']['artists']:
                    artist = data['d']['song']['artists'][0]['nameRomaji'] or data['d']['song']['artists'][0]['name'] or 'NotAvailable'

                if data['d']['song']['albums'] and data['d']['song']['albums'][0]['image']:
                    cover = data['d']['song']['albums'][0]['image']
                    if not _save_cover(cover, album_cover_url + cover):
                        cover = 'blank.png'
                elif data['d']['song']['artists'] and data['d']['song']['artists'][0]['image']:
                    cover = data['d']['song']['artists'][0]['image']
                    if not _save_cover(cover, artist_cover_url):
                        cover = 'blank.png'

                stdout.write(
                    f'count{count}cover{cover}title{title}artist{artist}end\n')
                stdout.flush()

if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main(loop))
