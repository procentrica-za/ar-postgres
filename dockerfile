FROM postgres
FROM postgis/postgis
COPY scripts/* /docker-entrypoint-initdb.d/
COPY sql/* /sql/




    
