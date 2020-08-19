import requests
from datetime import datetime
from flask import Flask
from flask import render_template
from datetime import time
import mysql.connector
import dateutil.parser

def main():
    endpoint = "https://api.parin.io/sensor/4221"
    headers = {'x-api-key':'w3HkNadqoJ2KKtM1hgOn76RhGfwdi2dH1E2FW1sZ'}

    try:


        db_connection = mysql.connector.connect(user='admin', password='password123',
                                      host='mysql.amazonaws.com',
                                      database='conti')

        db_cursor = db_connection.cursor()

        r= requests.get(endpoint,headers=headers)
        print(r.json())
        print(type(r.json()))

        values = r.json()
        db_rows = [(row["temperature"],dateutil.parser.parse(row["timestamp"]).strftime('%Y-%m-%d %H:%M:%S')) for row in values if float(row["temperature"]) > 78.9]
        print(db_rows)

        db_cursor.executemany(
                        "INSERT INTO temp_data (temperature,timestamp) VALUES (%s, %s);",
                        db_rows)
        db_connection.commit()

        print(db_rows)

        sql_query = "select * from temp_data td where td.timestamp between (now() - INTERVAL 6 hour) and now()"

        db_cursor = db_connection.cursor()
        db_cursor.execute(sql_query)
        all= db_cursor.fetchall()

        print("the values are", db_cursor.rowcount )

        tempt=[]
        times1=[]
        for a in all:
            print(a[0], a[1])
            tempt.append(a[0])
            times1.append(a[1])

        print(tempt)
        print(times1)

    except :
        print("Error Fecting Data from endpoint or inserting to DB")

    finally:
        if(db_connection.is_connected()):
            db_connection.close()

if __name__ == "__main__":
    main()
