import pandas as pd

import numpy as np

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import confusion_matrix, classification_report

import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader

# 1. Configuration
CSV_PATH = 'data.csv'
RANDOM_SEED = 42
BATCH_SIZE = 64
EPOCHS = 10
LEARNING_RATE = 0.001
HIDDEN_SIZE = 64
NUM_CLASSES = 4

# 2. Data Preparation
df = pd.read_csv(
    CSV_PATH,
    header=None,
    names=["timestamp", "accel_x", "accel_y", "accel_z", "activity"]
)

# Extract features and labels
X = df[["accel_x", "accel_y", "accel_z"]].values
y = df["activity"].values

# Split data into training and test sets
X_train, X_temp, y_train, y_temp = train_test_split(
    X, y, train_size=0.8, random_state=RANDOM_SEED
)
X_val, X_test, y_val, y_test = train_test_split(
    X_temp, y_temp, train_size=0.5, random_state=RANDOM_SEED
)


# 3. Pytorch Dataset


# 4. Model Definition


# 5. Training
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=LEARNING_RATE)

for epoch in range(EPOCHS):
    model.train()
    running_loss = 0.0
    correct = 0
    total = 0

    # get X and  y in batch from a loader:
        # make attempt and got outputs
        # check if the outputs are correct
        # calculate loss
        # backpropagation
        # update weights
        
    


# 6. Evaluation