# pip install PyMySQL
import pymysql
from tkinter import *           # библиотека для создания GUI
from tkinter import ttk         # для отображеня иерархических данных
from tkinter import messagebox  # для отоброжения диалоговых окон с сообщениями
import tkinter as tk
from config import host, user, password, db_name


# Подключение к БД
def connection():
    conn = pymysql.connect(
        host=host,
        port=3306,
        user=user,
        password=password,
        db=db_name)
    return conn

# Обновить таблицу - функция для обновления данных в виджете Treeview.
# Она очищает все записи в Treeview, затем выполняет функцию read()
# для получения данных из базы данных и вставляет их в Treeview


def refreshTable():
    for data in my_tree.get_children():
        my_tree.delete(data)

    for array in read():
        my_tree.insert(parent='', index='end', iid=array,
                       text="", values=(array), tag="orow")

    my_tree.tag_configure('orow', background='#EEEEEE', font=('Arial', 12))
    my_tree.grid(row=8, column=0, columnspan=5, rowspan=11, padx=10, pady=20)


# GUI - Создание главной формы
root = Tk()
root.title("Справочник")
root.geometry("1080x720")
my_tree = ttk.Treeview(root)

# функции

# placeholders - заполнители для последующего ввода
# переменные типа StringVar, используемые для установки значения в поля ввода (Entry) и получения данных оттуда
# ph1,ph2,ph3,ph4,ph5 будут использоваться в качестве заполнителей для пяти полей ввода (Entry)
ph1 = tk.StringVar()
ph2 = tk.StringVar()
ph3 = tk.StringVar()
ph4 = tk.StringVar()
ph5 = tk.StringVar()


def setph(word, num):  # функция для установки значений placeholders ph1, ph2, ph3, ph4, ph5
    if num == 1:       # на основе переданного word и num
        ph1.set(word)
    if num == 2:
        ph2.set(word)
    if num == 3:
        ph3.set(word)
    if num == 4:
        ph4.set(word)
    if num == 5:
        ph5.set(word)


def read():  # Функция чтения из БД
    conn = connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM students;")
    results = cursor.fetchall()
    conn.commit()
    conn.close()
    return results


def add():  # Функция добавления в БД (INSERT)
    studid = str(sdudidEntry.get())
    fname = str(fnameEntry.get())
    lname = str(lnameEntry.get())
    address = str(addressEntry.get())
    phone = str(phoneEntry.get())

    if (studid == "" or studid == " ") or (fname == "" or fname == " ") or (lname == "" or lname == " ") or (address == "" or address == " ") or (phone == "" or phone == " "):
        messagebox.showinfo("Ошибка", "Пожалуйста, заполните пустую строку")
        return
    else:
        try:
            conn = connection()
            cursor = conn.cursor()

            cursor.execute("INSERT INTO students VALUES ('"+studid+"','" +
                           fname+"', '"+lname+"', '"+address+"', '"+phone+"') ")
            conn.commit()
            conn.close()

        except:
            messagebox.showinfo("Ошибка", "Такой Id уже есть в БД")
            return

    refreshTable()


def reset():  # Функция удаления всех данных из БД (DELETE)
    decision = messagebox.askquestion(
        "Внимание!", "Вы точно хотите удалить все данные?")
    if decision != "yes":
        return
    else:
        try:
            conn = connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM students")
            conn.commit()
            conn.close()

        except:
            messagebox.showinfo("Ошибка", "Извините, произошла ошибка")
            return

    refreshTable()


def delete():  # Функция удаления выбранных данных из БД (DELETE)
    decision = messagebox.askquestion(
        "Внимание!", "Вы точно хотите удалить выбранные данные?")
    if decision != "yes":
        return
    else:
        try:
            selected_item = my_tree.selection()[0]
            deleteData = str(my_tree.item(selected_item)['values'][0])

            conn = connection()
            cursor = conn.cursor()
            cursor.execute("DELETE FROM students WHERE Id= '" +
                           str(deleteData)+"'")
            conn.commit()
            conn.close()

        except:
            messagebox.showinfo("Ошибка", "Извините, произошла ошибка")
            return

    refreshTable()


def select():  # Функция установки выбранных данных из БД в поля ввода (select)
    try:
        selected_item = my_tree.selection()[0]
        studid = str(my_tree.item(selected_item)['values'][0])
        fname = str(my_tree.item(selected_item)['values'][1])
        lname = str(my_tree.item(selected_item)['values'][2])
        address = str(my_tree.item(selected_item)['values'][3])
        phone = str(my_tree.item(selected_item)['values'][4])

        setph(studid, 1)
        setph(fname, 2)
        setph(lname, 3)
        setph(address, 4)
        setph(phone, 5)
    except:
        messagebox.showinfo("Ошибка", "Пожалуйста, выберите строку данных")


def search():  # Функция поиска данных в БД (select)
    studid = str(sdudidEntry.get())
    fname = str(fnameEntry.get())
    lname = str(lnameEntry.get())
    address = str(addressEntry.get())
    phone = str(phoneEntry.get())

    conn = connection()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM students WHERE Id='" +
                   studid+"' or firstname='" +
                   fname+"' or lastname='" +
                   lname+"' or address='" +
                   address+"' or phone='" +
                   phone+"' ")

    try:
        result = cursor.fetchall()

        for num in range(0, 5):
            setph(result[0][num], (num+1))

        conn.commit()
        conn.close()
    except:
        messagebox.showinfo("Ошибка", "Данные не найдены")


def update():  # Функция обновления данных в БД (update)
    selectedStudid = ""

    try:
        selected_item = my_tree.selection()[0]
        selectedStudid = str(my_tree.item(selected_item)['values'][0])
    except:
        messagebox.showinfo("Ошибка", "Выберите строку данных")

    studid = str(sdudidEntry.get())
    fname = str(fnameEntry.get())
    lname = str(lnameEntry.get())
    address = str(addressEntry.get())
    phone = str(phoneEntry.get())

    if (studid == "" or studid == " ") or (fname == "" or fname == " ") or (lname == "" or lname == " ") or (address == "" or address == " ") or (phone == "" or phone == " "):
        messagebox.showinfo("Ошибка", "Заполните пустую запись")
        return
    else:
        try:
            conn = connection()
            cursor = conn.cursor()
            cursor.execute("UPDATE students SET Id='" +
                           studid+"', firstname='" +
                           fname+"', lastname='" +
                           lname+"', address='" +
                           address+"', phone='" +
                           phone+"' WHERE Id='" +
                           selectedStudid+"' ")
            conn.commit()
            conn.close()
        except:
            messagebox.showinfo("Ошибка", "Id уже существует")
            return

    refreshTable()


# GUI
# Создание заголовка
label = Label(root, text="Справочник (CRUD)",
              font=("Arial Bold", 30))
# Размещение заголовка на главной форме
label.grid(row=0, column=0, columnspan=8, rowspan=2, padx=50, pady=40)

# Создание меток с названиями
sdudidLabel = Label(root, text="Id", font=('Arial', 15))
fnameLabel = Label(root, text="Имя", font=('Arial', 15))
lnameLabel = Label(root, text="Фамилия", font=('Arial', 15))
addressLabel = Label(root, text="Адрес", font=('Arial', 15))
phoneLabel = Label(root, text="Телефон", font=('Arial', 15))

# Размещение меток на главной форме
sdudidLabel.grid(row=3, column=0, columnspan=1, padx=50, pady=5)
fnameLabel.grid(row=4, column=0, columnspan=1, padx=50, pady=5)
lnameLabel.grid(row=5, column=0, columnspan=1, padx=50, pady=5)
addressLabel.grid(row=6, column=0, columnspan=1, padx=50, pady=5)
phoneLabel.grid(row=7, column=0, columnspan=1, padx=50, pady=5)

# Создание полей ввода данных - textvariable позже
sdudidEntry = Entry(root, width=55, bd=5, font=('Arial', 15), textvariable=ph1)
fnameEntry = Entry(root, width=55, bd=5, font=('Arial', 15), textvariable=ph2)
lnameEntry = Entry(root, width=55, bd=5, font=('Arial', 15), textvariable=ph3)
addressEntry = Entry(root, width=55, bd=5, font=(
    'Arial', 15), textvariable=ph4)
phoneEntry = Entry(root, width=55, bd=5, font=('Arial', 15), textvariable=ph5)

# Размещение полей ввода данных на главной форме
sdudidEntry.grid(row=3, column=1, columnspan=4, padx=5, pady=0)
fnameEntry.grid(row=4, column=1, columnspan=4, padx=5, pady=0)
lnameEntry.grid(row=5, column=1, columnspan=4, padx=5, pady=0)
addressEntry.grid(row=6, column=1, columnspan=4, padx=5, pady=0)
phoneEntry.grid(row=7, column=1, columnspan=4, padx=5, pady=0)

# Создание кнопок и обработка их нажатия
addBtn = Button(root, text="Add (Добавить)", padx=65, pady=25, width=10,
                bd=5, font=('Arial', 15), bg='#84F894', command=add)
updateBtn = Button(root, text="Update (Обновить)", padx=65, pady=25,
                   width=10, bd=5, font=('Arial', 15), bg='#84E8F8', command=update)
deleteBtn = Button(root, text="Delete (Удалить)", padx=65, pady=25,
                   width=10, bd=5, font=('Arial', 15), bg='#FF9999', command=delete)
searchBtn = Button(root, text="Search (Поиск)", padx=65, pady=25,
                   width=10, bd=5, font=('Arial', 15), bg='#F4FE82', command=search)
resetBtn = Button(root, text="Reset (Сброс)", padx=65, pady=25,
                  width=10, bd=5, font=('Arial', 15), bg='#F398FF', command=reset)
selectBtn = Button(root, text="Select (Выбрать)", padx=65, pady=25,
                   width=10, bd=5, font=('Arial', 15), bg='#EEEEEE', command=select)

# Размещение кнопок на главной форме
addBtn.grid(row=3, column=5, columnspan=1, rowspan=2)
updateBtn.grid(row=5, column=5, columnspan=1, rowspan=2)
deleteBtn.grid(row=7, column=5, columnspan=1, rowspan=2)
searchBtn.grid(row=9, column=5, columnspan=1, rowspan=2)
resetBtn.grid(row=11, column=5, columnspan=1, rowspan=2)
selectBtn.grid(row=13, column=5, columnspan=1, rowspan=2)

# Создание виджета куда будет выводится информация по запросам
style = ttk.Style()
style.configure("Treeview.Heading", font=('Arial', 15))
my_tree['columns'] = ("Id", "Имя", "Фамилия",
                      "Адрес", "Телефон")

# Создание внутри виджета Treeview колонок для информации с определением ширины колонки
my_tree.column("#0", width=0, stretch=NO)
my_tree.column("Id", anchor=W, width=50)
my_tree.column("Имя", anchor=W, width=150)
my_tree.column("Фамилия", anchor=W, width=150)
my_tree.column("Адрес", anchor=W, width=285)
my_tree.column("Телефон", anchor=W, width=150)

# Создание заголовков колонок с указанием их имён
my_tree.heading("Id", text="Id", anchor=W)
my_tree.heading("Имя", text="Имя", anchor=W)
my_tree.heading("Фамилия", text="Фамилия", anchor=W)
my_tree.heading("Адрес", text="Адрес", anchor=W)
my_tree.heading("Телефон", text="Телефон", anchor=W)


refreshTable()


root.mainloop()
