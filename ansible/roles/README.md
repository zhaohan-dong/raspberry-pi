# Roles for Raspberry Pi

- common: Common role to setup Debian/Ubuntu/RedHat nodes
- raspberry_pi_common: (not meant to be used directly but as a dependency of specific raspberry pi model role) Role to setup watchdog and other common things
- raspberry_pi_4: Role specifically for Raspberry Pi 4
- raspberry_pi_5: Role specifically for Raspberry Pi 5

Boot config is set at the model-specific roles to avoid unnecessary changes due to template-file mismatch and resulting reboot.