echo -ne "${LCYAN}Table Name : ${NC}";
read tname
            [ ! -f "$DB_PATH/$tname" ] && echo -e "${LRED}❌ Not found!${NC}" && continue
            row=""; col_idx=1
            mapfile -t meta_lines < "$DB_PATH/${tname}_meta"
            for line in "${meta_lines[@]}";
            do
            cname=$(echo "$line" | cut -d':' -f1); ctype=$(echo "$line" | cut -d':' -f2); ispk=$(echo "$line" | cut -d':' -f3)
                while true; do
                    echo -ne "${WHITE}$cname ($ctype) $([[ "$ispk" == "yes" ]] && echo -e "${LYELLOW}[PK]${NC}"): "
                    read val
                    val=$(echo "$val" | xargs)
                    [[ -z "$val" || "$val" == *","* ]] && echo -e "${LRED}❌ Invalid!${NC}" && continue
                    if [[ "$ispk" == "yes" ]]; then
                        exists=$(awk -F',' -v v="$val" -v c="$col_idx" '$c == v {print "1"}' "$DB_PATH/$tname")
                        [[ "$exists" == "1" ]] && echo -e "${LRED}❌ PK Exists!${NC}" && continue
                    fi
                    [[ "$ctype" == "Int" && ! "$val" =~ ^[0-9]+$ ]] && echo -e "${LRED}❌ Must be Int!${NC}" && continue
                    break
                done
                row+="$val,"; ((col_idx++))
            done
            echo "${row%,}" >> "$DB_PATH/$tname";
            echo -e "${LGREEN}✅ Row Added.${NC}"; 

