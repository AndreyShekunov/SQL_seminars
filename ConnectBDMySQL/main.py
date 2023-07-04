import pymysql
from config import host, user, password, db_name


try:
    connection = pymysql.connect(
        host=host,  # 127.0.0.1 из config.py
        port=3306,
        user=user,  # "root" из config.py
        password=password,  # "1234" из config.py
        database=db_name,  # "seminar2" из config.py
        cursorclass=pymysql.cursors.DictCursor
    )
    print("Успешное подключение...")

    try:
        cursor = connection.cursor()

        # удаление таблицы connect, чтобы данные не удваивались
        cursor.execute("DROP TABLE IF EXISTS connect;")

        # создаем таблицу connect в БД
        create_query = "CREATE TABLE IF NOT EXISTS connect(" \
            "id INT PRIMARY KEY AUTO_INCREMENT," \
                       "firstname VARCHAR(45));"
        cursor.execute(create_query)

        # заполнение таблицы connect
        insert_query = "INSERT connect (firstname)" \
            "VALUES ('Антон'), ('Alex'), ('Андрей'), ('Сергей');"
        cursor.execute(insert_query)
        connection.commit()  # сохранение данных и передача их в MySQL
        print("Данные успешно внесены в таблицу .")

        # обновление таблицы connect
        update_query = "UPDATE connect SET firstname = 'Mike' WHERE id = 1;"
        cursor.execute(update_query)
        connection.commit()
        print("Данные успешно обновлены.")

        # удаление записи из таблицы connect
        delete_query = "DELETE FROM connect WHERE id = 1;"
        cursor.execute(delete_query)
        connection.commit()
        print("Данные успешно удалены.")

        # выборка из БД (select)
        select_query = "SELECT * FROM connect;"
        cursor.execute(select_query)

        rows = cursor.fetchall()  # записываем полученные данные из таблице в виде словаря

        for row in rows:  # через цикл выводим полученные данный в терминал
            print(row)

        # {'id': 2, 'firstname': 'Alex'}
        # {'id': 3, 'firstname': 'Андрей'}
        # {'id': 4, 'firstname': 'Сергей'}

    finally:
        connection.close()

except Exception as ex:
    print("Отключение.")
    print(ex)
