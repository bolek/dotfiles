function getpostgis () {
    wget -q -P tmp/ https://github.com/postgis/postgis/archive/"$@".tar.gz
    tar xvzf tmp/"$@".tar.gz -C tmp/
    cd tmp/postgis-"$@"
    if [[ ! -a ./configure ]]; then
      ./autogen.sh
    fi
    eval ./configure `pg_config --configure`
    make
    make install
    cd ../..
    rm -rf tmp/
}