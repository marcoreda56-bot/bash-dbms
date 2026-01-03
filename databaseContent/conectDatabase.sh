echo -e "${LPURPLE}🔗 Available Databases to connect:${NC}"

found=false
for db in "$DB_folder"/*; do
    if [[ -d "$db" ]]; then
        found=true
        echo -e "  • ${WHITE}$(basename "$db")${NC}"
    fi
done

if [[ "$found" == false ]]; then
    echo -e "${LYELLOW}⚠️ No databases available.${NC}"
    break
fi

echo -ne "${LCYAN}Enter database name to connect: ${NC}"
read dbname
dbname=$(echo "$dbname" | xargs)

if [[ -d "$DB_folder/$dbname" ]]; then
    echo -e "${LGREEN}🚀 Connected to '$dbname'${NC}"
    ./table.sh "$DB_folder/$dbname"
else
    echo -e "${LRED}❌ Database '$dbname' does not exist!${NC}"
fi
