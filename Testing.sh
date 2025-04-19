#!/bin/bash

read -p $' 0 to encrypt messages \n 1 to encrypt image \n 2 to decrypt messages or images \n\nAnything else to quit program: ' n
if [ "$n" = "0" ]; then
    keys=()
    names=()
    while IFS= read -r line; do
        if [[ "$line" == gpg:*key* ]]; then
            key_id=${line#*key }
            key_id=${key_id%%:*}
            name=${line#*\"}
            name=${name%%\"*}
            keys+=("$key_id")
            names+=("$name")
        fi
    done < <(for f in *.asc; do gpg --import "$f" 2>&1; done)

    echo "Available keys:"
    for i in "${!keys[@]}"; do
        printf "%d) %s - %s\n" "$((i+1))" "${keys[i]}" "${names[i]}"
    done

    read -p $'\nEnter key numbers (space-separated): ' -a numbers
    selected_keys=()
    for num in "${numbers[@]}"; do
        index=$((num - 1))
        if [[ "$num" =~ ^[0-9]+$ ]] && [ "$index" -ge 0 ] && [ "$index" -lt "${#keys[@]}" ]; then
            selected_keys+=("${keys[index]}")
        else
            echo "Invalid entry: $num (ignored)"
        fi
    done

    echo -e "\nSelected key IDs and names:"
    for i in "${!selected_keys[@]}"; do
        printf "%s\n" "${selected_keys[i]}"
    done


lines=()
echo "Enter your text (type 'DONE' to finish):"

while true; do
    read -e -p "> " line
    if [[ "$line" == "DONE" ]]; then
        break
    fi
    lines+=("$line")
done

while true; do
    echo "Current text:"
    for i in "${!lines[@]}"; do
        echo "$i: ${lines[i]}"
    done

    read -p "Enter line number to edit (or 'SAVE' to finish): " choice
    if [[ "$choice" == "SAVE" ]]; then
        break
    elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice < ${#lines[@]} )); then
        read -e -p "Edit line $choice: " new_line
        lines[$choice]="$new_line"
    else
        echo "Invalid choice."
    fi
done

final_text=$(printf "%s\n" "${lines[@]}")
echo "Final text:"
echo "$final_text"

    for aID in "${!selected_keys[@]}"; do
            echo "${selected_keys[aID]}"
            echo "$final_text" | gpg --armour -e -r "${selected_keys[aID]}" > txt.gpg
            #read -p "Name of file for "${selected_keys[aID]}" (don't repeat the same name): " name
            hexdump -v -e '1/1 "%02x"' txt.gpg | rev
            shred txt.gpg
    done
elif [ "$n" = "1" ]; then
    ls
    read -p "Media File name (with the .png or .mp4): " p
    hexdump -v -e '1/1 "%02x"' $p | rev > media
    for aID in "${selected_keys[aID]}"; do
            gpg -r  "${selected_keys[aID]}" -e media
            shred media
    done
elif [ "$n" = "2" ]; then
    read -p "Message (m) / Image (i) / Video (v)? " mi
    #ls
    #read -p "File name: " e
        if [ $mi = "m" ]; then
            read -p "Paste dump: " p_d
            perl -e 'print pack("H*", $ARGV[0])' $(echo $p_d | rev) > output.gpg
            gpg -d output.gpg
        elif [ $mi = "i" ]; then
            gpg -d $e.gpg > $e
            perl -e 'print pack("H*", $ARGV[0])' $(cat $e | rev) > image.png
        elif [ $mi = "v" ]; then
            gpg -d $e.gpg > $e
            perl -e 'print pack("H*", $ARGV[0])' $(cat $e | rev) > video.mp4
        else
            echo "Wrong input, exitting."
            exit
        fi
else
    exit
fi

else
    exit
fi
