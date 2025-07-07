#include <SoftwareSerial.h>

SoftwareSerial BTSerial(10, 11); // D10 = RX, D11 = TX

void setup() {
  Serial.begin(9600);      // 串口监视器通信
  BTSerial.begin(9600);    // 蓝牙通信
  Serial.println("请输入内容，将通过蓝牙发送...");
}

void loop() {
  if (Serial.available()) {
    String input = Serial.readStringUntil('\n'); // 读一行你打的内容
    BTSerial.println(input);                     // 发送到手机
    Serial.print("发送成功: ");
    Serial.println(input);
  }

  // 可选：如果从手机发内容过来也打印
  if (BTSerial.available()) {
    String incoming = BTSerial.readStringUntil('\n');
    Serial.print("手机发来：");
    Serial.println(incoming);
  }
}
