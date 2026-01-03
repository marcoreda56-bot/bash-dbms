# 🗄️ Bash Script-Based Database Management System (DBMS)

A command-line **Database Management System (DBMS)** built entirely using **Bash scripting**.
This project simulates core database functionalities using the Linux file system and standard Linux CLI tools.

---

## 🎯 Objective

The objective of this project is to develop a functional DBMS in Bash that supports:

- Database-level operations
- Table-level operations
- File-based data storage
- Modular scripting and input validation

This project is developed as part of **ITI – Open Source Track** training.

---

## 👨‍💻 Author

**Marco Reda**  
**Ehdaa Abdala**  

Software Engineer & Full-Stack Developer  
ITI – Open Source Track  

- GitHub: https://github.com/marcoreda56-bot

---

## 🧩 Project Overview

This system is fully CLI-based and **modular**, composed of multiple Bash scripts working together.

- Each database is represented as a directory.
- Each table is represented as a data file.
- Each table has an associated metadata file storing column definitions and data types.
- Modular structure:
  - `db.sh` → Main database controller
  - `databaseContent/` → Scripts handling database operations
  - `table.sh` → Table-level controller
  - `tableContent/` → Scripts handling table operations
- Entry point: `startScript.sh` launches the DBMS

---

## 📁 Project Structure

bash-dbms/
│
├── startScript.sh          # Entry point of the project; launches the DBMS
├── db.sh                   # Main database-level controller
├── table.sh                # Main table-level controller
│
├── databaseContent/        # Scripts for database operations
│   ├── createDatabase.sh   # Handles creation of new databases
│   ├── listDatabase.sh     # Handles listing all databases
│   ├── connectDatabase.sh  # Handles connecting to an existing database
│   └── deleteDatabase.sh   # Handles deletion of databases
│
├── tableContent/           # Scripts for table-level operations
│   ├── createTable.sh      # Handles table creation
│   ├── listTables.sh       # Handles listing tables
│   ├── insertRow.sh        # Handles inserting rows into tables
│   ├── updateCell.sh       # Handles updating specific cells
│   ├── deleteRow.sh        # Handles deleting rows
│   ├── dropTable.sh        # Handles deleting tables
│   ├── showData.sh         # Handles displaying table data (all/specific columns)
│   └── exportCSV.sh        # Handles exporting table data to CSV
│
├── Database/               # Directory containing all databases (data storage)
│
└── README.md               # Project documentation


---

## ⚙️ Features

### 📂 Database Management

- Create Database  
  - Validate database name (must start with a letter, no special characters)
  - Create database directory with proper permissions

- List Databases  
  - Display all existing databases

- Connect to Database  
  - Connect to an existing database
  - Transfer control to table management operations (`table.sh`)

- Delete Database  
  - Confirm before deletion
  - Ensure database exists before removal

- Exit  
  - Gracefully exit the system

---

### 📑 Table Management

- Create Table  
  - Define table name
  - Specify number of columns
  - Define column names and data types (Integer, String)
  - Store table structure in a metadata file

- List Tables  
  - Display all tables in the connected database

- Drop Table  
  - Delete a table after user confirmation

- Insert Row  
  - Validate input data
  - Ensure primary key uniqueness

- Show Data  
  - Display all table data
  - Select all columns or specific columns (by name or index)

- Update Cell  
  - Update a specific cell using row and column numbers

- Delete Row  
  - Delete a specific row using a unique identifier

- Search Data  
  - Search for specific values inside table columns

- Export Data to CSV  
  - Export table data into a CSV file for external use

- Exit  
  - Return control to the main database menu

---

## 🛠️ Technologies Used

- Bash Scripting
- Linux Command Line
- awk
- sed
- column
- Git & GitHub

---

## ▶️ How to Run the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/marcoreda56-bot/bash-dbms.git

Navigate to the project directory:

cd bash-dbms


Grant execution permissions:

chmod +x startScript.sh db.sh table.sh


Start the project:

./startScript.sh

🧠 Learning Outcomes

Writing modular Bash scripts

Managing data using the Linux file system

Input validation and error handling

Using metadata to simulate database schemas

Exporting data to CSV

Building real-world CLI-based applications

🚀 Future Improvements

Advanced data validation rules

Indexing for faster search

User authentication system

Transaction handling simulation

Logging and auditing features

📜 License

This project is developed for educational purposes as part of
ITI – Open Source Track training.
