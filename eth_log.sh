#   Begin analysis

while [[ true ]]
do
    NET=`ifconfig eth0`
    STRING=`echo ${NET} | grep -e "TX bytes:.*)" -o`
    echo -------------${STRING}-------------
    sleep 120
done