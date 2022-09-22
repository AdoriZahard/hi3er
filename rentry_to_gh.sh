# Run with bash or zsh or similar, requires sed
# ./rentry_to_gh.sh <name of rentry file with hi3er markdown> [<optional output filename, defaults to rentry_to_gh_out.txt>]

if [ "$#" -gt 1 ]
then
    output_file=$2
else
    output_file="rentry_to_gh_out.txt"
fi

if [ "$#" -lt 1 ]
then
    echo "Need input file argument, run with ./rentry_to_gh.sh <input filename>"
fi

cp $1 $output_file

# Change admonitions
# !!! note <info>
# !!!note <info>
# !!!note: <info>
# to:
# !!! note
#     <info>
# the extra \l makes the admonition's first letter lowercase
sed -i -E 's/^\s*!!!\s*([[:alpha:]]+):*\s/!!! \l\1\n    /gi' $output_file

# info did not have a colored box
#sed -i 's/!!! info/!!! note/gi' $output_file

# Removed centered # and ##
sed -i -E 's/^#\s*->(.*)\s*<-\s*$/# \1/g' $output_file
sed -i -E 's/^##\s*->(.*)\s*<-\s*$/## -- \1/g' $output_file

# Increase the # amounts
sed -i 's/^#/##/g' $output_file
# Remove a # for the title which should be the first occurance of #
sed -i '0,/^#/s/#//' $output_file

# Remove centered from images or links
sed -i -E 's/\s*->\s*(!*\s*\[.*\]\s*\(.*\))\s*<-\s*/\1/g' $output_file

# Replace ->&<- with <p align="center">&</p>
sed -i 's/\s*->\s*/\<p align="center"\>/g; s/\s*<-\s*$/\<\/p\>/g' $output_file

# Replace :-:, :--:, :---:, etc by :----:
sed -i 's/:-*:/:----:/g' $output_file

# Make Signets into Signet and then add a newline before signet tables
sed -i 's/Signets | Priority/Signet | Priority/gi' $output_file
sed -i 's/Signet | Priority/\n&/gi' $output_file
sed -i 's/time | sigil/\n&/gi' $output_file


