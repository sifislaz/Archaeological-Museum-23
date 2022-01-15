import sqlite3
import csv
from os import path

class DB_Connect():

    def __init__(self, filename):
        self.filename = filename
        try:
            self.connect = sqlite3.connect(filename) #Connect to the DB
            self.connect.row_factory = sqlite3.Row #Take the rows of the DB
            self.cursor = self.connect.cursor() #Create a cursor
            print("Accomplished connection to ", filename)
            self.cursor.execute("select sqlite_version()")
            record = self.cursor.fetchall()
            for rec in record:
                print("SQLite Database Version is:", rec[0]) #Print SQLite Version
        except sqlite3.Error as e:
            print("Couldn't connect to the Database ", e) #Print the error

    def createDB(self):
        self.executeSQLFile("Archaeological_Museum_create.sql")
        self.insertFromCSVfile("random_data.csv", "VISITOR")
        self.executeSQLFile("fill_exhibit.sql")
        self.executeSQLFile("fill_exhibition.sql")
        self.executeSQLFile("fill_discount.sql")
        self.executeSQLFile("fill_ticket.sql")
        self.executeSQLFile("fill_outside_org.sql")
        self.executeSQLFile("fill_contains.sql")
        self.executeSQLFile("fill_ex_position.sql")
        self.executeSQLFile("fill_temporary.sql")
        self.executeSQLFile("fill_permanent.sql")
        self.executeSQLFile("fill_loans.sql")
        self.executeSQLFile("fill_buys.sql")
        self.executeSQLFile("fill_deserves.sql")
        self.executeSQLFile("fill_visits.sql")
        self.executeSQLFile("fill_applies.sql")
        self.executeSQLFile("fill_borrows.sql")
        print("Database is created and filled with data")

    def close(self):
        self.connect.commit();
        self.connect.close();


    def executeSQLFile(self, filename):
        with open(filename,'r',encoding='utf-8') as file:
            try:
                sql = file.read()
                self.cursor.executescript(sql)
                self.connect.commit()
            except sqlite3.Error as e:
               print("Error during executing sql file", e)
               return

    def insertFromCSVfile(self, filename, table):
        with open(filename,'r',encoding='utf-8') as file:
            data = csv.reader(file)
            try:
                for row in data:
                    sql = "INSERT INTO {} VALUES ".format(table)
                    val = "(" + ", ".join((len(row)-1)*"?")+", ?)"
                    sql += val
                    self.cursor.execute(sql, row)
                    self.connect.commit()
            except sqlite3.Error as e:
                print("Error during data insertion", e)
                return

    def executeSQL(self, query, show=False):
        try:
            for statement in query.split(";"):
                if statement.strip():
                    self.cursor.execute(statement)
                    print('Executing query {}'.format(statement))
                if show:
                    for row in self.cursor.fetchall():
                            print(",".join([str(item) for item in row]))
                self.connect.commit()
                return True
        except sqlite3.Error as e:
            print("Couldn't execute query ", e)
            return False
    

    def updateTable(self):
        table = input("Enter the name of the table\n")
        attributes = []
        values = []
        conditions = ""
        sql="UPDATE {} SET ".format(table)
        while 1:
            try:
                attributes.append(input("Enter the attribute name (Press Ctrl+Z+Return to end):\n"))
                values.append(input("Enter the value (Press Ctrl+Z+Return to end):\n"))
            except EOFError:
                break
        conditions = input("Enter the conditions: (Press Return if no conditions)\n")
        if len(attributes) != len(values):
            print("Wrong Input!")
        for i in range(len(attributes)):
            if i != len(attributes) - 1:
                sql += "{} = {}, ".format(attributes[i], values[i])
            else:
                sql += "{} = {} ".format(attributes[i], values[i])
        if len(conditions) != 0:
            sql += "WHERE {}".format(conditions)
        sql+=';'
        try:
            print("Executing ", sql)
            self.cursor.execute(sql)
            print("Table {} updated".format(table))
            self.connect.commit()
        except sqlite3.Error as e:
            print("Error in update of {}: {}".format(table, e))


    def deleteFromTable(self):
        table = input("Enter the name of the table:\n")
        conditions = input("Enter the conditions:\n")
        sql = "DELETE FROM {} WHERE {}".format(table, conditions)
        try:
            self.cursor.execute(sql)
            print("Deletion performed")
            self.connect.commit()
        except sqlite3.Error as e:
            print("Error in deletion: ", e)


    def dropTable(self):
        table = input("Enter the name of the table:\n")
        restriction = input("Enter RESTRICT or CASCADE or press Return:\n")
        sql = "DROP TABLE {} {};".format(table,restriction)
        try:
            print("Executing ", sql)
            self.cursor.execute(sql)
            print("Table {} dropped".format(table))
            self.connect.commit()
        except sqlite3.Error as e:
            print("Error during deleting table: ", e)


    def insertToTable(self):
        try:
            table = input("Enter table name:\n")
            attr = input("Enter attributes(Separated with comma) (If you want all attributes press Return):\n")
            values = input("Enter values (Separated with comma):\n").split(",")
            for i in range(len(values)):
                values[i] = values[i].strip(" ")
            values = tuple(values)
            if len(attr) != 0:
                sql = "INSERT INTO {} ({}) VALUES ({}, ?);".format(table, attr, ", ".join((len(values)-1)*"?"))
            else:
                sql = "INSERT INTO {} VALUES ({}, ?);".format(table, ", ".join((len(values)-1)*"?"))
            self.cursor.execute(sql,values)
            self.connect.commit()
        except sqlite3.Error as e:
            print("Error during insertion: ", e)


    def readData(self):
        sql =""
        try:
            values = input("Enter the values you want to see (Comma separated and using aliases):\n")
            dis = input("Do you want distinct values? Y/[N]:\n")
            if(dis == "Y" or dis == "y"):
                sql = "SELECT DISTINCT {} FROM ".format(values)
            else:
                sql = "SELECT {} FROM ".format(values)
            while 1:
                try:
                    table = input("Enter table name:\n")
                    sql += table
                    alias = input("Enter alias for the table (Press return if you don't want):\n")
                    if len(alias) != 0:
                        sql += " AS {} ".format(alias)
                    c = int(input("Choose:\n1. JOIN\n2. NATURAL JOIN\n3. LEFT OUTER JOIN\n4. No JOIN\nIf you don't want to add other tables press Ctrl+Z+Return\n"))
                    if c not in range(1,5):
                        print("Try Again")
                    elif c == 1:
                        table2 = input("Enter alias for the table (Press return if you don't want):\n")
                        alias2 = input("Table alias (Press return if you don't want):\n")
                        jcond = input("Enter JOIN condition:\n")
                        if len(alias2) != 0:
                            sql+=" JOIN {} AS {} ON {}".format(table2,alias2,jcond)
                        else:
                            sql+=" JOIN {} ON {}".format(table2,jcond)
                    elif c == 2:
                        table2 = input("Enter table name:\n")
                        sql += " NATURAL JOIN {}".format(table2)
                    elif c == 3:
                        table2 = input("Enter table name:\n")
                        jcond = input("Enter JOIN condition:\n")
                        sql+=" LEFT OUTER JOIN {} ON {} ".format(table2,jcond)
                    nxt = input("Do you want to select from another table? (Y/N):\n")
                    if nxt == "Y" or nxt == "y":
                        sql+=", "
                    else:
                        raise EOFError()
                except EOFError:
                    break
            cond = input("Enter Conditions (Press Return if you don't want):\n")
            if len(cond) != 0:
                sql+= " WHERE {}".format(cond)
            ob = input("Do you want ORDER BY (Y/N):\n")
            if ob == "Y" or ob == "y":
                ord = input("Enter the attributes (Separated by comma) of ordering followed by ASC (or nothing) for Ascending or DESC for Descending:\n")
                sql += " ORDER BY {} ".format(ord)
            gb = input("Do you want GROUP BY (Y/N):\n")
            if gb == "Y" or gb == "y":
                gr = input("Enter the attribute of grouping:\n")
                sql += " GROUP BY {}".format(gr)
                having = input("Add condition of grouping (Press Return if you don't want):\n")
                if len(having) != 0:
                    sql+= " HAVING {}".format(having)
            sql+=";"
            print("Executing ", sql)
            self.cursor.execute(sql)
            for row in self.cursor.fetchall():
                    print(",".join([str(item) for item in row]))
            self.connect.commit()
        except sqlite3.Error as e:
            print("Error during selection: ",e)


def menu(Data):
    while 1:
        c = int(input("Choose the type of query you want to execute:\n1. Type your own query\n2. Configure UPDATE query\n3. Configure DELETE query\n4. Configure DROP query\n5. Configure INSERT query\n6. Configure SELECT query\n7. Execute SQL File\n8. INSERT data from CSV File\n9. Exit\n"))
        if c not in range(1,10):
            print("Try Again")
        else:
            if c == 1:
                sql = input("Write your query:\n")
                show = input("Do you want to show results? Y/[N]\n")
                if show=="Y" or show=="y":
                    Data.executeSQL(sql, True)
                else:
                    Data.executeSQL(sql)
            elif c == 2:
                Data.updateTable()
            elif c == 3:
                Data.deleteFromTable()
            elif c == 4:
                Data.dropTable()
            elif c == 5:
                Data.insertToTable()
            elif c == 6:
                Data.readData()
            elif c == 7:
                fname = input("Enter the name of the SQL file:\n")
                if len(fname) != 0:
                    Data.executeSQLFile(fname)
                else:
                    print("Insert Name!")
            elif c == 8:
                fname = input("Enter the name of the CSV file:\n")
                table = input("Enter the table name")
                if len(fname) != 0 and len(table):
                    Data.insertFromCSVfile(fname,table)
                else:
                    print("Try again!")
            elif c == 9:
                break



if __name__ == "__main__":
    database_file = "{}.db".format(input("Insert the name of your database:\n"))
    if path.exists(database_file):
        Data = DB_Connect(database_file)
        menu(Data)
        Data.close()
    else:
        Data = DB_Connect(database_file)
        Data.createDB()
        menu(Data)
        Data.close()


