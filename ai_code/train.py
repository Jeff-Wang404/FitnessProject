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


# 3. Pytorch Dataset


# 4. Model Definition


# 5. Training


# 6. Evaluation