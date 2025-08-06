from fastapi import FastAPI
app=FastAPI()
@app.get("/")
def index():
    return {"message": "Hello World", "CY": 200}

# 路由參數
@app.get("/data")
def getData(q, p):
    q = int(q)
    p = int(p)
    return {"Q * 2": q * 2, "P * 2": p * 2}

# 動態路由
@app.get("/users/{user}")
def get_user(user: str):
    return {"user": user}

# query string
@app.get("/hello")
def say_hello(name: str):
    return {"message": f"Hello {name}"}

@app.get("/multiply")
def multiply(num1: int, num2: int):
    return {"result": num1 * num2}

# typing module
from typing import Annotated
from fastapi import Query

@app.get("/books")
def read_books(
    keyword: Annotated[str, Query(min_length=3, max_length=20)],
    limit: Annotated[int, Query(ge=1, le=100)] = 10
):
    return {"keyword": keyword, "limit": limit}

from fastapi import Path

@app.get("/users/{user_id}")
def get_user(user_id: Annotated[int, Path(ge=1, le=10000)]):
    return {"user_id": user_id}


# Response
from fastapi.responses import HTMLResponse

@app.get("/html")
def return_html():
    return HTMLResponse("""
    <html>
      <body>
        <h1>Hello HTML!</h1>
      </body>
    </html>
    """)

from fastapi.responses import PlainTextResponse
@app.get("/plaintext")
def read_plaintext():
    return PlainTextResponse("""
        <html>
            <body>
                <h1>Hello World</h1>
            </body>
        </html>
    """)


from fastapi.responses import FileResponse
@app.get("/file")
def read_file():
    return FileResponse("index.html")

from fastapi.responses import RedirectResponse
@app.get("/redirect")
def redirect():
    return RedirectResponse(url="/")

# Staticfile處理靜態檔，要放在最下方
from fastapi.staticfiles import StaticFiles
app.mount(
    "/public",
    StaticFiles(directory="public", html=True)
)

# 表單
from fastapi import Form

@app.get("/form")
def multiply(num: int):
    return {"result": num * num}

# post
@app.post("/multiply")
def add(num1: int, num2: int):
    return {"result": num1 + num2}

# post
from fastapi import Body
import json
@app.post("/test")
def add(body=Body(None)):
    data=json.loads(body)
    print(data)
    return {"ok": True, "result": data["X"]}


# database
import mysql.connector

con=mysql.connector.connect(
    user="root",
    password="12345678",
    host="localhost",
    database="fastapi"
)
print("Database connected")

@app.get("/createMessage")
def createMessage(author: Annotated[str, None], content: Annotated[str, None]):
    cursor = con.cursor()
    cursor.execute("INSERT INTO message(author, content) VALUES(%s, %s)", [author, content])
    con.commit()
    return {"ok": True}