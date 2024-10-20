# Roles for Raspberry Pi

- common: Common role to setup Debian/Ubuntu/RedHat nodes
- raspberry_pi_common: (not meant to be used directly but as a dependency of specific raspberry pi model role) Role to setup watchdog and other common things
- raspberry_pi_4: Role specifically for Raspberry Pi 4
- raspberry_pi_5: Role specifically for Raspberry Pi 5

Boot config is set at the model-specific roles to avoid unnecessary changes due to template-file mismatch and resulting reboot.

## Variables
> These can be found in roles/role_name/meta/argument_specs.yml, but putting it here for easy access
### common
- `common_ssh_allowed_src`: A list of allowed network address for ssh (default: any)

### raspberry_pi_common
- `raspberry_pi_common_enable_i2c`: Enable i2c on GPIO pins (default: false)
- `raspberry_pi_common_enable_spi`: Enable spi on GPIO pins (default: false)
- `raspberry_pi_common_enable_uart`: Enable UART (default: false)
- `raspberry_pi_common_enable_watchdog`: Setup and enable watchdog (default: true)
- `raspberry_pi_common_watchdog_max_temp`: Watchdog max temperature (default: 80000)

### raspberry_pi_4
- `raspberry_pi_4_has_gpio_fan`: Whether Raspberry Pi 4 has GPIO fan installed (default: true)
- `raspberry_pi_4_gpio_fan_pin`: PWM control pin of the Fan (default: 14)
- `raspberry_pi_4_fan_temp`: Threshold temperature in millicelsius to turn on the fan (default: 60000)
- `raspberry_pi_4_turn_off_lights`: Turn off all external lights (power, ethernet) (default: false)

### raspberry_pi_5
- `raspberry_pi_5_enable_pcie_without_hat`: Enable PCIe without needing to enable HAT+ device (default: false)
- `raspberry_pi_5_enable_pcie_gen3`: Enable PCIe Gen3 speed (Raspberry Pi 5 only certified to PCIe Gen2) (default: false)
- `raspberry_pi_5_has_rtc_batt`: Enable charging if Raspberry Pi 5 has RTC backup battery installed (default: false)
- `raspberry_pi_5_usb_max_current_enable`: Enable 1600mA USB power on Raspberry Pi even when not supplying 25W power, also used to boot from USB if underpowered by PSW (default: false)
- `raspberry_pi_5_turn_off_lights`: Turn off all external lights (power, ethernet) (default: false)
