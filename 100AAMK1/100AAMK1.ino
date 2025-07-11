/*********************************************************************************
 * 文件名  ：main.c
 * 描述    ：        
 * 硬件连接：
 * 应变片弯曲传感器：VCC -> 5V; GND -> GND; AO -> A0;
 * 功能描述：测量弯曲角度；
             串口接收测量所得的弯曲角度（波特率9600）；
   使用时先进行零度和最大角度校准，依据校准值调整 Voltage_0   Voltage_set
**********************************************************************************/
const int Flex_PIN = A0;          // 电压采集接口

// Measure the voltage at 5V and the actual resistance of your// 100k resistor, and enter them below:
const float VCC =5000.0;          // 模块供电电压，ADC参考电压为V

// Upload the code, then try to adjust these values to more// accurately calculate bend degree.
const float Voltage_0 =2000.0;    // 零点电压值mV  校准时需修改
const float Voltage_set =3000.0 ; // 已知角度输出电压值mV  需修改
const float Angle_0 =0.0;         // 零点角度  校准时需修改
const float Angle_set =90.0 ;     // 已知角度  需修改

#define K_Value  (Angle_set-Angle_0)/(Voltage_set/1000-Voltage_0/1000)
#define B_Value  Angle_0-(Voltage_0/1000)*K_Value

float angle,pre_angle; // 角度

void setup() 
{
  Serial.begin(9600);
  pinMode(Flex_PIN, INPUT);
}

void loop() 
{
  // Read the ADC, and calculate voltage and resistance from it
  int F_ADC=analogRead(Flex_PIN);
  float Flex_V=F_ADC* VCC / 1023.0;
  Serial.println("Voltage: "+String(Flex_V) +" V");
// Use the calculated resistance to estimate the sensor's// bend angle:
  float angle=K_Value*(Flex_V/1000)+B_Value;
  if(angle>180){angle=180;}
  if(angle<-180){angle=-180;}
  Serial.println("Angle: "+String(angle) +"°");
  Serial.println();
  delay(500);
}
