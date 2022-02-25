function getpostgis () {
    wget -q -P tmp/ https://github.com/postgis/postgis/archive/"$@".tar.gz
    tar xvzf tmp/"$@".tar.gz -C tmp/
    cd tmp/postgis-"$@"
    if [[ ! -a ./configure ]]; then
      ./autogen.sh
    fi
    eval ./configure `pg_config --configure --withprojdir=/opt/homebrew/Cellar/proj/8.2.1`
    make
    make install
    cd ../..
    rm -rf tmp/
}