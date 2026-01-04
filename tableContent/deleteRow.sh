echo -ne "Table Name: "; 
read -r tname
    [ ! -f "$DB_PATH/$tname" ] && echo -e "${LRED}❌ Not found!${NC}" && continue
    pk_idx=$(awk -F':' '$3=="yes" {print NR}' "$DB_PATH/${tname}_meta")
    echo -ne "PK to delete: "; 
    read -r id
    awk -F',' -v id="$id" -v c="$pk_idx" '$c == id {found=1; next} {print $0} END {if (!found) exit 1}' "$DB_PATH/$tname" > tmp 2>/dev/null
    
    if [ $? -eq 0 ];
    then
    mv tmp "$DB_PATH/$tname" && echo -e "${LGREEN}✅ Deleted.${NC}"
    else 
    rm tmp 2>/dev/null && echo -e "${LRED}❌ PK '$id' not found!${NC}"; 
    fi 
