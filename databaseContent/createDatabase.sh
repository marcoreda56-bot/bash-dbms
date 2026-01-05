echo -ne "${LCYAN}Please enter name of database: ${NC}"
	    read -r databaseName
            databaseName=$(echo "$databaseName" | tr '[:upper:]' '[:lower:]' | xargs)
	    databaseName=$(echo "$databaseName" | tr -d '\\' | xargs )
	    	
	    if [[ -z "$databaseName" ]]; then
	    echo -e "${LRED}❌ Database name cannot be empty${NC}"

	    elif [[ ! "$databaseName" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
	    echo -e "${LRED}❌ Invalid name! (Must start with a letter and contain only letters, numbers, _ )${NC}"

	    elif [[ -d "$DB_folder/$databaseName" ]]; then
	    echo -e "${LRED}❌ Database already exists!${NC}"

	    else
	    mkdir "$DB_folder/$databaseName"
	    chmod 755 "$DB_folder/$databaseName"
	    echo -e "${LGREEN}✅ Database '$databaseName' created successfully.${NC}"
	    fi
