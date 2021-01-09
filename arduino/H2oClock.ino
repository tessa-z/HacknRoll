#include <SPI.h>
#include <SD.h>
#include <pcmConfig.h>
#include <pcmRF.h>
#include <TMRpcm.h>
#include <Bounce2.h>
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <SimpleSDAudio.h>

#define SCREEN_WIDTH 128 // OLED display size, in pixels
#define SCREEN_HEIGHT 64

// Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)
#define OLED_RESET     4 // Reset pin # (or -1 if sharing Arduino reset pin)
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

//variables to draw clock
const float pi = 3.14159267 ;
const int clock_center_x=64;
const int clock_center_y=32;
int o=1;

// variables used to calculate coordinates of points on the circle
int x;
int y;
int x1;
int y1;

//time variables
int seconds=0;
int minutes=0;
int hours=9;
bool flag = true;  //(AM)

//interrupt variables
const byte interruptPin = 2;
volatile byte state = HIGH;
Button button = Button();

//play music
#define SD_ChipSelectPin 4
TMRpcm music;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  
  // SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
  if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) { // Address 0x3D for 128x64
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
  }
  display.clearDisplay();
  draw_clock_face();   
  display.display();

  //play music
  music.speakerPin = 9;
  if (!SD.begin(SD_ChipSelectPin)) {
    Serial.println("SD fail");
    return;
  }
  music.setVolume(5);    //   0 to 7. Set volume level
  music.quality(1);   

  //interrupt button
  pinMode(interruptPin, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(interruptPin), alarm, CHANGE);
}

void draw_second(int second, int mode){
   y= (23*cos(pi-(2*pi)/60*second))+clock_center_y;
   x =(23*sin(pi-(2*pi)/60*second))+clock_center_x;
   if (mode==1)display.drawLine(clock_center_x,clock_center_y,x,y,SSD1306_WHITE); else display.drawLine(clock_center_x,clock_center_y,x,y,SSD1306_BLACK);
}

void draw_hour(int hour, int minute, int mode){
  
   y= (18*cos(pi-(2*pi)/12*hour-(2*PI)/720*minute))+clock_center_y;
   x =(18*sin(pi-(2*pi)/12*hour-(2*PI)/720*minute))+clock_center_x;
   y1=(18*cos(pi-(2*pi)/12*hour-(2*PI)/720*minute))+clock_center_y+1;
   x1=(18*sin(pi-(2*pi)/12*hour-(2*PI)/720*minute))+clock_center_x+1;
   if (mode==1){
    display.drawLine(clock_center_x,clock_center_y,x,y,SSD1306_WHITE);
    display.drawLine(clock_center_x+1,clock_center_y+1,x1,y1,SSD1306_WHITE);
   }
   else{
    display.drawLine(clock_center_x,clock_center_y,x,y,SSD1306_BLACK);
    display.drawLine(clock_center_x+1,clock_center_y+1,x1,y1,SSD1306_BLACK);
   }  
}
void draw_minute(int minute, int mode){
   y= (24*cos(pi-(2*pi)/60*minute))+clock_center_y;
   x =(24*sin(pi-(2*pi)/60*minute))+clock_center_x;
   y1=(24*cos(pi-(2*pi)/60*minute))+clock_center_y+1;
   x1=(24*sin(pi-(2*pi)/60*minute))+clock_center_x+1;
   if (mode==1){
    display.drawLine(clock_center_x,clock_center_y,x,y,SSD1306_WHITE);
    display.drawLine(clock_center_x+1,clock_center_y+1,x1,y1,SSD1306_WHITE);
   }
   else{
    display.drawLine(clock_center_x,clock_center_y,x,y,SSD1306_BLACK);
    display.drawLine(clock_center_x+1,clock_center_y+1,x1,y1,SSD1306_BLACK);
   } }

void draw_clock_face(void){
// draw the center of the clock
  display.drawCircle(clock_center_x, clock_center_y,3, SSD1306_WHITE);
  display.fillCircle(clock_center_x, clock_center_y,3, SSD1306_WHITE);

// draw hour pointers around the face of a clock
for (int i=0;i<12;i++){
   y= (32*cos(pi-(2*pi)/12*i))+clock_center_y;
   x =(32*sin(pi-(2*pi)/12*i))+clock_center_x;
   y1= (28*cos(pi-(2*pi)/12*i))+clock_center_y;
   x1 =(28*sin(pi-(2*pi)/12*i))+clock_center_x;
   display.drawLine(x1,y1,x,y,SSD1306_WHITE);
}
// print string "12" at the top of the face of the clock  
  display.drawCircle(26*sin(pi)+clock_center_x, (26*cos(pi))+clock_center_y, 6, SSD1306_BLACK);
  display.fillCircle(26*sin(pi)+clock_center_x, (26*cos(pi))+clock_center_y, 5, SSD1306_BLACK);
  display.setTextSize(1);             // Normal 1:1 pixel scale
  display.setTextColor(SSD1306_WHITE);        // Draw white text
  display.setCursor(clock_center_x-3,0);             // Start at top-left corner
  display.println(F("12"));
}

void redraw_clock_face_elements(void){
    display.drawCircle(clock_center_x, clock_center_y,3, SSD1306_WHITE);
    display.fillCircle(clock_center_x, clock_center_y,3, SSD1306_WHITE);
    display.setCursor(clock_center_x-3,0);             
    display.println(F("12"));
}

void am_pm(void){
    display.setCursor(108,10);
    if (flag == true){
      display.println(F("AM"));
    }
    else{
      display.println(F("PM"));
    }
}

void alarm(){
  state = !state;
}

void loop() {
  
  while (state == HIGH){
    display.clearDisplay();
    Serial.println(digitalRead(interruptPin));
    // manage seconds, minutes, hours
    seconds = seconds + 1;
    if (seconds==60){
      seconds = 0;
      minutes = minutes+1;
    }
    if (minutes == 60){
      minutes = 0;
      hours = hours+1;
    }
    if (hours==13){
      hours = 1;
      flag = !flag;
    }
  
    //draw stuff every second
    //draw_second(seconds,0);
    draw_clock_face();
    am_pm();
    //draw_minute(minutes,0);
    //draw_hour(hours,minutes,0);
    draw_second(seconds,1);
    draw_minute(minutes,1);
    draw_hour(hours,minutes,1);
    display.display(); 
    delay(1000);
    redraw_clock_face_elements();
  
    //delay(1000);
    draw_second(seconds,0);
    draw_minute(minutes,0);
    draw_hour(hours,minutes,0);
  }

  while (state == LOW){
    Serial.println(digitalRead(interruptPin));
    //change display
    display.clearDisplay();
    display.setCursor(44, 28);
    display.println(F("WAKE UP!"));
    //play alarm  
    music.play("1.wav",0);
  }
}
