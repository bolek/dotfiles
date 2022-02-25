#add each topic folder to fpath so that they can add functions and completion scripts
for topic_folder ($ZSH/*) if [ -d $topic_folder ]; then  fpath=($topic_folder $fpath); fi;

#add pure them functions
fpath+=/opt/homebrew/Cellar/pure/1.20.1/share/zsh/site-functions
fpath+=/opt/homebrew/share/zsh/site-functions