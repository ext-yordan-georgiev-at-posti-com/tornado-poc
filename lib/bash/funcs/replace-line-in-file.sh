# Argument: file, line to find as string, line to replace as string.
# Exit 1 when:
# - file does not exist
# - search line is missing
# - replacement line is missing
# - search line not found in the file, unless replacement line is found
# - replacement line not found in the file, after replacement operation.

do_replace_line_in_file(){

   fle=$1
   test -f $fle || {
      echo "ERROR : File '$fle' does not exist."; 
      exit 1;
   }

   search_line=$2
   test -n "$search_line" || {
      echo "ERROR : Missing search line for the file '$fle'";
      exit 1;
   }

   replacement_line=$3
   test -n "$replacement_line" || {
      echo "ERROR : Missing replacement line for the file '$fle'";
      exit 1;
   }

   check_replacement_line_exists(){

      line_in_file=$(sudo grep -x "$replacement_line" $fle)
      test -n "$line_in_file" || {
         echo "ERROR : Replacement line ('$replacement_line') not found in the file '$fle'";
         exit 1;
      }

   }

   line_in_file=$(sudo grep -x "$search_line" $fle)
   # Search line in file is not found.
   if [ -z "$line_in_file" ]
      then {
         # Check in a subshell if replacement line exists already in file.
         ( check_replacement_line_exists )
         if [ $? -ne 0 ]
         then {
            echo "ERROR : Search line ('$search_line') not found in the file '$fle'";
            exit 1;
         }
         fi
      }
   # Search line in file is found.
   else {
      sudo perl -p -i -e "s|$search_line|$replacement_line|g" $fle

      check_replacement_line_exists
   }
   fi

}
