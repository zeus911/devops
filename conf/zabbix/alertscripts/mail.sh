#!/bin/bash
 
to=$1
subject=$2
body=$3
 
cat <<EOF | mail -s "$subject" "$to"
$body
EOF
