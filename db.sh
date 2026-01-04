#!/bin/bash

WHITE='\033[1;37m'; LGREEN='\033[1;32m'; LYELLOW='\033[1;33m'; LCYAN='\033[1;36m'
LRED='\033[1;31m'; LPURPLE='\033[1;35m'; BOLD='\033[1m'; NC='\033[0m'

DB_folder="/home/marco/script/project/DataBase/"

# Create root folder if not exist
mkdir -p "$DB_folder"

while true; do

    echo -e "\n${BOLD}${LCYAN}======================================================${NC}"
    echo -e "${BOLD}${WHITE}            BASH DBMS - MAIN MENU            ${NC}"
    echo -e "${BOLD}${LCYAN}======================================================${NC}"
    echo -e "${LYELLOW} 1)${NC} Create Database"
    echo -e "${LYELLOW} 2)${NC} List Databases"
    echo -e "${LYELLOW} 3)${NC} Connect to Database"
    echo -e "${LYELLOW} 4)${NC} Delete Database"
    echo -e "${LYELLOW} 5)${NC} Exit"
    echo -e "${BOLD}${LCYAN}======================================================${NC}"
    
    echo -ne "${BOLD}${WHITE}👉 Please enter your choice: ${NC}";
    read -r choice
    choice=$(echo "$choice" | xargs )
    case "$choice" in
        1)
            source /home/marco/script/project/databaseContent/createDatabase.sh
	    ;;
            
        2)
	    source /home/marco/script/project/databaseContent/listDatabase.sh
            ;;
            
        3)
            source /home/marco/script/project/databaseContent/conectDatabase.sh  
            ;;
            
        4)
            source /home/marco/script/project/databaseContent/deleteDatabase.sh 
            ;;
            
        "exit"|5)
            echo -e "${LPURPLE}👋 Exiting... Goodbye!${NC}"
            exit 0
            ;;
            
        *)
            echo -e "${LRED}❌ Invalid option! Please try again.${NC}"
            ;;
    esac
done
