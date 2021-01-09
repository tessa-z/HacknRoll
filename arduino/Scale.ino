#include <DFRobot_HX711.h>

DFRobot_HX711 MyScale(A2, A3);

void setup() {
  Serial.begin(9600);
}

void loop() {
  Serial.print(MyScale.readWeight(), 1);
  Serial.println(" g");
  delay(200);
}
