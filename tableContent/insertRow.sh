echo -ne "${LCYAN}Table Name : ${NC}"
read -r tname


if [[ ! -f "$DB_PATH/$tname" || ! -f "$DB_PATH/${tname}_meta" ]]; then
    echo -e "${LRED}❌ Table not found!${NC}"
    continue
fi


mapfile -t meta_lines < "$DB_PATH/${tname}_meta"
expected_cols=${#meta_lines[@]}


if [[ -s "$DB_PATH/$tname" ]]; then
    line_num=1
    while IFS=',' read -ra cols; do
        if (( ${#cols[@]} != expected_cols )); then
            echo -e "${LRED}❌ Corrupted row at line $line_num${NC}"
            continue 2
        fi
        ((line_num++))
    done < "$DB_PATH/$tname"
fi

row=""
col_idx=1


for line in "${meta_lines[@]}"; do
    cname=$(cut -d':' -f1 <<< "$line")
    ctype=$(cut -d':' -f2 <<< "$line")
    ispk=$(cut -d':' -f3 <<< "$line")

    while true;
    do
        echo -ne "${WHITE}$cname ($ctype) $([[ "$ispk" == "yes" ]] && echo -e "${LYELLOW}[PK]${NC}"): "
        read -r val
        val=$(echo "$val" | xargs)

        [[ -z "$val" || "$val" == *","* ]] && echo -e "${LRED}❌ Invalid value${NC}" && continue

        # ---- Type Check ----
        if [[ "$ctype" == "Int" && ! "$val" =~ ^[0-9]+$ ]]; then
            echo -e "${LRED}❌ Must be Int${NC}"
            continue
        fi

        if [[ "$ispk" == "yes" && -s "$DB_PATH/$tname" ]]; then
            exists="false"
            while IFS=',' read -ra cols; do
                if [[ "$(echo "${cols[$((col_idx-1))]}" | xargs)" == "$val" ]]; then
                    exists="true"
                    break
                fi
            done < "$DB_PATH/$tname"

            [[ "$exists" == "true" ]] && echo -e "${LRED}❌ PK Exists!${NC}" && continue
        fi

        break
    done

    row+="$val,"
    ((col_idx++))
done

echo "${row%,}" >> "$DB_PATH/$tname"
echo -e "${LGREEN}✅ Row Added Successfully${NC}"

