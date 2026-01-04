
name_regex='^[a-z][a-z0-9_]*$'
reserved_words="select insert delete update table where from join"


while true; do
    echo -ne "${LCYAN}Enter table name: ${NC}"
    read tname
    tname=$(echo "$tname" | tr '[:upper:]' '[:lower:]' | xargs)

    [[ -z "$tname" || ! "$tname" =~ $name_regex ]] && \
        echo -e "${LRED}❌ Invalid name! Use lowercase letters, numbers, _. Start with letter.${NC}" && continue

    for w in $reserved_words; 
    do
        [[ "$tname" == "$w" ]] && echo -e "${LRED}❌ Reserved word!${NC}" && continue 2
    done

    [ -f "$DB_PATH/$tname" ] && echo -e "${LRED}❌ Table exists!${NC}" && continue
    break
done


while true; do
    echo -ne "${LCYAN}Number of columns: ${NC}"
    read colnum
    [[ "$colnum" =~ ^[1-9][0-9]*$ && "$colnum" -gt 0 ]] && break
    echo -e "${LRED}❌ Enter a valid number.${NC}"
done


temp_meta=""
pk_chosen=false
cancelled=false
col_names=()

for ((i=1; i<=colnum; i++)); do
    echo -e "${LPURPLE}--- Column $i ---${NC}"

    # Column Name
    while true; do
        echo -ne "Name: "
        read colname
        colname=$(echo "$colname" | tr '[:upper:]' '[:lower:]' | xargs)

        [[ -z "$colname" || ! "$colname" =~ $name_regex ]] && \
            echo -e "${LRED}❌ Invalid column name!${NC}" && continue

        for w in $reserved_words; do
            [[ "$colname" == "$w" ]] && echo -e "${LRED}❌ Reserved word!${NC}" && continue 2
        done

        for existing in "${col_names[@]}"; do
            [[ "$colname" == "$existing" ]] && \
                echo -e "${LRED}❌ Column already exists!${NC}" && continue 2
        done

        col_names+=("$colname")
        break
    done

    # Column Type 
    while true; 
    do
        echo -ne "Type (Int/String): "
        read coltype
        clean_type=$(echo "$coltype" | tr '[:upper:]' '[:lower:]' | xargs)

        if [[ "$clean_type" == "int" ]];
        then
            coltype="Int";
            break
        elif [[ "$clean_type" == "string" ]];
        then
            coltype="String";
            break
        else
            echo -e "${LRED}❌ Invalid type! Enter Int or String.${NC}"
        fi
    done

    # Primary Key
    is_pk="no"
    if [ "$pk_chosen" = false ]; then
        if [ "$i" -lt "$colnum" ]; then
            while true; do
                echo -ne "${LYELLOW}Make PK? (y/n): ${NC}"
                read ch
                ch=$(echo "$ch" | tr '[:upper:]' '[:lower:]' | xargs)

                if [[ "$ch" == "y" || "$ch" == "yes" ]];
                then
                    is_pk="yes";
                    pk_chosen=true;
                    break
                elif [[ "$ch" == "n" || "$ch" == "no" ]]; then
                    break
                else
                    echo -e "${LRED}❌ Enter y or n.${NC}"
                fi
            done
        else
            echo -e "${LRED}⚠️ No PK chosen! [y] Make PK, [r] Restart, [c] Cancel:${NC}"
            while true;
            do
                read last_ch
                last_ch=$(echo "$last_ch" | tr '[:upper:]' '[:lower:]' | xargs)

                if [[ "$last_ch" == "y" || "$last_ch" == "yes" ]];
                then
                    is_pk="yes"; 
                    pk_chosen=true; 
                    break
                elif [[ "$last_ch" == "r" ]]; then
                    i=0
                    temp_meta=""
                    pk_chosen=false
                    col_names=()
                    continue 2
                elif [[ "$last_ch" == "c" ]]; then
                    cancelled=true;
                    break 2
                else
                    echo -e "${LRED} ❌ Required y / r / c.${NC}"
                fi
            done
        fi
    fi

    temp_meta+="$colname:$coltype:$is_pk"$'\n'
done

# Create Table
if [ "$pk_chosen" = true ] && [ "$cancelled" = false ];
then
    echo -n "$temp_meta" > "$DB_PATH/${tname}_meta"
    touch "$DB_PATH/$tname"
    echo -e "${LGREEN} ✅ Table '$tname' created successfully.${NC}"
elif [ "$cancelled" = true ]; then
    echo -e "${LRED} 🚫 Operation cancelled.${NC}"
fi

