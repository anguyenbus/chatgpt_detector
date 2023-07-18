import os
import sys

import boto3
from ssm_parameter_store import EC2ParameterStore
from tqdm import tqdm

tqdm.pandas()

LOCAL_ONLY = os.getenv('LOCAL_ONLY', 'false')


def retrieve_aws_region() -> str:
    region = os.getenv("REGION")
    if not region:
        sess = boto3.session.Session()
        region = sess.region_name
        if not region or region == "":
            sys.exit(
                "Neither environment variable REGION nor AWS Region configuration available."
            )
    return region


def retrieve_aws_account_id() -> str:
    client = boto3.client("sts")
    return client.get_caller_identity().get("Account")


def get_ssm_parameter(parameter_path: str, param_name=""):
    try:
        region = retrieve_aws_region()
        print(f'Region detected: {region}')
        store = EC2ParameterStore(region_name=region)
        if param_name == "":
            param = store.get_parameters_by_path(parameter_path, decrypt=True)
        else:
            param = store.get_parameter(
                parameter_path + "/" + param_name, decrypt=True
            )[param_name]
        return param
    except (ConnectionError, ValueError) as error:
        print(str(error), parameter_path, param_name)
        raise
