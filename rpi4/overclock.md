# Overclock (and disable UART) on Raspberry Pi 4B
*Last Update: 20240408*

We can change `config.txt` on boot SD card/drive to overclock.
The mileage might vary depending on specific machine chip.

## Disable UART
> UART need to be disabled as enabling UART [limits GPU core clock](https://www.raspberrypi.com/documentation/computers/configuration.html#mini-uart-and-cpu-core-frequency)

Disable UART: In `config.txt`, comment out `enable_uart=1` or set `enable_uart=0`

## Enable Overclock
Set the following in `config.txt`:
```
arm_boost=1
over_voltage=6
arm_freq=2100
#arm_freq_min=400
gpu_freq=600
gpu_mem=256
```
`over_voltage=6` sets voltage to be `6 * 0.025 = 0.15V` over default voltage. The hardware/firmware sets a hard limit of 1.1V supply, so this should be the maximum effective voltage set.

Also check `arm_64bit=1`, which should be set by default.