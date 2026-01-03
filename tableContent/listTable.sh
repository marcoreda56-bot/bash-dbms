ls -1 "$DB_PATH" | grep -Ev '(_meta$|\.csv$)' | sed 's/^/  • /'

