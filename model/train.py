import os
from datetime import datetime

import torch
from constants import (BATCH_SIZE, DEPLOY, MODEL_LATEST_S3_PATH, MODEL_S3_PATH,
                       NUM_EPOCHS, TARGET_BUCKET, TRAIN_DATA_FILE)
from s3_helper import S3Helper
from torch.utils.data import DataLoader, Dataset
from transformers import RobertaForSequenceClassification, RobertaTokenizer

# Set the device (CPU or GPU) for training
DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

# Define your custom dataset for training


class CustomDataset(Dataset):
    def __init__(self, file_path):
        # Load and preprocess your training data
        self.data = self.load_data(file_path)

    def __len__(self):
        return len(self.data)

    def __getitem__(self, index):
        # Return the input and label for each training example
        return self.data[index]

    def load_data(self, file_path):
        data = []
        with open(file_path, "r", encoding="utf-8") as file:
            for line in file:
                line = line.strip()
                if line:
                    # Preprocess the training data
                    # Split the line into the sentence and label
                    sentence, label = line.rsplit(" ", 1)

                    # Create an input-label pair
                    input_data = {
                        "input_sentence": sentence.strip(),
                        "label": int(label)
                    }

                    data.append(input_data)

        return data


if __name__ == "__main__":
    # Initialize the tokenizer and model
    tokenizer = RobertaTokenizer.from_pretrained(
        "roberta-base-openai-detector")
    model = RobertaForSequenceClassification.from_pretrained(
        "roberta-base-openai-detector").to(DEVICE)

    # Create your custom dataset
    dataset = CustomDataset(TRAIN_DATA_FILE)

    # Create a data loader for batching and shuffling the data
    data_loader = DataLoader(dataset, batch_size=BATCH_SIZE, shuffle=True)

    # Set the optimizer and loss function
    optimizer = torch.optim.AdamW(model.parameters(), lr=1e-5)
    criterion = torch.nn.CrossEntropyLoss()

    # Training loop
    model.train()
    for epoch in range(NUM_EPOCHS):
        running_loss = 0.0
        for batch in data_loader:
            input_sentences = batch["input_sentence"]
            labels = batch["label"]

            # Tokenize the input sentences
            inputs = tokenizer.batch_encode_plus(
                input_sentences,
                padding=True,
                truncation=True,
                max_length=512,
                return_tensors="pt"
            )

            # Move the inputs and labels to the specified device
            input_ids = inputs["input_ids"].to(DEVICE)
            attention_mask = inputs["attention_mask"].to(DEVICE)
            labels = labels.to(DEVICE)

            optimizer.zero_grad()

            # Forward pass
            outputs = model(input_ids=input_ids,
                            attention_mask=attention_mask, labels=labels)
            loss = outputs.loss
            logits = outputs.logits

            # Backward pass and optimization
            loss.backward()
            optimizer.step()

            running_loss += loss.item()

        epoch_loss = running_loss / len(data_loader)
        print(f"Epoch {epoch + 1} - Loss: {epoch_loss:.4f}")

    # versioning
    s3_helper = S3Helper()
    s3_helper.upload_model(model, TARGET_BUCKET, MODEL_S3_PATH)
    if DEPLOY:
        s3_helper.upload_model(model, TARGET_BUCKET, MODEL_LATEST_S3_PATH)
