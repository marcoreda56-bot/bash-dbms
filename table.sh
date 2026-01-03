#!/bin/bash

WHITE='\033[1;37m'; LGREEN='\033[1;32m'; LYELLOW='\033[1;33m'; LCYAN='\033[1;36m'
LRED='\033[1;31m'; LPURPLE='\033[1;35m'; BOLD='\033[1m'; NC='\033[0m'

DB_PATH="$1"
[ -z "$DB_PATH" ] && echo -e "${LRED}❌ No DB selected!${NC}" && exit 1

while true; do
    echo -e "\n${BOLD}${LCYAN}------------------------------------------------------${NC}"
    echo -e "${BOLD}${WHITE}  DATABASE: ${LPURPLE}${DB_PATH##*/}${NC}"
    echo -e "${BOLD}${LCYAN}------------------------------------------------------${NC}"
    echo -e "${LYELLOW} 1)${NC}  Create Table      ${LYELLOW} 2)${NC}  List Tables      ${LYELLOW} 3)${NC}  Drop Table"
    echo -e "${LYELLOW} 4)${NC}  Insert Row        ${LYELLOW} 5)${NC}  Show Data        ${LYELLOW} 6)${NC}  Delete Row"
    echo -e "${LYELLOW} 7)${NC}  Update Cell       ${LYELLOW} 8)${NC}  Search Table     ${LYELLOW} 9)${NC}  Convert to CSV"
    echo -e "${LYELLOW} 10)${NC} Main Menu"
    echo -e "${BOLD}${LCYAN}------------------------------------------------------${NC}"
    
    echo -ne "${BOLD}${WHITE}👉 Choice: ${NC}"; read choice

    case $choice in
        1) 
            source /home/marco/script/project/tableContent/createtable.sh
        ;;

        2) 
            source /home/marco/script/project/tableContent/listTable.sh
        ;;
        
        3) 
            source /home/marco/script/project/tableContent/dropTable.sh
        ;;
        
        4) 
	    source /home/marco/script/project/tableContent/insertRow.sh
	;;
        5) 
            source /home/marco/script/project/tableContent/showData.sh
	;;
        6) 
            source /home/marco/script/project/tableContent/deleteRow.sh
        ;;

        7) 
            source /home/marco/script/project/tableContent/updateCell.sh
        ;;

        8) 
            source /home/marco/script/project/tableContent/searchTable.sh
        ;;
        9) 
            source /home/marco/script/project/tableContent/convertcsv.sh
       	    ;;
        10)
       	    exit 0 ;;
        *) echo -e "${LRED}❌ Invalid!${NC}" 
        ;;
    esac
done
