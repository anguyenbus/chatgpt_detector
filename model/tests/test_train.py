import pytest
from constants import TRAIN_DATA_FILE
from your_module import CustomDataset


# Test case 1: Ensure dataset length is correct
def test_custom_dataset_length():
    # Replace with the path to your actual data file
    file_path = TRAIN_DATA_FILE
    dataset = CustomDataset(file_path)
    # Replace 10 with the expected length of your dataset
    assert len(dataset) == 4

# Test case 2: Ensure __getitem__ returns the correct item


def test_custom_dataset_getitem():
    # Replace with the path to your actual data file
    file_path = TRAIN_DATA_FILE
    dataset = CustomDataset(file_path)

    # Replace 0 with the index of the item you want to test
    expected_item = {
        "input_sentence": "This is a sentence generated by ChatGPT",
        "label": 0
    }

    assert dataset[0] == expected_item

# Test case 3: Ensure loading data from the file works correctly


def test_custom_dataset_load_data():
    # Replace with the path to your actual data file
    file_path = TRAIN_DATA_FILE
    dataset = CustomDataset(file_path)

    # Assuming you know the first two lines of your data file
    expected_data = [
        {"input_sentence": "I am a human-written sentence.", "label": 1},
        {"input_sentence": "This sentence is not from ChatGPT.", "label": 1}
        # Add more expected items as per your data file
    ]

    assert dataset.data[-1:] == expected_data
