# Ubuntu

## Setup GPIO fan
On the SD card, add the following to the existing `config.txt`:
```
# Turn off red power LED
dtparam=pwr_led_trigger=default-on
dtparam=pwr_led_activelow=off
# Turn off green activity LED
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off
# Turn off ethernet LEDs
dtparam=eth_led0=4
dtparam=eth_led1=4

# Control fan
dtoverlay=gpio-fan,gpiopin=14,temp=60000
```
Connect the PWM pin of the fan to GPIO pin 14

> Note: This is different for pre-bullseye and other systems, wehre `dtparam=act_led_trigger=none` is used instead of `dtparam=pwr_led_trigger=default-on`

## Overclock and disable UART
We can change `config.txt` to overclock and disable UART to improve performance.
Disable UART: comment out `enable_uart=1` or set `enable_uart=0`

Overclock (max 2.1GHz achieved, also don't use over_voltage to supply more power as it would be controlled automatically and safely):
```
arm_freq=2100
arm_freq_min=400
gpu_freq=500
gpu_mem=256
```
