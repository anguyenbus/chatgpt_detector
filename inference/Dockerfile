# Use an official Python runtime as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install awscli

# Copy the inference code into the container
COPY inference/ .

ENV SM_MODEL_DIR /opt/ml/model

# Set the command to run when the container starts (inference script)
ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8080", "inference:app", "-n"]