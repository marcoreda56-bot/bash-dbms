echo -ne "Enter the table you want to convert to CSV: "
read tname

if [ -f "$DB_PATH/$tname" ]; 
then
    header=$(awk -F':' '{print $1}' "$DB_PATH/${tname}_meta" | paste -sd',' -)
  
    {
        echo "$header"
        cat "$DB_PATH/$tname"
    } > "$DB_PATH/${tname}.csv"
    
    echo -e "${LGREEN}✅ '$tname' converted successfully.${NC}"
else
    echo -e "${LRED}❌ Sorry, table not found!${NC}"
fi

