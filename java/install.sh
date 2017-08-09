# Install sdkman
curl -s "https://get.sdkman.io" | zsh
source "$HOME/.sdkman/bin/sdkman-init.sh"
sed -i -- 's/sdkman_beta_channel=false/sdkman_beta_channel=true/g' ~/.sdkman/etc/config
sdk selfupdate force

sdk install java
sdk install grails 3.2.9
