test -z ${BOX:-} && {
   echo "you MUST specify the box to rsync to !!!";
   exit 1;
}
echo using the following BOX : $BOX
# -p some_var=some_val
# 
arr_params=($(echo $params | tr ',' "\n"))
for i in "${arr_params[@]}"
do
   var_name=$(echo $i|cut -d'=' -f1)
   var_val=$(echo $i|cut -d'=' -f2)
   declare $var_name=$var_val
   test $var_name == 'tgt_box' && tgt_box=$var_val
   #echo var_name: $var_name
   #echo var_val: $var_val
   #echo var_val expanded: ${!var_name}
done

echo tgt_box: $var_val
