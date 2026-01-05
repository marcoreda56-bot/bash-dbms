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
read -r dbname
dbname=$(echo "$dbname" | xargs)
if [[ "$dbname" == *"/"* || "$dbname" == *".."* || "$dbname" == *"."* ]]; then
    echo -e "${LRED}❌ Invalid table name! Paths are not allowed.${NC}"
    continue
fi
if [[ -z "$dbname" ]]; 
then
echo -ne "${LYELLOW}❌ Sorry can not be empty.${NC}"
continue
fi

if [[ -d "$DB_folder/$dbname" ]]; then
    echo -e "${LGREEN}🚀 Connected to '$dbname'${NC}"
    /home/marco/script/project/table.sh "$DB_folder/$dbname"
else
    echo -e "${LRED}❌ Database '$dbname' does not exist!${NC}"
fi
