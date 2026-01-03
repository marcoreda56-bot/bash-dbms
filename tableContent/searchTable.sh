echo -ne "Enter Table Name: "
read tname

if [ -f "$DB_PATH/$tname" ]; then
    echo -ne "Search about what?: "
    read s
    awk -F',' -v s="$s" '$0 ~ s' "$DB_PATH/$tname" | column -t -s ','

else
    echo -e "${LRED}❌ Table '$tname' not found.${NC}"
fi

