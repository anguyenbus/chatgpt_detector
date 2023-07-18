import torch
from transformers import RobertaTokenizer, RobertaForSequenceClassification
from flask import Flask, request, jsonify

# Set the path to the saved model directory
MODEL_DIR = "latest"

# Set the device (CPU or GPU) for inference
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Initialize the tokenizer and model
tokenizer = RobertaTokenizer.from_pretrained(MODEL_DIR)
model = RobertaForSequenceClassification.from_pretrained(MODEL_DIR).to(DEVICE)

# Create a Flask application
app = Flask(__name__)

# API endpoint for prediction


@app.route("/predict", methods=["POST"])
def predict():
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


# Run the Flask application
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)