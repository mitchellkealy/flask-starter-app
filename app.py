from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
import os
import database.db_connector as db

# Configurationnn

app = Flask(__name__)
db_connection = db.connect_to_database()

mysql = MySQL(app)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'mitch'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'bbm'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

# Routes 

@app.route('/')
def root():
    return render_template("main.j2")

@app.route('/customers', methods=["POST", "GET"])
def customers():
    if request.method == "POST":
        # fire off if user presses the Add Person button
        if request.form.get("Add_Customer"):
            # grab user form inputs
            customer_name = request.form["customer_name"]
            date_created = request.form["date_created"]
            customer_email = request.form["customer_email"]
            customer_phone = request.form["customer_phone"]

            # account for null age
            if customer_phone == "":
                query = "INSERT INTO Customers (customer_name, date_created, customer_email) VALUES (%s, %s,%s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (customer_name, date_created, customer_email))
                mysql.connection.commit()

            # no null inputs
            else:
                query = "INSERT INTO Customers (customer_name, date_created, customer_email, customer_phone) VALUES (%s, %s,%s,%s)"
                cur = mysql.connection.cursor()
                cur.execute(query, (customer_name, date_created, customer_email, customer_phone))
                mysql.connection.commit()

            # redirect back to people page
            return redirect("/customers")

    # Grab bsg_people data so we send it to our template to display
    if request.method == "GET":
        # mySQL query to grab all the people in bsg_people
        query = "SELECT * FROM Customers;"
        cursor = db.execute_query(db_connection=db_connection, query=query)
        data = cursor.fetchall()
        return render_template("customers.j2", data=data)
    

# route for delete functionality, deleting a person from bsg_people,
# we want to pass the 'id' value of that person on button click (see HTML) via the route
@app.route("/delete_customer/<customer_id>")
def delete_customer(customer_id):
    # mySQL query to delete the person with our passed id
    query = "DELETE FROM Customers WHERE customer_id = '%s';"
    cur = mysql.connection.cursor()
    cur.execute(query, (customer_id))
    mysql.connection.commit()

    # redirect back to people page
    return redirect("/customers")


# route for edit functionality, updating the attributes of a person in bsg_people
# similar to our delete route, we want to the pass the 'id' value of that person on button click (see HTML) via the route
@app.route("/edit_customer/<customer_id>", methods=["POST", "GET"])
def edit_customer(customer_id):
    if request.method == "GET":
        # mySQL query to grab the info of the person with our passed id
        query = "SELECT * FROM Customers WHERE customer_id = %s" % (customer_id)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        # render edit_people page passing our query data and homeworld data to the edit_people template
        return render_template("edit_customers.j2", data=data)

    # meat and potatoes of our update functionality
    if request.method == "POST":
        # fire off if user clicks the 'Edit Person' button
        if request.form.get("Edit_Customer"):
            # grab user form inputs
            customer_name = request.form["customer_name"]
            date_created = request.form["date_created"]
            customer_email = request.form["customer_email"]
            customer_phone = request.form["customer_phone"]

            # account for null homeworld
            if customer_phone == "":
                query = "UPDATE Customers SET Customers.customer_name = %s, Customers.date_created = %s, Customers.customer_email = %s, Customers.customer_phone = NULL WHERE Customers.customer_id = %s"
                cur = mysql.connection.cursor()
                cur.execute(query, (customer_name, date_created, customer_email, customer_id))
                mysql.connection.commit()

            # no null inputs
            else:
                query = "UPDATE Customers SET Customers.customer_name = %s, Customers.date_created = %s, Customers.customer_email = %s, Customers.customer_phone = %s WHERE Customers.customer_id = %s"
                cur = mysql.connection.cursor()
                cur.execute(query, (customer_name, date_created, customer_email, customer_phone, customer_id))
                mysql.connection.commit()

            # redirect back to people page after we execute the update query
            return redirect("/customers")

    
# Listener

if __name__ == "__main__":
    port = int(os.environ.get('PORT', 9112))
    app.run(port=port, debug=True)