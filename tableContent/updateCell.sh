#!/bin/bash

echo -ne "${LCYAN}Table Name : ${NC}"
read tname

if [[ ! -f "$DB_PATH/$tname" || ! -f "$DB_PATH/${tname}_meta" ]]; then
    echo -e "${LRED}❌ Table not found!${NC}"
    exit 1 
fi

mapfile -t meta_lines < "$DB_PATH/${tname}_meta"
expected_cols=${#meta_lines[@]}

if [[ ! -s "$DB_PATH/$tname" ]]; then
    echo -e "${LRED}❌ Table is empty${NC}"
    exit 1
fi

echo -e "\n--- Current Data ---"
cat -n "$DB_PATH/$tname"
echo -e "--------------------"


while true; do
    echo -ne "${LCYAN}Row Number : ${NC}"
    read r
    r=$(echo "$r" | xargs)

    if [[ -z "$r" ]]; then
        echo -e "${LRED}❌ Cannot be empty!${NC}"
    elif [[ ! "$r" =~ ^[1-9][0-9]*$ ]]; 
    then
        echo -e "${LRED}❌ Invalid! Must be a number greater than 0.${NC}"
    else
        total_rows=$(wc -l < "$DB_PATH/$tname")
        if (( r > total_rows )); then
            echo -e "${LRED}❌ Row out of range! (Max: $total_rows)${NC}"
        else
            break
        fi
    fi
done


while true; 
do
    echo -ne "${LCYAN}Column Number : ${NC}"
    read c
    c=$(echo "$c" | xargs)

    if [[ -z "$c" ]]; then
        echo -e "${LRED}❌ Cannot be empty!${NC}"
    elif [[ ! "$c" =~ ^[1-9][0-9]*$ ]]; then
        echo -e "${LRED}❌ Invalid! Must be a number greater than 0.${NC}"
    else
        if (( c > expected_cols )); then
            echo -e "${LRED}❌ Column out of range! (Max: $expected_cols)${NC}"
        else
            break
        fi
    fi
done

line="${meta_lines[$((c-1))]}"
ctype=$(echo "$line" | cut -d':' -f2)
ispk=$(echo "$line" | cut -d':' -f3)


while true; do
    echo -ne "${LCYAN}New Value ($ctype): ${NC}"
    read newValue
    newValue=$(echo "$newValue" | xargs)

    if [[ -z "$newValue" ]]; then
        echo -e "${LRED}❌ Value cannot be empty${NC}"
        continue
    fi

    if [[ "$ctype" == "Int" && ! "$newValue" =~ ^[1-9][0-9]*$ ]]; then
        echo -e "${LRED}❌ Invalid type! Must be an Integer.${NC}"
        continue
    fi
    

    if [[ "$ispk" == "yes" ]]; 
    then
        pk_exists="no"
        current_line=1
        while IFS=',' read -ra cols; do

            if (( current_line != r )); then

                val_in_db=$(echo "${cols[$((c-1))]}" | xargs)
                if [[ "$val_in_db" == "$newValue" ]]; then
                    pk_exists="yes"
                    break
                fi
            fi
            ((current_line++))
        done < "$DB_PATH/$tname"

        if [[ "$pk_exists" == "yes" ]]; then
            echo -e "${LRED}❌ PK Exists! Value '$newValue' is already used.${NC}"
            continue 
        fi
    fi
    break 
done

awk -F',' -v r="$r" -v c="$c" -v v="$newValue" '
    BEGIN { FS=OFS="," }
    NR == r { $c = v }
    { print }
' "$DB_PATH/$tname" > "$DB_PATH/.tmp" && mv "$DB_PATH/.tmp" "$DB_PATH/$tname"

echo -e "${LGREEN}✅ Updated Successfully${NC}"
