# main.py

# 터미널에서 아래 두 줄을 통해 fastapi, uvicorn 설치  
# pip install fastapi 
# pip install uvicorn[standard]

# 이후 아래 터미널 명령어로 서버 켬 (폴더를 정확하게 들어왔는지 확인)
# uvicorn main:app --reload

from fastapi import FastAPI, Request
import random
import requests
from dotenv import load_dotenv
import os
from openai import OpenAI


# .env 파일에 내용을 불러옴
load_dotenv()


# from ___ import <import한 함수> : ____를 그 import한 함수로 이용 가능

app = FastAPI()

# /docs -> 라우팅 목록으로 이동 가능

@app.get('/')
def home():
    return {'home' : 'sweet home'}
    

@app.get('/hi')
def hi():
    return {'status': 'ok'}

@app.get('/lotto')
def lotto():
    return {
        'numbers': random.sample(range(1, 46), 6)
    }





def send_message(chat_id, message):
    bot_token = os.getenv('TELEGRAM_BOT_TOKEN')
    URL = f'https://api.telegram.org/bot{bot_token}'
    body = {
        'chat_id': chat_id, 
        'text': message
    }
    requests.get(URL+'/sendMessage',body)


# /telegram 라우팅으로 텔레그램 서버가 Bot에 업데이트가 있을 경우, 우리에게 알려줌

@app.post('/telegram')
async def telegram(request: Request):
    print('텔레그램 요청')
    
    data  = await request.json()
    sender_id = data['message']['chat']['id']
    input_msg = data['message']['text']
    
    client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))
    
    res = client.responses.create(
        model = 'gpt-4.1-mini',
        input = input_msg,
        instructions='',
    )
    send_message(sender_id, res.output_text)
    
    return {'status': '굿'}