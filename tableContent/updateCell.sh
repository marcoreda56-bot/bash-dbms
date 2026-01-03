echo -ne "${LCYAN}Table Name : ${NC}"
read tname

if [[ ! -f "$DB_PATH/$tname" || ! -f "$DB_PATH/${tname}_meta" ]];
then
    echo -e "${LRED}❌ Table not found!${NC}"
    exit 1
fi


mapfile -t meta_lines < "$DB_PATH/${tname}_meta"
expected_cols=${#meta_lines[@]}


if [[ ! -s "$DB_PATH/$tname" ]]; 
then
    echo -e "${LRED}❌ Table is empty${NC}"
    continue
fi


echo -e "\n--- Current Data ---"
cat -n "$DB_PATH/$tname"
echo -e "--------------------"


echo -ne "${LCYAN}Row Number : ${NC}"
read r
echo -ne "${LCYAN}Column Number : ${NC}"
read c


[[ ! "$r" =~ ^[0-9]+$ || ! "$c" =~ ^[0-9]+$ ]] && {
    echo -e "${LRED}❌ Invalid input${NC}"
    continue
}


total_rows=$(wc -l < "$DB_PATH/$tname")
(( r < 1 || r > total_rows )) && {
    echo -e "${LRED}❌ Row out of range${NC}"
    exit 1
}


(( c < 1 || c > expected_cols )) && {
    echo -e "${LRED}❌ Column out of range${NC}"
    exit 1
}


line_num=1
while IFS=',' read -ra cols;
do
    if (( ${#cols[@]} != expected_cols )); then
        echo -e "${LRED}❌ Corrupted row at line $line_num${NC}"
        continue
    fi
    ((line_num++))
done < "$DB_PATH/$tname"


line="${meta_lines[$((c-1))]}"
ctype=$(cut -d':' -f2 <<< "$line")
ispk=$(cut -d':' -f3 <<< "$line")


echo -ne "${LCYAN}New Value ($ctype): ${NC}"
read newValue
newValue=$(echo "$newValue" | xargs)


if [[ "$ctype" == "Int" && ! "$newValue" =~ ^[0-9]+$ ]]; then
    echo -e "${LRED}❌ Must be Int${NC}"
    continue
fi


if [[ "$ispk" == "yes" ]]; then
    line_num=1
    while IFS=',' read -ra cols; do
        if (( line_num != r )); then
            if [[ "$(echo "${cols[$((c-1))]}" | xargs)" == "$newValue" ]]; 
            then
                echo -e "${LRED}❌ PK Exists${NC}"
                continue 2
            fi
        fi
        ((line_num++))
    done < "$DB_PATH/$tname"
fi


awk -F',' -v r="$r" -v c="$c" -v v="$newValue" '
    BEGIN { OFS="," }
    NR == r { $c = v }
    { print }
' "$DB_PATH/$tname" > "$DB_PATH/.tmp" && mv "$DB_PATH/.tmp" "$DB_PATH/$tname"

echo -e "${LGREEN}✅ Updated Successfully${NC}"

