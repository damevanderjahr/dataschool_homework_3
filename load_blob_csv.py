import os
from azure.storage.filedatalake import DataLakeServiceClient, FileSystemClient, DataLakeDirectoryClient
from azure.core.exceptions import ResourceExistsError

connection_string = os.getenv('AZURE_STORAGE_ACCESS_KEY_CONNECTION_STRING')
container_name = "zharynin"
local_path = "."
local_file_name = "yellow_tripdata_2020-01.csv"
upload_file_path = os.path.join(local_path, local_file_name)
upload_file_path = os.path.expanduser(upload_file_path)
datalake_service_client = DataLakeServiceClient.from_connection_string(connection_string)
folder_names = ['homework_3']

def check_and_create_container_if_not_exist(datalake_client, container):
    list_fs = list(map(lambda x: x.name, datalake_client.list_file_systems()))
    file_system_client = datalake_client.get_file_system_client(container_name)
    if container in list_fs:
        print("Container already exist, skip create step")
        return file_system_client
    else:
        try:
            file_system_client.create_file_system()
            return file_system_client
        except ResourceExistsError:
            print("Something wrong, container already exist, but not in container list, check code")
            exit(1)


def check_and_create_folder_if_not_exist(client, file_system_client, folder_name, c_path):
    path_list = list(map(lambda x: x.name, file_system_client.get_paths()))
    c_path = c_path + folder_name if c_path == '' else c_path + '/' + folder_name
    if c_path in path_list:
        print("Folder already exist, skip create step")
        return go_to_subfolder(client, folder_name), c_path
    else:
        try:
            return create_folder(client, folder_name), c_path
        except:
            print("Something wrong, folder already exist, but not in path list, check code")
            exit(1)


def create_folder(client, folder_name):
    if type(client) == FileSystemClient:
        return client.create_directory(folder_name)
    elif type(client) == DataLakeDirectoryClient:
        return client.create_sub_directory(folder_name)
    else:
        print("ERROR: Wrong client type")
        exit(1)


def go_to_subfolder(client, folder_name):
    if type(client) == FileSystemClient:
        return client.get_directory_client(folder_name)
    elif type(client) == DataLakeDirectoryClient:
        return client.get_sub_directory_client(folder_name)
    else:
        print("ERROR: Wrong client type")
        exit(1)


file_system_client = check_and_create_container_if_not_exist(datalake_service_client, container_name)
directory_client = file_system_client
current_path = ''
for f_name in folder_names:
    directory_client, current_path = check_and_create_folder_if_not_exist(directory_client, file_system_client, f_name, current_path)
directory_path = directory_client.get_directory_properties().name
directory_path = '/'.join(directory_path.split('/'))
directory_client = file_system_client.get_directory_client(directory_path)

with open(upload_file_path, "rb") as data:
    file_client = directory_client.get_file_client(local_file_name)
    file_client.create_file()
    file_client.append_data(data, 0)
    file_client.flush_data(data.tell())


path_list = file_system_client.get_paths()
for path in path_list:
    print(path.name)
