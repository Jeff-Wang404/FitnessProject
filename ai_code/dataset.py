import os
import csv
import random
random.seed(42)
from sklearn.model_selection import train_test_split
from pathlib import Path

base_dir = "source"
classes = {
    "none": 0,
    "curls": 1,
    "lateral_raises": 2,
    "dumbell_presses": 3,
}

output_csv = "data.csv"

def process_source_to_csv():
    with open(output_csv, "w", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["timestamp", "accel_x", "accel_y", "accel_z", "activity"])

        for folder_name, label_value in classes.items():
            folder_path = os.path.join(base_dir, folder_name)
            if not os.path.exists(folder_path):
                print(f"Folder {folder_path} does not exist")
                continue

            for file_name in os.listdir(folder_path):
                if file_name.endswith(".txt"):
                    file_path = os.path.join(folder_path, file_name)
                    with open(file_path, "r") as f:
                        for line in f:
                            line = line.strip()

                            if not line:
                                continue

                            parts = line.split(",")
                            if len(parts == 5):
                                timestamp, accel_x, accel_y, accel_z, _ = parts
                                writer.writerow([timestamp, accel_x, accel_y, accel_z, label_value])

if __name__ == "__main__":
    process_source_to_csv()
    print("Done processing source data to CSV")