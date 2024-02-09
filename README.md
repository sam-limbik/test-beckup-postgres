# PostgreSQL All Database Backup CronJob
This repository contains a Kubernetes CronJob configuration for automated backups of all databases in a PostgreSQL instance. The backup is scheduled to run every day at 21:14, and the resulting dump is compressed and stored in an AWS S3 bucket.

### Installation
Apply the CronJob to your Kubernetes cluster:

```
kubectl apply -f postgresql-cornjob.yaml
```
### Configuration

Adjust the following parameters in the postgresql-all-db-backup-job.yaml file according to your setup:

- schedule: The cron schedule for the backup job. The provided schedule runs the job every day at 21:14.
- env section: Update the environment variables based on your PostgreSQL and AWS S3 configuration.
- AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY: AWS IAM user credentials with S3 access.
- POSTGRES_PASSWORD, POSTGRES_USER, and POSTGRES_HOST: PostgreSQL database connection details.
- S3_BUCKET_NAME and S3_FOLDER_NAME: AWS S3 bucket and folder where the backup will be stored.

----------------------------------------------------------------------------------------------------------------------------------------------------
# Backup PostgreSQL
 A backup script for PostgreSQL that automatically pushes the backup to Amazon S3 

### Create the Backup Script
1. Copy the following script into the file:
```
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
```
2. Make the Script Executable
```
chmod +x backup_postgres_to_s3.sh
```
3. Test the Script
```
./backup_postgres_to_s3.sh
```
5. Schedule the Script with Cron
Open the crontab file:

```
crontab -e
```
6. Add a line to schedule your script to run at a specific time every night. For example, to run it every day at 2 AM, add:

```
0 2 * * * /path/to/your/backup_postgres_to_s3.sh

```
