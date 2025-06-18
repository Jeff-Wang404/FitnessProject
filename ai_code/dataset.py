# dataset.py
import os
import random
random.seed(42)

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split

CSV_PATH = 'data.csv'
OUTPUT_DIR = 'dataset'
RANDOM_SEED = 42
WINDOW_SIZE = 128
OVERLAP = 0.5

base_dir = "source"
classes = {
    "idle": 0,
    "pec_deck": 1,
    "barbell_bench_press": 2,
    "dumbbell_presses": 3,
    "dumbbell_flies": 4,
    "cable_crossover": 5,
    "incline_bench_press": 6,
    "bicep_curls": 7,
    "preacher_curls": 8,
    "tricep_pushdowns": 9,
    "overhead_cable_triceps_extension": 10,
    "hammer_curls": 11,
    "close_grip_bench_press": 12,
    "romanian_deadlift": 13,
    "kettlebell_swings": 14,
    "barbell_front_squats": 15,
    "dumbell_walking_lunges": 16,
    "cable_squat_to_overhead_press": 17,
    "landmine_reverse_lunge_with_press": 18,
}

def segment_signal(data, window_size, overlap):
    segments = []
    step = window_size - int(window_size * overlap)
    arr = data[["accel_x","accel_y","accel_z"]].values
    for start in range(0, len(arr) - window_size + 1, step):
        seg = arr[start:start+window_size]
        segments.append(seg)
    return segments

# Gather segments & labels
all_segments, all_labels = [], []

for csv_file in os.listdir(base_dir):
    if not csv_file.endswith('.csv'): continue
    name = csv_file[:-4].lower()
    if name not in classes:
        print(f"Skipping {name}")
        continue
    label = classes[name]
    df = pd.read_csv(os.path.join(base_dir, csv_file))
    segs = segment_signal(df, WINDOW_SIZE, OVERLAP)
    all_segments += segs
    all_labels += [label] * len(segs)

all_segments = np.array(all_segments)
all_labels   = np.array(all_labels)
print("Total segments:", all_segments.shape[0])

# Split
X_train, X_temp, y_train, y_temp = train_test_split(
    all_segments, all_labels, train_size=0.8, random_state=RANDOM_SEED
)
X_val, X_test, y_val, y_test = train_test_split(
    X_temp, y_temp, train_size=0.5, random_state=RANDOM_SEED
)

# Save
os.makedirs(OUTPUT_DIR, exist_ok=True)
for name, arr in [
    ("X_train.npy", X_train), ("y_train.npy", y_train),
    ("X_val.npy",   X_val),   ("y_val.npy",   y_val),
    ("X_test.npy",  X_test),  ("y_test.npy",  y_test),
]:
    np.save(os.path.join(OUTPUT_DIR, name), arr)

if __name__ == "__main__":
    print("Done processing source data to NPYs")
