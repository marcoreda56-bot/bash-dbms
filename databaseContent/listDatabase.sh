echo -e "${LPURPLE}📋 Available Databases:${NC}"

dbs=("$DB_folder"/*/)

if [[ ${#dbs[@]} -eq 0 ]]; then
    echo -e "   ${WHITE}(No databases found)${NC}"
else
    for db in "${dbs[@]}"; do
        echo -e "  • ${WHITE}$(basename "$db")${NC}"
    done
fi
