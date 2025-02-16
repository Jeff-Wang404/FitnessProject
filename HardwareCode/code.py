import time
import board
import busio
import adafruit_adx134x
import neopixel

# ---------- USER SETTINGS ----------
EXERCISE_LABEL = 1 # 0=None, 1=Lateral Raise, 2=Curls, 3=Dumbell Press
LOG_FILENAME = "data.csv"
RECORD_SECONDS = 10 # seconds
SAMPLING_DELAY = 0.05 # 50 ms between samples
PREPARE_SECONDS = 10 # seconds before recording starts
# -----------------------------------

# Create I2C bus
i2c = busio.I2C(board.SCL, board.SDA)
adxl = adafruit_adx134x.ADXL345(i2c)

pixel = neopixel.NeoPixel(board.NEOPIXEL, 1)

pixel[0] = (0, 0, 255) # Blue

# Prepare
time.sleep(PREPARE_SECONDS)

pixel[0] = (255, 0, 0) # Red

start_time = time.monotonic()

# Open log file
with open(LOG_FILENAME, "a") as log_file:
    log_file.write("Starting data collection for exercise {} for {} seconds.\n".format(EXERCISE_LABEL, RECORD_SECONDS))

    while time.monotonic() - start_time < RECORD_SECONDS:
        current_time = time.monotonic() - start_time
        x, y, z = adxl.acceleration
        log_file.write("{:.3f},{:.3f},{:.3f},{:.3f},{:.3f}\n".format(current_time, x, y, z, EXERCISE_LABEL))
        log_file.flush()
        time.sleep(SAMPLING_DELAY)

pixel[0] = (0, 255, 0) # Green