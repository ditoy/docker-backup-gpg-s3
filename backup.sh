#!/bin/sh

BACKUP_DATE=$(date +"%Y-%m-%d_%H-%M")

echo "[`date +%Y-%m-%d\ %H:%M:%S`] starting the backup process"

cd /backup

echo "[`date +%Y-%m-%d\ %H:%M:%S`] taring the backup folder..."
tar cJf ~/$BACKUP_DATE-$S3_BUCKET_NAME.tar.xz ./*
cd /

echo "[`date +%Y-%m-%d\ %H:%M:%S`] encrypting the backup file..."
gpg --trust-model always --output ~/$BACKUP_DATE-$S3_BUCKET_NAME.tar.xz.gpg --encrypt --recipient $GPG_RECIPIENT ~/$BACKUP_DATE-$S3_BUCKET_NAME.tar.xz
rm ~/$BACKUP_DATE-$S3_BUCKET_NAME.tar.xz

echo "[`date +%Y-%m-%d\ %H:%M:%S`] uploading encrypted backup file to AWS S3..."
aws s3 cp ~/$BACKUP_DATE-$S3_BUCKET_NAME.tar.xz.gpg s3://$S3_BUCKET_NAME/$BACKUP_DATE-$S3_BUCKET_NAME.tar.xz.gpg --storage-class STANDARD_IA
rm ~/$BACKUP_DATE-$S3_BUCKET_NAME.tar.xz.gpg

echo "[($date)] backup process completed"
