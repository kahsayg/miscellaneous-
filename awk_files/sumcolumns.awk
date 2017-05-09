http://www.unix.com/shell-programming-scripting/186493-awk-based-script-find-average-all-columns-data-file.html

FNR==1 { nf=NF} {  for(i=1; i<=NF; i++)    arr[i]+=$i ;  fnr=FNR } END {   for( i=1; i<=nf; i++)    printf("%.2f%s", arr[i] / fnr, (i==nf) ? "\n" : FS) }