# postgres

Postgres is built with [pgenv](https://github.com/theory/pgenv) (`~/.pgenv`,
on PATH via `_path.zsh`). Build deps come from `profiles/work/Brewfile`.

```sh
export PGENV_CONFIGURE_OPTIONS="--with-uuid=e2fs --with-openssl \
  --with-libraries=$(brew --prefix openssl@3)/lib \
  --with-includes=$(brew --prefix openssl@3)/include"
pgenv build <version> && pgenv use <version>
```

PostGIS, built against the active `pg_config`:

```sh
getpostgis 3.5.0
```
