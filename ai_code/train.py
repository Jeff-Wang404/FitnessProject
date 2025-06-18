# train.py
import os
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader

# Configuration
DATASET_DIR  = 'dataset'
BATCH_SIZE   = 64
EPOCHS       = 50
LEARNING_RATE= 0.001
HIDDEN_SIZE  = 64
NUM_CLASSES  = 19   # now including idle + 18 exercises
NUM_FEATURES = 3
WINDOW_SIZE  = 128

class ExerciseDataset(Dataset):
    def __init__(self, X, y):
        # X shape: (N, window, 3)
        self.X = torch.tensor(X, dtype=torch.float32)
        self.y = torch.tensor(y, dtype=torch.long)
    def __len__(self):
        return len(self.X)
    def __getitem__(self, idx):
        x = self.X[idx].permute(1, 0)  # -> (3, window)
        # per-channel normalization
        mean = x.mean(dim=1, keepdim=True)
        std  = x.std(dim=1, keepdim=True)
        x = (x - mean) / (std + 1e-6)
        return x, self.y[idx]

# Load splits
X_train = np.load(os.path.join(DATASET_DIR, 'X_train.npy'))
y_train = np.load(os.path.join(DATASET_DIR, 'y_train.npy'))
X_val   = np.load(os.path.join(DATASET_DIR, 'X_val.npy'))
y_val   = np.load(os.path.join(DATASET_DIR, 'y_val.npy'))

train_loader = DataLoader(
    ExerciseDataset(X_train, y_train),
    batch_size=BATCH_SIZE, shuffle=True
)
val_loader = DataLoader(
    ExerciseDataset(X_val, y_val),
    batch_size=BATCH_SIZE, shuffle=False
)

# Model
class ExerciseClassifier(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv1d(NUM_FEATURES, HIDDEN_SIZE, kernel_size=3, padding=1)
        self.conv2 = nn.Conv1d(HIDDEN_SIZE, HIDDEN_SIZE, kernel_size=3, padding=1)
        self.pool  = nn.MaxPool1d(2)
        self.fc1   = nn.Linear(HIDDEN_SIZE * (WINDOW_SIZE // 2), 128)
        self.fc2   = nn.Linear(128, NUM_CLASSES)
    def forward(self, x):
        x = F.relu(self.conv1(x))
        x = self.pool(F.relu(self.conv2(x)))
        x = x.view(x.size(0), -1)
        x = F.relu(self.fc1(x))
        return self.fc2(x)

# Train loop
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = ExerciseClassifier().to(device)
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=LEARNING_RATE)

for epoch in range(1, EPOCHS+1):
    model.train()
    total_loss = 0.0
    for xb, yb in train_loader:
        xb, yb = xb.to(device), yb.to(device)
        optimizer.zero_grad()
        preds = model(xb)
        loss  = criterion(preds, yb)
        loss.backward()
        optimizer.step()
        total_loss += loss.item()
    avg_loss = total_loss / len(train_loader)

    # Validation
    model.eval()
    correct, total = 0, 0
    with torch.no_grad():
        for xb, yb in val_loader:
            xb, yb = xb.to(device), yb.to(device)
            pred = model(xb).argmax(dim=1)
            correct += (pred == yb).sum().item()
            total   += yb.size(0)
    val_acc = 100 * correct / total
    print(f"Epoch {epoch}/{EPOCHS} — Loss: {avg_loss:.4f}, Val Acc: {val_acc:.2f}%")

# Save
torch.save(model.state_dict(), 'exercise_classifier.pth')
print("Model saved as exercise_classifier.pth")
