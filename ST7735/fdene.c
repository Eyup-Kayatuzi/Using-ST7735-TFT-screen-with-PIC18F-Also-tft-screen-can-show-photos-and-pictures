//   RST (optional), CS and DC
#define TFT_RST       RD0_bit
#define TFT_CS        RD1_bit
#define TFT_DC        RD2_bit
#define TFT_RST_DIR   TRISD0_bit
#define TFT_CS_DIR    TRISD1_bit
#define TFT_DC_DIR    TRISD2_bit

#include "ST7735.h"       // include ST7735 TFT display driver source code
#include "GFX_Library.h"  // include graphics library source code
#include "bitmap.h"




// main function
void main()
{
  OSCCON = 0x72;   // set internal oscillator to 16MHz
  ANSELC = 0;      // configure all PORTC pins as digital
  ANSELD = 0;      // configure all PORTD pins as digital
  SPI1_Init();       // initialize the SPI1 module with default settings

  // Use this initializer if using a 1.8" TFT screen:
  tft_initR(INITR_BLACKTAB);      // Init ST7735S chip, black tab
  display_setTextWrap(1);  // allow text to run off right edge
  display_fillScreen(ST7735_BLACK);
  
  /*display_setCursor(0, 0);
  display_setTextSize(1);
  display_setTextColor(ST7735_RED, ST7735_BLACK);
  display_setRotation(0);
  display_puts("Herhaba\r\n");
  display_setTextSize(2);
  display_setTextColor(ST7735_GREEN, ST7735_BLACK);
  display_puts("Muhammet Bey\r\n");    */
  
  
  display_drawBitmapV2(14,30,dene,100,100, ST7735_BLUE); //FOR pictures

  while(1) {
           /*

           display_setCursor(64, 80);
           display_setTextSize(3);
           display_setTextColor(ST7735_RED, ST7735_BLACK);
           display_puts("1");
           Delay_ms(1000);
           display_setCursor(64, 80);
           display_puts("2");
           Delay_ms(1000);
           display_setCursor(64, 80);
           display_puts("3");
           Delay_ms(1000); */
  }

}