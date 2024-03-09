import psycopg2
from config import config
import math
from prettytable import PrettyTable
 
class BD:
    def __init__(self):
        self.__conn:psycopg2.connection = None
        self.__cur:psycopg2.cursor = self.connect()
        self.__name = ''
        self.__surname = ''
        self.__role = ''
        self.__userid = -1
        self.__logged = False
        
    def connect(self):
        """ Connect to the PostgreSQL database server """
        conn = None
        try:
            # read connection parameters
            params = config()

            # connect to the PostgreSQL server
            print('Connecting to the PostgreSQL database...')
            conn = psycopg2.connect(**params)

            self.__conn = conn

            # create a cursor
            cur = conn.cursor()

        # execute a statement
            print("Succefully Connected")
            print('PostgreSQL database version:')
            cur.execute('SELECT version()')
            
            # display the PostgreSQL database server version
            db_version = cur.fetchone()
            print(db_version)
        # close the communication with the PostgreSQL
        except (Exception, psycopg2.DatabaseError) as error:
            print(error)

        return cur
    
    def close(self):
        self.__create_log("disconnect")
        self.__cur.close()
        self.__conn.close()

    #TODO: Wrong username/password screen
    def login(self, user: str, password: str):
        # do database shenanigans
        
        sql_query = 'select * from users where login = %s and password = md5(%s);'
        self.__cur.execute(sql_query, (user, password))

        row = self.__cur.fetchall()
        if len(row) > 1:
            self.close()
            raise Exception("Mais de um usuario encontrado, saindo....")
        if len(row) == 0:
            self.close()
            raise Exception("Usuario e/ou senha incorreto")
        
        self.__logged = True
        self.__role = row[0][3]
        self.__userid = row[0][0]
        self.__originalid = row[0][4]
        self.__create_log("connect")
        
        if self.__role == 'admin':
            self.__name = 'ADMIN'
            self.__surname = ''
            self.__ref = 'admin'
            
        elif self.__role == 'piloto':
            sql_query = 'select * from driver where driverid = %s;'
            self.__cur.execute(sql_query, str(self.__originalid))

            driver = self.__cur.fetchone()
            self.__name = driver[4]
            self.__surname = driver[5]
            self.__ref = driver[1]
            pass

        elif self.__role == 'escuderia':
            sql_query = 'select * from constructors where constructorid = %s;'
            self.__cur.execute(sql_query, (str(self.__originalid)))

            constructor = self.__cur.fetchone()
            self.__name = constructor[2]
            self.__surname = ""
            self.__ref = constructor[1]

        else:
            raise Exception("Tipo Invalido")
        
        
    def overview(self) -> bool:
        if not self.__logged:
            return False
        
        #print (self.__overview_screen())
        if self.__role == 'admin':
            return self.__overview_admin()
        if self.__role == 'piloto':
            return self.__overview_driver()
        if self.__role == 'escuderia':
            return self.__overview_constructor()


    def __overview_admin(self) -> bool:
        self.__overview_admin_data()
        return self.__admin_actions()
        
    def __overview_driver(self) -> bool:
        self.__overview_driver_data()
        return self.__driver_actions()
        pass
    
    def __overview_constructor(self) -> bool:
        self.__overview_constructor_data()
        return self.__constructor_actions()
        pass
    
    def __overview_screen(self, n = True)->str:
        name = ''
        if n:
            name = " " +  self.__name
            if self.__surname != "":
                name = name+" "+self.__surname
            name = name + " "
        t = '+' + '-' * (20 - math.floor((len(name)/2)))+ name + '-' * (20 - math.ceil((len(name)/2))) + '+'
        return t
  
    # Imprime na tela:
    # Pilotos cadastrados: XX
    # Escuderias cadastradas: XX
    # Quantidade de corridas: XX
    # Quantidade de Temporadas: XX
    def __overview_admin_data(self):
        x = PrettyTable()
        x.title = "ADMINISTRATOR"
        
        self.__cur.execute(
            "select total_drivers()"
            )
        total_drivers = self.__cur.fetchall()[0][0]
        
        self.__cur.execute(
            "select total_constructors()"
            )
        total_constructors = self.__cur.fetchall()[0][0]
        
        self.__cur.execute(
            "select total_races()"
            )
        total_races = self.__cur.fetchall()[0][0]
        
        self.__cur.execute(
            "select total_seasons()"
            )
        total_seasons = self.__cur.fetchall()[0][0]
        
        x.header = False
        x.add_row(["Total de Pilotos", total_drivers])
        x.add_row(["Total de Escuderias", total_constructors])
        x.add_row(["Total de Corridas", total_races])
        x.add_row(["Total de Temporadas", total_seasons])
        
        print(x)
    
    # Imprime na tela
    # Vitorias: XX
    # Primeiro ano: XXXX Ultimo Ano XXXX
    def __overview_driver_data(self):
        x = PrettyTable()
        x.title = self.__name + " " + self.__surname
        x.header = False

        sql_query = "select total_wins_drivers(%s)"
        self.__cur.execute(sql_query,(self.__ref,))
        
        total_wins_drivers = self.__cur.fetchall()[0][0]

        sql_query = "select first_last_year_drivers(%s)"
        self.__cur.execute(sql_query, (self.__ref,))
        
        data = self.__cur.fetchall()[0][0].split(',')
        first_year_drivers = data[0][1::]
        last_year_drivers = data[1][:-1:]
        
        print
        
        x.add_row(["Vitorias", total_wins_drivers])
        x.add_row(["Primeiro ano com Vitoria", first_year_drivers])
        x.add_row(["Ultimo ano com Vitoria", last_year_drivers])
        print(x)
    
    # Imprime na tela:
    # Vitorias: XX
    # Qt. de Pilotos: XX
    # Primeiro ano: XXXX Ultimo Ano XXXX
    def __overview_constructor_data(self):
        x = PrettyTable()
        x.title = self.__name
        x.header = False
        
        sql_query="select total_wins_constructors(%s)"
        self.__cur.execute(sql_query, (self.__ref,))
        total_wins_constructors = self.__cur.fetchall()[0][0]
        x.add_row(["Vitorias", total_wins_constructors])
        
        sql_query = "select total_drivers_constructors(%s)"
        self.__cur.execute(sql_query, (self.__ref,))
        total_drivers_constructors = self.__cur.fetchall()[0][0]
        x.add_row(["Total de Pilotos", total_drivers_constructors])
        
        sql_query = "select first_last_year_constructors(%s)"
        self.__cur.execute(sql_query, (self.__ref,))
        data = self.__cur.fetchall()[0][0].split(',')
        first_year_constructors = data[0][1::]
        last_year_constructors = data[1][:-1:]
        x.add_row(["Primeiro ano com Vitoria", first_year_constructors])
        x.add_row(["Ultimo ano com Vitoria", last_year_constructors])
        
        print(x)
    
    def __admin_actions(self):
        print('Ações Disponiveis:')
        print('[1] - Cadastrar Escuderia')
        print('[2] - Cadastrar Piloto')
        print('[3] - Imprimir Relatório 1 - Status')
        print('[4] - Imprimir Relatorio 2 - Cidades')
        print('[0] - Sair')
        op = input('Digite a opção: ')
        if op == '0':
            return False
        elif op =='1':
            self.__admin_register_constructor()
    
        elif op =='2':
            self.__admin_register_driver()
    
        elif op =='3':
            self.__admin_status_report1()
    
        elif op =='4':
            self.__admin_status_report2()
    
        else:
            print("Opção Inválida")
        return True
    
    def __constructor_actions(self):
        print('Ações Disponiveis:')
        print('[1] - Consultar Piloto')
        print('[2] - Imprimir Relatório 3 - Pilotos')
        print('[3] - Imprimir Relatorio 4 - Resultados')
        print('[0] - Sair')
        op = input('Digite a opção: ')
        
        if op == '0':
            return False
        elif op =='1':
            self.__constructor_consult()

        elif op =='2':
            self.__constructor_status_report3()

        elif op =='3':
            self.__constructor_status_report4()

        else:
            print("Opção Inválida")
        return True
    
    def __driver_actions(self):
        print('Ações Disponiveis:')
        print('[1] - Imprimir Relatório 5 - Vitorias')
        print('[2] - Imprimir Relatorio 6 - Status')
        print('[0] - Sair')
        op = input('Digite a opção: ')
        if op == '0':
            return False
        elif op =='1':
            self.__driver_status_report5()
            
        elif op =='2':
            self.__driver_status_report6()
            
        else:
            print("Opção Inválida")
            
        return True
    
    
    # criar trigger ON INSERT in Constructor
    #TODO: executar a função na base de dados
    #input dos dados dentro dessa função
    def __admin_register_constructor(self):
        constructorref_ = input("Referencia da Escuderia: ").replace(";","").replace('"','').replace("'",'')
        nome_ = input("Nome da Escuderia: ").replace(";","").replace('"','').replace("'",'')
        nationality_ = input("Nacionalidade da Escuderia: ").replace(";","").replace('"','').replace("'",'')

        sql_query = 'select new_constructor(%s, %s, %s);'
        self.__cur.execute(sql_query, (constructorref_, nome_, nationality_))

        self.__conn.commit()
        print("Escuderia Adicionada com Sucesso")
        self.__create_log("commit")
        pass
    
    # criar trigger ON INSERT in driver
    #TODO: executar a função na base de dados
    #input dos dados dentro dessa função
    def __admin_register_driver(self):
        driverref_ = input("Referencia do Piloto: ").replace(";","").replace('"','').replace("'",'')
        number_ = input("Numero do Piloto: ").replace(";","").replace('"','').replace("'",'')
        code_ = input("Código do Piloto: ").replace(";","").replace('"','').replace("'",'')
        forename_ = input("Nome do Piloto: ").replace(";","").replace('"','').replace("'",'')
        surname_ = input("Sobrenome do Piloto: ").replace(";","").replace('"','').replace("'",'')
        dob_ = input("Nascimento (DD/MM/AAAA): ").replace(";","").replace('"','').replace("'",'')
        nationality_ = input("Nacionalidade do Piloto: ").replace(";","").replace('"','').replace("'",'')

        sql_query = 'select new_driver(%s, %s, %s, %s, %s, %s, %s);'
        self.__cur.execute(sql_query, (driverref_, str(number_), code_, forename_, surname_, str(dob_), nationality_))
        
        self.__conn.commit()
        print("Piloto Adicionado com Sucesso")
        self.__create_log("commit")
        pass
    
    # Consultar pilotos da escuderia por forename
    #TODO: executar a função na base de dados
    #input dos dados dentro dessa função
    def __constructor_consult(self):
        piloto = input("Nome do piloto para consultar: ")
        sql_query = "select consultar_piloto(%s, %s)"
        self.__cur.execute(sql_query, (self.__ref, piloto))
        data = self.__cur.fetchall()
        x = PrettyTable()
        x.title = "Consulta Piloto: "+ piloto
        x.field_names = ["Nome", "Nascimento", "Nacionalidade"]
        for row in data:
            row = row[0].split(',')
            name = row[0][1::].replace('"',"")
            dob = row[1].split("-")
            dob = dob[2] + "/" + dob[1]+ "/"+dob[0]
            nationality = row[2][:-1:]
            
            x.add_row([name, dob, nationality])
        print(x)
    
    
    # Relatório 1
    def __admin_status_report1(self):
        self.__cur.execute(
            "select report1()"
        )
        data =self.__cur.fetchall()
        x = PrettyTable()
        x.title = "Report1 - Quantidade de Status"
        x.field_names = ["Status", "Quantidade"]
        for row in data:
            row = row[0].split(',')
            status = row[0][1::]
            quantity = row[1][:-1:]
            x.add_row([status,quantity])
        print(x)
    
    # Relatório 2
    def __admin_status_report2(self):
        cidade = input("Cidade:")
        sql_query = "select report2(%s)"
        self.__cur.execute(sql_query, (cidade,))
        data = self.__cur.fetchall()
        x = PrettyTable()
        x.title = "Report 2 - Aeroportos proximos"
        x.field_names = ["Cidade", "IATA", "AeroPorto", "Cidade do Aeroporto", "Distancia", "Tamanho"]
        for row in data:
            row = row[0].split(',')
            dist = row[4].split('.')[0] + " Km"
            tipo = row[5] == "Medium" if row[5] == "medium_airport" else "Large"
            x.add_row([row[0][1::],row[1],row[2],row[3],dist,tipo])
            
        print(x)
    
    # Relatório 3
    def __constructor_status_report3(self):
        sql_query = "select report3(%s)"
        self.__cur.execute(sql_query, (self.__ref,))
        data = self.__cur.fetchall()
        x = PrettyTable()
        x.title = "Report 3 - Pilotos Escuderia "+self.__name
        x.field_names = ["Piloto", "# Polipositions"]
        for row in data:
            row = row[0].split(',')
            x.add_row([row[0][1::], row[1][:-1:]])

        print(x)
    
    
    # Relatório 4
    def __constructor_status_report4(self):
        sql_query = "select report4(%s)"
        self.__cur.execute(sql_query, (self.__ref,))
        data = self.__cur.fetchall()
        x = PrettyTable()
        x.title = "Report 4 - Status Escuderia: " + self.__name
        x.field_names = ["Status", "Quantidade"]
        for row in data:
            row = row[0].split(',')
            x.add_row([row[0][1::], row[1][:-1:]])
            
        print(x)
    
    # Relatório 5
    def __driver_status_report5(self):
        sql_query = "select report5(%s)"
        self.__cur.execute(sql_query, (self.__ref,))
        data = self.__cur.fetchall()
        x = PrettyTable()
        x.title = "Report 5 - Vitorias do Piloto: " + self.__name + " " + self.__surname
        x.field_names = ["Ano", "Vitorias","Corrida"]
        row = data[0][0].split(',')
        
        row[0] = "GERAL"
        x.add_row([row[0][1::], row[2][:-1:],""])
        for row in data[1::]:
            row = row[0].split(',')
            x.add_row([row[0][1::], row[2][:-1:],row[1]])
            
        print(x)
    
    # Relatório 6    
    def __driver_status_report6(self):
        sql_query = "select report6(%s)"
        self.__cur.execute(sql_query, (self.__ref,))
        data = self.__cur.fetchall()
        x = PrettyTable()
        x.title = "Report 6 - Status do Piloto: " + self.__name + " " + self.__surname
        x.field_names = ["Status", "Quantidade"]
        for row in data:
            row = row[0].split(',')
            x.add_row([row[0][1::], row[1][:-1:]])
        print(x)
    
    def __create_log(self,tipo: str):
        sql_query = 'call new_log(%s, %s);'
        self.__cur.execute(sql_query, (str(self.__userid), tipo))
        self.__conn.commit()
    
    def test2(self):
        self.__admin_register_driver()
        
        
        
        
        
if __name__ == '__main__':
    db = BD()
    db.login('admin', 'admin')
    db.test2()
    
