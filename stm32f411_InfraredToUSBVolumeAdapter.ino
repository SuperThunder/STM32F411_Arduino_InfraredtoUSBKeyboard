/*
 * MIT License
 */

//Using shiriff irremote and onetransistor smashed together examples :)

//Shiriff IRremote
#include <Arduino.h>
#define DECODE_NEC          1
// MARK_EXCESS_MICROS is subtracted from all marks and added to all spaces before decoding,
// to compensate for the signal forming of different IR receiver modules.
#define MARK_EXCESS_MICROS    20 // 20 is recommended for the cheap VS1838 modules
//#define RECORD_GAP_MICROS 12000 // Activate it for some LG air conditioner protocols
/*
 * First define macros for input and output pin etc.
 */
#include "PinDefinitionsAndMore.h"
#include <IRremote.h>
#if defined(APPLICATION_PIN)
#define DEBUG_BUTTON_PIN    APPLICATION_PIN // if low, print timing for each received data set
#else
#define DEBUG_BUTTON_PIN   6
#endif

//onetransistor MediaKeyboard
#include <MediaKeyboard.h>
#include <Keyboard.h>


void setup() {

  MediaKeyboard.begin();
  
  Serial.begin(115200);
  delay(750); //some delay for serial and keyboard to get ready
  Serial1.println(F("Infrared lib test. Actual serial on Rx: PB7, Tx: PB6"));

  //HID means no USB serial, so use physical serial
  Serial1.setRx(PB7); //RX on PB7
  Serial1.setTx(PB6); //TX on PB6
  Serial1.begin(115200);
  Serial1.println(F("Infrared lib test"));

  //shiriff irremote (PA6 for IR rx data pin)
#if defined(IR_MEASURE_TIMING) && defined(IR_TIMING_TEST_PIN)
    pinMode(IR_TIMING_TEST_PIN, OUTPUT);
#endif

    pinMode(DEBUG_BUTTON_PIN, INPUT_PULLUP);
    

// In case the interrupt driver crashes on setup, give a clue
// to the user what's going on.
    Serial1.println(F("Enabling IRin..."));

    /*
     * Start the receiver, enable feedback LED and (if not 3. parameter specified) take LED feedback pin from the internal boards definition
     */
    IrReceiver.begin(IR_RECEIVE_PIN, DISABLE_LED_FEEDBACK);

    Serial1.print(F("Ready to receive IR signals at pin "));

    Serial1.println(IR_RECEIVE_PIN_STRING);

    Serial1.print(F("Debug button pin is "));
    Serial1.println(DEBUG_BUTTON_PIN);

    // infos for receive
    Serial1.print(RECORD_GAP_MICROS);
    Serial1.println(F(" us is the (minimum) gap, after which the start of a new IR packet is assumed"));
    Serial1.print(MARK_EXCESS_MICROS);
    Serial1.println(F(" us are subtracted from all marks and added to all spaces for decoding"));
}

void loop() {
    /*
     * Check if received data is available and if yes, try to decode it.
     * Decoded result is in the IrReceiver.decodedIRData structure.
     *
     * E.g. command is in IrReceiver.decodedIRData.command
     * address is in command is in IrReceiver.decodedIRData.address
     * and up to 32 bit raw data in IrReceiver.decodedIRData.decodedRawData
     */
    if (IrReceiver.decode()) {
        Serial1.println();
        if (IrReceiver.decodedIRData.flags & IRDATA_FLAGS_WAS_OVERFLOW) {
            IrReceiver.decodedIRData.flags = false; // yes we have recognized the flag :-)
            Serial1.println(F("Overflow detected"));
        } else {
            // Print a short summary of received data
            IrReceiver.printIRResultShort(&Serial1);

            if (IrReceiver.decodedIRData.protocol == UNKNOWN || digitalRead(DEBUG_BUTTON_PIN) == LOW) {
                // We have an unknown protocol, print more info
                IrReceiver.printIRResultRawFormatted(&Serial1, true);
            }
        }

        /*
         * !!!Important!!! Enable receiving of the next value,
         * since receiving has stopped after the end of the current received data packet.
         */
        IrReceiver.resume();

        /*
         * Finally check the received data and perform actions according to the received address and commands
         */
        if (IrReceiver.decodedIRData.address == 0) {
            //if (IrReceiver.decodedIRData.command == 0x07) {
                // do something
            //} else if (IrReceiver.decodedIRData.command == 0x11) {
            //    // do something else
            //}
            switch(IrReceiver.decodedIRData.command)
            {
              //0x07 vol down
              case 0x07:
                MediaKeyboard.press(VOLUME_DOWN);
                MediaKeyboard.release();
                break;
                
              //0x15 vol up
              case 0x15:
                MediaKeyboard.press(VOLUME_UP);
                MediaKeyboard.release();
                break;
                
              //0x09 EQ button (used for mute)
              case 0x09:
                MediaKeyboard.press(VOLUME_MUTE);
                MediaKeyboard.release();
                delay(500);
                break;

              //todo: check the last push time against a defined rate limit for these media keys, rather than delay
              //PlayPause
              case 0x43:
                MediaKeyboard.press(MEDIA_PLAY_PAUSE);
                MediaKeyboard.release();
                delay(1000);
                break;

              //Next
              case 0x40:
                MediaKeyboard.press(MEDIA_NEXT);
                MediaKeyboard.release();
                delay(500);
                break;

              //Prev
              case 0x44:
                MediaKeyboard.press(MEDIA_PREV);
                MediaKeyboard.release();
                delay(500);
                break;
              
              default:
                break;
            }
        }
    }
}
