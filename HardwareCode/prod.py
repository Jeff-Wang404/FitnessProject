# bluetooth pairing to the flutter app

# it needs to continuously stream accelerometer data to the flutter app

# also lights up the neopixel to indicate if it is looking for a bluetooth connection, 
# streaming, or if *low battery
import time # keeps track of time
import board # provides access to the board's pins
import busio # for I2C communication
import adafruit_adxl34x # library for the ADXL345 accelerometer
import neopixel # library for controlling NeoPixels
import analogio # library for reading analog inputs (for checking low battery)
from adafruit_ble import BLERadio # library for Bluetooth Low Energy communication
from adafruit_ble.advertising.standard import ProvideServicesAdvertisement # for advertising BLE services
from adafruit_ble.services.nordic import UARTService # for UART communication over BLE

# ---------- USER SETTINGS ----------
# EXERCISE_LABEL = 1 # 0=None, 1=Lateral Raise, 2=Curls, 3=Dumbell Press
# LOG_FILENAME = "data.csv"
# RECORD_SECONDS = 10 # seconds
SAMPLING_DELAY = 0.05 # 50 ms between samples
PREPARE_SECONDS = 10 # seconds before recording starts
# -----------------------------------

# Create BLE radio and services
ble = BLERadio()
ble.name = "RepSync Device"  # Set BLE device name
uart = UARTService()
advertisement = ProvideServicesAdvertisement(uart)

# Create I2C bus
# i2c = busio.I2C(board.SCL, board.SDA)
i2c = board.STEMMA_I2C()
adxl = adafruit_adxl34x.ADXL345(i2c)

# Define neopixel colors
pixel = neopixel.NeoPixel(board.NEOPIXEL, 1)
COLOR_CONNECTING = (0, 0, 255) # Blue
COLOR_STREAMING = (0, 255, 0) # Green
COLOR_LOW_BATTERY = (255, 0, 0) # Red

# async function to blink neopixel
def blink_pixel(color, interval=0.5):
    pixel.fill(color)
    time.sleep(interval)
    pixel.fill((0, 0, 0))  # Turn off the pixel
    time.sleep(interval)

# Create analog input for battery level
try:
    battery = analogio.AnalogIn(board.VOLTAGE_MONITOR)  # Adjust pin as necessary
except:
    battery = None

def read_battery_voltage():
    if battery is not None:
        return (battery.value * 3.3) / 65536  # Convert to voltage (assuming 3.3V reference)
    return None

LOW_BATTERY_THRESHOLD = 3.15 # Voltage threshold for low battery

while True:
    # 1. Start advertising BLE service
    pixel.fill(COLOR_CONNECTING)  # Set neopixel to blue
    ble.start_advertising(advertisement)
    print("Waiting for BLE connection...")

    while not ble.connected:
        pixel.brightness = 0.1  # Dim the pixel while waiting
        time.sleep(0.5)
        pixel.brightness = 0.5  # Brighten the pixel when connected
        time.sleep(0.5)
    ble.stop_advertising()

    print("BLE connected!")

    # 2. Prepare for data collection
    pixel.fill(COLOR_STREAMING)  # Set neopixel to green
    while ble.connected:
        # Check battery level
        voltage = read_battery_voltage()
        if voltage is not None and voltage > LOW_BATTERY_THRESHOLD:
            pixel.fill(COLOR_STREAMING)  # Set neopixel to green
        else:
            # Blick red if low battery
            blink_pixel(COLOR_LOW_BATTERY, interval=2.0)
            # alernate: solid red
            # pixel.fill(COLOR_LOW_BATTERY)
        # Stream accelerometer data
        x, y, z = adxl.acceleration
        data = "{:.3f},{:.3f},{:.3f}\n".format(x, y, z)
        try:
            uart.write(data.encode('utf-8'))  # Send data over BLE
            print("Sent:", data.strip())
        except Exception as e:
            print("Error sending data:", e)
            break

        time.sleep(SAMPLING_DELAY)

    print("BLE disconnected, stopping data collection.")
    pixel.fill((0, 0, 0))  # Turn off the neopixel
    time.sleep(1)  # Wait before next connection attempt