# Use an official Python runtime as the base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the inference code into the container
COPY inference/inference.py .
COPY inference/run.sh .
COPY artifacts/latest /app/latest

# Set the command to run when the container starts (inference script)
ENTRYPOINT ["./run.sh"]