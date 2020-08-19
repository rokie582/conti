from datetime import datetime
from flask import Flask
from flask import render_template
from datetime import time
import mysql.connector
import dateutil.parser




app = Flask(__name__)

@app.route("/line_chart")
def line_chart():
    try:

        db_connection = mysql.connector.connect(user='admin', password='password123',
                                                host='mysql.cp97zrqvbvgg.eu-central-1.rds.amazonaws.com',
                                                database='conti')

        sql_query = "select * from temp_data td where td.timestamp between (now() - INTERVAL 6 hour) and now()"

        db_cursor = db_connection.cursor()
        db_cursor.execute(sql_query)
        all = db_cursor.fetchall()

        print("the values are", db_cursor.rowcount)

        tempt = []
        times1 = []
        for a in all:
            print(a[0], a[1])
            tempt.append(a[0])
            times1.append(a[1])

        print(tempt)
        print(times1)
        legend = 'Temperatures'
        temperatures = tempt
        times = times1
        return render_template('line_chart.html', values=temperatures, labels=times, legend=legend)


    except :
        print("Error Fecting Data from endpoint or inserting to DB")

    finally:
        if(db_connection.is_connected()):
            db_connection.close()

if __name__ == "__main__":
    app.run( port=80)
