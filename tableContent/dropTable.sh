echo -ne "Enter the table name you want to drop: "
read tname

if [ -f "$DB_PATH/$tname" ];
then
    echo -e "Are you sure you want to drop the table '${tname}'?"
    echo -e "1. Yes\n2. No"
    
    read check
    check=$(echo "$check" | tr '[:upper:]' '[:lower:]' | xargs)

    if [[ "$check" == "1" || "$check" == "y" || "$check" == "yes" ]];
    then
        rm -f "$DB_PATH/$tname" "$DB_PATH/${tname}_meta"
        echo -e "${LGREEN}🗑️ Table '$tname' deleted successfully.${NC}"
    else
        echo -e "${LYELLOW}⚠️ Operation cancelled.${NC}"
    fi
else
    echo -e "${LRED}❌ Table '$tname' not found.${NC}"
fi

