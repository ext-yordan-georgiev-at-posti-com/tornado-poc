# Arguments: file and package.
# Exit 1 when:
# - File does not exist.
# - Package is an empty string.
# - Package does not exist in the file.
# - Package is a custom package but does not have a version in the file.
# - Package is a default package in the file.
# Displays:
# - Version, when the custom package exists with version.
 
do_get_version_of_package_from_file(){

   fle=$1
   test -f $fle || {
      echo "ERROR : File '$fle' does not exist.";
      exit 1;
   }

   package=$2
   test -n "$package" || {
      echo "ERROR : Argument to search from file '$fle' is missing.";
      exit 1;
   }

   line=$(grep -w $package $fle)
   test -n "$line" || {
      echo "ERROR : Argument '$package' is not found in the file '$fle'";
      exit 1;
   }

   version=$(echo $line | cut -d'=' -f2)
   test -n "$version" || {
      echo "ERROR : Argument '$package' is a custom package but does not have a version defined in the file '$fle'";
      exit 1;
   }
   [[ $line == $version ]] && {
      echo "ERROR : Argument '$package' is a default package in the file '$fle'";
      exit 1;
   }

   echo $version
}
