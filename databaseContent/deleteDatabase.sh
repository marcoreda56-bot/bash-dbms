echo -ne "${LCYAN}Enter database name to delete: ${NC}";
            read dbname
            dbname=$(echo "$dbname" | xargs)
            if [ -d "$DB_folder/$dbname" ] && [ -n "$dbname" ]; then
                echo -ne "${LRED}⚠️ Are you sure you want to delete '$dbname'? (y/n): ${NC}"
                read confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" || "$confirm" == "yes" || "$confirm" == "Yes" || "$confirm" == "YES" ]]; then
                    rm -r "$DB_folder/$dbname"
                    echo -e "${LGREEN}🗑️ Database '$dbname' was deleted.${NC}"
                else
                    echo -e "${LYELLOW}🚫 Deletion cancelled.${NC}"
                fi
            else
                echo -e "${LRED}❌ Database '$dbname' does not exist!${NC}"
            fi
