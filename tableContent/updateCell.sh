echo -ne "Table Name: "; 
    read tname
    [ ! -f "$DB_PATH/$tname" ] && echo -e "${LRED}❌ Table not found!${NC}" && continue
    
    if [ ! -s "$DB_PATH/$tname" ]; 
    then
        echo -e "${LRED}❌ Table is empty! Cannot update values.${NC}"
        continue
    fi

while true; 
do
    echo -ne "Enter the number of Row: "
    read r
    if ! [[ "$r" =~ ^[0-9]+$ ]];
    then
        echo -e "${LRED}❌ Row must be a number!${NC}"
        continue
    fi

    total_rows=$(wc -l < "$DB_PATH/$tname")
    if (( r < 1 || r > total_rows )); then
        echo -e "${LRED}❌ Row out of range! Total rows: $total_rows${NC}"
        continue
    fi
    break
done


while true; 
do
    echo -ne "Enter the number of Column: "
    read c
    if ! [[ "$c" =~ ^[0-9]+$ ]]; then
        echo -e "${LRED}❌ Column must be a number!${NC}"
        continue
    fi

    total_cols=$(wc -l < "$DB_PATH/${tname}_meta")
    if (( c < 1 || c > total_cols )); then
        echo -e "${LRED}❌ Column out of range! Total columns: $total_cols${NC}"
        continue
    fi
    break
done

    type=$(awk -F':' -v c="$c" 'NR==c {print $2}' "$DB_PATH/${tname}_meta")
    [ -z "$type" ] && echo -e "${LRED}❌ Invalid Column!${NC}" && continue
    
    echo -ne "New Value ($type): ";
    read newValue;
    newvalueClean=$(echo "$newValue" | xargs )
    if [ -z "$newvalueClean" ];
    then
    echo -e "${LRED} ❌ Value cannot be empty!${NC}"
    continue
    fi

    if [[ "$type" == "Int" && ! "$newvalueClean" =~ ^[0-9]+$ ]];
    then 
        echo -e "${LRED}❌ Must be Int!${NC}"
    else 
        awk -F',' -v OFS=',' -v r="$r" -v c="$c" -v v="$newvalueClean" 'NR==r {$c=v} 1' "$DB_PATH/$tname" > tmp && mv tmp "$DB_PATH/$tname"
        echo -e "${LGREEN} ✅ Updated.${NC}"
fi

