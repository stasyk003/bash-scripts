#!/bin/bash

MYSQL_ROOT_PASSWORD=$(grep -E '^MYSQL_ROOT_PASSWORD=' ./s3-bucket/.env | sed -E 's/MYSQL_ROOT_PASSWORD=//')
USER="root"
PASSWORD="$MYSQL_ROOT_PASSWORD"
DATABASE="my_database"

timestamp=$(date +"%d-%m-%Y_%H:%M:%S")

command="sudo docker exec -i $container_id mysql-db -u root -p'$PASSWORD' $DATABASE --ignore-table=${DATABASE}.logs > "dump_${DATABASE}_${timestamp}.sql""
    
eval $command

dump_file="dump_${DATABASE}_${timestamp}.sql"
zip_file="dump_${DATABASE}_${timestamp}.zip"

zip "$zip_file" "$dump_file"

rm "$dump_file"

aws s3 cp "$zip_file" s3://test-bucket-bash-script/
