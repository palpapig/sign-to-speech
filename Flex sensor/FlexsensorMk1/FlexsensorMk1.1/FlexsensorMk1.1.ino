/*
  Flex sensor reader with ADC oversampling (+2 bits → 12‑bit resolution)
  Based on your original sketch, refactored by ChatGPT – 2025‑07‑09
*/

#include <Arduino.h>

/* ----------- Hardware configuration ----------- */
const uint8_t flexPin = A0;            // ADC pin connected to the divider node
const float    VCC     = 5.0;          // Arduino supply voltage (V)
const float    R_DIV   = 15000.0;      // Fixed resistor in voltage divider (Ω)
const float    flatResistance  = 13340.0; // Sensor resistance when flat  (Ω)
const float    bendResistance  = 14100.0; // Sensor resistance at 90° bend (Ω) NEED TO BE CHECKED

/* ----------- Oversampling parameters ----------- */
// EXTRA_BITS:   1 = +1 bit (11‑bit), 2 = +2 bit (12‑bit),
//               3 = +3 bit (13‑bit), 4 = +4 bit (14‑bit)
const uint8_t  EXTRA_BITS = 2;                       // Desired extra bits
const uint16_t SAMPLES    = 1 << (EXTRA_BITS * 2);  // 4^n samples required

/*
   oversampleRead(pin)
   ────────────────────
   Perform N (=4^n) successive 10‑bit ADC reads, accumulate, then
   right‑shift by EXTRA_BITS to obtain a 10+EXTRA_BITS‑bit result.
*/
uint16_t oversampleRead(uint8_t pin)
{
  uint32_t acc = 0;
  for (uint16_t i = 0; i < SAMPLES; ++i) {
    acc += analogRead(pin);   // Single 10‑bit conversion (~110 µs @ prescale 128)
  }
  return acc >> EXTRA_BITS;   // 0‒(2^(10+EXTRA_BITS) − 1)
}

void setup()
{
  Serial.begin(115200);
  while (!Serial) { /* wait for USB */ }
  Serial.println(F("Flex sensor oversampling demo"));
  Serial.print(F("Oversampling: +")); Serial.print(EXTRA_BITS);
  Serial.print(F(" bit, SAMPLES=")); Serial.print(SAMPLES);
  Serial.println();
}

void loop()
{
  /* ---------- Read sensor ---------- */
  const uint16_t adc = oversampleRead(flexPin);      // 12‑bit value (0‑4095)

  /* ---------- Calculate voltage ---------- */
  const float adcMax = (1 << (10 + EXTRA_BITS)) - 1; // 2^(10+n) − 1
  const float Vflex  = adc * VCC / adcMax;           // Divider output voltage (V)

  /* ---------- Calculate resistance ---------- */
  const float Rflex  = R_DIV * (VCC / Vflex - 1.0);  // Sensor resistance (Ω)

  /* ---------- Map resistance to bend angle ---------- */
  float angle = (Rflex - flatResistance) * 90.0 /
                (bendResistance - flatResistance);
  angle = constrain(angle, 0.0, 90.0);

  /* ---------- Serial output ---------- */
  Serial.print(F("ADC="));   Serial.print(adc);
  Serial.print(F("  V="));   Serial.print(Vflex, 3);
  Serial.print(F(" V  R=")); Serial.print(Rflex, 1);
  Serial.print(F(" Ω  Angle=")); Serial.print(angle, 1);
  Serial.println(F("°"));

  delay(400);  // ~50 Hz update rate (adjust as needed)
}
