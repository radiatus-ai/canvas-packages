import os
import time
import shutil
from typing import Any, Dict, List

import requests
import yaml
from google.cloud import storage
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

def read_yaml_file(file_path: str) -> Dict[str, Any]:
    with open(file_path, "r") as file:
        return yaml.safe_load(file)


def convert_yaml_to_package(yaml_data: Dict[str, Any]) -> Dict[str, Any]:
    return {
        "name": yaml_data.get("name", ""),
        "type": yaml_data.get("type", ""),
        "inputs": yaml_data.get("inputs", {}),
        "outputs": yaml_data.get("outputs", {}),
        "parameters": yaml_data.get("parameters", {}),
        # this script uploads global packages, not project packages
        # "project_id": project_id
    }


def create_package(api_base_url: str, package_data: Dict[str, Any]) -> Dict[str, Any]:
    url = f"{api_base_url}/packages/"
    headers = {
        "Authorization": f"Bearer {os.getenv('API_OAUTH_TOKEN')}"
    }
    response = requests.post(url, json=package_data, headers=headers)
    response.raise_for_status()
    return response.json()


def remove_gcs_directory(bucket_name: str, directory_path: str):
    """Removes all blobs in the specified GCS directory."""
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blobs = bucket.list_blobs(prefix=directory_path)
    for blob in blobs:
        blob.delete()
    print(f"Removed existing directory: {directory_path}")


def upload_to_gcs(bucket_name: str, source_dir: str, destination_blob_name: str):
    """Uploads a directory to the specified GCS bucket."""
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)

    for root, _, files in os.walk(source_dir):
        for file in files:
            local_file = os.path.join(root, file)
            relative_path = os.path.relpath(local_file, source_dir)
            blob_name = os.path.join(destination_blob_name, relative_path)

            blob = bucket.blob(blob_name)
            blob.upload_from_filename(local_file)
            print(f"File {local_file} uploaded to {blob_name}.")


def upload_packages(api_base_url: str, modules_dir: str, gcs_bucket_name: str) -> List[Dict[str, Any]]:
    uploaded_packages = []

    for root, _, files in os.walk(modules_dir):
        for file in files:
            if file.endswith(("canvas.yaml", "infra.yml")):
                file_path = os.path.join(root, file)
                print(f"Processing file: {file_path}")

                yaml_data = read_yaml_file(file_path)
                package_data = convert_yaml_to_package(yaml_data)

                try:
                    created_package = create_package(api_base_url, package_data)
                    uploaded_packages.append(created_package)
                    print(f"Successfully created package: {created_package['name']}")

                    # Upload package directory to GCS
                    package_dir = os.path.dirname(file_path)
                    gcs_destination = f"{created_package['type']}"

                    # Remove existing directory before uploading
                    remove_gcs_directory(gcs_bucket_name, gcs_destination)

                    upload_to_gcs(gcs_bucket_name, package_dir, gcs_destination)
                    print(f"Uploaded package contents to GCS: {gcs_destination}")

                    # Add a 2-second delay after each package upload
                    time.sleep(2)

                except requests.RequestException as e:
                    print(f"Failed to create package: {package_data['name']}")
                    print(f"Error: {str(e)}")

                # Return after processing one package
                return uploaded_packages

    return uploaded_packages


# Example usage
if __name__ == "__main__":
    API_BASE_URL = os.getenv("API_BASE_URL", "http://localhost:8000")
    GCS_BUCKET_NAME = os.getenv("GCS_BUCKET_NAME", "rad-packages-1234")
    MODULE_DIRS = os.getenv("MODULE_DIRS", "['gcp/cloud-sql-mysql', 'gcp/cloud-sql-postgresql', 'gcp/gke-autopilot', 'gcp/memorystore-memcache', 'gcp/memorystore-redis', 'gcp/pubsub', 'gcp/storage-bucket', 'gcp/subnet', 'gcp/vpc']")
    MODULE_DIRS = eval(MODULE_DIRS) if isinstance(MODULE_DIRS, str) else MODULE_DIRS

    total_uploaded_packages = 0
    for module_dir in MODULE_DIRS:
        uploaded_packages = upload_packages(API_BASE_URL, module_dir, GCS_BUCKET_NAME)
        total_uploaded_packages += len(uploaded_packages)
        print(f"Packages uploaded from {module_dir}: {len(uploaded_packages)}")

    print(f"Total packages uploaded: {total_uploaded_packages}")
