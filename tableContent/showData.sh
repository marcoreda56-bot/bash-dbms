echo -ne "${LCYAN}Table Name: ${NC}"
read tname

if [ -f "$DB_PATH/$tname" ]; then

    echo -e "${WHITE}1) Show All Columns${NC}\n${WHITE}2) Select Specific Columns${NC}"
    echo -ne "${BOLD}Choice: ${NC}"
    read show_choice

    if [[ "$show_choice" == "1" ]]; then
        # Show all columns
        header=$(awk -F':' 'BEGIN{ORS=","} {print $1}' "$DB_PATH/${tname}_meta" | sed 's/,$//')
        echo -e "\n${BOLD}${WHITE}--- $tname ---${NC}"
        (echo -e "${LGREEN}$header${NC}"; cat "$DB_PATH/$tname") | column -t -s ','

    elif [[ "$show_choice" == "2" ]]; then
        # Select specific columns
        echo -e "${LPURPLE}Available Columns:${NC}"
        awk -F':' '{print NR") " $1}' "$DB_PATH/${tname}_meta"

        echo -ne "${WHITE}Enter column names or numbers: ${NC}"
        read user_input

        indices=$(awk -F':' -v inp="$user_input" '
            BEGIN { split(inp, words, " ") }
            { 
                for (i in words) { 
                    if (words[i] == NR || words[i] == $1) { 
                        result[i] = NR 
                    } 
                } 
            } 
            END { 
                for (j=1; j<=length(words); j++) 
                    printf "%s ", result[j] 
            }' "$DB_PATH/${tname}_meta")

        if [ -z "$(echo $indices | xargs)" ]; then
            echo -e "${LRED}❌ No valid columns!${NC}"
        else
            header=$(awk -F':' -v idx="$indices" '
                BEGIN { split(idx,a," ") } 
                { for(i in a) if(NR==a[i]) printf "%s ", $1 }' "$DB_PATH/${tname}_meta")

            echo -e "\n${BOLD}${WHITE}--- Custom View: $tname ---${NC}"
            (echo -e "${LGREEN}$header${NC}"; 
             awk -F',' -v idx="$indices" '
                 BEGIN { split(idx,a," ") } 
                 { for(i in a) printf "%s ", $a[i]; print "" }' "$DB_PATH/$tname") | column -t
        fi

    fi

else
    echo -e "${LRED}❌ Not found.${NC}"
fi

