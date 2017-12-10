#!/bin/bash

# Program: TextGrid2CSV.sh
# Purpose: Convert TextGrid files output by Montreal Forced Aligner to CSV

# Define awk program to convert TextGrid to CSV
read -r -d '' converter <<'EOF'
    FNR == 1 { phones = 0 }

    phones == 1 && /^\t{4}/ && /xmin/ { printf("%s,", FILENAME) }

    phones == 1 && /^\t{4}/ && $0 !~ /text/ { 
        gsub(/^[\t a-z]+ = /, "")
        gsub(/[\t ]+$/, "")
        printf("%s,", $0)
    }

    phones == 1 && /^\t{4}/ && /text/ { 
        gsub(/^[\t a-z]+ = /, "")
        gsub(/[\t ]+$/, "")
        printf("%s\n", $0)
    }

    /item \[2\]:/ { phones = 1 }
EOF

# Create output file
echo "file,xmin,xmax,text" > ../data/labels.csv

# Fill output file
for d in $(ls ../data/alignments | grep -E '[a-z0-9]{8}')
do
    for f in $(ls ../data/alignments/$d)
    do
        awk "$converter" "../data/alignments/$d/$f" >> ../data/labels.csv
    done
done

# Convert blank labels to silence
sed -iE 's/""$/"sil"/g' ../data/labels.csv

exit 0

