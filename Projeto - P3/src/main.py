import db
import getpass

if __name__ == '__main__':
    username = str(input("Username:\t"))
    password = str(getpass.getpass("Password:\t"))
    bd = db.BD()
    op = True
    bd.login(username, password)
    while (op):
        op = bd.overview()
        
    bd.close()
