import os
from datetime import datetime

TARGET_BUCKET = "chatgptdetector"
# Set the path to your training data file
TRAIN_DATA_FILE = "data/training_data.txt"

# Set the number of training epochs and batch size
NUM_EPOCHS = 10
BATCH_SIZE = 16

# Set the DEPLOY flag (change it to True or False based on your requirement)
DEPLOY = False

DATETIME_NOW = datetime.utcnow()
CONTAINER_PREFIX = os.getenv("CONTAINER_PREFIX", "/opt/ml/")


CONTAINER_PREFIX_PROGRAM = os.getenv(
    "CONTAINER_PREFIX_PROGRAM", "/opt/program/")
PARAM_PATH = os.path.join(
    CONTAINER_PREFIX, "input/config/hyperparameters.json")

MODEL_S3_PATH = f"{TARGET_BUCKET}/created_date={DATETIME_NOW.strftime('%Y-%m-%d')}/created_time={DATETIME_NOW.strftime('%H-%M-%S')}/model"
MODEL_LATEST_S3_PATH = f"{TARGET_BUCKET}/latest/model"
