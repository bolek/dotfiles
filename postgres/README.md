# postgres

Postgres is built with [pgenv](https://github.com/theory/pgenv), a git
checkout in `~/.pgenv` (on PATH via `_path.zsh`).

- `install.sh` (run by `script/install`) clones or updates pgenv and seeds
  `~/.pgenv/config/default.conf` from `pgenv-default.conf` if it's missing.
- Build deps (openssl@3, icu4c, libxml2, ossp-uuid, …) are in
  `profiles/work/Brewfile`.

```sh
pgenv available          # list versions
pgenv build 17.11        # build with the default.conf options
pgenv use 17.11
```

PostGIS, built against the active `pg_config`:

```sh
getpostgis 3.5.0
```
