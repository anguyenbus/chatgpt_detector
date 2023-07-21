"""
Author: An Nguyen
"""

import os

import torch
from flask import Flask, jsonify, request
from transformers import RobertaForSequenceClassification, RobertaTokenizer
from werkzeug.middleware.proxy_fix import ProxyFix

# Set the path to the saved model directory, inferencing
MODEL_DIR = os.environ["SM_MODEL_DIR"]

# Set the device (CPU or GPU) for inference
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")


# Check if the directory exists and is not empty
if not os.path.exists(MODEL_DIR) or not os.listdir(MODEL_DIR):
    raise ValueError("Model directories are empty in the specified directory.")

    # Load the tokenizer from the specified directory
tokenizer = RobertaTokenizer.from_pretrained(MODEL_DIR, local_files_only=True)
# Initialize the tokenizer and model, load from opt/ml/model only
tokenizer = RobertaTokenizer.from_pretrained(MODEL_DIR, local_files_only=True)
model = RobertaForSequenceClassification.from_pretrained(
    MODEL_DIR, local_files_only=True).to(DEVICE)

# Create a Flask application
app = Flask(__name__)

# API endpoint for prediction

# Since the web application runs behind a proxy (nginx), we need to
# add this setting to our app.
app.wsgi_app = ProxyFix(
    app.wsgi_app, x_for=1, x_proto=1, x_host=1, x_prefix=1
)


@app.route("/ping", methods=["GET"])
def ping():
    """
    Healthcheck function.
    """
    return "Healthy"


@app.route("/invocations", methods=["POST"])
def invocations():
    # Get the input text from the request
    input_text = request.json["input_text"]

    # Tokenize the input text
    inputs = tokenizer.encode_plus(
        input_text,
        add_special_tokens=True,
        truncation=True,
        padding="longest",
        max_length=512,
        return_tensors="pt"
    )

    # Move the inputs to the specified device
    inputs = {key: tensor.to(DEVICE) for key, tensor in inputs.items()}

    # Perform inference
    with torch.no_grad():
        model.eval()
        outputs = model(**inputs)

    # Get the predicted class
    predicted_class = torch.argmax(outputs.logits, dim=1).item()

    # Return the prediction as JSON response
    response = {"input_text": input_text, "predicted_class": predicted_class}
    return jsonify(response)
