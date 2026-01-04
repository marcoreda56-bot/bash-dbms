echo -ne "Table Name: "
read tname

if [[ ! -f "$DB_PATH/$tname" || ! -f "$DB_PATH/${tname}_meta" ]]; 
then
    echo "❌ Table or Meta not found!"
    continue
fi

mapfile -t meta < "$DB_PATH/${tname}_meta"
cols_count=${#meta[@]}
total_rows=$(wc -l < "$DB_PATH/$tname")

line=1
while IFS=',' read -ra row;
do
    if (( ${#row[@]} != cols_count ));
    then
        echo "❌ Corrupted row at line $line"
        continue 2
    fi
    ((line++))
done < "$DB_PATH/$tname"

echo "1) Show All Columns (All Rows)"
echo "2) Select Specific Columns (All Rows)"
echo "3) Show Single Row"
echo "4) Get Cell (Row + Column)"
echo -n "Choice: "
read choice

case $choice in
1)

    header=$(awk -F':' '{print $1}' "$DB_PATH/${tname}_meta" | paste -sd "," -)
    #(echo "$header"; cat "$DB_PATH/$tname") | column -t -s ','
    (echo "$header"; cat "$DB_PATH/$tname") | tr ',' '|' | column -t -s '|'

    ;;

2)

    awk -F':' '{print NR") "$1}' "$DB_PATH/${tname}_meta"
echo -n "Enter column names or numbers: "
read input
if [[ -z "$input" ]]; then
    echo "❌ cant be empty"
    continue
fi

input=$(echo "$input" | tr -s ' ')
input=$(echo "$input" | tr ',' ' ')

indices=""
for w in $input; do
    idx=$(awk -F':' -v w="$w" '($1==w || NR==w){print NR; exit}' "$DB_PATH/${tname}_meta")
    if [[ -z "$idx" ]]; then
        echo "❌ Invalid column: $w"
        continue 2
    fi
    indices+="$idx "
done
awk -F',' -v idx="$indices" '
BEGIN { split(idx,a," ") }
{
    for(i=1;i<=length(a);i++) printf "%s ", $a[i]
    print ""
}' "$DB_PATH/$tname" | column -t

    ;;

3)

    echo -n "Enter row number: "
    read r
    if ! [[ "$r" =~ ^[1-9][0-9]*$ ]] || (( r > total_rows )); then
    echo "❌ Invalid row number"
    continue
    fi

    row=$(head -n "$r" "$DB_PATH/$tname" | tail -n 1)
    IFS=',' read -ra cols <<< "$row"
    for col in "${cols[@]}"; do
        echo -n "$col    "
    done
    echo
    ;;

4)

    echo -n "Enter row number: "
    read r
    if ! [[ "$r" =~ ^[0-9]+$ ]] || (( r<1 || r>total_rows )); then
        echo "❌ Invalid row number"
	continue
    fi

    awk -F':' '{print NR") "$1}' "$DB_PATH/${tname}_meta"
    echo -n "Enter column number: "
    read c
    if ! [[ "$c" =~ ^[0-9]+$ ]] || (( c<1 || c>cols_count )); 
    then
        echo "❌ Invalid column number"
        continue
    fi

    cell=$(head -n "$r" "$DB_PATH/$tname" | tail -n 1 | awk -F',' -v col="$c" '{print $col}')
    colname=$(sed -n "${c}p" "$DB_PATH/${tname}_meta" | cut -d':' -f1)
    echo "Cell [$r,$colname] = $cell"
    ;;

*)
    echo "❌ Invalid choice"
    ;;
esac

