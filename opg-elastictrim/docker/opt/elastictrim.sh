#!/bin/bash

set -eo pipefail

if [[ -z "${OPG_ENV}" ]]; then
  echo "OPG_ENV environment variable not defined. Exiting."  
  exit
fi

es_address=localhost
bucket_name="sirius-elastic-backup-${OPG_ENV}"
archive_days_limit=${ELASTICTRIM_DAYS_OLD:-70}

# Default to safe value
case "${ELASTICTRIM_NOBACKUP,,}" in
 false) nobackup=false ;;
 *) nobackup=true ;;
esac

# Default to safe value of no deletes is true
case "${ELASTICTRIM_NODELETE,,}" in
 false) nodelete=false ;;
 *) nodelete=true ;;
esac

echo "Running with configuration
       OPG_ENV:     $OPG_ENV
       es_address:  $es_address
       archive_days_limit: $archive_days_limit
       bucket_name: $bucket_name
       nobackup:    $nobackup
       nodelete:    $nodelete
    "

indexes=$(curl -s http://$es_address:9200/_cat/indices?h=h,i,creation.date.string | sort)
# do not delete the .kibana index
indexes=$(echo "$indexes" | grep -v .kibana)

while read -r index; do
    date_created="$(echo $index | cut -d ' ' -f 3)"
    index_name="$(echo $index | cut -d ' ' -f 2)"
    created_days_ago=$(( (`date -d "00:00" +%s` - `date -d $date_created +%s`) / (24*3600) ))

    if (( created_days_ago > archive_days_limit )); then
        echo "Index: $index_name which was created $created_days_ago days ago will be backed up to S3 and then deleted"

        # Backup the index to S3.
        echo "  Backup index $index_name"
        if $nobackup ; then
            echo "  NOOP mode. Not Backing $index_name to s3://$bucket_name"
        else
            echo "  Backing up $index_name to s3://$bucket_name"
            mkdir -p /data/esdump
            docker run \
              --network="host" \
              --rm \
              -v /data/esdump:/outputfiles \
              taskrabbit/elasticsearch-dump \
                --input=http://$es_address:9200/"$index_name" \
                --output=/outputfiles/"$index_name" \
                --noRefresh \
                --limit 1000
            aws s3 mv /outputfiles/"$index_name" s3://"$bucket_name"/"$index_name"
        fi
        
        # Remove the index.
        echo "  Remove index $index_name"

        # Test is backup is present on S3
        s3_index_file="$(aws s3 ls s3://$bucket_name/$index_name)"
        if [ $? -ne 0 ]
        then
            echo "  s3://$bucket_name/$index_name does not exist. Skipping indended delete."
            continue
        else
            echo "  Found s3://$bucket_name/$index_name"
        fi

        # Small indexes could be sign of failure.    
        s3_index_file_size="$( echo $s3_index_file | cut -d ' ' -f 3)"
        echo "  s3://$bucket_name/$index_name File size: $s3_index_file_size"
        if [ "$s3_index_file_size" -lt 100000 ]
        then
            echo "  s3://$bucket_name/$index_name is too small. Skipping indended delete."
            continue
        fi

        if $nodelete ; then
            echo "  NOOP mode. Not Removing index $index_name"
        else
            echo "  Removing index $index_name"
            curl -X DELETE http://$es_address:9200/"$index_name"
        fi
            
    else
        echo "Index: $index_name which was created $created_days_ago days ago will be kept"
    fi

done <<< "$indexes"
