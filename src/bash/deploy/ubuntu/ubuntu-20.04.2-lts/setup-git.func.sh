do_setup_git(){

   test -f ~/.gitconfig && cp -v ~/.gitconfig ~/.gitconfig.$(date "+%Y%m%d_%H%M%S")

cat << EOF_GIT >> ~/.gitconfig

   [credential]
     helper = cache

   [core]
     editor = vim
     pager = less -r
     autocrlf = false
	  filemode = false

   [push]
      default = simple
      followTags = true

   [color]
     diff = auto
     status = auto
     branch = auto
     interactive = auto
     ui = true
     pager = true

   [color "status"]
     added = green
     changed = red bold
     untracked = magenta bold

   [color "branch"]
     remote = yellow

   [fetch]
      prune = true
EOF_GIT

   # have the filemode = false on the project level as well
   perl -pi -e 's|filemode = true|filemode = false|g' $PRODUCT_DIR/.git/config
}
