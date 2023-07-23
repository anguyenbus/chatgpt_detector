import os

import pytest
import torch
from flask import Flask
from transformers import RobertaForSequenceClassification, RobertaTokenizer
from werkzeug.middleware.proxy_fix import ProxyFix


@pytest.fixture
def app():
    # Create a Flask application
    app = Flask(__name__)

    # Since the web application runs behind a proxy (nginx), we need to
    # add this setting to our app.
    app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1,
                            x_proto=1, x_host=1, x_prefix=1)

    return app


@pytest.fixture
def model():
    # Set the path to the saved model directory, inferencing
    model_dir = os.environ["SM_MODEL_DIR"]

    # Set the device (CPU or GPU) for inference
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

    # Initialize the tokenizer and model
    tokenizer = RobertaTokenizer.from_pretrained(model_dir)
    model = RobertaForSequenceClassification.from_pretrained(
        model_dir).to(device)

    return model, tokenizer


@pytest.fixture
def client(app):
    return app.test_client()
