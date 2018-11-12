#!/bin/sh

BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M")

echo "[($date)] starting the backup process"

cd /backup

echo "[($date)] taring the backup folder..."
tar cJf ~/$S3_BUCKET_NAME$BACKUP_DATE.tar.xz ./*
cd /

echo "[($date)] encrypting the backup file..."
gpg --trust-model always --output ~/$S3_BUCKET_NAME$BACKUP_DATE.tar.xz.gpg --encrypt --recipient $GPG_RECIPIENT ~/$S3_BUCKET_NAME$BACKUP_DATE.tar.xz
rm ~/$S3_BUCKET_NAME$BACKUP_DATE.tar.xz

echo "[($date)] uploading encrypted backup file to AWS S3..."
aws s3 cp ~/$S3_BUCKET_NAME$BACKUP_DATE.tar.xz.gpg s3://$S3_BUCKET_NAME/$S3_BUCKET_NAME$BACKUP_DATE.tar.xz.gpg --storage-class STANDARD_IA
rm ~/$S3_BUCKET_NAME$BACKUP_DATE.tar.xz.gpg

echo "[($date)] backup process completed"
