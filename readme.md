# Infrared remote control for PC using STM32F411CEU6 'BlackPill' board
Using common cheap NEC 8 bit coded infrared remote ('Car MP3' labelled) and cheap receiver (1838 type variants), control volume / mute / play-pause / next / previous / etc on a PC over USB.

Connect receiver data pin to PA6. Serial RX on PB7, serial TX on PB6.


### Libraries needed:

MediaKeyboard by onetransistor: https://www.onetransistor.eu/2020/03/usb-multimedia-keys-on-arduino-stm32.html

Arduino-IRremote by Ken Shiriff et al (available in arduino library manager): https://github.com/Arduino-IRremote/Arduino-IRremote

STM32 cores for Arduino: https://github.com/stm32duino/Arduino_Core_STM32



Uses around 20k bytes flash, 3k bytes for global variables. So should also work with F401, F103, etc, maybe even F0.
