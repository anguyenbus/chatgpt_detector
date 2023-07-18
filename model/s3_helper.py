"""
title: s3_helper
description: Helper module for S3 operations
author: An Nguyen
"""

import os

import boto3


class S3Helper:
    s3_resource = boto3.resource('s3')
    s3 = boto3.client('s3')

    def upload_file(self, file_name: str, bucket: str, object_name: str = None) -> bool:
        """Uploads a file to an S3 bucket.

        Args:
            file_name (str): File to upload.
            bucket (str): Bucket to upload to.
            object_name (str, optional): S3 object name. If not specified, file_name is used.

        Returns:
            bool: True if the file was uploaded successfully, else False.

        Raises:
            RuntimeError: If the file failed to upload to S3.
        """
        if object_name is None:
            object_name = file_name

        try:
            _ = self.s3.upload_file(file_name, bucket, object_name)
            print(f"Uploading {file_name} to s3://{bucket}/{object_name}")
        except Exception as e:
            print(str(e))
            raise RuntimeError("Failed to upload file to S3")
        return True

    def upload_model(self, model, bucket: str, object_name: str) -> None:
        """Uploads a PyTorch model to an S3 bucket.

        Args:
            model (torch.nn.Module): PyTorch model to upload.
            bucket (str): Bucket to upload to.
            object_name (str): S3 object name for the model.

        Returns:
            None
        """
        # Save the model locally
        model_dir = "./saved_model"
        os.makedirs(model_dir, exist_ok=True)
        model.save_pretrained(model_dir)

        # Upload the model to S3
        self.upload_folder(model_dir, bucket, object_name)

        print(f"Uploaded model to S3 bucket: s3://{bucket}/{object_name}")

    def upload_folder(self, local_folder: str, s3_bucket: str, s3_folder: str) -> None:
        """Uploads a folder to an S3 bucket.

        Args:
            local_folder (str): Local folder to upload.
            s3_bucket (str): Bucket to upload to.
            s3_folder (str): Folder in S3.

        Returns:
            None

        """
        for subdir, _, files in os.walk(local_folder):
            for file in files:
                local_path = os.path.join(subdir, file)
                relative_path = os.path.relpath(local_path, local_folder)
                s3_path = os.path.join(s3_folder, relative_path)
                self.upload_file(local_path, s3_bucket, s3_path)

        print(f"Upload data to {s3_bucket}/{s3_folder}")
