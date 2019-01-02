#!/bin/bash

if [[ -z "${OPG_ENV}" ]]; then
  echo "OPG_ENV environment variable not defined. Exiting."  
  exit
fi

es_address=localhost
bucket_name="sirius-elastic-backup-${OPG_ENV}"
days_old_should_be_archived=12
noopmode=true

echo "Running with configuration
       OPG_ENV:     $OPG_ENV
       es_address:  $es_address
       bucket_name: $bucket_name
       noopmode:    $noopmode
    "

indexes=$(curl -s http://$es_address:9200/_cat/indices?h=h,i,creation.date.string | sort)
# do not delete the .kibana index
indexes=$(echo "$indexes" | grep -v .kibana)

while read -r index; do
    date_created="$(echo $index | cut -d ' ' -f 3)"
    index_name="$(echo $index | cut -d ' ' -f 2)"
    created_days_ago=$(( (`date -d "00:00" +%s` - `date -d $date_created +%s`) / (24*3600) ))

    if (( created_days_ago > days_old_should_be_archived )); then
        echo "Index: $index_name which was created $created_days_ago days ago will be backed up to S3 and then deleted"

        # Backup the index to S3.
        if $noopmode ; then
            echo "  NOOP mode. Backup $index_name to s3://$bucket_name"
        else
            echo "  Backup $index_name to s3://$bucket_name"
            docker run --network="host" --rm taskrabbit/elasticsearch-dump --input=http://$es_address:9200/"$index_name" --s3Bucket=$bucket_name --s3RecordKey="$index_name" --noRefresh --limit 10000
        fi
        
        # Remove the index.
        if $noopmode ; then
            echo "  NOOP mode. Removing index $index_name"
        else
            echo "  Removing index $index_name"
            #curl -X DELETE http://$es_address:9200/$index_name
        fi
            
    else
        echo "Index: $index_name which was created $created_days_ago days ago will be kept"
    fi

done <<< "$indexes"