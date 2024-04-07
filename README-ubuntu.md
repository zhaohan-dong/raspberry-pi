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
