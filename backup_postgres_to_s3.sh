#!/bin/bash

# Set your PostgreSQL and Kubernetes configurations
POSTGRES_NAMESPACE="default"
POSTGRES_POD_NAME="postgres-7d877d54f7-x445x"
POSTGRES_DB_NAME="user"
BACKUP_DIR="./"
POSTGRES_USER="user"


S3_BUCKET="test-backup-postgresql2024"

# Create a timestamp for the backup file
TIMESTAMP=$(date "+%Y%m%d%H%M%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.sql"

# Execute pg_dump within the PostgreSQL pod
kubectl exec -it -n $POSTGRES_NAMESPACE $POSTGRES_POD_NAME -- pg_dump -U $POSTGRES_USER -d $POSTGRES_DB_NAME > $BACKUP_FILE

aws s3 cp ./$BACKUP_FILE s3://$S3_BUCKET/$BACKUP_FILE

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup successful. File: $BACKUP_FILE"
else
  echo "Backup failed. Please check the logs for more information."
fi
