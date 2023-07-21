# Use an official Python runtime as the base image
FROM python:3.9

# Set environment variables
# ensures that Python outputs everything that's printed directly to the terminal (so logs can be seen in real-time)
ENV PYTHONUNBUFFERED=TRUE
# ensures Python doesn't try to write .pyc files to disk (useful for improving performance in some scenarios)
ENV PYTHONDONTWRITEBYTECODE=TRUE

# Update PATH environment variable to include /opt/program directory
ENV PATH="/opt/program:${PATH}"

# Set the working directory in the Docker image to /opt/program
WORKDIR /opt/program


# Copy the requirements file into the container
COPY ./requirements.txt /opt/program/requirements.txt

# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install awscli

# Copy the inference code into the container
COPY inference/ /opt/program

ENV SM_MODEL_DIR /opt/ml/model

# Set the command to run when the container starts (inference script)
ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:8080", "/opt/program/inference:app"]