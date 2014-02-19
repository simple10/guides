# Resources

* [Costs of a PostgreSQL connection](http://hans.io/blog/2014/02/19/postgresql_connection/index.html)

# OSX

```bash
brew install postgresql

# Init postgres db and conf files
initdb /usr/local/var/postgres -E utf8

# Start server
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start

# Setup postgres superuser for dev
psql -U joe postgres
create role postgres SUPERUSER login;
\q
```

