#!/bin/sh

BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M")
FILENAME=$BACKUP_DATE-$APP_NAME

echo "[`date +%Y-%m-%d\ %H:%M:%S`] starting the backup process"

cd /backup

echo "[`date +%Y-%m-%d\ %H:%M:%S`] taring the backup folder..."
tar cJf ~/$FILENAME.tar.xz ./*
cd /

echo "[`date +%Y-%m-%d\ %H:%M:%S`] encrypting the backup file..."
gpg --trust-model always --output ~/$FILENAME.tar.xz.gpg --encrypt --recipient $GPG_RECIPIENT ~/$FILENAME.tar.xz
rm ~/$FILENAME.tar.xz

echo "[`date +%Y-%m-%d\ %H:%M:%S`] uploading encrypted backup file to AWS S3..."
aws s3 cp ~/$FILENAME.tar.xz.gpg s3://$S3_BUCKET_NAME/$FILENAME.tar.xz.gpg --storage-class STANDARD_IA
rm ~/$FILENAME.tar.xz.gpg

echo "[($date)] backup process completed"
