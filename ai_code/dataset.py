import os
import csv
import random
random.seed(42)
import pandas as pd
from sklearn.model_selection import train_test_split
from pathlib import Path
import numpy as np

CSV_PATH = 'data.csv'
OUTPUT_DIR = 'dataset'
RANDOM_SEED = 42
WINDOW_SIZE = 128
OVERLAP = 0.5

base_dir = "source"
classes = {
    "curls": 0,
    "lateral_raises": 1,
    "dumbell_presses": 2,
}

def segment_signal(data, window_size, overlap):
    segments = []
    step = window_size - overlap
    for start in range(0, len(data) - window_size + 1, step):
        end = start + window_size
        segment = data[start:end]
        if len(segment) == window_size:
            segments.append(segment)
    return segments

# Lists to collect all segments and labels
all_segments = []
all_labels = []

# for folder_name, label_value in classes.items(): # TODO readjust this in a moment
#     folder_path = os.path.join(base_dir, folder_name)
#     if not os.path.exists(folder_path):
#         print(f"Folder {folder_path} does not exist")
#         continue

#     for file_name in os.listdir(folder_path):
#         if file_name.endswith(".txt"):
#             file_path = os.path.join(folder_path, file_name)
#             with open(file_path, "r") as f:
#                 for line in f:
#                     line = line.strip()

#                     if not line:
#                         continue

#                     parts = line.split(",")
#                     if len(parts == 5):
#                         timestamp, accel_x, accel_y, accel_z, _ = parts
#                         # writer.writerow([timestamp, accel_x, accel_y, accel_z, label_value])


# # 2. Data Preparation
# df = pd.read_csv(
#     CSV_PATH,
#     header=None,
#     names=["timestamp", "accel_x", "accel_y", "accel_z", "activity"]
# )

# # Extract features and labels
# X = df[["accel_x", "accel_y", "accel_z"]].values
# y = df["activity"].values

# Split data into training and test sets
X_train, X_temp, y_train, y_temp = train_test_split(
    X, y, train_size=0.8, random_state=RANDOM_SEED
)
X_val, X_test, y_val, y_test = train_test_split(
    X_temp, y_temp, train_size=0.5, random_state=RANDOM_SEED
)

np.save(os.path.join(OUTPUT_DIR, "X_train.npy"), X_train)
np.save(os.path.join(OUTPUT_DIR, "y_train.npy"), y_train)
np.save(os.path.join(OUTPUT_DIR, "X_val.npy"), X_val)
np.save(os.path.join(OUTPUT_DIR, "y_val.npy"), y_val)
np.save(os.path.join(OUTPUT_DIR, "X_test.npy"), X_test)
np.save(os.path.join(OUTPUT_DIR, "y_test.npy"), y_test)


if __name__ == "__main__":
    # process_source_to_csv()
    print("Done processing source data to CSV")