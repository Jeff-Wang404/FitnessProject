import pandas as pd

import numpy as np
import os

from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import confusion_matrix, classification_report

import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader

# 1. Configuration
# CSV_PATH = 'data.csv'
# RANDOM_SEED = 42
DATASET_DIR = 'dataset'
BATCH_SIZE = 64
EPOCHS = 10
LEARNING_RATE = 0.001
HIDDEN_SIZE = 64
NUM_CLASSES = 3
NUM_FEATURES = 3
WINDOW_SIZE = 128

# # 2. Data Preparation
# df = pd.read_csv(
#     CSV_PATH,
#     header=None,
#     names=["timestamp", "accel_x", "accel_y", "accel_z", "activity"]
# )

# # Extract features and labels
# X = df[["accel_x", "accel_y", "accel_z"]].values
# y = df["activity"].values

# # Split data into training and test sets
# X_train, X_temp, y_train, y_temp = train_test_split(
#     X, y, train_size=0.8, random_state=RANDOM_SEED
# )
# X_val, X_test, y_val, y_test = train_test_split(
#     X_temp, y_temp, train_size=0.5, random_state=RANDOM_SEED
# )


# 3. Pytorch Dataset
class ExerciseDataset(Dataset):
    def __init__(self, X, y):
        self.X = torch.tensor(X, dtype=torch.float32)
        self.y = torch.tensor(y, dtype=torch.long)

    def __len__(self):
        return len(self.X)
    
    def __getitem__(self, idx):
        sample = self.X[idx].permute(1, 0)
        label = self.y[idx]
        return sample, label

# Load the dataset files
X_train = np.load(os.path.join(DATASET_DIR, 'X_train.npy'))
y_train = np.load(os.path.join(DATASET_DIR, 'y_train.npy'))
X_val = np.load(os.path.join(DATASET_DIR, 'X_val.npy'))
y_val = np.load(os.path.join(DATASET_DIR, 'y_val.npy'))

# Create datasets and dataloaders
train_dataset = ExerciseDataset(X_train, y_train)
val_dataset = ExerciseDataset(X_val, y_val)

train_loader = DataLoader(train_dataset, batch_size=BATCH_SIZE, shuffle=True)
val_loader = DataLoader(val_dataset, batch_size=BATCH_SIZE, shuffle=False)

# 4. Model Definition
class ExerciseClassifier(nn.Module):
    def __init__(self, num_features=NUM_FEATURES, num_classes=NUM_CLASSES):
        super(ExerciseClassifier, self).__init__()
        self.conv1 = nn.Conv1d(num_features, HIDDEN_SIZE, kernel_size=3, padding=1)
        self.conv2 = nn.Conv1d(HIDDEN_SIZE, HIDDEN_SIZE, kernel_size=3, padding=1)
        self.pool = nn.MaxPool1d(kernel_size=2)
        self.fc1 = nn.Linear(HIDDEN_SIZE * (WINDOW_SIZE // 2), 128)
        self.fc2 = nn.Linear(128, num_classes)

    def forward(self, x):
        x = F.relu(self.conv1(x))
        x = self.pool(F.relu(self.conv2(x)))
        x = x.view(x.size(0), -1)
        x = F.relu(self.fc1(x))
        x = self.fc2(x)
        return x

# 5. Training
model = ExerciseClassifier()
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)

criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=LEARNING_RATE)

for epoch in range(EPOCHS):
    model.train()
    running_loss = 0.0
    for inputs, labels in train_loader:
        inputs, labels = inputs.to(device), labels.to(device)
        optimizer.zero_grad()
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
        running_loss += loss.item()
    avg_loss = running_loss / len(train_loader)

    # Validation
    model.eval()
    correct = 0
    total = 0
    with torch.no_grad():
        for inputs, labels in val_loader:
            inputs, labels = inputs.to(device), labels.to(device)
            outputs = model(inputs)
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
    val_accuracy = correct / total * 100
    print(f'Epoch [{epoch+1}/{EPOCHS}], Loss: {avg_loss:.4f}, Val Accuracy: {val_accuracy:.2f}%')
    
# 6. Save the Model
torch.save(model.state_dict(), 'exercise_classifier.pth')
print("Model saved as exercise_classifier.pth")