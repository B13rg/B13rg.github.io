# tree ./advanced-custom-fields-6.3.6 > tree-6.3.6.txt 
# tree ./advanced-custom-fields-6.3.6.2 > tree-6.3.6.2.txt 
\diff -qr ./advanced-custom-fields-6.3.6/ ./advanced-custom-fields-6.3.6.2/ > diff-summary.txt
\diff -u --suppress-common-lines -b -r ./advanced-custom-fields-6.3.6/ ./advanced-custom-fields-6.3.6.2/ > diff.txt

