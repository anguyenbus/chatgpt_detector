# Use a Python base image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the project files into the container
COPY requirements.txt .
COPY model/ ./model
COPY data/ ./model/data

# Install the required dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the DEPLOY flag (change it to true or false based on your requirement)
ARG DEPLOY=false

# Set the working directory to the model directory
WORKDIR /app/model

# Run the training script
ENTRYPOINT ["./run.sh"]