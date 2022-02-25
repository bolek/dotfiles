install postgres:

```
POSTGRES_EXTRA_CONFIGURE_OPTIONS="--with-uuid=e2fs --with-openssl --with-libraries=/usr/local/lib:/opt/homebrew/opt/openssl@1.1/lib --with-includes=/usr/local/include:/opt/homebrew/opt/openssl@1.1/include" asdf install postgres 12.7
```

PostGIS:
https://github.com/smashedtoatoms/asdf-postgres/issues/5#issuecomment-1039688845

```
getpostgis 3.2.0
```
