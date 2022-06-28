
_startWrite:

;st7735.h,334 :: 		void startWrite(void) {
;st7735.h,335 :: 		TFT_CS = 0;
	BCF         RD1_bit+0, BitPos(RD1_bit+0) 
;st7735.h,336 :: 		}
L_end_startWrite:
	RETURN      0
; end of _startWrite

_endWrite:

;st7735.h,345 :: 		void endWrite(void) {
;st7735.h,346 :: 		TFT_CS = 1;
	BSF         RD1_bit+0, BitPos(RD1_bit+0) 
;st7735.h,347 :: 		}
L_end_endWrite:
	RETURN      0
; end of _endWrite

_writeCommand:

;st7735.h,359 :: 		void writeCommand(uint8_t cmd) {
;st7735.h,360 :: 		TFT_DC = 0;
	BCF         RD2_bit+0, BitPos(RD2_bit+0) 
;st7735.h,361 :: 		ST7735_SPI_Write(cmd);
	MOVF        FARG_writeCommand_cmd+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,362 :: 		TFT_DC = 1;
	BSF         RD2_bit+0, BitPos(RD2_bit+0) 
;st7735.h,363 :: 		}
L_end_writeCommand:
	RETURN      0
; end of _writeCommand

_displayInit:

;st7735.h,372 :: 		void displayInit(const uint8_t *addr){
;st7735.h,375 :: 		startWrite();
	CALL        _startWrite+0, 0
;st7735.h,377 :: 		numCommands = *addr++;   // Number of commands to follow
	MOVF        FARG_displayInit_addr+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_displayInit_addr+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_displayInit_addr+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, displayInit_numCommands_L0+0
	MOVLW       1
	ADDWF       FARG_displayInit_addr+0, 1 
	MOVLW       0
	ADDWFC      FARG_displayInit_addr+1, 1 
	ADDWFC      FARG_displayInit_addr+2, 1 
;st7735.h,379 :: 		while(numCommands--) {                 // For each command...
L_displayInit0:
	MOVF        displayInit_numCommands_L0+0, 0 
	MOVWF       R0 
	DECF        displayInit_numCommands_L0+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_displayInit1
;st7735.h,381 :: 		writeCommand(*addr++); // Read, issue command
	MOVF        FARG_displayInit_addr+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_displayInit_addr+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_displayInit_addr+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_writeCommand_cmd+0
	CALL        _writeCommand+0, 0
	MOVLW       1
	ADDWF       FARG_displayInit_addr+0, 1 
	MOVLW       0
	ADDWFC      FARG_displayInit_addr+1, 1 
	ADDWFC      FARG_displayInit_addr+2, 1 
;st7735.h,382 :: 		numArgs  = *addr++;    // Number of args to follow
	MOVF        FARG_displayInit_addr+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_displayInit_addr+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_displayInit_addr+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 0 
	MOVWF       displayInit_numArgs_L0+0 
	MOVLW       1
	ADDWF       FARG_displayInit_addr+0, 1 
	MOVLW       0
	ADDWFC      FARG_displayInit_addr+1, 1 
	ADDWFC      FARG_displayInit_addr+2, 1 
;st7735.h,383 :: 		ms       = numArgs & ST_CMD_DELAY;   // If hibit set, delay follows args
	MOVLW       128
	ANDWF       R0, 0 
	MOVWF       displayInit_ms_L0+0 
	CLRF        displayInit_ms_L0+1 
	MOVLW       0
	ANDWF       displayInit_ms_L0+1, 1 
	MOVLW       0
	MOVWF       displayInit_ms_L0+1 
;st7735.h,384 :: 		numArgs &= ~ST_CMD_DELAY;            // Mask out delay bit
	MOVLW       127
	ANDWF       R0, 0 
	MOVWF       displayInit_numArgs_L0+0 
;st7735.h,385 :: 		while(numArgs--) {                   // For each argument...
L_displayInit2:
	MOVF        displayInit_numArgs_L0+0, 0 
	MOVWF       R0 
	DECF        displayInit_numArgs_L0+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_displayInit3
;st7735.h,386 :: 		ST7735_SPI_Write(*addr++);   // Read, issue argument
	MOVF        FARG_displayInit_addr+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_displayInit_addr+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_displayInit_addr+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_SPI1_Write_data_+0
	CALL        _SPI1_Write+0, 0
	MOVLW       1
	ADDWF       FARG_displayInit_addr+0, 1 
	MOVLW       0
	ADDWFC      FARG_displayInit_addr+1, 1 
	ADDWFC      FARG_displayInit_addr+2, 1 
;st7735.h,387 :: 		}
	GOTO        L_displayInit2
L_displayInit3:
;st7735.h,389 :: 		if(ms) {
	MOVF        displayInit_ms_L0+0, 0 
	IORWF       displayInit_ms_L0+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_displayInit4
;st7735.h,390 :: 		ms = *addr++; // Read post-command delay time (ms)
	MOVF        FARG_displayInit_addr+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_displayInit_addr+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_displayInit_addr+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, displayInit_ms_L0+0
	MOVLW       0
	MOVWF       displayInit_ms_L0+1 
	MOVLW       1
	ADDWF       FARG_displayInit_addr+0, 1 
	MOVLW       0
	ADDWFC      FARG_displayInit_addr+1, 1 
	ADDWFC      FARG_displayInit_addr+2, 1 
;st7735.h,391 :: 		if(ms == 255) ms = 500;     // If 255, delay for 500 ms
	MOVLW       0
	XORWF       displayInit_ms_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__displayInit343
	MOVLW       255
	XORWF       displayInit_ms_L0+0, 0 
L__displayInit343:
	BTFSS       STATUS+0, 2 
	GOTO        L_displayInit5
	MOVLW       244
	MOVWF       displayInit_ms_L0+0 
	MOVLW       1
	MOVWF       displayInit_ms_L0+1 
L_displayInit5:
;st7735.h,392 :: 		while(ms--) delay_ms(1);
L_displayInit6:
	MOVF        displayInit_ms_L0+0, 0 
	MOVWF       R0 
	MOVF        displayInit_ms_L0+1, 0 
	MOVWF       R1 
	MOVLW       1
	SUBWF       displayInit_ms_L0+0, 1 
	MOVLW       0
	SUBWFB      displayInit_ms_L0+1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_displayInit7
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       48
	MOVWF       R13, 0
L_displayInit8:
	DECFSZ      R13, 1, 1
	BRA         L_displayInit8
	DECFSZ      R12, 1, 1
	BRA         L_displayInit8
	NOP
	GOTO        L_displayInit6
L_displayInit7:
;st7735.h,393 :: 		}
L_displayInit4:
;st7735.h,394 :: 		}
	GOTO        L_displayInit0
L_displayInit1:
;st7735.h,395 :: 		endWrite();
	CALL        _endWrite+0, 0
;st7735.h,396 :: 		}
L_end_displayInit:
	RETURN      0
; end of _displayInit

_tft_initB:

;st7735.h,403 :: 		void tft_initB(void) {
;st7735.h,405 :: 		TFT_RST = 1;
	BSF         RD0_bit+0, BitPos(RD0_bit+0) 
;st7735.h,407 :: 		TFT_RST_DIR = 0;
	BCF         TRISD0_bit+0, BitPos(TRISD0_bit+0) 
;st7735.h,409 :: 		delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_tft_initB9:
	DECFSZ      R13, 1, 1
	BRA         L_tft_initB9
	DECFSZ      R12, 1, 1
	BRA         L_tft_initB9
	DECFSZ      R11, 1, 1
	BRA         L_tft_initB9
;st7735.h,410 :: 		TFT_RST = 0;
	BCF         RD0_bit+0, BitPos(RD0_bit+0) 
;st7735.h,411 :: 		delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_tft_initB10:
	DECFSZ      R13, 1, 1
	BRA         L_tft_initB10
	DECFSZ      R12, 1, 1
	BRA         L_tft_initB10
	DECFSZ      R11, 1, 1
	BRA         L_tft_initB10
;st7735.h,412 :: 		TFT_RST = 1;
	BSF         RD0_bit+0, BitPos(RD0_bit+0) 
;st7735.h,413 :: 		delay_ms(200);
	MOVLW       5
	MOVWF       R11, 0
	MOVLW       15
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_tft_initB11:
	DECFSZ      R13, 1, 1
	BRA         L_tft_initB11
	DECFSZ      R12, 1, 1
	BRA         L_tft_initB11
	DECFSZ      R11, 1, 1
	BRA         L_tft_initB11
;st7735.h,416 :: 		TFT_CS = 1;
	BSF         RD1_bit+0, BitPos(RD1_bit+0) 
;st7735.h,418 :: 		TFT_CS_DIR = 0;
	BCF         TRISD1_bit+0, BitPos(TRISD1_bit+0) 
;st7735.h,422 :: 		TFT_DC_DIR = 0;
	BCF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;st7735.h,425 :: 		displayInit(Bcmd);
	MOVLW       _Bcmd+0
	MOVWF       FARG_displayInit_addr+0 
	MOVLW       hi_addr(_Bcmd+0)
	MOVWF       FARG_displayInit_addr+1 
	MOVLW       higher_addr(_Bcmd+0)
	MOVWF       FARG_displayInit_addr+2 
	CALL        _displayInit+0, 0
;st7735.h,426 :: 		setRotation(0);
	CLRF        FARG_setRotation_m+0 
	CALL        _setRotation+0, 0
;st7735.h,427 :: 		}
L_end_tft_initB:
	RETURN      0
; end of _tft_initB

_tft_initR:

;st7735.h,435 :: 		void tft_initR(uint8_t options) {
;st7735.h,437 :: 		TFT_RST = 1;
	BSF         RD0_bit+0, BitPos(RD0_bit+0) 
;st7735.h,439 :: 		TFT_RST_DIR = 0;
	BCF         TRISD0_bit+0, BitPos(TRISD0_bit+0) 
;st7735.h,441 :: 		delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_tft_initR12:
	DECFSZ      R13, 1, 1
	BRA         L_tft_initR12
	DECFSZ      R12, 1, 1
	BRA         L_tft_initR12
	DECFSZ      R11, 1, 1
	BRA         L_tft_initR12
;st7735.h,442 :: 		TFT_RST = 0;
	BCF         RD0_bit+0, BitPos(RD0_bit+0) 
;st7735.h,443 :: 		delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_tft_initR13:
	DECFSZ      R13, 1, 1
	BRA         L_tft_initR13
	DECFSZ      R12, 1, 1
	BRA         L_tft_initR13
	DECFSZ      R11, 1, 1
	BRA         L_tft_initR13
;st7735.h,444 :: 		TFT_RST = 1;
	BSF         RD0_bit+0, BitPos(RD0_bit+0) 
;st7735.h,445 :: 		delay_ms(200);
	MOVLW       5
	MOVWF       R11, 0
	MOVLW       15
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_tft_initR14:
	DECFSZ      R13, 1, 1
	BRA         L_tft_initR14
	DECFSZ      R12, 1, 1
	BRA         L_tft_initR14
	DECFSZ      R11, 1, 1
	BRA         L_tft_initR14
;st7735.h,448 :: 		TFT_CS = 1;
	BSF         RD1_bit+0, BitPos(RD1_bit+0) 
;st7735.h,450 :: 		TFT_CS_DIR = 0;
	BCF         TRISD1_bit+0, BitPos(TRISD1_bit+0) 
;st7735.h,454 :: 		TFT_DC_DIR = 0;
	BCF         TRISD2_bit+0, BitPos(TRISD2_bit+0) 
;st7735.h,457 :: 		displayInit(Rcmd1);
	MOVLW       _Rcmd1+0
	MOVWF       FARG_displayInit_addr+0 
	MOVLW       hi_addr(_Rcmd1+0)
	MOVWF       FARG_displayInit_addr+1 
	MOVLW       higher_addr(_Rcmd1+0)
	MOVWF       FARG_displayInit_addr+2 
	CALL        _displayInit+0, 0
;st7735.h,458 :: 		if(options == INITR_GREENTAB) {
	MOVF        FARG_tft_initR_options+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_tft_initR15
;st7735.h,459 :: 		displayInit(Rcmd2green);
	MOVLW       _Rcmd2green+0
	MOVWF       FARG_displayInit_addr+0 
	MOVLW       hi_addr(_Rcmd2green+0)
	MOVWF       FARG_displayInit_addr+1 
	MOVLW       higher_addr(_Rcmd2green+0)
	MOVWF       FARG_displayInit_addr+2 
	CALL        _displayInit+0, 0
;st7735.h,460 :: 		_colstart = 2;
	MOVLW       2
	MOVWF       __colstart+0 
;st7735.h,461 :: 		_rowstart = 1;
	MOVLW       1
	MOVWF       __rowstart+0 
;st7735.h,462 :: 		} else if((options == INITR_144GREENTAB) || (options == INITR_HALLOWING)) {
	GOTO        L_tft_initR16
L_tft_initR15:
	MOVF        FARG_tft_initR_options+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L__tft_initR318
	MOVF        FARG_tft_initR_options+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L__tft_initR318
	GOTO        L_tft_initR19
L__tft_initR318:
;st7735.h,463 :: 		_height   = ST7735_TFTHEIGHT_128;
	MOVLW       128
	MOVWF       __height+0 
;st7735.h,464 :: 		_width    = ST7735_TFTWIDTH_128;
	MOVLW       128
	MOVWF       __width+0 
;st7735.h,465 :: 		displayInit(Rcmd2green144);
	MOVLW       _Rcmd2green144+0
	MOVWF       FARG_displayInit_addr+0 
	MOVLW       hi_addr(_Rcmd2green144+0)
	MOVWF       FARG_displayInit_addr+1 
	MOVLW       higher_addr(_Rcmd2green144+0)
	MOVWF       FARG_displayInit_addr+2 
	CALL        _displayInit+0, 0
;st7735.h,466 :: 		_colstart = 2;
	MOVLW       2
	MOVWF       __colstart+0 
;st7735.h,467 :: 		_rowstart = 3; // For default rotation 0
	MOVLW       3
	MOVWF       __rowstart+0 
;st7735.h,468 :: 		} else if(options == INITR_MINI160x80) {
	GOTO        L_tft_initR20
L_tft_initR19:
	MOVF        FARG_tft_initR_options+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_tft_initR21
;st7735.h,469 :: 		_height   = ST7735_TFTHEIGHT_160;
	MOVLW       160
	MOVWF       __height+0 
;st7735.h,470 :: 		_width    = ST7735_TFTWIDTH_80;
	MOVLW       80
	MOVWF       __width+0 
;st7735.h,471 :: 		displayInit(Rcmd2green160x80);
	MOVLW       _Rcmd2green160x80+0
	MOVWF       FARG_displayInit_addr+0 
	MOVLW       hi_addr(_Rcmd2green160x80+0)
	MOVWF       FARG_displayInit_addr+1 
	MOVLW       higher_addr(_Rcmd2green160x80+0)
	MOVWF       FARG_displayInit_addr+2 
	CALL        _displayInit+0, 0
;st7735.h,472 :: 		_colstart = 24;
	MOVLW       24
	MOVWF       __colstart+0 
;st7735.h,473 :: 		_rowstart = 0;
	CLRF        __rowstart+0 
;st7735.h,474 :: 		} else {
	GOTO        L_tft_initR22
L_tft_initR21:
;st7735.h,476 :: 		displayInit(Rcmd2red);
	MOVLW       _Rcmd2red+0
	MOVWF       FARG_displayInit_addr+0 
	MOVLW       hi_addr(_Rcmd2red+0)
	MOVWF       FARG_displayInit_addr+1 
	MOVLW       higher_addr(_Rcmd2red+0)
	MOVWF       FARG_displayInit_addr+2 
	CALL        _displayInit+0, 0
;st7735.h,477 :: 		}
L_tft_initR22:
L_tft_initR20:
L_tft_initR16:
;st7735.h,478 :: 		displayInit(Rcmd3);
	MOVLW       _Rcmd3+0
	MOVWF       FARG_displayInit_addr+0 
	MOVLW       hi_addr(_Rcmd3+0)
	MOVWF       FARG_displayInit_addr+1 
	MOVLW       higher_addr(_Rcmd3+0)
	MOVWF       FARG_displayInit_addr+2 
	CALL        _displayInit+0, 0
;st7735.h,481 :: 		if((options == INITR_BLACKTAB) || (options == INITR_MINI160x80)) {
	MOVF        FARG_tft_initR_options+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L__tft_initR317
	MOVF        FARG_tft_initR_options+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L__tft_initR317
	GOTO        L_tft_initR25
L__tft_initR317:
;st7735.h,482 :: 		startWrite();
	CALL        _startWrite+0, 0
;st7735.h,483 :: 		writeCommand(ST77XX_MADCTL);
	MOVLW       54
	MOVWF       FARG_writeCommand_cmd+0 
	CALL        _writeCommand+0, 0
;st7735.h,484 :: 		ST7735_SPI_Write(0xC0);
	MOVLW       192
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,485 :: 		endWrite();
	CALL        _endWrite+0, 0
;st7735.h,486 :: 		}
L_tft_initR25:
;st7735.h,488 :: 		if(options == INITR_HALLOWING) {
	MOVF        FARG_tft_initR_options+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_tft_initR26
;st7735.h,490 :: 		tabcolor = INITR_144GREENTAB;
	MOVLW       1
	MOVWF       _tabcolor+0 
;st7735.h,491 :: 		setRotation(2);
	MOVLW       2
	MOVWF       FARG_setRotation_m+0 
	CALL        _setRotation+0, 0
;st7735.h,492 :: 		} else {
	GOTO        L_tft_initR27
L_tft_initR26:
;st7735.h,493 :: 		tabcolor = options;
	MOVF        FARG_tft_initR_options+0, 0 
	MOVWF       _tabcolor+0 
;st7735.h,494 :: 		setRotation(0);
	CLRF        FARG_setRotation_m+0 
	CALL        _setRotation+0, 0
;st7735.h,495 :: 		}
L_tft_initR27:
;st7735.h,496 :: 		}
L_end_tft_initR:
	RETURN      0
; end of _tft_initR

_drawPixel:

;st7735.h,498 :: 		void drawPixel(uint8_t x, uint8_t y, uint16_t color) {
;st7735.h,499 :: 		if((x < _width) && (y < _height)) {
	MOVF        __width+0, 0 
	SUBWF       FARG_drawPixel_x+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_drawPixel30
	MOVF        __height+0, 0 
	SUBWF       FARG_drawPixel_y+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_drawPixel30
L__drawPixel319:
;st7735.h,500 :: 		startWrite();
	CALL        _startWrite+0, 0
;st7735.h,501 :: 		setAddrWindow(x, y, 1, 1);
	MOVF        FARG_drawPixel_x+0, 0 
	MOVWF       FARG_setAddrWindow_x+0 
	MOVF        FARG_drawPixel_y+0, 0 
	MOVWF       FARG_setAddrWindow_y+0 
	MOVLW       1
	MOVWF       FARG_setAddrWindow_w+0 
	MOVLW       1
	MOVWF       FARG_setAddrWindow_h+0 
	CALL        _setAddrWindow+0, 0
;st7735.h,502 :: 		ST7735_SPI_Write(color >> 8);
	MOVF        FARG_drawPixel_color+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,503 :: 		ST7735_SPI_Write(color & 0xFF);
	MOVLW       255
	ANDWF       FARG_drawPixel_color+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,504 :: 		endWrite();
	CALL        _endWrite+0, 0
;st7735.h,505 :: 		}
L_drawPixel30:
;st7735.h,506 :: 		}
L_end_drawPixel:
	RETURN      0
; end of _drawPixel

_setAddrWindow:

;st7735.h,517 :: 		void setAddrWindow(uint8_t x, uint8_t y, uint8_t w, uint8_t h) {
;st7735.h,518 :: 		x += _xstart;
	MOVF        __xstart+0, 0 
	ADDWF       FARG_setAddrWindow_x+0, 1 
;st7735.h,519 :: 		y += _ystart;
	MOVF        __ystart+0, 0 
	ADDWF       FARG_setAddrWindow_y+0, 1 
;st7735.h,521 :: 		writeCommand(ST77XX_CASET); // Column addr set
	MOVLW       42
	MOVWF       FARG_writeCommand_cmd+0 
	CALL        _writeCommand+0, 0
;st7735.h,522 :: 		ST7735_SPI_Write(0);
	CLRF        FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,523 :: 		ST7735_SPI_Write(x);
	MOVF        FARG_setAddrWindow_x+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,524 :: 		ST7735_SPI_Write(0);
	CLRF        FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,525 :: 		ST7735_SPI_Write(x+w-1);
	MOVF        FARG_setAddrWindow_w+0, 0 
	ADDWF       FARG_setAddrWindow_x+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	DECF        FARG_SPI1_Write_data_+0, 1 
	CALL        _SPI1_Write+0, 0
;st7735.h,527 :: 		writeCommand(ST77XX_RASET); // Row addr set
	MOVLW       43
	MOVWF       FARG_writeCommand_cmd+0 
	CALL        _writeCommand+0, 0
;st7735.h,528 :: 		ST7735_SPI_Write(0);
	CLRF        FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,529 :: 		ST7735_SPI_Write(y);
	MOVF        FARG_setAddrWindow_y+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,530 :: 		ST7735_SPI_Write(0);
	CLRF        FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,531 :: 		ST7735_SPI_Write(y+h-1);
	MOVF        FARG_setAddrWindow_h+0, 0 
	ADDWF       FARG_setAddrWindow_y+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	DECF        FARG_SPI1_Write_data_+0, 1 
	CALL        _SPI1_Write+0, 0
;st7735.h,533 :: 		writeCommand(ST77XX_RAMWR); // write to RAM
	MOVLW       44
	MOVWF       FARG_writeCommand_cmd+0 
	CALL        _writeCommand+0, 0
;st7735.h,534 :: 		}
L_end_setAddrWindow:
	RETURN      0
; end of _setAddrWindow

_setRotation:

;st7735.h,542 :: 		void setRotation(uint8_t m) {
;st7735.h,543 :: 		uint8_t madctl = 0;
	CLRF        setRotation_madctl_L0+0 
;st7735.h,545 :: 		rotation = m & 3; // can't be higher than 3
	MOVLW       3
	ANDWF       FARG_setRotation_m+0, 0 
	MOVWF       _rotation+0 
;st7735.h,548 :: 		if((tabcolor == INITR_144GREENTAB) || (tabcolor == INITR_HALLOWING)) {
	MOVF        _tabcolor+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation324
	MOVF        _tabcolor+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation324
	GOTO        L_setRotation33
L__setRotation324:
;st7735.h,550 :: 		_rowstart = (rotation < 2) ? 3 : 1;
	MOVLW       2
	SUBWF       _rotation+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_setRotation34
	MOVLW       3
	MOVWF       ?FLOC___setRotationT52+0 
	GOTO        L_setRotation35
L_setRotation34:
	MOVLW       1
	MOVWF       ?FLOC___setRotationT52+0 
L_setRotation35:
	MOVF        ?FLOC___setRotationT52+0, 0 
	MOVWF       __rowstart+0 
;st7735.h,551 :: 		}
L_setRotation33:
;st7735.h,553 :: 		switch (rotation) {
	GOTO        L_setRotation36
;st7735.h,554 :: 		case 0:
L_setRotation38:
;st7735.h,555 :: 		if ((tabcolor == INITR_BLACKTAB) || (tabcolor == INITR_MINI160x80)) {
	MOVF        _tabcolor+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation323
	MOVF        _tabcolor+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation323
	GOTO        L_setRotation41
L__setRotation323:
;st7735.h,556 :: 		madctl = ST77XX_MADCTL_MX | ST77XX_MADCTL_MY | ST77XX_MADCTL_RGB;
	MOVLW       192
	MOVWF       setRotation_madctl_L0+0 
;st7735.h,557 :: 		} else {
	GOTO        L_setRotation42
L_setRotation41:
;st7735.h,558 :: 		madctl = ST77XX_MADCTL_MX | ST77XX_MADCTL_MY | ST7735_MADCTL_BGR;
	MOVLW       200
	MOVWF       setRotation_madctl_L0+0 
;st7735.h,559 :: 		}
L_setRotation42:
;st7735.h,561 :: 		if (tabcolor == INITR_144GREENTAB) {
	MOVF        _tabcolor+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_setRotation43
;st7735.h,562 :: 		_height = ST7735_TFTHEIGHT_128;
	MOVLW       128
	MOVWF       __height+0 
;st7735.h,563 :: 		_width  = ST7735_TFTWIDTH_128;
	MOVLW       128
	MOVWF       __width+0 
;st7735.h,564 :: 		} else if (tabcolor == INITR_MINI160x80)  {
	GOTO        L_setRotation44
L_setRotation43:
	MOVF        _tabcolor+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_setRotation45
;st7735.h,565 :: 		_height = ST7735_TFTHEIGHT_160;
	MOVLW       160
	MOVWF       __height+0 
;st7735.h,566 :: 		_width  = ST7735_TFTWIDTH_80;
	MOVLW       80
	MOVWF       __width+0 
;st7735.h,567 :: 		} else {
	GOTO        L_setRotation46
L_setRotation45:
;st7735.h,568 :: 		_height = ST7735_TFTHEIGHT_160;
	MOVLW       160
	MOVWF       __height+0 
;st7735.h,569 :: 		_width  = ST7735_TFTWIDTH_128;
	MOVLW       128
	MOVWF       __width+0 
;st7735.h,570 :: 		}
L_setRotation46:
L_setRotation44:
;st7735.h,571 :: 		_xstart   = _colstart;
	MOVF        __colstart+0, 0 
	MOVWF       __xstart+0 
;st7735.h,572 :: 		_ystart   = _rowstart;
	MOVF        __rowstart+0, 0 
	MOVWF       __ystart+0 
;st7735.h,573 :: 		break;
	GOTO        L_setRotation37
;st7735.h,574 :: 		case 1:
L_setRotation47:
;st7735.h,575 :: 		if ((tabcolor == INITR_BLACKTAB) || (tabcolor == INITR_MINI160x80)) {
	MOVF        _tabcolor+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation322
	MOVF        _tabcolor+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation322
	GOTO        L_setRotation50
L__setRotation322:
;st7735.h,576 :: 		madctl = ST77XX_MADCTL_MY | ST77XX_MADCTL_MV | ST77XX_MADCTL_RGB;
	MOVLW       160
	MOVWF       setRotation_madctl_L0+0 
;st7735.h,577 :: 		} else {
	GOTO        L_setRotation51
L_setRotation50:
;st7735.h,578 :: 		madctl = ST77XX_MADCTL_MY | ST77XX_MADCTL_MV | ST7735_MADCTL_BGR;
	MOVLW       168
	MOVWF       setRotation_madctl_L0+0 
;st7735.h,579 :: 		}
L_setRotation51:
;st7735.h,581 :: 		if (tabcolor == INITR_144GREENTAB)  {
	MOVF        _tabcolor+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_setRotation52
;st7735.h,582 :: 		_width  = ST7735_TFTHEIGHT_128;
	MOVLW       128
	MOVWF       __width+0 
;st7735.h,583 :: 		_height = ST7735_TFTWIDTH_128;
	MOVLW       128
	MOVWF       __height+0 
;st7735.h,584 :: 		} else if (tabcolor == INITR_MINI160x80)  {
	GOTO        L_setRotation53
L_setRotation52:
	MOVF        _tabcolor+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_setRotation54
;st7735.h,585 :: 		_width  = ST7735_TFTHEIGHT_160;
	MOVLW       160
	MOVWF       __width+0 
;st7735.h,586 :: 		_height = ST7735_TFTWIDTH_80;
	MOVLW       80
	MOVWF       __height+0 
;st7735.h,587 :: 		} else {
	GOTO        L_setRotation55
L_setRotation54:
;st7735.h,588 :: 		_width  = ST7735_TFTHEIGHT_160;
	MOVLW       160
	MOVWF       __width+0 
;st7735.h,589 :: 		_height = ST7735_TFTWIDTH_128;
	MOVLW       128
	MOVWF       __height+0 
;st7735.h,590 :: 		}
L_setRotation55:
L_setRotation53:
;st7735.h,591 :: 		_ystart   = _colstart;
	MOVF        __colstart+0, 0 
	MOVWF       __ystart+0 
;st7735.h,592 :: 		_xstart   = _rowstart;
	MOVF        __rowstart+0, 0 
	MOVWF       __xstart+0 
;st7735.h,593 :: 		break;
	GOTO        L_setRotation37
;st7735.h,594 :: 		case 2:
L_setRotation56:
;st7735.h,595 :: 		if ((tabcolor == INITR_BLACKTAB) || (tabcolor == INITR_MINI160x80)) {
	MOVF        _tabcolor+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation321
	MOVF        _tabcolor+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation321
	GOTO        L_setRotation59
L__setRotation321:
;st7735.h,596 :: 		madctl = ST77XX_MADCTL_RGB;
	CLRF        setRotation_madctl_L0+0 
;st7735.h,597 :: 		} else {
	GOTO        L_setRotation60
L_setRotation59:
;st7735.h,598 :: 		madctl = ST7735_MADCTL_BGR;
	MOVLW       8
	MOVWF       setRotation_madctl_L0+0 
;st7735.h,599 :: 		}
L_setRotation60:
;st7735.h,601 :: 		if (tabcolor == INITR_144GREENTAB) {
	MOVF        _tabcolor+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_setRotation61
;st7735.h,602 :: 		_height = ST7735_TFTHEIGHT_128;
	MOVLW       128
	MOVWF       __height+0 
;st7735.h,603 :: 		_width  = ST7735_TFTWIDTH_128;
	MOVLW       128
	MOVWF       __width+0 
;st7735.h,604 :: 		} else if (tabcolor == INITR_MINI160x80)  {
	GOTO        L_setRotation62
L_setRotation61:
	MOVF        _tabcolor+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_setRotation63
;st7735.h,605 :: 		_height = ST7735_TFTHEIGHT_160;
	MOVLW       160
	MOVWF       __height+0 
;st7735.h,606 :: 		_width  = ST7735_TFTWIDTH_80;
	MOVLW       80
	MOVWF       __width+0 
;st7735.h,607 :: 		} else {
	GOTO        L_setRotation64
L_setRotation63:
;st7735.h,608 :: 		_height = ST7735_TFTHEIGHT_160;
	MOVLW       160
	MOVWF       __height+0 
;st7735.h,609 :: 		_width  = ST7735_TFTWIDTH_128;
	MOVLW       128
	MOVWF       __width+0 
;st7735.h,610 :: 		}
L_setRotation64:
L_setRotation62:
;st7735.h,611 :: 		_xstart   = _colstart;
	MOVF        __colstart+0, 0 
	MOVWF       __xstart+0 
;st7735.h,612 :: 		_ystart   = _rowstart;
	MOVF        __rowstart+0, 0 
	MOVWF       __ystart+0 
;st7735.h,613 :: 		break;
	GOTO        L_setRotation37
;st7735.h,614 :: 		case 3:
L_setRotation65:
;st7735.h,615 :: 		if ((tabcolor == INITR_BLACKTAB) || (tabcolor == INITR_MINI160x80)) {
	MOVF        _tabcolor+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation320
	MOVF        _tabcolor+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L__setRotation320
	GOTO        L_setRotation68
L__setRotation320:
;st7735.h,616 :: 		madctl = ST77XX_MADCTL_MX | ST77XX_MADCTL_MV | ST77XX_MADCTL_RGB;
	MOVLW       96
	MOVWF       setRotation_madctl_L0+0 
;st7735.h,617 :: 		} else {
	GOTO        L_setRotation69
L_setRotation68:
;st7735.h,618 :: 		madctl = ST77XX_MADCTL_MX | ST77XX_MADCTL_MV | ST7735_MADCTL_BGR;
	MOVLW       104
	MOVWF       setRotation_madctl_L0+0 
;st7735.h,619 :: 		}
L_setRotation69:
;st7735.h,621 :: 		if (tabcolor == INITR_144GREENTAB)  {
	MOVF        _tabcolor+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_setRotation70
;st7735.h,622 :: 		_width  = ST7735_TFTHEIGHT_128;
	MOVLW       128
	MOVWF       __width+0 
;st7735.h,623 :: 		_height = ST7735_TFTWIDTH_128;
	MOVLW       128
	MOVWF       __height+0 
;st7735.h,624 :: 		} else if (tabcolor == INITR_MINI160x80)  {
	GOTO        L_setRotation71
L_setRotation70:
	MOVF        _tabcolor+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_setRotation72
;st7735.h,625 :: 		_width  = ST7735_TFTHEIGHT_160;
	MOVLW       160
	MOVWF       __width+0 
;st7735.h,626 :: 		_height = ST7735_TFTWIDTH_80;
	MOVLW       80
	MOVWF       __height+0 
;st7735.h,627 :: 		} else {
	GOTO        L_setRotation73
L_setRotation72:
;st7735.h,628 :: 		_width  = ST7735_TFTHEIGHT_160;
	MOVLW       160
	MOVWF       __width+0 
;st7735.h,629 :: 		_height = ST7735_TFTWIDTH_128;
	MOVLW       128
	MOVWF       __height+0 
;st7735.h,630 :: 		}
L_setRotation73:
L_setRotation71:
;st7735.h,631 :: 		_ystart   = _colstart;
	MOVF        __colstart+0, 0 
	MOVWF       __ystart+0 
;st7735.h,632 :: 		_xstart   = _rowstart;
	MOVF        __rowstart+0, 0 
	MOVWF       __xstart+0 
;st7735.h,633 :: 		break;
	GOTO        L_setRotation37
;st7735.h,634 :: 		}
L_setRotation36:
	MOVF        _rotation+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_setRotation38
	MOVF        _rotation+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_setRotation47
	MOVF        _rotation+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_setRotation56
	MOVF        _rotation+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_setRotation65
L_setRotation37:
;st7735.h,636 :: 		startWrite();
	CALL        _startWrite+0, 0
;st7735.h,637 :: 		writeCommand(ST77XX_MADCTL);
	MOVLW       54
	MOVWF       FARG_writeCommand_cmd+0 
	CALL        _writeCommand+0, 0
;st7735.h,638 :: 		ST7735_SPI_Write(madctl);
	MOVF        setRotation_madctl_L0+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,639 :: 		endWrite();
	CALL        _endWrite+0, 0
;st7735.h,640 :: 		}
L_end_setRotation:
	RETURN      0
; end of _setRotation

_drawHLine:

;st7735.h,651 :: 		void drawHLine(uint8_t x, uint8_t y, uint8_t w, uint16_t color) {
;st7735.h,652 :: 		if( (x < _width) && (y < _height) && w) {
	MOVF        __width+0, 0 
	SUBWF       FARG_drawHLine_x+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_drawHLine76
	MOVF        __height+0, 0 
	SUBWF       FARG_drawHLine_y+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_drawHLine76
	MOVF        FARG_drawHLine_w+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_drawHLine76
L__drawHLine325:
;st7735.h,653 :: 		uint8_t hi = color >> 8, lo = color;
	MOVF        FARG_drawHLine_color+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       drawHLine_hi_L1+0 
	MOVF        FARG_drawHLine_color+0, 0 
	MOVWF       drawHLine_lo_L1+0 
;st7735.h,655 :: 		if((x + w - 1) >= _width)
	MOVF        FARG_drawHLine_w+0, 0 
	ADDWF       FARG_drawHLine_x+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       R3 
	MOVLW       128
	XORWF       R3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__drawHLine350
	MOVF        __width+0, 0 
	SUBWF       R2, 0 
L__drawHLine350:
	BTFSS       STATUS+0, 0 
	GOTO        L_drawHLine77
;st7735.h,656 :: 		w = _width  - x;
	MOVF        FARG_drawHLine_x+0, 0 
	SUBWF       __width+0, 0 
	MOVWF       FARG_drawHLine_w+0 
L_drawHLine77:
;st7735.h,657 :: 		startWrite();
	CALL        _startWrite+0, 0
;st7735.h,658 :: 		setAddrWindow(x, y, w, 1);
	MOVF        FARG_drawHLine_x+0, 0 
	MOVWF       FARG_setAddrWindow_x+0 
	MOVF        FARG_drawHLine_y+0, 0 
	MOVWF       FARG_setAddrWindow_y+0 
	MOVF        FARG_drawHLine_w+0, 0 
	MOVWF       FARG_setAddrWindow_w+0 
	MOVLW       1
	MOVWF       FARG_setAddrWindow_h+0 
	CALL        _setAddrWindow+0, 0
;st7735.h,659 :: 		while (w--) {
L_drawHLine78:
	MOVF        FARG_drawHLine_w+0, 0 
	MOVWF       R0 
	DECF        FARG_drawHLine_w+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_drawHLine79
;st7735.h,660 :: 		ST7735_SPI_Write(hi);
	MOVF        drawHLine_hi_L1+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,661 :: 		ST7735_SPI_Write(lo);
	MOVF        drawHLine_lo_L1+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,662 :: 		}
	GOTO        L_drawHLine78
L_drawHLine79:
;st7735.h,663 :: 		endWrite();
	CALL        _endWrite+0, 0
;st7735.h,664 :: 		}
L_drawHLine76:
;st7735.h,665 :: 		}
L_end_drawHLine:
	RETURN      0
; end of _drawHLine

_drawVLine:

;st7735.h,676 :: 		void drawVLine(uint8_t x, uint8_t y, uint8_t h, uint16_t color) {
;st7735.h,677 :: 		if( (x < _width) && (y < _height) && h) {
	MOVF        __width+0, 0 
	SUBWF       FARG_drawVLine_x+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_drawVLine82
	MOVF        __height+0, 0 
	SUBWF       FARG_drawVLine_y+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_drawVLine82
	MOVF        FARG_drawVLine_h+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_drawVLine82
L__drawVLine326:
;st7735.h,678 :: 		uint8_t hi = color >> 8, lo = color;
	MOVF        FARG_drawVLine_color+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       drawVLine_hi_L1+0 
	MOVF        FARG_drawVLine_color+0, 0 
	MOVWF       drawVLine_lo_L1+0 
;st7735.h,679 :: 		if((y + h - 1) >= _height)
	MOVF        FARG_drawVLine_h+0, 0 
	ADDWF       FARG_drawVLine_y+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       R3 
	MOVLW       128
	XORWF       R3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__drawVLine352
	MOVF        __height+0, 0 
	SUBWF       R2, 0 
L__drawVLine352:
	BTFSS       STATUS+0, 0 
	GOTO        L_drawVLine83
;st7735.h,680 :: 		h = _height - y;
	MOVF        FARG_drawVLine_y+0, 0 
	SUBWF       __height+0, 0 
	MOVWF       FARG_drawVLine_h+0 
L_drawVLine83:
;st7735.h,681 :: 		startWrite();
	CALL        _startWrite+0, 0
;st7735.h,682 :: 		setAddrWindow(x, y, 1, h);
	MOVF        FARG_drawVLine_x+0, 0 
	MOVWF       FARG_setAddrWindow_x+0 
	MOVF        FARG_drawVLine_y+0, 0 
	MOVWF       FARG_setAddrWindow_y+0 
	MOVLW       1
	MOVWF       FARG_setAddrWindow_w+0 
	MOVF        FARG_drawVLine_h+0, 0 
	MOVWF       FARG_setAddrWindow_h+0 
	CALL        _setAddrWindow+0, 0
;st7735.h,683 :: 		while (h--) {
L_drawVLine84:
	MOVF        FARG_drawVLine_h+0, 0 
	MOVWF       R0 
	DECF        FARG_drawVLine_h+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_drawVLine85
;st7735.h,684 :: 		ST7735_SPI_Write(hi);
	MOVF        drawVLine_hi_L1+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,685 :: 		ST7735_SPI_Write(lo);
	MOVF        drawVLine_lo_L1+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,686 :: 		}
	GOTO        L_drawVLine84
L_drawVLine85:
;st7735.h,687 :: 		endWrite();
	CALL        _endWrite+0, 0
;st7735.h,688 :: 		}
L_drawVLine82:
;st7735.h,689 :: 		}
L_end_drawVLine:
	RETURN      0
; end of _drawVLine

_fillRect:

;st7735.h,701 :: 		void fillRect(uint8_t x, uint8_t y, uint8_t w, uint8_t h, uint16_t color) {
;st7735.h,703 :: 		if(w && h) {                            // Nonzero width and height?
	MOVF        FARG_fillRect_w+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_fillRect88
	MOVF        FARG_fillRect_h+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_fillRect88
L__fillRect328:
;st7735.h,704 :: 		uint8_t hi = color >> 8, lo = color;
	MOVF        FARG_fillRect_color+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       fillRect_hi_L1+0 
	MOVF        FARG_fillRect_color+0, 0 
	MOVWF       fillRect_lo_L1+0 
;st7735.h,705 :: 		if((x >= _width) || (y >= _height))
	MOVF        __width+0, 0 
	SUBWF       FARG_fillRect_x+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L__fillRect327
	MOVF        __height+0, 0 
	SUBWF       FARG_fillRect_y+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L__fillRect327
	GOTO        L_fillRect91
L__fillRect327:
;st7735.h,706 :: 		return;
	GOTO        L_end_fillRect
L_fillRect91:
;st7735.h,707 :: 		if((x + w - 1) >= _width)
	MOVF        FARG_fillRect_w+0, 0 
	ADDWF       FARG_fillRect_x+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       R3 
	MOVLW       128
	XORWF       R3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__fillRect354
	MOVF        __width+0, 0 
	SUBWF       R2, 0 
L__fillRect354:
	BTFSS       STATUS+0, 0 
	GOTO        L_fillRect92
;st7735.h,708 :: 		w = _width  - x;
	MOVF        FARG_fillRect_x+0, 0 
	SUBWF       __width+0, 0 
	MOVWF       FARG_fillRect_w+0 
L_fillRect92:
;st7735.h,709 :: 		if((y + h - 1) >= _height)
	MOVF        FARG_fillRect_h+0, 0 
	ADDWF       FARG_fillRect_y+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       1
	SUBWF       R0, 0 
	MOVWF       R2 
	MOVLW       0
	SUBWFB      R1, 0 
	MOVWF       R3 
	MOVLW       128
	XORWF       R3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__fillRect355
	MOVF        __height+0, 0 
	SUBWF       R2, 0 
L__fillRect355:
	BTFSS       STATUS+0, 0 
	GOTO        L_fillRect93
;st7735.h,710 :: 		h = _height - y;
	MOVF        FARG_fillRect_y+0, 0 
	SUBWF       __height+0, 0 
	MOVWF       FARG_fillRect_h+0 
L_fillRect93:
;st7735.h,711 :: 		startWrite();
	CALL        _startWrite+0, 0
;st7735.h,712 :: 		setAddrWindow(x, y, w, h);
	MOVF        FARG_fillRect_x+0, 0 
	MOVWF       FARG_setAddrWindow_x+0 
	MOVF        FARG_fillRect_y+0, 0 
	MOVWF       FARG_setAddrWindow_y+0 
	MOVF        FARG_fillRect_w+0, 0 
	MOVWF       FARG_setAddrWindow_w+0 
	MOVF        FARG_fillRect_h+0, 0 
	MOVWF       FARG_setAddrWindow_h+0 
	CALL        _setAddrWindow+0, 0
;st7735.h,713 :: 		px = (uint16_t)w * h;
	MOVF        FARG_fillRect_w+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_fillRect_h+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       fillRect_px_L0+0 
	MOVF        R1, 0 
	MOVWF       fillRect_px_L0+1 
;st7735.h,714 :: 		while (px--) {
L_fillRect94:
	MOVF        fillRect_px_L0+0, 0 
	MOVWF       R0 
	MOVF        fillRect_px_L0+1, 0 
	MOVWF       R1 
	MOVLW       1
	SUBWF       fillRect_px_L0+0, 1 
	MOVLW       0
	SUBWFB      fillRect_px_L0+1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_fillRect95
;st7735.h,715 :: 		ST7735_SPI_Write(hi);
	MOVF        fillRect_hi_L1+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,716 :: 		ST7735_SPI_Write(lo);
	MOVF        fillRect_lo_L1+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,717 :: 		}
	GOTO        L_fillRect94
L_fillRect95:
;st7735.h,718 :: 		endWrite();
	CALL        _endWrite+0, 0
;st7735.h,719 :: 		}
L_fillRect88:
;st7735.h,720 :: 		}
L_end_fillRect:
	RETURN      0
; end of _fillRect

_fillScreen:

;st7735.h,728 :: 		void fillScreen(uint16_t color) {
;st7735.h,729 :: 		fillRect(0, 0, _width, _height, color);
	CLRF        FARG_fillRect_x+0 
	CLRF        FARG_fillRect_y+0 
	MOVF        __width+0, 0 
	MOVWF       FARG_fillRect_w+0 
	MOVF        __height+0, 0 
	MOVWF       FARG_fillRect_h+0 
	MOVF        FARG_fillScreen_color+0, 0 
	MOVWF       FARG_fillRect_color+0 
	MOVF        FARG_fillScreen_color+1, 0 
	MOVWF       FARG_fillRect_color+1 
	CALL        _fillRect+0, 0
;st7735.h,730 :: 		}
L_end_fillScreen:
	RETURN      0
; end of _fillScreen

_invertDisplay:

;st7735.h,739 :: 		void invertDisplay(bool i) {
;st7735.h,740 :: 		startWrite();
	CALL        _startWrite+0, 0
;st7735.h,741 :: 		writeCommand(i ? ST77XX_INVON : ST77XX_INVOFF);
	MOVF        FARG_invertDisplay_i+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_invertDisplay96
	MOVLW       33
	MOVWF       ?FLOC___invertDisplayT114+0 
	GOTO        L_invertDisplay97
L_invertDisplay96:
	MOVLW       32
	MOVWF       ?FLOC___invertDisplayT114+0 
L_invertDisplay97:
	MOVF        ?FLOC___invertDisplayT114+0, 0 
	MOVWF       FARG_writeCommand_cmd+0 
	CALL        _writeCommand+0, 0
;st7735.h,742 :: 		endWrite();
	CALL        _endWrite+0, 0
;st7735.h,743 :: 		}
L_end_invertDisplay:
	RETURN      0
; end of _invertDisplay

_pushColor:

;st7735.h,752 :: 		void pushColor(uint16_t color) {
;st7735.h,753 :: 		uint8_t hi = color >> 8, lo = color;
	MOVF        FARG_pushColor_color+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVF        R0, 0 
	MOVWF       pushColor_hi_L0+0 
	MOVF        FARG_pushColor_color+0, 0 
	MOVWF       pushColor_lo_L0+0 
;st7735.h,754 :: 		startWrite();
	CALL        _startWrite+0, 0
;st7735.h,755 :: 		ST7735_SPI_Write(hi);
	MOVF        pushColor_hi_L0+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,756 :: 		ST7735_SPI_Write(lo);
	MOVF        pushColor_lo_L0+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;st7735.h,757 :: 		endWrite();
	CALL        _endWrite+0, 0
;st7735.h,758 :: 		}
L_end_pushColor:
	RETURN      0
; end of _pushColor

_writeLine:

;gfx_library.h,395 :: 		void writeLine(uint16_t x0, uint16_t y0, uint16_t x1, uint16_t y1, uint16_t color) {
;gfx_library.h,396 :: 		bool steep = abs((int16_t)(y1 - y0)) > abs((int16_t)(x1 - x0));
	MOVF        FARG_writeLine_y0+0, 0 
	SUBWF       FARG_writeLine_y1+0, 0 
	MOVWF       FARG_abs_a+0 
	MOVF        FARG_writeLine_y0+1, 0 
	SUBWFB      FARG_writeLine_y1+1, 0 
	MOVWF       FARG_abs_a+1 
	CALL        _abs+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__writeLine+0 
	MOVF        R1, 0 
	MOVWF       FLOC__writeLine+1 
	MOVF        FARG_writeLine_x0+0, 0 
	SUBWF       FARG_writeLine_x1+0, 0 
	MOVWF       FARG_abs_a+0 
	MOVF        FARG_writeLine_x0+1, 0 
	SUBWFB      FARG_writeLine_x1+1, 0 
	MOVWF       FARG_abs_a+1 
	CALL        _abs+0, 0
	MOVLW       128
	XORWF       R1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       FLOC__writeLine+1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeLine360
	MOVF        FLOC__writeLine+0, 0 
	SUBWF       R0, 0 
L__writeLine360:
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       writeLine_steep_L0+0 
;gfx_library.h,398 :: 		if (steep) {
	MOVF        R2, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_writeLine98
;gfx_library.h,399 :: 		_swap_int16_t(x0, y0);
	MOVF        FARG_writeLine_x0+0, 0 
	MOVWF       writeLine_t_L2+0 
	MOVF        FARG_writeLine_x0+1, 0 
	MOVWF       writeLine_t_L2+1 
	MOVF        FARG_writeLine_y0+0, 0 
	MOVWF       FARG_writeLine_x0+0 
	MOVF        FARG_writeLine_y0+1, 0 
	MOVWF       FARG_writeLine_x0+1 
	MOVF        writeLine_t_L2+0, 0 
	MOVWF       FARG_writeLine_y0+0 
	MOVF        writeLine_t_L2+1, 0 
	MOVWF       FARG_writeLine_y0+1 
;gfx_library.h,400 :: 		_swap_int16_t(x1, y1);
	MOVF        FARG_writeLine_x1+0, 0 
	MOVWF       writeLine_t_L2_L2+0 
	MOVF        FARG_writeLine_x1+1, 0 
	MOVWF       writeLine_t_L2_L2+1 
	MOVF        FARG_writeLine_y1+0, 0 
	MOVWF       FARG_writeLine_x1+0 
	MOVF        FARG_writeLine_y1+1, 0 
	MOVWF       FARG_writeLine_x1+1 
	MOVF        writeLine_t_L2_L2+0, 0 
	MOVWF       FARG_writeLine_y1+0 
	MOVF        writeLine_t_L2_L2+1, 0 
	MOVWF       FARG_writeLine_y1+1 
;gfx_library.h,401 :: 		}
L_writeLine98:
;gfx_library.h,403 :: 		if (x0 > x1) {
	MOVF        FARG_writeLine_x0+1, 0 
	SUBWF       FARG_writeLine_x1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeLine361
	MOVF        FARG_writeLine_x0+0, 0 
	SUBWF       FARG_writeLine_x1+0, 0 
L__writeLine361:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeLine99
;gfx_library.h,404 :: 		_swap_int16_t(x0, x1);
	MOVF        FARG_writeLine_x0+0, 0 
	MOVWF       writeLine_t_L2_L2_L2+0 
	MOVF        FARG_writeLine_x0+1, 0 
	MOVWF       writeLine_t_L2_L2_L2+1 
	MOVF        FARG_writeLine_x1+0, 0 
	MOVWF       FARG_writeLine_x0+0 
	MOVF        FARG_writeLine_x1+1, 0 
	MOVWF       FARG_writeLine_x0+1 
	MOVF        writeLine_t_L2_L2_L2+0, 0 
	MOVWF       FARG_writeLine_x1+0 
	MOVF        writeLine_t_L2_L2_L2+1, 0 
	MOVWF       FARG_writeLine_x1+1 
;gfx_library.h,405 :: 		_swap_int16_t(y0, y1);
	MOVF        FARG_writeLine_y0+0, 0 
	MOVWF       writeLine_t_L2_L2_L2_L2+0 
	MOVF        FARG_writeLine_y0+1, 0 
	MOVWF       writeLine_t_L2_L2_L2_L2+1 
	MOVF        FARG_writeLine_y1+0, 0 
	MOVWF       FARG_writeLine_y0+0 
	MOVF        FARG_writeLine_y1+1, 0 
	MOVWF       FARG_writeLine_y0+1 
	MOVF        writeLine_t_L2_L2_L2_L2+0, 0 
	MOVWF       FARG_writeLine_y1+0 
	MOVF        writeLine_t_L2_L2_L2_L2+1, 0 
	MOVWF       FARG_writeLine_y1+1 
;gfx_library.h,406 :: 		}
L_writeLine99:
;gfx_library.h,408 :: 		dx = x1 - x0;
	MOVF        FARG_writeLine_x0+0, 0 
	SUBWF       FARG_writeLine_x1+0, 0 
	MOVWF       writeLine_dx_L0+0 
	MOVF        FARG_writeLine_x0+1, 0 
	SUBWFB      FARG_writeLine_x1+1, 0 
	MOVWF       writeLine_dx_L0+1 
;gfx_library.h,409 :: 		dy = abs((int16_t)(y1 - y0));
	MOVF        FARG_writeLine_y0+0, 0 
	SUBWF       FARG_writeLine_y1+0, 0 
	MOVWF       FARG_abs_a+0 
	MOVF        FARG_writeLine_y0+1, 0 
	SUBWFB      FARG_writeLine_y1+1, 0 
	MOVWF       FARG_abs_a+1 
	CALL        _abs+0, 0
	MOVF        R0, 0 
	MOVWF       writeLine_dy_L0+0 
	MOVF        R1, 0 
	MOVWF       writeLine_dy_L0+1 
;gfx_library.h,411 :: 		err = dx / 2;
	MOVF        writeLine_dx_L0+0, 0 
	MOVWF       writeLine_err_L0+0 
	MOVF        writeLine_dx_L0+1, 0 
	MOVWF       writeLine_err_L0+1 
	RRCF        writeLine_err_L0+1, 1 
	RRCF        writeLine_err_L0+0, 1 
	BCF         writeLine_err_L0+1, 7 
	BTFSC       writeLine_err_L0+1, 6 
	BSF         writeLine_err_L0+1, 7 
	BTFSS       writeLine_err_L0+1, 7 
	GOTO        L__writeLine362
	BTFSS       STATUS+0, 0 
	GOTO        L__writeLine362
	INFSNZ      writeLine_err_L0+0, 1 
	INCF        writeLine_err_L0+1, 1 
L__writeLine362:
;gfx_library.h,414 :: 		if (y0 < y1) {
	MOVF        FARG_writeLine_y1+1, 0 
	SUBWF       FARG_writeLine_y0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeLine363
	MOVF        FARG_writeLine_y1+0, 0 
	SUBWF       FARG_writeLine_y0+0, 0 
L__writeLine363:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeLine100
;gfx_library.h,415 :: 		ystep = 1;
	MOVLW       1
	MOVWF       writeLine_ystep_L0+0 
	MOVLW       0
	MOVWF       writeLine_ystep_L0+1 
;gfx_library.h,416 :: 		} else {
	GOTO        L_writeLine101
L_writeLine100:
;gfx_library.h,417 :: 		ystep = -1;
	MOVLW       255
	MOVWF       writeLine_ystep_L0+0 
	MOVLW       255
	MOVWF       writeLine_ystep_L0+1 
;gfx_library.h,418 :: 		}
L_writeLine101:
;gfx_library.h,420 :: 		for (; x0<=x1; x0++) {
L_writeLine102:
	MOVF        FARG_writeLine_x0+1, 0 
	SUBWF       FARG_writeLine_x1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeLine364
	MOVF        FARG_writeLine_x0+0, 0 
	SUBWF       FARG_writeLine_x1+0, 0 
L__writeLine364:
	BTFSS       STATUS+0, 0 
	GOTO        L_writeLine103
;gfx_library.h,421 :: 		if (steep) {
	MOVF        writeLine_steep_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_writeLine105
;gfx_library.h,422 :: 		display_drawPixel(y0, x0, color);
	MOVF        FARG_writeLine_y0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        FARG_writeLine_x0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_writeLine_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_writeLine_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,423 :: 		} else {
	GOTO        L_writeLine106
L_writeLine105:
;gfx_library.h,424 :: 		display_drawPixel(x0, y0, color);
	MOVF        FARG_writeLine_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        FARG_writeLine_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_writeLine_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_writeLine_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,425 :: 		}
L_writeLine106:
;gfx_library.h,426 :: 		err -= dy;
	MOVF        writeLine_dy_L0+0, 0 
	SUBWF       writeLine_err_L0+0, 0 
	MOVWF       R1 
	MOVF        writeLine_dy_L0+1, 0 
	SUBWFB      writeLine_err_L0+1, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       writeLine_err_L0+0 
	MOVF        R2, 0 
	MOVWF       writeLine_err_L0+1 
;gfx_library.h,427 :: 		if (err < 0) {
	MOVLW       128
	XORWF       R2, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__writeLine365
	MOVLW       0
	SUBWF       R1, 0 
L__writeLine365:
	BTFSC       STATUS+0, 0 
	GOTO        L_writeLine107
;gfx_library.h,428 :: 		y0 += ystep;
	MOVF        writeLine_ystep_L0+0, 0 
	ADDWF       FARG_writeLine_y0+0, 1 
	MOVF        writeLine_ystep_L0+1, 0 
	ADDWFC      FARG_writeLine_y0+1, 1 
;gfx_library.h,429 :: 		err += dx;
	MOVF        writeLine_dx_L0+0, 0 
	ADDWF       writeLine_err_L0+0, 1 
	MOVF        writeLine_dx_L0+1, 0 
	ADDWFC      writeLine_err_L0+1, 1 
;gfx_library.h,430 :: 		}
L_writeLine107:
;gfx_library.h,420 :: 		for (; x0<=x1; x0++) {
	INFSNZ      FARG_writeLine_x0+0, 1 
	INCF        FARG_writeLine_x0+1, 1 
;gfx_library.h,431 :: 		}
	GOTO        L_writeLine102
L_writeLine103:
;gfx_library.h,432 :: 		}
L_end_writeLine:
	RETURN      0
; end of _writeLine

_display_drawLine:

;gfx_library.h,444 :: 		void display_drawLine(uint16_t x0, uint16_t y0, uint16_t x1, uint16_t y1, uint16_t color) {
;gfx_library.h,446 :: 		if(x0 == x1){
	MOVF        FARG_display_drawLine_x0+1, 0 
	XORWF       FARG_display_drawLine_x1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawLine367
	MOVF        FARG_display_drawLine_x1+0, 0 
	XORWF       FARG_display_drawLine_x0+0, 0 
L__display_drawLine367:
	BTFSS       STATUS+0, 2 
	GOTO        L_display_drawLine108
;gfx_library.h,447 :: 		if(y0 > y1) _swap_int16_t(y0, y1);
	MOVF        FARG_display_drawLine_y0+1, 0 
	SUBWF       FARG_display_drawLine_y1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawLine368
	MOVF        FARG_display_drawLine_y0+0, 0 
	SUBWF       FARG_display_drawLine_y1+0, 0 
L__display_drawLine368:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawLine109
	MOVF        FARG_display_drawLine_y0+0, 0 
	MOVWF       display_drawLine_t_L2+0 
	MOVF        FARG_display_drawLine_y0+1, 0 
	MOVWF       display_drawLine_t_L2+1 
	MOVF        FARG_display_drawLine_y1+0, 0 
	MOVWF       FARG_display_drawLine_y0+0 
	MOVF        FARG_display_drawLine_y1+1, 0 
	MOVWF       FARG_display_drawLine_y0+1 
	MOVF        display_drawLine_t_L2+0, 0 
	MOVWF       FARG_display_drawLine_y1+0 
	MOVF        display_drawLine_t_L2+1, 0 
	MOVWF       FARG_display_drawLine_y1+1 
L_display_drawLine109:
;gfx_library.h,448 :: 		display_drawVLine(x0, y0, y1 - y0 + 1, color);
	MOVF        FARG_display_drawLine_x0+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        FARG_display_drawLine_y0+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        FARG_display_drawLine_y0+0, 0 
	SUBWF       FARG_display_drawLine_y1+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	INCF        FARG_drawVLine_h+0, 1 
	MOVF        FARG_display_drawLine_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_drawLine_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
;gfx_library.h,449 :: 		} else if(y0 == y1){
	GOTO        L_display_drawLine110
L_display_drawLine108:
	MOVF        FARG_display_drawLine_y0+1, 0 
	XORWF       FARG_display_drawLine_y1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawLine369
	MOVF        FARG_display_drawLine_y1+0, 0 
	XORWF       FARG_display_drawLine_y0+0, 0 
L__display_drawLine369:
	BTFSS       STATUS+0, 2 
	GOTO        L_display_drawLine111
;gfx_library.h,450 :: 		if(x0 > x1) _swap_int16_t(x0, x1);
	MOVF        FARG_display_drawLine_x0+1, 0 
	SUBWF       FARG_display_drawLine_x1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawLine370
	MOVF        FARG_display_drawLine_x0+0, 0 
	SUBWF       FARG_display_drawLine_x1+0, 0 
L__display_drawLine370:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawLine112
	MOVF        FARG_display_drawLine_x0+0, 0 
	MOVWF       display_drawLine_t_L2_L2+0 
	MOVF        FARG_display_drawLine_x0+1, 0 
	MOVWF       display_drawLine_t_L2_L2+1 
	MOVF        FARG_display_drawLine_x1+0, 0 
	MOVWF       FARG_display_drawLine_x0+0 
	MOVF        FARG_display_drawLine_x1+1, 0 
	MOVWF       FARG_display_drawLine_x0+1 
	MOVF        display_drawLine_t_L2_L2+0, 0 
	MOVWF       FARG_display_drawLine_x1+0 
	MOVF        display_drawLine_t_L2_L2+1, 0 
	MOVWF       FARG_display_drawLine_x1+1 
L_display_drawLine112:
;gfx_library.h,451 :: 		display_drawHLine(x0, y0, x1 - x0 + 1, color);
	MOVF        FARG_display_drawLine_x0+0, 0 
	MOVWF       FARG_drawHLine_x+0 
	MOVF        FARG_display_drawLine_y0+0, 0 
	MOVWF       FARG_drawHLine_y+0 
	MOVF        FARG_display_drawLine_x0+0, 0 
	SUBWF       FARG_display_drawLine_x1+0, 0 
	MOVWF       FARG_drawHLine_w+0 
	INCF        FARG_drawHLine_w+0, 1 
	MOVF        FARG_display_drawLine_color+0, 0 
	MOVWF       FARG_drawHLine_color+0 
	MOVF        FARG_display_drawLine_color+1, 0 
	MOVWF       FARG_drawHLine_color+1 
	CALL        _drawHLine+0, 0
;gfx_library.h,452 :: 		} else {
	GOTO        L_display_drawLine113
L_display_drawLine111:
;gfx_library.h,453 :: 		writeLine(x0, y0, x1, y1, color);
	MOVF        FARG_display_drawLine_x0+0, 0 
	MOVWF       FARG_writeLine_x0+0 
	MOVF        FARG_display_drawLine_x0+1, 0 
	MOVWF       FARG_writeLine_x0+1 
	MOVF        FARG_display_drawLine_y0+0, 0 
	MOVWF       FARG_writeLine_y0+0 
	MOVF        FARG_display_drawLine_y0+1, 0 
	MOVWF       FARG_writeLine_y0+1 
	MOVF        FARG_display_drawLine_x1+0, 0 
	MOVWF       FARG_writeLine_x1+0 
	MOVF        FARG_display_drawLine_x1+1, 0 
	MOVWF       FARG_writeLine_x1+1 
	MOVF        FARG_display_drawLine_y1+0, 0 
	MOVWF       FARG_writeLine_y1+0 
	MOVF        FARG_display_drawLine_y1+1, 0 
	MOVWF       FARG_writeLine_y1+1 
	MOVF        FARG_display_drawLine_color+0, 0 
	MOVWF       FARG_writeLine_color+0 
	MOVF        FARG_display_drawLine_color+1, 0 
	MOVWF       FARG_writeLine_color+1 
	CALL        _writeLine+0, 0
;gfx_library.h,454 :: 		}
L_display_drawLine113:
L_display_drawLine110:
;gfx_library.h,455 :: 		}
L_end_display_drawLine:
	RETURN      0
; end of _display_drawLine

_display_drawCircle:

;gfx_library.h,466 :: 		void display_drawCircle(uint16_t x0, uint16_t y0, uint16_t r, uint16_t color) {
;gfx_library.h,467 :: 		int16_t f = 1 - r;
	MOVF        FARG_display_drawCircle_r+0, 0 
	SUBLW       1
	MOVWF       display_drawCircle_f_L0+0 
	MOVF        FARG_display_drawCircle_r+1, 0 
	MOVWF       display_drawCircle_f_L0+1 
	MOVLW       0
	SUBFWB      display_drawCircle_f_L0+1, 1 
;gfx_library.h,468 :: 		int16_t ddF_x = 1;
	MOVLW       1
	MOVWF       display_drawCircle_ddF_x_L0+0 
	MOVLW       0
	MOVWF       display_drawCircle_ddF_x_L0+1 
;gfx_library.h,469 :: 		int16_t ddF_y = -2 * r;
	MOVLW       254
	MOVWF       R0 
	MOVLW       255
	MOVWF       R1 
	MOVF        FARG_display_drawCircle_r+0, 0 
	MOVWF       R4 
	MOVF        FARG_display_drawCircle_r+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       display_drawCircle_ddF_y_L0+0 
	MOVF        R1, 0 
	MOVWF       display_drawCircle_ddF_y_L0+1 
;gfx_library.h,470 :: 		int16_t x = 0;
	CLRF        display_drawCircle_x_L0+0 
	CLRF        display_drawCircle_x_L0+1 
;gfx_library.h,471 :: 		int16_t y = r;
	MOVF        FARG_display_drawCircle_r+0, 0 
	MOVWF       display_drawCircle_y_L0+0 
	MOVF        FARG_display_drawCircle_r+1, 0 
	MOVWF       display_drawCircle_y_L0+1 
;gfx_library.h,473 :: 		display_drawPixel(x0  , y0+r, color);
	MOVF        FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        FARG_display_drawCircle_r+0, 0 
	ADDWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,474 :: 		display_drawPixel(x0  , y0-r, color);
	MOVF        FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        FARG_display_drawCircle_r+0, 0 
	SUBWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,475 :: 		display_drawPixel(x0+r, y0  , color);
	MOVF        FARG_display_drawCircle_r+0, 0 
	ADDWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,476 :: 		display_drawPixel(x0-r, y0  , color);
	MOVF        FARG_display_drawCircle_r+0, 0 
	SUBWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,478 :: 		while (x<y) {
L_display_drawCircle114:
	MOVLW       128
	XORWF       display_drawCircle_x_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       display_drawCircle_y_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawCircle372
	MOVF        display_drawCircle_y_L0+0, 0 
	SUBWF       display_drawCircle_x_L0+0, 0 
L__display_drawCircle372:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawCircle115
;gfx_library.h,479 :: 		if (f >= 0) {
	MOVLW       128
	XORWF       display_drawCircle_f_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawCircle373
	MOVLW       0
	SUBWF       display_drawCircle_f_L0+0, 0 
L__display_drawCircle373:
	BTFSS       STATUS+0, 0 
	GOTO        L_display_drawCircle116
;gfx_library.h,480 :: 		y--;
	MOVLW       1
	SUBWF       display_drawCircle_y_L0+0, 1 
	MOVLW       0
	SUBWFB      display_drawCircle_y_L0+1, 1 
;gfx_library.h,481 :: 		ddF_y += 2;
	MOVLW       2
	ADDWF       display_drawCircle_ddF_y_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      display_drawCircle_ddF_y_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       display_drawCircle_ddF_y_L0+0 
	MOVF        R1, 0 
	MOVWF       display_drawCircle_ddF_y_L0+1 
;gfx_library.h,482 :: 		f += ddF_y;
	MOVF        R0, 0 
	ADDWF       display_drawCircle_f_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      display_drawCircle_f_L0+1, 1 
;gfx_library.h,483 :: 		}
L_display_drawCircle116:
;gfx_library.h,484 :: 		x++;
	INFSNZ      display_drawCircle_x_L0+0, 1 
	INCF        display_drawCircle_x_L0+1, 1 
;gfx_library.h,485 :: 		ddF_x += 2;
	MOVLW       2
	ADDWF       display_drawCircle_ddF_x_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      display_drawCircle_ddF_x_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       display_drawCircle_ddF_x_L0+0 
	MOVF        R1, 0 
	MOVWF       display_drawCircle_ddF_x_L0+1 
;gfx_library.h,486 :: 		f += ddF_x;
	MOVF        R0, 0 
	ADDWF       display_drawCircle_f_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      display_drawCircle_f_L0+1, 1 
;gfx_library.h,488 :: 		display_drawPixel(x0 + x, y0 + y, color);
	MOVF        display_drawCircle_x_L0+0, 0 
	ADDWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircle_y_L0+0, 0 
	ADDWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,489 :: 		display_drawPixel(x0 - x, y0 + y, color);
	MOVF        display_drawCircle_x_L0+0, 0 
	SUBWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircle_y_L0+0, 0 
	ADDWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,490 :: 		display_drawPixel(x0 + x, y0 - y, color);
	MOVF        display_drawCircle_x_L0+0, 0 
	ADDWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircle_y_L0+0, 0 
	SUBWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,491 :: 		display_drawPixel(x0 - x, y0 - y, color);
	MOVF        display_drawCircle_x_L0+0, 0 
	SUBWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircle_y_L0+0, 0 
	SUBWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,492 :: 		display_drawPixel(x0 + y, y0 + x, color);
	MOVF        display_drawCircle_y_L0+0, 0 
	ADDWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircle_x_L0+0, 0 
	ADDWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,493 :: 		display_drawPixel(x0 - y, y0 + x, color);
	MOVF        display_drawCircle_y_L0+0, 0 
	SUBWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircle_x_L0+0, 0 
	ADDWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,494 :: 		display_drawPixel(x0 + y, y0 - x, color);
	MOVF        display_drawCircle_y_L0+0, 0 
	ADDWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircle_x_L0+0, 0 
	SUBWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,495 :: 		display_drawPixel(x0 - y, y0 - x, color);
	MOVF        display_drawCircle_y_L0+0, 0 
	SUBWF       FARG_display_drawCircle_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircle_x_L0+0, 0 
	SUBWF       FARG_display_drawCircle_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircle_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircle_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,496 :: 		}
	GOTO        L_display_drawCircle114
L_display_drawCircle115:
;gfx_library.h,497 :: 		}
L_end_display_drawCircle:
	RETURN      0
; end of _display_drawCircle

_display_drawCircleHelper:

;gfx_library.h,509 :: 		void display_drawCircleHelper(uint16_t x0, uint16_t y0, uint16_t r, uint8_t cornername, uint16_t color) {
;gfx_library.h,510 :: 		int16_t f     = 1 - r;
	MOVF        FARG_display_drawCircleHelper_r+0, 0 
	SUBLW       1
	MOVWF       display_drawCircleHelper_f_L0+0 
	MOVF        FARG_display_drawCircleHelper_r+1, 0 
	MOVWF       display_drawCircleHelper_f_L0+1 
	MOVLW       0
	SUBFWB      display_drawCircleHelper_f_L0+1, 1 
;gfx_library.h,511 :: 		int16_t ddF_x = 1;
	MOVLW       1
	MOVWF       display_drawCircleHelper_ddF_x_L0+0 
	MOVLW       0
	MOVWF       display_drawCircleHelper_ddF_x_L0+1 
;gfx_library.h,512 :: 		int16_t ddF_y = -2 * r;
	MOVLW       254
	MOVWF       R0 
	MOVLW       255
	MOVWF       R1 
	MOVF        FARG_display_drawCircleHelper_r+0, 0 
	MOVWF       R4 
	MOVF        FARG_display_drawCircleHelper_r+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       display_drawCircleHelper_ddF_y_L0+0 
	MOVF        R1, 0 
	MOVWF       display_drawCircleHelper_ddF_y_L0+1 
;gfx_library.h,513 :: 		int16_t x     = 0;
	CLRF        display_drawCircleHelper_x_L0+0 
	CLRF        display_drawCircleHelper_x_L0+1 
;gfx_library.h,514 :: 		int16_t y     = r;
	MOVF        FARG_display_drawCircleHelper_r+0, 0 
	MOVWF       display_drawCircleHelper_y_L0+0 
	MOVF        FARG_display_drawCircleHelper_r+1, 0 
	MOVWF       display_drawCircleHelper_y_L0+1 
;gfx_library.h,516 :: 		while (x<y) {
L_display_drawCircleHelper117:
	MOVLW       128
	XORWF       display_drawCircleHelper_x_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       display_drawCircleHelper_y_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawCircleHelper375
	MOVF        display_drawCircleHelper_y_L0+0, 0 
	SUBWF       display_drawCircleHelper_x_L0+0, 0 
L__display_drawCircleHelper375:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawCircleHelper118
;gfx_library.h,517 :: 		if (f >= 0) {
	MOVLW       128
	XORWF       display_drawCircleHelper_f_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawCircleHelper376
	MOVLW       0
	SUBWF       display_drawCircleHelper_f_L0+0, 0 
L__display_drawCircleHelper376:
	BTFSS       STATUS+0, 0 
	GOTO        L_display_drawCircleHelper119
;gfx_library.h,518 :: 		y--;
	MOVLW       1
	SUBWF       display_drawCircleHelper_y_L0+0, 1 
	MOVLW       0
	SUBWFB      display_drawCircleHelper_y_L0+1, 1 
;gfx_library.h,519 :: 		ddF_y += 2;
	MOVLW       2
	ADDWF       display_drawCircleHelper_ddF_y_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      display_drawCircleHelper_ddF_y_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       display_drawCircleHelper_ddF_y_L0+0 
	MOVF        R1, 0 
	MOVWF       display_drawCircleHelper_ddF_y_L0+1 
;gfx_library.h,520 :: 		f     += ddF_y;
	MOVF        R0, 0 
	ADDWF       display_drawCircleHelper_f_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      display_drawCircleHelper_f_L0+1, 1 
;gfx_library.h,521 :: 		}
L_display_drawCircleHelper119:
;gfx_library.h,522 :: 		x++;
	INFSNZ      display_drawCircleHelper_x_L0+0, 1 
	INCF        display_drawCircleHelper_x_L0+1, 1 
;gfx_library.h,523 :: 		ddF_x += 2;
	MOVLW       2
	ADDWF       display_drawCircleHelper_ddF_x_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      display_drawCircleHelper_ddF_x_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       display_drawCircleHelper_ddF_x_L0+0 
	MOVF        R1, 0 
	MOVWF       display_drawCircleHelper_ddF_x_L0+1 
;gfx_library.h,524 :: 		f     += ddF_x;
	MOVF        R0, 0 
	ADDWF       display_drawCircleHelper_f_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      display_drawCircleHelper_f_L0+1, 1 
;gfx_library.h,525 :: 		if (cornername & 0x4) {
	BTFSS       FARG_display_drawCircleHelper_cornername+0, 2 
	GOTO        L_display_drawCircleHelper120
;gfx_library.h,526 :: 		display_drawPixel(x0 + x, y0 + y, color);
	MOVF        display_drawCircleHelper_x_L0+0, 0 
	ADDWF       FARG_display_drawCircleHelper_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircleHelper_y_L0+0, 0 
	ADDWF       FARG_display_drawCircleHelper_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircleHelper_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircleHelper_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,527 :: 		display_drawPixel(x0 + y, y0 + x, color);
	MOVF        display_drawCircleHelper_y_L0+0, 0 
	ADDWF       FARG_display_drawCircleHelper_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircleHelper_x_L0+0, 0 
	ADDWF       FARG_display_drawCircleHelper_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircleHelper_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircleHelper_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,528 :: 		}
L_display_drawCircleHelper120:
;gfx_library.h,529 :: 		if (cornername & 0x2) {
	BTFSS       FARG_display_drawCircleHelper_cornername+0, 1 
	GOTO        L_display_drawCircleHelper121
;gfx_library.h,530 :: 		display_drawPixel(x0 + x, y0 - y, color);
	MOVF        display_drawCircleHelper_x_L0+0, 0 
	ADDWF       FARG_display_drawCircleHelper_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircleHelper_y_L0+0, 0 
	SUBWF       FARG_display_drawCircleHelper_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircleHelper_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircleHelper_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,531 :: 		display_drawPixel(x0 + y, y0 - x, color);
	MOVF        display_drawCircleHelper_y_L0+0, 0 
	ADDWF       FARG_display_drawCircleHelper_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircleHelper_x_L0+0, 0 
	SUBWF       FARG_display_drawCircleHelper_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircleHelper_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircleHelper_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,532 :: 		}
L_display_drawCircleHelper121:
;gfx_library.h,533 :: 		if (cornername & 0x8) {
	BTFSS       FARG_display_drawCircleHelper_cornername+0, 3 
	GOTO        L_display_drawCircleHelper122
;gfx_library.h,534 :: 		display_drawPixel(x0 - y, y0 + x, color);
	MOVF        display_drawCircleHelper_y_L0+0, 0 
	SUBWF       FARG_display_drawCircleHelper_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircleHelper_x_L0+0, 0 
	ADDWF       FARG_display_drawCircleHelper_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircleHelper_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircleHelper_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,535 :: 		display_drawPixel(x0 - x, y0 + y, color);
	MOVF        display_drawCircleHelper_x_L0+0, 0 
	SUBWF       FARG_display_drawCircleHelper_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircleHelper_y_L0+0, 0 
	ADDWF       FARG_display_drawCircleHelper_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircleHelper_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircleHelper_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,536 :: 		}
L_display_drawCircleHelper122:
;gfx_library.h,537 :: 		if (cornername & 0x1) {
	BTFSS       FARG_display_drawCircleHelper_cornername+0, 0 
	GOTO        L_display_drawCircleHelper123
;gfx_library.h,538 :: 		display_drawPixel(x0 - y, y0 - x, color);
	MOVF        display_drawCircleHelper_y_L0+0, 0 
	SUBWF       FARG_display_drawCircleHelper_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircleHelper_x_L0+0, 0 
	SUBWF       FARG_display_drawCircleHelper_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircleHelper_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircleHelper_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,539 :: 		display_drawPixel(x0 - x, y0 - y, color);
	MOVF        display_drawCircleHelper_x_L0+0, 0 
	SUBWF       FARG_display_drawCircleHelper_x0+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_drawCircleHelper_y_L0+0, 0 
	SUBWF       FARG_display_drawCircleHelper_y0+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawCircleHelper_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawCircleHelper_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
;gfx_library.h,540 :: 		}
L_display_drawCircleHelper123:
;gfx_library.h,541 :: 		}
	GOTO        L_display_drawCircleHelper117
L_display_drawCircleHelper118:
;gfx_library.h,542 :: 		}
L_end_display_drawCircleHelper:
	RETURN      0
; end of _display_drawCircleHelper

_display_fillCircle:

;gfx_library.h,553 :: 		void display_fillCircle(uint16_t x0, uint16_t y0, uint16_t r, uint16_t color) {
;gfx_library.h,554 :: 		display_drawVLine(x0, y0-r, 2*r+1, color);
	MOVF        FARG_display_fillCircle_x0+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        FARG_display_fillCircle_r+0, 0 
	SUBWF       FARG_display_fillCircle_y0+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        FARG_display_fillCircle_r+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	RLCF        FARG_drawVLine_h+0, 1 
	BCF         FARG_drawVLine_h+0, 0 
	INCF        FARG_drawVLine_h+0, 1 
	MOVF        FARG_display_fillCircle_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_fillCircle_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
;gfx_library.h,555 :: 		display_fillCircleHelper(x0, y0, r, 3, 0, color);
	MOVF        FARG_display_fillCircle_x0+0, 0 
	MOVWF       FARG_display_fillCircleHelper_x0+0 
	MOVF        FARG_display_fillCircle_x0+1, 0 
	MOVWF       FARG_display_fillCircleHelper_x0+1 
	MOVF        FARG_display_fillCircle_y0+0, 0 
	MOVWF       FARG_display_fillCircleHelper_y0+0 
	MOVF        FARG_display_fillCircle_y0+1, 0 
	MOVWF       FARG_display_fillCircleHelper_y0+1 
	MOVF        FARG_display_fillCircle_r+0, 0 
	MOVWF       FARG_display_fillCircleHelper_r+0 
	MOVF        FARG_display_fillCircle_r+1, 0 
	MOVWF       FARG_display_fillCircleHelper_r+1 
	MOVLW       3
	MOVWF       FARG_display_fillCircleHelper_cornername+0 
	CLRF        FARG_display_fillCircleHelper_delta+0 
	CLRF        FARG_display_fillCircleHelper_delta+1 
	MOVF        FARG_display_fillCircle_color+0, 0 
	MOVWF       FARG_display_fillCircleHelper_color+0 
	MOVF        FARG_display_fillCircle_color+1, 0 
	MOVWF       FARG_display_fillCircleHelper_color+1 
	CALL        _display_fillCircleHelper+0, 0
;gfx_library.h,556 :: 		}
L_end_display_fillCircle:
	RETURN      0
; end of _display_fillCircle

_display_fillCircleHelper:

;gfx_library.h,570 :: 		void display_fillCircleHelper(uint16_t x0, uint16_t y0, uint16_t r, uint8_t corners, uint16_t delta, uint16_t color) {
;gfx_library.h,571 :: 		int16_t f     = 1 - r;
	MOVF        FARG_display_fillCircleHelper_r+0, 0 
	SUBLW       1
	MOVWF       display_fillCircleHelper_f_L0+0 
	MOVF        FARG_display_fillCircleHelper_r+1, 0 
	MOVWF       display_fillCircleHelper_f_L0+1 
	MOVLW       0
	SUBFWB      display_fillCircleHelper_f_L0+1, 1 
;gfx_library.h,572 :: 		int16_t ddF_x = 1;
	MOVLW       1
	MOVWF       display_fillCircleHelper_ddF_x_L0+0 
	MOVLW       0
	MOVWF       display_fillCircleHelper_ddF_x_L0+1 
;gfx_library.h,573 :: 		int16_t ddF_y = -2 * r;
	MOVLW       254
	MOVWF       R0 
	MOVLW       255
	MOVWF       R1 
	MOVF        FARG_display_fillCircleHelper_r+0, 0 
	MOVWF       R4 
	MOVF        FARG_display_fillCircleHelper_r+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       display_fillCircleHelper_ddF_y_L0+0 
	MOVF        R1, 0 
	MOVWF       display_fillCircleHelper_ddF_y_L0+1 
;gfx_library.h,574 :: 		int16_t x     = 0;
	CLRF        display_fillCircleHelper_x_L0+0 
	CLRF        display_fillCircleHelper_x_L0+1 
;gfx_library.h,575 :: 		int16_t y     = r;
	MOVF        FARG_display_fillCircleHelper_r+0, 0 
	MOVWF       display_fillCircleHelper_y_L0+0 
	MOVF        FARG_display_fillCircleHelper_r+1, 0 
	MOVWF       display_fillCircleHelper_y_L0+1 
;gfx_library.h,576 :: 		int16_t px    = x;
	MOVF        display_fillCircleHelper_x_L0+0, 0 
	MOVWF       display_fillCircleHelper_px_L0+0 
	MOVF        display_fillCircleHelper_x_L0+1, 0 
	MOVWF       display_fillCircleHelper_px_L0+1 
;gfx_library.h,577 :: 		int16_t py    = y;
	MOVF        FARG_display_fillCircleHelper_r+0, 0 
	MOVWF       display_fillCircleHelper_py_L0+0 
	MOVF        FARG_display_fillCircleHelper_r+1, 0 
	MOVWF       display_fillCircleHelper_py_L0+1 
;gfx_library.h,579 :: 		delta++; // Avoid some +1's in the loop
	INFSNZ      FARG_display_fillCircleHelper_delta+0, 1 
	INCF        FARG_display_fillCircleHelper_delta+1, 1 
;gfx_library.h,581 :: 		while(x < y) {
L_display_fillCircleHelper124:
	MOVLW       128
	XORWF       display_fillCircleHelper_x_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       display_fillCircleHelper_y_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillCircleHelper379
	MOVF        display_fillCircleHelper_y_L0+0, 0 
	SUBWF       display_fillCircleHelper_x_L0+0, 0 
L__display_fillCircleHelper379:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillCircleHelper125
;gfx_library.h,582 :: 		if (f >= 0) {
	MOVLW       128
	XORWF       display_fillCircleHelper_f_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillCircleHelper380
	MOVLW       0
	SUBWF       display_fillCircleHelper_f_L0+0, 0 
L__display_fillCircleHelper380:
	BTFSS       STATUS+0, 0 
	GOTO        L_display_fillCircleHelper126
;gfx_library.h,583 :: 		y--;
	MOVLW       1
	SUBWF       display_fillCircleHelper_y_L0+0, 1 
	MOVLW       0
	SUBWFB      display_fillCircleHelper_y_L0+1, 1 
;gfx_library.h,584 :: 		ddF_y += 2;
	MOVLW       2
	ADDWF       display_fillCircleHelper_ddF_y_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      display_fillCircleHelper_ddF_y_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       display_fillCircleHelper_ddF_y_L0+0 
	MOVF        R1, 0 
	MOVWF       display_fillCircleHelper_ddF_y_L0+1 
;gfx_library.h,585 :: 		f     += ddF_y;
	MOVF        R0, 0 
	ADDWF       display_fillCircleHelper_f_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      display_fillCircleHelper_f_L0+1, 1 
;gfx_library.h,586 :: 		}
L_display_fillCircleHelper126:
;gfx_library.h,587 :: 		x++;
	INFSNZ      display_fillCircleHelper_x_L0+0, 1 
	INCF        display_fillCircleHelper_x_L0+1, 1 
;gfx_library.h,588 :: 		ddF_x += 2;
	MOVLW       2
	ADDWF       display_fillCircleHelper_ddF_x_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      display_fillCircleHelper_ddF_x_L0+1, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       display_fillCircleHelper_ddF_x_L0+0 
	MOVF        R1, 0 
	MOVWF       display_fillCircleHelper_ddF_x_L0+1 
;gfx_library.h,589 :: 		f     += ddF_x;
	MOVF        R0, 0 
	ADDWF       display_fillCircleHelper_f_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      display_fillCircleHelper_f_L0+1, 1 
;gfx_library.h,592 :: 		if(x < (y + 1)) {
	MOVLW       1
	ADDWF       display_fillCircleHelper_y_L0+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      display_fillCircleHelper_y_L0+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       display_fillCircleHelper_x_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillCircleHelper381
	MOVF        R1, 0 
	SUBWF       display_fillCircleHelper_x_L0+0, 0 
L__display_fillCircleHelper381:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillCircleHelper127
;gfx_library.h,593 :: 		if(corners & 1) display_drawVLine(x0+x, y0-y, 2*y+delta, color);
	BTFSS       FARG_display_fillCircleHelper_corners+0, 0 
	GOTO        L_display_fillCircleHelper128
	MOVF        display_fillCircleHelper_x_L0+0, 0 
	ADDWF       FARG_display_fillCircleHelper_x0+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        display_fillCircleHelper_y_L0+0, 0 
	SUBWF       FARG_display_fillCircleHelper_y0+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        display_fillCircleHelper_y_L0+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	RLCF        FARG_drawVLine_h+0, 1 
	BCF         FARG_drawVLine_h+0, 0 
	MOVF        FARG_display_fillCircleHelper_delta+0, 0 
	ADDWF       FARG_drawVLine_h+0, 1 
	MOVF        FARG_display_fillCircleHelper_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_fillCircleHelper_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
L_display_fillCircleHelper128:
;gfx_library.h,594 :: 		if(corners & 2) display_drawVLine(x0-x, y0-y, 2*y+delta, color);
	BTFSS       FARG_display_fillCircleHelper_corners+0, 1 
	GOTO        L_display_fillCircleHelper129
	MOVF        display_fillCircleHelper_x_L0+0, 0 
	SUBWF       FARG_display_fillCircleHelper_x0+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        display_fillCircleHelper_y_L0+0, 0 
	SUBWF       FARG_display_fillCircleHelper_y0+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        display_fillCircleHelper_y_L0+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	RLCF        FARG_drawVLine_h+0, 1 
	BCF         FARG_drawVLine_h+0, 0 
	MOVF        FARG_display_fillCircleHelper_delta+0, 0 
	ADDWF       FARG_drawVLine_h+0, 1 
	MOVF        FARG_display_fillCircleHelper_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_fillCircleHelper_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
L_display_fillCircleHelper129:
;gfx_library.h,595 :: 		}
L_display_fillCircleHelper127:
;gfx_library.h,596 :: 		if(y != py) {
	MOVF        display_fillCircleHelper_y_L0+1, 0 
	XORWF       display_fillCircleHelper_py_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillCircleHelper382
	MOVF        display_fillCircleHelper_py_L0+0, 0 
	XORWF       display_fillCircleHelper_y_L0+0, 0 
L__display_fillCircleHelper382:
	BTFSC       STATUS+0, 2 
	GOTO        L_display_fillCircleHelper130
;gfx_library.h,597 :: 		if(corners & 1) display_drawVLine(x0+py, y0-px, 2*px+delta, color);
	BTFSS       FARG_display_fillCircleHelper_corners+0, 0 
	GOTO        L_display_fillCircleHelper131
	MOVF        display_fillCircleHelper_py_L0+0, 0 
	ADDWF       FARG_display_fillCircleHelper_x0+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        display_fillCircleHelper_px_L0+0, 0 
	SUBWF       FARG_display_fillCircleHelper_y0+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        display_fillCircleHelper_px_L0+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	RLCF        FARG_drawVLine_h+0, 1 
	BCF         FARG_drawVLine_h+0, 0 
	MOVF        FARG_display_fillCircleHelper_delta+0, 0 
	ADDWF       FARG_drawVLine_h+0, 1 
	MOVF        FARG_display_fillCircleHelper_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_fillCircleHelper_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
L_display_fillCircleHelper131:
;gfx_library.h,598 :: 		if(corners & 2) display_drawVLine(x0-py, y0-px, 2*px+delta, color);
	BTFSS       FARG_display_fillCircleHelper_corners+0, 1 
	GOTO        L_display_fillCircleHelper132
	MOVF        display_fillCircleHelper_py_L0+0, 0 
	SUBWF       FARG_display_fillCircleHelper_x0+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        display_fillCircleHelper_px_L0+0, 0 
	SUBWF       FARG_display_fillCircleHelper_y0+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        display_fillCircleHelper_px_L0+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	RLCF        FARG_drawVLine_h+0, 1 
	BCF         FARG_drawVLine_h+0, 0 
	MOVF        FARG_display_fillCircleHelper_delta+0, 0 
	ADDWF       FARG_drawVLine_h+0, 1 
	MOVF        FARG_display_fillCircleHelper_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_fillCircleHelper_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
L_display_fillCircleHelper132:
;gfx_library.h,599 :: 		py = y;
	MOVF        display_fillCircleHelper_y_L0+0, 0 
	MOVWF       display_fillCircleHelper_py_L0+0 
	MOVF        display_fillCircleHelper_y_L0+1, 0 
	MOVWF       display_fillCircleHelper_py_L0+1 
;gfx_library.h,600 :: 		}
L_display_fillCircleHelper130:
;gfx_library.h,601 :: 		px = x;
	MOVF        display_fillCircleHelper_x_L0+0, 0 
	MOVWF       display_fillCircleHelper_px_L0+0 
	MOVF        display_fillCircleHelper_x_L0+1, 0 
	MOVWF       display_fillCircleHelper_px_L0+1 
;gfx_library.h,602 :: 		}
	GOTO        L_display_fillCircleHelper124
L_display_fillCircleHelper125:
;gfx_library.h,603 :: 		}
L_end_display_fillCircleHelper:
	RETURN      0
; end of _display_fillCircleHelper

_display_drawRect:

;gfx_library.h,615 :: 		void display_drawRect(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint16_t color) {
;gfx_library.h,616 :: 		display_drawHLine(x, y, w, color);
	MOVF        FARG_display_drawRect_x+0, 0 
	MOVWF       FARG_drawHLine_x+0 
	MOVF        FARG_display_drawRect_y+0, 0 
	MOVWF       FARG_drawHLine_y+0 
	MOVF        FARG_display_drawRect_w+0, 0 
	MOVWF       FARG_drawHLine_w+0 
	MOVF        FARG_display_drawRect_color+0, 0 
	MOVWF       FARG_drawHLine_color+0 
	MOVF        FARG_display_drawRect_color+1, 0 
	MOVWF       FARG_drawHLine_color+1 
	CALL        _drawHLine+0, 0
;gfx_library.h,617 :: 		display_drawHLine(x, y+h-1, w, color);
	MOVF        FARG_display_drawRect_x+0, 0 
	MOVWF       FARG_drawHLine_x+0 
	MOVF        FARG_display_drawRect_h+0, 0 
	ADDWF       FARG_display_drawRect_y+0, 0 
	MOVWF       FARG_drawHLine_y+0 
	DECF        FARG_drawHLine_y+0, 1 
	MOVF        FARG_display_drawRect_w+0, 0 
	MOVWF       FARG_drawHLine_w+0 
	MOVF        FARG_display_drawRect_color+0, 0 
	MOVWF       FARG_drawHLine_color+0 
	MOVF        FARG_display_drawRect_color+1, 0 
	MOVWF       FARG_drawHLine_color+1 
	CALL        _drawHLine+0, 0
;gfx_library.h,618 :: 		display_drawVLine(x, y, h, color);
	MOVF        FARG_display_drawRect_x+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        FARG_display_drawRect_y+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        FARG_display_drawRect_h+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	MOVF        FARG_display_drawRect_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_drawRect_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
;gfx_library.h,619 :: 		display_drawVLine(x+w-1, y, h, color);
	MOVF        FARG_display_drawRect_w+0, 0 
	ADDWF       FARG_display_drawRect_x+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	DECF        FARG_drawVLine_x+0, 1 
	MOVF        FARG_display_drawRect_y+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        FARG_display_drawRect_h+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	MOVF        FARG_display_drawRect_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_drawRect_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
;gfx_library.h,620 :: 		}
L_end_display_drawRect:
	RETURN      0
; end of _display_drawRect

_display_drawRoundRect:

;gfx_library.h,633 :: 		void display_drawRoundRect(uint16_t x, uint16_t y, uint16_t w, uint16_t h, uint16_t r, uint16_t color) {
;gfx_library.h,634 :: 		int16_t max_radius = ((w < h) ? w : h) / 2; // 1/2 minor axis
	MOVF        FARG_display_drawRoundRect_h+1, 0 
	SUBWF       FARG_display_drawRoundRect_w+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawRoundRect385
	MOVF        FARG_display_drawRoundRect_h+0, 0 
	SUBWF       FARG_display_drawRoundRect_w+0, 0 
L__display_drawRoundRect385:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawRoundRect133
	MOVF        FARG_display_drawRoundRect_w+0, 0 
	MOVWF       ?FLOC___display_drawRoundRectT244+0 
	MOVF        FARG_display_drawRoundRect_w+1, 0 
	MOVWF       ?FLOC___display_drawRoundRectT244+1 
	GOTO        L_display_drawRoundRect134
L_display_drawRoundRect133:
	MOVF        FARG_display_drawRoundRect_h+0, 0 
	MOVWF       ?FLOC___display_drawRoundRectT244+0 
	MOVF        FARG_display_drawRoundRect_h+1, 0 
	MOVWF       ?FLOC___display_drawRoundRectT244+1 
L_display_drawRoundRect134:
	MOVF        ?FLOC___display_drawRoundRectT244+0, 0 
	MOVWF       R1 
	MOVF        ?FLOC___display_drawRoundRectT244+1, 0 
	MOVWF       R2 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R2, 7 
	MOVF        R1, 0 
	MOVWF       display_drawRoundRect_max_radius_L0+0 
	MOVF        R2, 0 
	MOVWF       display_drawRoundRect_max_radius_L0+1 
;gfx_library.h,635 :: 		if(r > max_radius) r = max_radius;
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawRoundRect386
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	SUBWF       R1, 0 
L__display_drawRoundRect386:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawRoundRect135
	MOVF        display_drawRoundRect_max_radius_L0+0, 0 
	MOVWF       FARG_display_drawRoundRect_r+0 
	MOVF        display_drawRoundRect_max_radius_L0+1, 0 
	MOVWF       FARG_display_drawRoundRect_r+1 
L_display_drawRoundRect135:
;gfx_library.h,637 :: 		display_drawHLine(x+r  , y    , w-2*r, color); // Top
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	ADDWF       FARG_display_drawRoundRect_x+0, 0 
	MOVWF       FARG_drawHLine_x+0 
	MOVF        FARG_display_drawRoundRect_y+0, 0 
	MOVWF       FARG_drawHLine_y+0 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	SUBWF       FARG_display_drawRoundRect_w+0, 0 
	MOVWF       FARG_drawHLine_w+0 
	MOVF        FARG_display_drawRoundRect_color+0, 0 
	MOVWF       FARG_drawHLine_color+0 
	MOVF        FARG_display_drawRoundRect_color+1, 0 
	MOVWF       FARG_drawHLine_color+1 
	CALL        _drawHLine+0, 0
;gfx_library.h,638 :: 		display_drawHLine(x+r  , y+h-1, w-2*r, color); // Bottom
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	ADDWF       FARG_display_drawRoundRect_x+0, 0 
	MOVWF       FARG_drawHLine_x+0 
	MOVF        FARG_display_drawRoundRect_h+0, 0 
	ADDWF       FARG_display_drawRoundRect_y+0, 0 
	MOVWF       FARG_drawHLine_y+0 
	DECF        FARG_drawHLine_y+0, 1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	SUBWF       FARG_display_drawRoundRect_w+0, 0 
	MOVWF       FARG_drawHLine_w+0 
	MOVF        FARG_display_drawRoundRect_color+0, 0 
	MOVWF       FARG_drawHLine_color+0 
	MOVF        FARG_display_drawRoundRect_color+1, 0 
	MOVWF       FARG_drawHLine_color+1 
	CALL        _drawHLine+0, 0
;gfx_library.h,639 :: 		display_drawVLine(x    , y+r  , h-2*r, color); // Left
	MOVF        FARG_display_drawRoundRect_x+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	ADDWF       FARG_display_drawRoundRect_y+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	SUBWF       FARG_display_drawRoundRect_h+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	MOVF        FARG_display_drawRoundRect_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_drawRoundRect_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
;gfx_library.h,640 :: 		display_drawVLine(x+w-1, y+r  , h-2*r, color); // Right
	MOVF        FARG_display_drawRoundRect_w+0, 0 
	ADDWF       FARG_display_drawRoundRect_x+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	DECF        FARG_drawVLine_x+0, 1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	ADDWF       FARG_display_drawRoundRect_y+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	SUBWF       FARG_display_drawRoundRect_h+0, 0 
	MOVWF       FARG_drawVLine_h+0 
	MOVF        FARG_display_drawRoundRect_color+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        FARG_display_drawRoundRect_color+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
;gfx_library.h,642 :: 		display_drawCircleHelper(x+r    , y+r    , r, 1, color);
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	ADDWF       FARG_display_drawRoundRect_x+0, 0 
	MOVWF       FARG_display_drawCircleHelper_x0+0 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	ADDWFC      FARG_display_drawRoundRect_x+1, 0 
	MOVWF       FARG_display_drawCircleHelper_x0+1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	ADDWF       FARG_display_drawRoundRect_y+0, 0 
	MOVWF       FARG_display_drawCircleHelper_y0+0 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	ADDWFC      FARG_display_drawRoundRect_y+1, 0 
	MOVWF       FARG_display_drawCircleHelper_y0+1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	MOVWF       FARG_display_drawCircleHelper_r+0 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	MOVWF       FARG_display_drawCircleHelper_r+1 
	MOVLW       1
	MOVWF       FARG_display_drawCircleHelper_cornername+0 
	MOVF        FARG_display_drawRoundRect_color+0, 0 
	MOVWF       FARG_display_drawCircleHelper_color+0 
	MOVF        FARG_display_drawRoundRect_color+1, 0 
	MOVWF       FARG_display_drawCircleHelper_color+1 
	CALL        _display_drawCircleHelper+0, 0
;gfx_library.h,643 :: 		display_drawCircleHelper(x+w-r-1, y+r    , r, 2, color);
	MOVF        FARG_display_drawRoundRect_w+0, 0 
	ADDWF       FARG_display_drawRoundRect_x+0, 0 
	MOVWF       FARG_display_drawCircleHelper_x0+0 
	MOVF        FARG_display_drawRoundRect_w+1, 0 
	ADDWFC      FARG_display_drawRoundRect_x+1, 0 
	MOVWF       FARG_display_drawCircleHelper_x0+1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	SUBWF       FARG_display_drawCircleHelper_x0+0, 1 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	SUBWFB      FARG_display_drawCircleHelper_x0+1, 1 
	MOVLW       1
	SUBWF       FARG_display_drawCircleHelper_x0+0, 1 
	MOVLW       0
	SUBWFB      FARG_display_drawCircleHelper_x0+1, 1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	ADDWF       FARG_display_drawRoundRect_y+0, 0 
	MOVWF       FARG_display_drawCircleHelper_y0+0 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	ADDWFC      FARG_display_drawRoundRect_y+1, 0 
	MOVWF       FARG_display_drawCircleHelper_y0+1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	MOVWF       FARG_display_drawCircleHelper_r+0 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	MOVWF       FARG_display_drawCircleHelper_r+1 
	MOVLW       2
	MOVWF       FARG_display_drawCircleHelper_cornername+0 
	MOVF        FARG_display_drawRoundRect_color+0, 0 
	MOVWF       FARG_display_drawCircleHelper_color+0 
	MOVF        FARG_display_drawRoundRect_color+1, 0 
	MOVWF       FARG_display_drawCircleHelper_color+1 
	CALL        _display_drawCircleHelper+0, 0
;gfx_library.h,644 :: 		display_drawCircleHelper(x+w-r-1, y+h-r-1, r, 4, color);
	MOVF        FARG_display_drawRoundRect_w+0, 0 
	ADDWF       FARG_display_drawRoundRect_x+0, 0 
	MOVWF       FARG_display_drawCircleHelper_x0+0 
	MOVF        FARG_display_drawRoundRect_w+1, 0 
	ADDWFC      FARG_display_drawRoundRect_x+1, 0 
	MOVWF       FARG_display_drawCircleHelper_x0+1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	SUBWF       FARG_display_drawCircleHelper_x0+0, 1 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	SUBWFB      FARG_display_drawCircleHelper_x0+1, 1 
	MOVLW       1
	SUBWF       FARG_display_drawCircleHelper_x0+0, 1 
	MOVLW       0
	SUBWFB      FARG_display_drawCircleHelper_x0+1, 1 
	MOVF        FARG_display_drawRoundRect_h+0, 0 
	ADDWF       FARG_display_drawRoundRect_y+0, 0 
	MOVWF       FARG_display_drawCircleHelper_y0+0 
	MOVF        FARG_display_drawRoundRect_h+1, 0 
	ADDWFC      FARG_display_drawRoundRect_y+1, 0 
	MOVWF       FARG_display_drawCircleHelper_y0+1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	SUBWF       FARG_display_drawCircleHelper_y0+0, 1 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	SUBWFB      FARG_display_drawCircleHelper_y0+1, 1 
	MOVLW       1
	SUBWF       FARG_display_drawCircleHelper_y0+0, 1 
	MOVLW       0
	SUBWFB      FARG_display_drawCircleHelper_y0+1, 1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	MOVWF       FARG_display_drawCircleHelper_r+0 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	MOVWF       FARG_display_drawCircleHelper_r+1 
	MOVLW       4
	MOVWF       FARG_display_drawCircleHelper_cornername+0 
	MOVF        FARG_display_drawRoundRect_color+0, 0 
	MOVWF       FARG_display_drawCircleHelper_color+0 
	MOVF        FARG_display_drawRoundRect_color+1, 0 
	MOVWF       FARG_display_drawCircleHelper_color+1 
	CALL        _display_drawCircleHelper+0, 0
;gfx_library.h,645 :: 		display_drawCircleHelper(x+r    , y+h-r-1, r, 8, color);
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	ADDWF       FARG_display_drawRoundRect_x+0, 0 
	MOVWF       FARG_display_drawCircleHelper_x0+0 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	ADDWFC      FARG_display_drawRoundRect_x+1, 0 
	MOVWF       FARG_display_drawCircleHelper_x0+1 
	MOVF        FARG_display_drawRoundRect_h+0, 0 
	ADDWF       FARG_display_drawRoundRect_y+0, 0 
	MOVWF       FARG_display_drawCircleHelper_y0+0 
	MOVF        FARG_display_drawRoundRect_h+1, 0 
	ADDWFC      FARG_display_drawRoundRect_y+1, 0 
	MOVWF       FARG_display_drawCircleHelper_y0+1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	SUBWF       FARG_display_drawCircleHelper_y0+0, 1 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	SUBWFB      FARG_display_drawCircleHelper_y0+1, 1 
	MOVLW       1
	SUBWF       FARG_display_drawCircleHelper_y0+0, 1 
	MOVLW       0
	SUBWFB      FARG_display_drawCircleHelper_y0+1, 1 
	MOVF        FARG_display_drawRoundRect_r+0, 0 
	MOVWF       FARG_display_drawCircleHelper_r+0 
	MOVF        FARG_display_drawRoundRect_r+1, 0 
	MOVWF       FARG_display_drawCircleHelper_r+1 
	MOVLW       8
	MOVWF       FARG_display_drawCircleHelper_cornername+0 
	MOVF        FARG_display_drawRoundRect_color+0, 0 
	MOVWF       FARG_display_drawCircleHelper_color+0 
	MOVF        FARG_display_drawRoundRect_color+1, 0 
	MOVWF       FARG_display_drawCircleHelper_color+1 
	CALL        _display_drawCircleHelper+0, 0
;gfx_library.h,646 :: 		}
L_end_display_drawRoundRect:
	RETURN      0
; end of _display_drawRoundRect

_display_fillRoundRect:

;gfx_library.h,660 :: 		uint16_t h, uint16_t r, uint16_t color) {
;gfx_library.h,661 :: 		int16_t max_radius = ((w < h) ? w : h) / 2; // 1/2 minor axis
	MOVF        FARG_display_fillRoundRect_h+1, 0 
	SUBWF       FARG_display_fillRoundRect_w+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillRoundRect388
	MOVF        FARG_display_fillRoundRect_h+0, 0 
	SUBWF       FARG_display_fillRoundRect_w+0, 0 
L__display_fillRoundRect388:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillRoundRect136
	MOVF        FARG_display_fillRoundRect_w+0, 0 
	MOVWF       ?FLOC___display_fillRoundRectT280+0 
	MOVF        FARG_display_fillRoundRect_w+1, 0 
	MOVWF       ?FLOC___display_fillRoundRectT280+1 
	GOTO        L_display_fillRoundRect137
L_display_fillRoundRect136:
	MOVF        FARG_display_fillRoundRect_h+0, 0 
	MOVWF       ?FLOC___display_fillRoundRectT280+0 
	MOVF        FARG_display_fillRoundRect_h+1, 0 
	MOVWF       ?FLOC___display_fillRoundRectT280+1 
L_display_fillRoundRect137:
	MOVF        ?FLOC___display_fillRoundRectT280+0, 0 
	MOVWF       R1 
	MOVF        ?FLOC___display_fillRoundRectT280+1, 0 
	MOVWF       R2 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R2, 7 
	MOVF        R1, 0 
	MOVWF       display_fillRoundRect_max_radius_L0+0 
	MOVF        R2, 0 
	MOVWF       display_fillRoundRect_max_radius_L0+1 
;gfx_library.h,662 :: 		if(r > max_radius) r = max_radius;
	MOVF        FARG_display_fillRoundRect_r+1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillRoundRect389
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	SUBWF       R1, 0 
L__display_fillRoundRect389:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillRoundRect138
	MOVF        display_fillRoundRect_max_radius_L0+0, 0 
	MOVWF       FARG_display_fillRoundRect_r+0 
	MOVF        display_fillRoundRect_max_radius_L0+1, 0 
	MOVWF       FARG_display_fillRoundRect_r+1 
L_display_fillRoundRect138:
;gfx_library.h,664 :: 		display_fillRect(x+r, y, w-2*r, h, color);
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	ADDWF       FARG_display_fillRoundRect_x+0, 0 
	MOVWF       FARG_fillRect_x+0 
	MOVF        FARG_display_fillRoundRect_y+0, 0 
	MOVWF       FARG_fillRect_y+0 
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	SUBWF       FARG_display_fillRoundRect_w+0, 0 
	MOVWF       FARG_fillRect_w+0 
	MOVF        FARG_display_fillRoundRect_h+0, 0 
	MOVWF       FARG_fillRect_h+0 
	MOVF        FARG_display_fillRoundRect_color+0, 0 
	MOVWF       FARG_fillRect_color+0 
	MOVF        FARG_display_fillRoundRect_color+1, 0 
	MOVWF       FARG_fillRect_color+1 
	CALL        _fillRect+0, 0
;gfx_library.h,666 :: 		display_fillCircleHelper(x+w-r-1, y+r, r, 1, h-2*r-1, color);
	MOVF        FARG_display_fillRoundRect_w+0, 0 
	ADDWF       FARG_display_fillRoundRect_x+0, 0 
	MOVWF       FARG_display_fillCircleHelper_x0+0 
	MOVF        FARG_display_fillRoundRect_w+1, 0 
	ADDWFC      FARG_display_fillRoundRect_x+1, 0 
	MOVWF       FARG_display_fillCircleHelper_x0+1 
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	SUBWF       FARG_display_fillCircleHelper_x0+0, 1 
	MOVF        FARG_display_fillRoundRect_r+1, 0 
	SUBWFB      FARG_display_fillCircleHelper_x0+1, 1 
	MOVLW       1
	SUBWF       FARG_display_fillCircleHelper_x0+0, 1 
	MOVLW       0
	SUBWFB      FARG_display_fillCircleHelper_x0+1, 1 
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	ADDWF       FARG_display_fillRoundRect_y+0, 0 
	MOVWF       FARG_display_fillCircleHelper_y0+0 
	MOVF        FARG_display_fillRoundRect_r+1, 0 
	ADDWFC      FARG_display_fillRoundRect_y+1, 0 
	MOVWF       FARG_display_fillCircleHelper_y0+1 
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	MOVWF       FARG_display_fillCircleHelper_r+0 
	MOVF        FARG_display_fillRoundRect_r+1, 0 
	MOVWF       FARG_display_fillCircleHelper_r+1 
	MOVLW       1
	MOVWF       FARG_display_fillCircleHelper_corners+0 
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	MOVWF       R0 
	MOVF        FARG_display_fillRoundRect_r+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	SUBWF       FARG_display_fillRoundRect_h+0, 0 
	MOVWF       FARG_display_fillCircleHelper_delta+0 
	MOVF        R1, 0 
	SUBWFB      FARG_display_fillRoundRect_h+1, 0 
	MOVWF       FARG_display_fillCircleHelper_delta+1 
	MOVLW       1
	SUBWF       FARG_display_fillCircleHelper_delta+0, 1 
	MOVLW       0
	SUBWFB      FARG_display_fillCircleHelper_delta+1, 1 
	MOVF        FARG_display_fillRoundRect_color+0, 0 
	MOVWF       FARG_display_fillCircleHelper_color+0 
	MOVF        FARG_display_fillRoundRect_color+1, 0 
	MOVWF       FARG_display_fillCircleHelper_color+1 
	CALL        _display_fillCircleHelper+0, 0
;gfx_library.h,668 :: 		display_fillCircleHelper(x+r    , y+r, r, 2, h-2*r-1, color);
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	ADDWF       FARG_display_fillRoundRect_x+0, 0 
	MOVWF       FARG_display_fillCircleHelper_x0+0 
	MOVF        FARG_display_fillRoundRect_r+1, 0 
	ADDWFC      FARG_display_fillRoundRect_x+1, 0 
	MOVWF       FARG_display_fillCircleHelper_x0+1 
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	ADDWF       FARG_display_fillRoundRect_y+0, 0 
	MOVWF       FARG_display_fillCircleHelper_y0+0 
	MOVF        FARG_display_fillRoundRect_r+1, 0 
	ADDWFC      FARG_display_fillRoundRect_y+1, 0 
	MOVWF       FARG_display_fillCircleHelper_y0+1 
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	MOVWF       FARG_display_fillCircleHelper_r+0 
	MOVF        FARG_display_fillRoundRect_r+1, 0 
	MOVWF       FARG_display_fillCircleHelper_r+1 
	MOVLW       2
	MOVWF       FARG_display_fillCircleHelper_corners+0 
	MOVF        FARG_display_fillRoundRect_r+0, 0 
	MOVWF       R0 
	MOVF        FARG_display_fillRoundRect_r+1, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	SUBWF       FARG_display_fillRoundRect_h+0, 0 
	MOVWF       FARG_display_fillCircleHelper_delta+0 
	MOVF        R1, 0 
	SUBWFB      FARG_display_fillRoundRect_h+1, 0 
	MOVWF       FARG_display_fillCircleHelper_delta+1 
	MOVLW       1
	SUBWF       FARG_display_fillCircleHelper_delta+0, 1 
	MOVLW       0
	SUBWFB      FARG_display_fillCircleHelper_delta+1, 1 
	MOVF        FARG_display_fillRoundRect_color+0, 0 
	MOVWF       FARG_display_fillCircleHelper_color+0 
	MOVF        FARG_display_fillRoundRect_color+1, 0 
	MOVWF       FARG_display_fillCircleHelper_color+1 
	CALL        _display_fillCircleHelper+0, 0
;gfx_library.h,669 :: 		}
L_end_display_fillRoundRect:
	RETURN      0
; end of _display_fillRoundRect

_display_drawTriangle:

;gfx_library.h,684 :: 		uint16_t x2, uint16_t y2, uint16_t color) {
;gfx_library.h,685 :: 		display_drawLine(x0, y0, x1, y1, color);
	MOVF        FARG_display_drawTriangle_x0+0, 0 
	MOVWF       FARG_display_drawLine_x0+0 
	MOVF        FARG_display_drawTriangle_x0+1, 0 
	MOVWF       FARG_display_drawLine_x0+1 
	MOVF        FARG_display_drawTriangle_y0+0, 0 
	MOVWF       FARG_display_drawLine_y0+0 
	MOVF        FARG_display_drawTriangle_y0+1, 0 
	MOVWF       FARG_display_drawLine_y0+1 
	MOVF        FARG_display_drawTriangle_x1+0, 0 
	MOVWF       FARG_display_drawLine_x1+0 
	MOVF        FARG_display_drawTriangle_x1+1, 0 
	MOVWF       FARG_display_drawLine_x1+1 
	MOVF        FARG_display_drawTriangle_y1+0, 0 
	MOVWF       FARG_display_drawLine_y1+0 
	MOVF        FARG_display_drawTriangle_y1+1, 0 
	MOVWF       FARG_display_drawLine_y1+1 
	MOVF        FARG_display_drawTriangle_color+0, 0 
	MOVWF       FARG_display_drawLine_color+0 
	MOVF        FARG_display_drawTriangle_color+1, 0 
	MOVWF       FARG_display_drawLine_color+1 
	CALL        _display_drawLine+0, 0
;gfx_library.h,686 :: 		display_drawLine(x1, y1, x2, y2, color);
	MOVF        FARG_display_drawTriangle_x1+0, 0 
	MOVWF       FARG_display_drawLine_x0+0 
	MOVF        FARG_display_drawTriangle_x1+1, 0 
	MOVWF       FARG_display_drawLine_x0+1 
	MOVF        FARG_display_drawTriangle_y1+0, 0 
	MOVWF       FARG_display_drawLine_y0+0 
	MOVF        FARG_display_drawTriangle_y1+1, 0 
	MOVWF       FARG_display_drawLine_y0+1 
	MOVF        FARG_display_drawTriangle_x2+0, 0 
	MOVWF       FARG_display_drawLine_x1+0 
	MOVF        FARG_display_drawTriangle_x2+1, 0 
	MOVWF       FARG_display_drawLine_x1+1 
	MOVF        FARG_display_drawTriangle_y2+0, 0 
	MOVWF       FARG_display_drawLine_y1+0 
	MOVF        FARG_display_drawTriangle_y2+1, 0 
	MOVWF       FARG_display_drawLine_y1+1 
	MOVF        FARG_display_drawTriangle_color+0, 0 
	MOVWF       FARG_display_drawLine_color+0 
	MOVF        FARG_display_drawTriangle_color+1, 0 
	MOVWF       FARG_display_drawLine_color+1 
	CALL        _display_drawLine+0, 0
;gfx_library.h,687 :: 		display_drawLine(x2, y2, x0, y0, color);
	MOVF        FARG_display_drawTriangle_x2+0, 0 
	MOVWF       FARG_display_drawLine_x0+0 
	MOVF        FARG_display_drawTriangle_x2+1, 0 
	MOVWF       FARG_display_drawLine_x0+1 
	MOVF        FARG_display_drawTriangle_y2+0, 0 
	MOVWF       FARG_display_drawLine_y0+0 
	MOVF        FARG_display_drawTriangle_y2+1, 0 
	MOVWF       FARG_display_drawLine_y0+1 
	MOVF        FARG_display_drawTriangle_x0+0, 0 
	MOVWF       FARG_display_drawLine_x1+0 
	MOVF        FARG_display_drawTriangle_x0+1, 0 
	MOVWF       FARG_display_drawLine_x1+1 
	MOVF        FARG_display_drawTriangle_y0+0, 0 
	MOVWF       FARG_display_drawLine_y1+0 
	MOVF        FARG_display_drawTriangle_y0+1, 0 
	MOVWF       FARG_display_drawLine_y1+1 
	MOVF        FARG_display_drawTriangle_color+0, 0 
	MOVWF       FARG_display_drawLine_color+0 
	MOVF        FARG_display_drawTriangle_color+1, 0 
	MOVWF       FARG_display_drawLine_color+1 
	CALL        _display_drawLine+0, 0
;gfx_library.h,688 :: 		}
L_end_display_drawTriangle:
	RETURN      0
; end of _display_drawTriangle

_display_fillTriangle:

;gfx_library.h,703 :: 		uint16_t x2, uint16_t y2, uint16_t color) {
;gfx_library.h,706 :: 		sa   = 0,
	CLRF        display_fillTriangle_sa_L0+0 
	CLRF        display_fillTriangle_sa_L0+1 
	CLRF        display_fillTriangle_sa_L0+2 
	CLRF        display_fillTriangle_sa_L0+3 
	CLRF        display_fillTriangle_sb_L0+0 
	CLRF        display_fillTriangle_sb_L0+1 
	CLRF        display_fillTriangle_sb_L0+2 
	CLRF        display_fillTriangle_sb_L0+3 
;gfx_library.h,710 :: 		if (y0 > y1) {
	MOVF        FARG_display_fillTriangle_y0+1, 0 
	SUBWF       FARG_display_fillTriangle_y1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle392
	MOVF        FARG_display_fillTriangle_y0+0, 0 
	SUBWF       FARG_display_fillTriangle_y1+0, 0 
L__display_fillTriangle392:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillTriangle139
;gfx_library.h,711 :: 		_swap_int16_t(y0, y1); _swap_int16_t(x0, x1);
	MOVF        FARG_display_fillTriangle_y0+0, 0 
	MOVWF       display_fillTriangle_t_L2+0 
	MOVF        FARG_display_fillTriangle_y0+1, 0 
	MOVWF       display_fillTriangle_t_L2+1 
	MOVF        FARG_display_fillTriangle_y1+0, 0 
	MOVWF       FARG_display_fillTriangle_y0+0 
	MOVF        FARG_display_fillTriangle_y1+1, 0 
	MOVWF       FARG_display_fillTriangle_y0+1 
	MOVF        display_fillTriangle_t_L2+0, 0 
	MOVWF       FARG_display_fillTriangle_y1+0 
	MOVF        display_fillTriangle_t_L2+1, 0 
	MOVWF       FARG_display_fillTriangle_y1+1 
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	MOVWF       display_fillTriangle_t_L2_L2+0 
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	MOVWF       display_fillTriangle_t_L2_L2+1 
	MOVF        FARG_display_fillTriangle_x1+0, 0 
	MOVWF       FARG_display_fillTriangle_x0+0 
	MOVF        FARG_display_fillTriangle_x1+1, 0 
	MOVWF       FARG_display_fillTriangle_x0+1 
	MOVF        display_fillTriangle_t_L2_L2+0, 0 
	MOVWF       FARG_display_fillTriangle_x1+0 
	MOVF        display_fillTriangle_t_L2_L2+1, 0 
	MOVWF       FARG_display_fillTriangle_x1+1 
;gfx_library.h,712 :: 		}
L_display_fillTriangle139:
;gfx_library.h,713 :: 		if (y1 > y2) {
	MOVF        FARG_display_fillTriangle_y1+1, 0 
	SUBWF       FARG_display_fillTriangle_y2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle393
	MOVF        FARG_display_fillTriangle_y1+0, 0 
	SUBWF       FARG_display_fillTriangle_y2+0, 0 
L__display_fillTriangle393:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillTriangle140
;gfx_library.h,714 :: 		_swap_int16_t(y2, y1); _swap_int16_t(x2, x1);
	MOVF        FARG_display_fillTriangle_y2+0, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2+0 
	MOVF        FARG_display_fillTriangle_y2+1, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2+1 
	MOVF        FARG_display_fillTriangle_y1+0, 0 
	MOVWF       FARG_display_fillTriangle_y2+0 
	MOVF        FARG_display_fillTriangle_y1+1, 0 
	MOVWF       FARG_display_fillTriangle_y2+1 
	MOVF        display_fillTriangle_t_L2_L2_L2+0, 0 
	MOVWF       FARG_display_fillTriangle_y1+0 
	MOVF        display_fillTriangle_t_L2_L2_L2+1, 0 
	MOVWF       FARG_display_fillTriangle_y1+1 
	MOVF        FARG_display_fillTriangle_x2+0, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2+0 
	MOVF        FARG_display_fillTriangle_x2+1, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2+1 
	MOVF        FARG_display_fillTriangle_x1+0, 0 
	MOVWF       FARG_display_fillTriangle_x2+0 
	MOVF        FARG_display_fillTriangle_x1+1, 0 
	MOVWF       FARG_display_fillTriangle_x2+1 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2+0, 0 
	MOVWF       FARG_display_fillTriangle_x1+0 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2+1, 0 
	MOVWF       FARG_display_fillTriangle_x1+1 
;gfx_library.h,715 :: 		}
L_display_fillTriangle140:
;gfx_library.h,716 :: 		if (y0 > y1) {
	MOVF        FARG_display_fillTriangle_y0+1, 0 
	SUBWF       FARG_display_fillTriangle_y1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle394
	MOVF        FARG_display_fillTriangle_y0+0, 0 
	SUBWF       FARG_display_fillTriangle_y1+0, 0 
L__display_fillTriangle394:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillTriangle141
;gfx_library.h,717 :: 		_swap_int16_t(y0, y1); _swap_int16_t(x0, x1);
	MOVF        FARG_display_fillTriangle_y0+0, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2_L2+0 
	MOVF        FARG_display_fillTriangle_y0+1, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2_L2+1 
	MOVF        FARG_display_fillTriangle_y1+0, 0 
	MOVWF       FARG_display_fillTriangle_y0+0 
	MOVF        FARG_display_fillTriangle_y1+1, 0 
	MOVWF       FARG_display_fillTriangle_y0+1 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2_L2+0, 0 
	MOVWF       FARG_display_fillTriangle_y1+0 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2_L2+1, 0 
	MOVWF       FARG_display_fillTriangle_y1+1 
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2_L2_L2+0 
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2_L2_L2+1 
	MOVF        FARG_display_fillTriangle_x1+0, 0 
	MOVWF       FARG_display_fillTriangle_x0+0 
	MOVF        FARG_display_fillTriangle_x1+1, 0 
	MOVWF       FARG_display_fillTriangle_x0+1 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2_L2_L2+0, 0 
	MOVWF       FARG_display_fillTriangle_x1+0 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2_L2_L2+1, 0 
	MOVWF       FARG_display_fillTriangle_x1+1 
;gfx_library.h,718 :: 		}
L_display_fillTriangle141:
;gfx_library.h,720 :: 		if(y0 == y2) { // Handle awkward all-on-same-line case as its own thing
	MOVF        FARG_display_fillTriangle_y0+1, 0 
	XORWF       FARG_display_fillTriangle_y2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle395
	MOVF        FARG_display_fillTriangle_y2+0, 0 
	XORWF       FARG_display_fillTriangle_y0+0, 0 
L__display_fillTriangle395:
	BTFSS       STATUS+0, 2 
	GOTO        L_display_fillTriangle142
;gfx_library.h,721 :: 		a = b = x0;
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	MOVWF       display_fillTriangle_b_L0+0 
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	MOVWF       display_fillTriangle_b_L0+1 
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	MOVWF       display_fillTriangle_a_L0+0 
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	MOVWF       display_fillTriangle_a_L0+1 
;gfx_library.h,722 :: 		if(x1 < a)      a = x1;
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	SUBWF       FARG_display_fillTriangle_x1+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle396
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	SUBWF       FARG_display_fillTriangle_x1+0, 0 
L__display_fillTriangle396:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillTriangle143
	MOVF        FARG_display_fillTriangle_x1+0, 0 
	MOVWF       display_fillTriangle_a_L0+0 
	MOVF        FARG_display_fillTriangle_x1+1, 0 
	MOVWF       display_fillTriangle_a_L0+1 
	GOTO        L_display_fillTriangle144
L_display_fillTriangle143:
;gfx_library.h,723 :: 		else if(x1 > b) b = x1;
	MOVF        FARG_display_fillTriangle_x1+1, 0 
	SUBWF       display_fillTriangle_b_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle397
	MOVF        FARG_display_fillTriangle_x1+0, 0 
	SUBWF       display_fillTriangle_b_L0+0, 0 
L__display_fillTriangle397:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillTriangle145
	MOVF        FARG_display_fillTriangle_x1+0, 0 
	MOVWF       display_fillTriangle_b_L0+0 
	MOVF        FARG_display_fillTriangle_x1+1, 0 
	MOVWF       display_fillTriangle_b_L0+1 
L_display_fillTriangle145:
L_display_fillTriangle144:
;gfx_library.h,724 :: 		if(x2 < a)      a = x2;
	MOVF        display_fillTriangle_a_L0+1, 0 
	SUBWF       FARG_display_fillTriangle_x2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle398
	MOVF        display_fillTriangle_a_L0+0, 0 
	SUBWF       FARG_display_fillTriangle_x2+0, 0 
L__display_fillTriangle398:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillTriangle146
	MOVF        FARG_display_fillTriangle_x2+0, 0 
	MOVWF       display_fillTriangle_a_L0+0 
	MOVF        FARG_display_fillTriangle_x2+1, 0 
	MOVWF       display_fillTriangle_a_L0+1 
	GOTO        L_display_fillTriangle147
L_display_fillTriangle146:
;gfx_library.h,725 :: 		else if(x2 > b) b = x2;
	MOVF        FARG_display_fillTriangle_x2+1, 0 
	SUBWF       display_fillTriangle_b_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle399
	MOVF        FARG_display_fillTriangle_x2+0, 0 
	SUBWF       display_fillTriangle_b_L0+0, 0 
L__display_fillTriangle399:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillTriangle148
	MOVF        FARG_display_fillTriangle_x2+0, 0 
	MOVWF       display_fillTriangle_b_L0+0 
	MOVF        FARG_display_fillTriangle_x2+1, 0 
	MOVWF       display_fillTriangle_b_L0+1 
L_display_fillTriangle148:
L_display_fillTriangle147:
;gfx_library.h,726 :: 		display_drawHLine(a, y0, b-a+1, color);
	MOVF        display_fillTriangle_a_L0+0, 0 
	MOVWF       FARG_drawHLine_x+0 
	MOVF        FARG_display_fillTriangle_y0+0, 0 
	MOVWF       FARG_drawHLine_y+0 
	MOVF        display_fillTriangle_a_L0+0, 0 
	SUBWF       display_fillTriangle_b_L0+0, 0 
	MOVWF       FARG_drawHLine_w+0 
	INCF        FARG_drawHLine_w+0, 1 
	MOVF        FARG_display_fillTriangle_color+0, 0 
	MOVWF       FARG_drawHLine_color+0 
	MOVF        FARG_display_fillTriangle_color+1, 0 
	MOVWF       FARG_drawHLine_color+1 
	CALL        _drawHLine+0, 0
;gfx_library.h,727 :: 		return;
	GOTO        L_end_display_fillTriangle
;gfx_library.h,728 :: 		}
L_display_fillTriangle142:
;gfx_library.h,730 :: 		dx01 = x1 - x0;
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	SUBWF       FARG_display_fillTriangle_x1+0, 0 
	MOVWF       display_fillTriangle_dx01_L0+0 
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	SUBWFB      FARG_display_fillTriangle_x1+1, 0 
	MOVWF       display_fillTriangle_dx01_L0+1 
;gfx_library.h,731 :: 		dy01 = y1 - y0;
	MOVF        FARG_display_fillTriangle_y0+0, 0 
	SUBWF       FARG_display_fillTriangle_y1+0, 0 
	MOVWF       display_fillTriangle_dy01_L0+0 
	MOVF        FARG_display_fillTriangle_y0+1, 0 
	SUBWFB      FARG_display_fillTriangle_y1+1, 0 
	MOVWF       display_fillTriangle_dy01_L0+1 
;gfx_library.h,732 :: 		dx02 = x2 - x0;
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	SUBWF       FARG_display_fillTriangle_x2+0, 0 
	MOVWF       display_fillTriangle_dx02_L0+0 
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	SUBWFB      FARG_display_fillTriangle_x2+1, 0 
	MOVWF       display_fillTriangle_dx02_L0+1 
;gfx_library.h,733 :: 		dy02 = y2 - y0;
	MOVF        FARG_display_fillTriangle_y0+0, 0 
	SUBWF       FARG_display_fillTriangle_y2+0, 0 
	MOVWF       display_fillTriangle_dy02_L0+0 
	MOVF        FARG_display_fillTriangle_y0+1, 0 
	SUBWFB      FARG_display_fillTriangle_y2+1, 0 
	MOVWF       display_fillTriangle_dy02_L0+1 
;gfx_library.h,734 :: 		dx12 = x2 - x1;
	MOVF        FARG_display_fillTriangle_x1+0, 0 
	SUBWF       FARG_display_fillTriangle_x2+0, 0 
	MOVWF       display_fillTriangle_dx12_L0+0 
	MOVF        FARG_display_fillTriangle_x1+1, 0 
	SUBWFB      FARG_display_fillTriangle_x2+1, 0 
	MOVWF       display_fillTriangle_dx12_L0+1 
;gfx_library.h,735 :: 		dy12 = y2 - y1;
	MOVF        FARG_display_fillTriangle_y1+0, 0 
	SUBWF       FARG_display_fillTriangle_y2+0, 0 
	MOVWF       display_fillTriangle_dy12_L0+0 
	MOVF        FARG_display_fillTriangle_y1+1, 0 
	SUBWFB      FARG_display_fillTriangle_y2+1, 0 
	MOVWF       display_fillTriangle_dy12_L0+1 
;gfx_library.h,743 :: 		if(y1 == y2) last = y1;   // Include y1 scanline
	MOVF        FARG_display_fillTriangle_y1+1, 0 
	XORWF       FARG_display_fillTriangle_y2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle400
	MOVF        FARG_display_fillTriangle_y2+0, 0 
	XORWF       FARG_display_fillTriangle_y1+0, 0 
L__display_fillTriangle400:
	BTFSS       STATUS+0, 2 
	GOTO        L_display_fillTriangle149
	MOVF        FARG_display_fillTriangle_y1+0, 0 
	MOVWF       display_fillTriangle_last_L0+0 
	MOVF        FARG_display_fillTriangle_y1+1, 0 
	MOVWF       display_fillTriangle_last_L0+1 
	GOTO        L_display_fillTriangle150
L_display_fillTriangle149:
;gfx_library.h,744 :: 		else         last = y1-1; // Skip it
	MOVLW       1
	SUBWF       FARG_display_fillTriangle_y1+0, 0 
	MOVWF       display_fillTriangle_last_L0+0 
	MOVLW       0
	SUBWFB      FARG_display_fillTriangle_y1+1, 0 
	MOVWF       display_fillTriangle_last_L0+1 
L_display_fillTriangle150:
;gfx_library.h,746 :: 		for(y=y0; y<=last; y++) {
	MOVF        FARG_display_fillTriangle_y0+0, 0 
	MOVWF       display_fillTriangle_y_L0+0 
	MOVF        FARG_display_fillTriangle_y0+1, 0 
	MOVWF       display_fillTriangle_y_L0+1 
L_display_fillTriangle151:
	MOVLW       128
	XORWF       display_fillTriangle_last_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       display_fillTriangle_y_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle401
	MOVF        display_fillTriangle_y_L0+0, 0 
	SUBWF       display_fillTriangle_last_L0+0, 0 
L__display_fillTriangle401:
	BTFSS       STATUS+0, 0 
	GOTO        L_display_fillTriangle152
;gfx_library.h,747 :: 		a   = x0 + sa / dy01;
	MOVF        display_fillTriangle_dy01_L0+0, 0 
	MOVWF       R4 
	MOVF        display_fillTriangle_dy01_L0+1, 0 
	MOVWF       R5 
	MOVLW       0
	BTFSC       display_fillTriangle_dy01_L0+1, 7 
	MOVLW       255
	MOVWF       R6 
	MOVWF       R7 
	MOVF        display_fillTriangle_sa_L0+0, 0 
	MOVWF       R0 
	MOVF        display_fillTriangle_sa_L0+1, 0 
	MOVWF       R1 
	MOVF        display_fillTriangle_sa_L0+2, 0 
	MOVWF       R2 
	MOVF        display_fillTriangle_sa_L0+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_S+0, 0
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FLOC__display_fillTriangle+0 
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	ADDWFC      R1, 0 
	MOVWF       FLOC__display_fillTriangle+1 
	MOVF        FLOC__display_fillTriangle+0, 0 
	MOVWF       display_fillTriangle_a_L0+0 
	MOVF        FLOC__display_fillTriangle+1, 0 
	MOVWF       display_fillTriangle_a_L0+1 
;gfx_library.h,748 :: 		b   = x0 + sb / dy02;
	MOVF        display_fillTriangle_dy02_L0+0, 0 
	MOVWF       R4 
	MOVF        display_fillTriangle_dy02_L0+1, 0 
	MOVWF       R5 
	MOVLW       0
	BTFSC       display_fillTriangle_dy02_L0+1, 7 
	MOVLW       255
	MOVWF       R6 
	MOVWF       R7 
	MOVF        display_fillTriangle_sb_L0+0, 0 
	MOVWF       R0 
	MOVF        display_fillTriangle_sb_L0+1, 0 
	MOVWF       R1 
	MOVF        display_fillTriangle_sb_L0+2, 0 
	MOVWF       R2 
	MOVF        display_fillTriangle_sb_L0+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_S+0, 0
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	ADDWF       R0, 0 
	MOVWF       R4 
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	ADDWFC      R1, 0 
	MOVWF       R5 
	MOVF        R4, 0 
	MOVWF       display_fillTriangle_b_L0+0 
	MOVF        R5, 0 
	MOVWF       display_fillTriangle_b_L0+1 
;gfx_library.h,749 :: 		sa += dx01;
	MOVF        display_fillTriangle_dx01_L0+0, 0 
	ADDWF       display_fillTriangle_sa_L0+0, 1 
	MOVF        display_fillTriangle_dx01_L0+1, 0 
	ADDWFC      display_fillTriangle_sa_L0+1, 1 
	MOVLW       0
	BTFSC       display_fillTriangle_dx01_L0+1, 7 
	MOVLW       255
	ADDWFC      display_fillTriangle_sa_L0+2, 1 
	ADDWFC      display_fillTriangle_sa_L0+3, 1 
;gfx_library.h,750 :: 		sb += dx02;
	MOVF        display_fillTriangle_dx02_L0+0, 0 
	ADDWF       display_fillTriangle_sb_L0+0, 1 
	MOVF        display_fillTriangle_dx02_L0+1, 0 
	ADDWFC      display_fillTriangle_sb_L0+1, 1 
	MOVLW       0
	BTFSC       display_fillTriangle_dx02_L0+1, 7 
	MOVLW       255
	ADDWFC      display_fillTriangle_sb_L0+2, 1 
	ADDWFC      display_fillTriangle_sb_L0+3, 1 
;gfx_library.h,755 :: 		if(a > b) _swap_int16_t(a,b);
	MOVLW       128
	XORWF       R5, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FLOC__display_fillTriangle+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle402
	MOVF        FLOC__display_fillTriangle+0, 0 
	SUBWF       R4, 0 
L__display_fillTriangle402:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillTriangle154
	MOVF        display_fillTriangle_a_L0+0, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2_L2_L2_L2+0 
	MOVF        display_fillTriangle_a_L0+1, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2_L2_L2_L2+1 
	MOVF        display_fillTriangle_b_L0+0, 0 
	MOVWF       display_fillTriangle_a_L0+0 
	MOVF        display_fillTriangle_b_L0+1, 0 
	MOVWF       display_fillTriangle_a_L0+1 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2_L2_L2_L2+0, 0 
	MOVWF       display_fillTriangle_b_L0+0 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2_L2_L2_L2+1, 0 
	MOVWF       display_fillTriangle_b_L0+1 
L_display_fillTriangle154:
;gfx_library.h,756 :: 		display_drawHLine(a, y, b-a+1, color);
	MOVF        display_fillTriangle_a_L0+0, 0 
	MOVWF       FARG_drawHLine_x+0 
	MOVF        display_fillTriangle_y_L0+0, 0 
	MOVWF       FARG_drawHLine_y+0 
	MOVF        display_fillTriangle_a_L0+0, 0 
	SUBWF       display_fillTriangle_b_L0+0, 0 
	MOVWF       FARG_drawHLine_w+0 
	INCF        FARG_drawHLine_w+0, 1 
	MOVF        FARG_display_fillTriangle_color+0, 0 
	MOVWF       FARG_drawHLine_color+0 
	MOVF        FARG_display_fillTriangle_color+1, 0 
	MOVWF       FARG_drawHLine_color+1 
	CALL        _drawHLine+0, 0
;gfx_library.h,746 :: 		for(y=y0; y<=last; y++) {
	INFSNZ      display_fillTriangle_y_L0+0, 1 
	INCF        display_fillTriangle_y_L0+1, 1 
;gfx_library.h,757 :: 		}
	GOTO        L_display_fillTriangle151
L_display_fillTriangle152:
;gfx_library.h,761 :: 		sa = dx12 * (y - y1);
	MOVF        FARG_display_fillTriangle_y1+0, 0 
	SUBWF       display_fillTriangle_y_L0+0, 0 
	MOVWF       R0 
	MOVF        FARG_display_fillTriangle_y1+1, 0 
	SUBWFB      display_fillTriangle_y_L0+1, 0 
	MOVWF       R1 
	MOVF        display_fillTriangle_dx12_L0+0, 0 
	MOVWF       R4 
	MOVF        display_fillTriangle_dx12_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       display_fillTriangle_sa_L0+0 
	MOVF        R1, 0 
	MOVWF       display_fillTriangle_sa_L0+1 
	MOVLW       0
	MOVWF       display_fillTriangle_sa_L0+2 
	MOVWF       display_fillTriangle_sa_L0+3 
;gfx_library.h,762 :: 		sb = dx02 * (y - y0);
	MOVF        FARG_display_fillTriangle_y0+0, 0 
	SUBWF       display_fillTriangle_y_L0+0, 0 
	MOVWF       R0 
	MOVF        FARG_display_fillTriangle_y0+1, 0 
	SUBWFB      display_fillTriangle_y_L0+1, 0 
	MOVWF       R1 
	MOVF        display_fillTriangle_dx02_L0+0, 0 
	MOVWF       R4 
	MOVF        display_fillTriangle_dx02_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       display_fillTriangle_sb_L0+0 
	MOVF        R1, 0 
	MOVWF       display_fillTriangle_sb_L0+1 
	MOVLW       0
	MOVWF       display_fillTriangle_sb_L0+2 
	MOVWF       display_fillTriangle_sb_L0+3 
;gfx_library.h,763 :: 		for(; y<=y2; y++) {
L_display_fillTriangle155:
	MOVF        display_fillTriangle_y_L0+1, 0 
	SUBWF       FARG_display_fillTriangle_y2+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle403
	MOVF        display_fillTriangle_y_L0+0, 0 
	SUBWF       FARG_display_fillTriangle_y2+0, 0 
L__display_fillTriangle403:
	BTFSS       STATUS+0, 0 
	GOTO        L_display_fillTriangle156
;gfx_library.h,764 :: 		a   = x1 + sa / dy12;
	MOVF        display_fillTriangle_dy12_L0+0, 0 
	MOVWF       R4 
	MOVF        display_fillTriangle_dy12_L0+1, 0 
	MOVWF       R5 
	MOVLW       0
	BTFSC       display_fillTriangle_dy12_L0+1, 7 
	MOVLW       255
	MOVWF       R6 
	MOVWF       R7 
	MOVF        display_fillTriangle_sa_L0+0, 0 
	MOVWF       R0 
	MOVF        display_fillTriangle_sa_L0+1, 0 
	MOVWF       R1 
	MOVF        display_fillTriangle_sa_L0+2, 0 
	MOVWF       R2 
	MOVF        display_fillTriangle_sa_L0+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_S+0, 0
	MOVF        FARG_display_fillTriangle_x1+0, 0 
	ADDWF       R0, 0 
	MOVWF       FLOC__display_fillTriangle+0 
	MOVF        FARG_display_fillTriangle_x1+1, 0 
	ADDWFC      R1, 0 
	MOVWF       FLOC__display_fillTriangle+1 
	MOVF        FLOC__display_fillTriangle+0, 0 
	MOVWF       display_fillTriangle_a_L0+0 
	MOVF        FLOC__display_fillTriangle+1, 0 
	MOVWF       display_fillTriangle_a_L0+1 
;gfx_library.h,765 :: 		b   = x0 + sb / dy02;
	MOVF        display_fillTriangle_dy02_L0+0, 0 
	MOVWF       R4 
	MOVF        display_fillTriangle_dy02_L0+1, 0 
	MOVWF       R5 
	MOVLW       0
	BTFSC       display_fillTriangle_dy02_L0+1, 7 
	MOVLW       255
	MOVWF       R6 
	MOVWF       R7 
	MOVF        display_fillTriangle_sb_L0+0, 0 
	MOVWF       R0 
	MOVF        display_fillTriangle_sb_L0+1, 0 
	MOVWF       R1 
	MOVF        display_fillTriangle_sb_L0+2, 0 
	MOVWF       R2 
	MOVF        display_fillTriangle_sb_L0+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_S+0, 0
	MOVF        FARG_display_fillTriangle_x0+0, 0 
	ADDWF       R0, 0 
	MOVWF       R4 
	MOVF        FARG_display_fillTriangle_x0+1, 0 
	ADDWFC      R1, 0 
	MOVWF       R5 
	MOVF        R4, 0 
	MOVWF       display_fillTriangle_b_L0+0 
	MOVF        R5, 0 
	MOVWF       display_fillTriangle_b_L0+1 
;gfx_library.h,766 :: 		sa += dx12;
	MOVF        display_fillTriangle_dx12_L0+0, 0 
	ADDWF       display_fillTriangle_sa_L0+0, 1 
	MOVF        display_fillTriangle_dx12_L0+1, 0 
	ADDWFC      display_fillTriangle_sa_L0+1, 1 
	MOVLW       0
	BTFSC       display_fillTriangle_dx12_L0+1, 7 
	MOVLW       255
	ADDWFC      display_fillTriangle_sa_L0+2, 1 
	ADDWFC      display_fillTriangle_sa_L0+3, 1 
;gfx_library.h,767 :: 		sb += dx02;
	MOVF        display_fillTriangle_dx02_L0+0, 0 
	ADDWF       display_fillTriangle_sb_L0+0, 1 
	MOVF        display_fillTriangle_dx02_L0+1, 0 
	ADDWFC      display_fillTriangle_sb_L0+1, 1 
	MOVLW       0
	BTFSC       display_fillTriangle_dx02_L0+1, 7 
	MOVLW       255
	ADDWFC      display_fillTriangle_sb_L0+2, 1 
	ADDWFC      display_fillTriangle_sb_L0+3, 1 
;gfx_library.h,772 :: 		if(a > b) _swap_int16_t(a,b);
	MOVLW       128
	XORWF       R5, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FLOC__display_fillTriangle+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_fillTriangle404
	MOVF        FLOC__display_fillTriangle+0, 0 
	SUBWF       R4, 0 
L__display_fillTriangle404:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_fillTriangle158
	MOVF        display_fillTriangle_a_L0+0, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2_L2_L2_L2_L2+0 
	MOVF        display_fillTriangle_a_L0+1, 0 
	MOVWF       display_fillTriangle_t_L2_L2_L2_L2_L2_L2_L2_L2+1 
	MOVF        display_fillTriangle_b_L0+0, 0 
	MOVWF       display_fillTriangle_a_L0+0 
	MOVF        display_fillTriangle_b_L0+1, 0 
	MOVWF       display_fillTriangle_a_L0+1 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2_L2_L2_L2_L2+0, 0 
	MOVWF       display_fillTriangle_b_L0+0 
	MOVF        display_fillTriangle_t_L2_L2_L2_L2_L2_L2_L2_L2+1, 0 
	MOVWF       display_fillTriangle_b_L0+1 
L_display_fillTriangle158:
;gfx_library.h,773 :: 		display_drawHLine(a, y, b-a+1, color);
	MOVF        display_fillTriangle_a_L0+0, 0 
	MOVWF       FARG_drawHLine_x+0 
	MOVF        display_fillTriangle_y_L0+0, 0 
	MOVWF       FARG_drawHLine_y+0 
	MOVF        display_fillTriangle_a_L0+0, 0 
	SUBWF       display_fillTriangle_b_L0+0, 0 
	MOVWF       FARG_drawHLine_w+0 
	INCF        FARG_drawHLine_w+0, 1 
	MOVF        FARG_display_fillTriangle_color+0, 0 
	MOVWF       FARG_drawHLine_color+0 
	MOVF        FARG_display_fillTriangle_color+1, 0 
	MOVWF       FARG_drawHLine_color+1 
	CALL        _drawHLine+0, 0
;gfx_library.h,763 :: 		for(; y<=y2; y++) {
	INFSNZ      display_fillTriangle_y_L0+0, 1 
	INCF        display_fillTriangle_y_L0+1, 1 
;gfx_library.h,774 :: 		}
	GOTO        L_display_fillTriangle155
L_display_fillTriangle156:
;gfx_library.h,775 :: 		}
L_end_display_fillTriangle:
	RETURN      0
; end of _display_fillTriangle

_display_putc:

;gfx_library.h,783 :: 		void display_putc(uint8_t c) {
;gfx_library.h,785 :: 		if (c == ' ' && cursor_x == 0 && wrap)
	MOVF        FARG_display_putc_c+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_display_putc161
	MOVLW       0
	XORWF       _cursor_x+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_putc406
	MOVLW       0
	XORWF       _cursor_x+0, 0 
L__display_putc406:
	BTFSS       STATUS+0, 2 
	GOTO        L_display_putc161
	MOVF        _wrap+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_display_putc161
L__display_putc330:
;gfx_library.h,786 :: 		return;
	GOTO        L_end_display_putc
L_display_putc161:
;gfx_library.h,787 :: 		if(c == '\r') {
	MOVF        FARG_display_putc_c+0, 0 
	XORLW       13
	BTFSS       STATUS+0, 2 
	GOTO        L_display_putc162
;gfx_library.h,788 :: 		cursor_x = 0;
	CLRF        _cursor_x+0 
	CLRF        _cursor_x+1 
;gfx_library.h,789 :: 		return;
	GOTO        L_end_display_putc
;gfx_library.h,790 :: 		}
L_display_putc162:
;gfx_library.h,791 :: 		if(c == '\n') {
	MOVF        FARG_display_putc_c+0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_display_putc163
;gfx_library.h,792 :: 		cursor_y += textsize * 8;
	MOVLW       3
	MOVWF       R2 
	MOVF        _textsize+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__display_putc407:
	BZ          L__display_putc408
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__display_putc407
L__display_putc408:
	MOVF        R0, 0 
	ADDWF       _cursor_y+0, 1 
	MOVF        R1, 0 
	ADDWFC      _cursor_y+1, 1 
;gfx_library.h,793 :: 		return;
	GOTO        L_end_display_putc
;gfx_library.h,794 :: 		}
L_display_putc163:
;gfx_library.h,796 :: 		for(i = 0; i < 5; i++ ) {
	CLRF        display_putc_i_L0+0 
L_display_putc164:
	MOVLW       5
	SUBWF       display_putc_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_display_putc165
;gfx_library.h,797 :: 		uint8_t line = font[c][i];
	MOVLW       5
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	MOVF        FARG_display_putc_c+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVLW       fdene_font+0
	ADDWF       R0, 1 
	MOVLW       hi_addr(fdene_font+0)
	ADDWFC      R1, 1 
	MOVLW       higher_addr(fdene_font+0)
	ADDWFC      R2, 1 
	MOVF        display_putc_i_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       TBLPTR+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      R2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, display_putc_line_L1+0
;gfx_library.h,798 :: 		for(j = 0; j < 8; j++, line >>= 1) {
	CLRF        display_putc_j_L0+0 
L_display_putc167:
	MOVLW       8
	SUBWF       display_putc_j_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_display_putc168
;gfx_library.h,799 :: 		if(line & 1) {
	BTFSS       display_putc_line_L1+0, 0 
	GOTO        L_display_putc170
;gfx_library.h,800 :: 		if(textsize == 1)
	MOVF        _textsize+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_display_putc171
;gfx_library.h,801 :: 		display_drawPixel(cursor_x + i, cursor_y + j, textcolor);
	MOVF        display_putc_i_L0+0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_putc_j_L0+0, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        _textcolor+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        _textcolor+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
	GOTO        L_display_putc172
L_display_putc171:
;gfx_library.h,803 :: 		display_fillRect(cursor_x + i * textsize, cursor_y + j * textsize, textsize, textsize, textcolor);
	MOVF        display_putc_i_L0+0, 0 
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_fillRect_x+0 
	MOVF        display_putc_j_L0+0, 0 
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       FARG_fillRect_y+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_w+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_h+0 
	MOVF        _textcolor+0, 0 
	MOVWF       FARG_fillRect_color+0 
	MOVF        _textcolor+1, 0 
	MOVWF       FARG_fillRect_color+1 
	CALL        _fillRect+0, 0
L_display_putc172:
;gfx_library.h,804 :: 		}
	GOTO        L_display_putc173
L_display_putc170:
;gfx_library.h,806 :: 		if(textbgcolor != textcolor) {
	MOVF        _textbgcolor+1, 0 
	XORWF       _textcolor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_putc409
	MOVF        _textcolor+0, 0 
	XORWF       _textbgcolor+0, 0 
L__display_putc409:
	BTFSC       STATUS+0, 2 
	GOTO        L_display_putc174
;gfx_library.h,807 :: 		if(textsize == 1)
	MOVF        _textsize+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_display_putc175
;gfx_library.h,808 :: 		display_drawPixel(cursor_x + i, cursor_y + j, textbgcolor);
	MOVF        display_putc_i_L0+0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_putc_j_L0+0, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        _textbgcolor+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        _textbgcolor+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
	GOTO        L_display_putc176
L_display_putc175:
;gfx_library.h,810 :: 		display_fillRect(cursor_x + i * textsize, cursor_y + j * textsize, textsize, textsize, textbgcolor);
	MOVF        display_putc_i_L0+0, 0 
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_fillRect_x+0 
	MOVF        display_putc_j_L0+0, 0 
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       FARG_fillRect_y+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_w+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_h+0 
	MOVF        _textbgcolor+0, 0 
	MOVWF       FARG_fillRect_color+0 
	MOVF        _textbgcolor+1, 0 
	MOVWF       FARG_fillRect_color+1 
	CALL        _fillRect+0, 0
L_display_putc176:
;gfx_library.h,811 :: 		}
L_display_putc174:
L_display_putc173:
;gfx_library.h,798 :: 		for(j = 0; j < 8; j++, line >>= 1) {
	INCF        display_putc_j_L0+0, 1 
	RRCF        display_putc_line_L1+0, 1 
	BCF         display_putc_line_L1+0, 7 
;gfx_library.h,812 :: 		}
	GOTO        L_display_putc167
L_display_putc168:
;gfx_library.h,796 :: 		for(i = 0; i < 5; i++ ) {
	INCF        display_putc_i_L0+0, 1 
;gfx_library.h,813 :: 		}
	GOTO        L_display_putc164
L_display_putc165:
;gfx_library.h,815 :: 		if(textbgcolor != textcolor) {  // If opaque, draw vertical line for last column
	MOVF        _textbgcolor+1, 0 
	XORWF       _textcolor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_putc410
	MOVF        _textcolor+0, 0 
	XORWF       _textbgcolor+0, 0 
L__display_putc410:
	BTFSC       STATUS+0, 2 
	GOTO        L_display_putc177
;gfx_library.h,816 :: 		if(textsize == 1)  display_drawVLine(cursor_x + 5, cursor_y, 8, textbgcolor);
	MOVF        _textsize+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_display_putc178
	MOVLW       5
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        _cursor_y+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVLW       8
	MOVWF       FARG_drawVLine_h+0 
	MOVF        _textbgcolor+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        _textbgcolor+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
	GOTO        L_display_putc179
L_display_putc178:
;gfx_library.h,817 :: 		else               display_fillRect(cursor_x + 5 * textsize, cursor_y, textsize, 8 * textsize, textbgcolor);
	MOVLW       5
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_fillRect_x+0 
	MOVF        _cursor_y+0, 0 
	MOVWF       FARG_fillRect_y+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_w+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_h+0 
	RLCF        FARG_fillRect_h+0, 1 
	BCF         FARG_fillRect_h+0, 0 
	RLCF        FARG_fillRect_h+0, 1 
	BCF         FARG_fillRect_h+0, 0 
	RLCF        FARG_fillRect_h+0, 1 
	BCF         FARG_fillRect_h+0, 0 
	MOVF        _textbgcolor+0, 0 
	MOVWF       FARG_fillRect_color+0 
	MOVF        _textbgcolor+1, 0 
	MOVWF       FARG_fillRect_color+1 
	CALL        _fillRect+0, 0
L_display_putc179:
;gfx_library.h,818 :: 		}
L_display_putc177:
;gfx_library.h,820 :: 		cursor_x += textsize * 6;
	MOVLW       6
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        PRODH+0, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       R4 
	MOVF        R3, 0 
	ADDWFC      _cursor_x+1, 0 
	MOVWF       R5 
	MOVF        R4, 0 
	MOVWF       _cursor_x+0 
	MOVF        R5, 0 
	MOVWF       _cursor_x+1 
;gfx_library.h,822 :: 		if( cursor_x > ((uint16_t)display_width + textsize * 6) )
	MOVF        __width+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R0, 0 
	ADDWF       R2, 1 
	MOVF        R1, 0 
	ADDWFC      R3, 1 
	MOVF        R5, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_putc411
	MOVF        R4, 0 
	SUBWF       R2, 0 
L__display_putc411:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_putc180
;gfx_library.h,823 :: 		cursor_x = display_width;
	MOVF        __width+0, 0 
	MOVWF       _cursor_x+0 
	MOVLW       0
	MOVWF       _cursor_x+1 
L_display_putc180:
;gfx_library.h,825 :: 		if (wrap && (cursor_x + (textsize * 5)) > display_width)
	MOVF        _wrap+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_display_putc183
	MOVLW       5
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        PRODH+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	ADDWFC      _cursor_x+1, 0 
	MOVWF       R3 
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_putc412
	MOVF        R2, 0 
	SUBWF       __width+0, 0 
L__display_putc412:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_putc183
L__display_putc329:
;gfx_library.h,827 :: 		cursor_x = 0;
	CLRF        _cursor_x+0 
	CLRF        _cursor_x+1 
;gfx_library.h,828 :: 		cursor_y += textsize * 8;
	MOVLW       3
	MOVWF       R0 
	MOVF        _textsize+0, 0 
	MOVWF       R2 
	MOVLW       0
	MOVWF       R3 
	MOVF        R0, 0 
L__display_putc413:
	BZ          L__display_putc414
	RLCF        R2, 1 
	BCF         R2, 0 
	RLCF        R3, 1 
	ADDLW       255
	GOTO        L__display_putc413
L__display_putc414:
	MOVF        R2, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       R4 
	MOVF        R3, 0 
	ADDWFC      _cursor_y+1, 0 
	MOVWF       R5 
	MOVF        R4, 0 
	MOVWF       _cursor_y+0 
	MOVF        R5, 0 
	MOVWF       _cursor_y+1 
;gfx_library.h,829 :: 		if( cursor_y > ((uint16_t)display_height + textsize * 8) )
	MOVF        __height+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R0, 0 
	ADDWF       R2, 1 
	MOVF        R1, 0 
	ADDWFC      R3, 1 
	MOVF        R5, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_putc415
	MOVF        R4, 0 
	SUBWF       R2, 0 
L__display_putc415:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_putc184
;gfx_library.h,830 :: 		cursor_y = display_height;
	MOVF        __height+0, 0 
	MOVWF       _cursor_y+0 
	MOVLW       0
	MOVWF       _cursor_y+1 
L_display_putc184:
;gfx_library.h,831 :: 		}
L_display_putc183:
;gfx_library.h,832 :: 		}
L_end_display_putc:
	RETURN      0
; end of _display_putc

_display_puts:

;gfx_library.h,835 :: 		void display_puts(uint8_t *s) {
;gfx_library.h,836 :: 		while(*s)
L_display_puts185:
	MOVFF       FARG_display_puts_s+0, FSR0L+0
	MOVFF       FARG_display_puts_s+1, FSR0H+0
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_display_puts186
;gfx_library.h,837 :: 		display_putc(*s++);
	MOVFF       FARG_display_puts_s+0, FSR0L+0
	MOVFF       FARG_display_puts_s+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
	INFSNZ      FARG_display_puts_s+0, 1 
	INCF        FARG_display_puts_s+1, 1 
	GOTO        L_display_puts185
L_display_puts186:
;gfx_library.h,838 :: 		}
L_end_display_puts:
	RETURN      0
; end of _display_puts

_display_customChar:

;gfx_library.h,841 :: 		void display_customChar(const uint8_t *c) {
;gfx_library.h,843 :: 		for(i = 0; i < 5; i++ ) {
	CLRF        display_customChar_i_L0+0 
L_display_customChar187:
	MOVLW       5
	SUBWF       display_customChar_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_display_customChar188
;gfx_library.h,844 :: 		uint8_t line = c[i];
	MOVF        display_customChar_i_L0+0, 0 
	ADDWF       FARG_display_customChar_c+0, 0 
	MOVWF       TBLPTR+0 
	MOVLW       0
	ADDWFC      FARG_display_customChar_c+1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      FARG_display_customChar_c+2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, display_customChar_line_L1+0
;gfx_library.h,845 :: 		for(j = 0; j < 8; j++, line >>= 1) {
	CLRF        display_customChar_j_L0+0 
L_display_customChar190:
	MOVLW       8
	SUBWF       display_customChar_j_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_display_customChar191
;gfx_library.h,846 :: 		if(line & 1) {
	BTFSS       display_customChar_line_L1+0, 0 
	GOTO        L_display_customChar193
;gfx_library.h,847 :: 		if(textsize == 1)
	MOVF        _textsize+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_display_customChar194
;gfx_library.h,848 :: 		display_drawPixel(cursor_x + i, cursor_y + j, textcolor);
	MOVF        display_customChar_i_L0+0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_customChar_j_L0+0, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        _textcolor+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        _textcolor+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
	GOTO        L_display_customChar195
L_display_customChar194:
;gfx_library.h,850 :: 		display_fillRect(cursor_x + i * textsize, cursor_y + j * textsize, textsize, textsize, textcolor);
	MOVF        display_customChar_i_L0+0, 0 
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_fillRect_x+0 
	MOVF        display_customChar_j_L0+0, 0 
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       FARG_fillRect_y+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_w+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_h+0 
	MOVF        _textcolor+0, 0 
	MOVWF       FARG_fillRect_color+0 
	MOVF        _textcolor+1, 0 
	MOVWF       FARG_fillRect_color+1 
	CALL        _fillRect+0, 0
L_display_customChar195:
;gfx_library.h,851 :: 		}
	GOTO        L_display_customChar196
L_display_customChar193:
;gfx_library.h,853 :: 		if(textbgcolor != textcolor) {
	MOVF        _textbgcolor+1, 0 
	XORWF       _textcolor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_customChar418
	MOVF        _textcolor+0, 0 
	XORWF       _textbgcolor+0, 0 
L__display_customChar418:
	BTFSC       STATUS+0, 2 
	GOTO        L_display_customChar197
;gfx_library.h,854 :: 		if(textsize == 1)
	MOVF        _textsize+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_display_customChar198
;gfx_library.h,855 :: 		display_drawPixel(cursor_x + i, cursor_y + j, textbgcolor);
	MOVF        display_customChar_i_L0+0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        display_customChar_j_L0+0, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        _textbgcolor+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        _textbgcolor+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
	GOTO        L_display_customChar199
L_display_customChar198:
;gfx_library.h,857 :: 		display_fillRect(cursor_x + i * textsize, cursor_y + j * textsize, textsize, textsize, textbgcolor);
	MOVF        display_customChar_i_L0+0, 0 
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_fillRect_x+0 
	MOVF        display_customChar_j_L0+0, 0 
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       FARG_fillRect_y+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_w+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_h+0 
	MOVF        _textbgcolor+0, 0 
	MOVWF       FARG_fillRect_color+0 
	MOVF        _textbgcolor+1, 0 
	MOVWF       FARG_fillRect_color+1 
	CALL        _fillRect+0, 0
L_display_customChar199:
;gfx_library.h,858 :: 		}
L_display_customChar197:
L_display_customChar196:
;gfx_library.h,845 :: 		for(j = 0; j < 8; j++, line >>= 1) {
	INCF        display_customChar_j_L0+0, 1 
	RRCF        display_customChar_line_L1+0, 1 
	BCF         display_customChar_line_L1+0, 7 
;gfx_library.h,859 :: 		}
	GOTO        L_display_customChar190
L_display_customChar191:
;gfx_library.h,843 :: 		for(i = 0; i < 5; i++ ) {
	INCF        display_customChar_i_L0+0, 1 
;gfx_library.h,860 :: 		}
	GOTO        L_display_customChar187
L_display_customChar188:
;gfx_library.h,862 :: 		if(textbgcolor != textcolor) {  // If opaque, draw vertical line for last column
	MOVF        _textbgcolor+1, 0 
	XORWF       _textcolor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_customChar419
	MOVF        _textcolor+0, 0 
	XORWF       _textbgcolor+0, 0 
L__display_customChar419:
	BTFSC       STATUS+0, 2 
	GOTO        L_display_customChar200
;gfx_library.h,863 :: 		if(textsize == 1)  display_drawVLine(cursor_x + 5, cursor_y, 8, textbgcolor);
	MOVF        _textsize+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_display_customChar201
	MOVLW       5
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_drawVLine_x+0 
	MOVF        _cursor_y+0, 0 
	MOVWF       FARG_drawVLine_y+0 
	MOVLW       8
	MOVWF       FARG_drawVLine_h+0 
	MOVF        _textbgcolor+0, 0 
	MOVWF       FARG_drawVLine_color+0 
	MOVF        _textbgcolor+1, 0 
	MOVWF       FARG_drawVLine_color+1 
	CALL        _drawVLine+0, 0
	GOTO        L_display_customChar202
L_display_customChar201:
;gfx_library.h,864 :: 		else               display_fillRect(cursor_x + 5 * textsize, cursor_y, textsize, 8 * textsize, textbgcolor);
	MOVLW       5
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       FARG_fillRect_x+0 
	MOVF        _cursor_y+0, 0 
	MOVWF       FARG_fillRect_y+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_w+0 
	MOVF        _textsize+0, 0 
	MOVWF       FARG_fillRect_h+0 
	RLCF        FARG_fillRect_h+0, 1 
	BCF         FARG_fillRect_h+0, 0 
	RLCF        FARG_fillRect_h+0, 1 
	BCF         FARG_fillRect_h+0, 0 
	RLCF        FARG_fillRect_h+0, 1 
	BCF         FARG_fillRect_h+0, 0 
	MOVF        _textbgcolor+0, 0 
	MOVWF       FARG_fillRect_color+0 
	MOVF        _textbgcolor+1, 0 
	MOVWF       FARG_fillRect_color+1 
	CALL        _fillRect+0, 0
L_display_customChar202:
;gfx_library.h,865 :: 		}
L_display_customChar200:
;gfx_library.h,867 :: 		cursor_x += textsize * 6;
	MOVLW       6
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R2 
	MOVF        PRODH+0, 0 
	MOVWF       R3 
	MOVF        R2, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       R4 
	MOVF        R3, 0 
	ADDWFC      _cursor_x+1, 0 
	MOVWF       R5 
	MOVF        R4, 0 
	MOVWF       _cursor_x+0 
	MOVF        R5, 0 
	MOVWF       _cursor_x+1 
;gfx_library.h,869 :: 		if( cursor_x > ((uint16_t)display_width + textsize * 6) )
	MOVF        __width+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R0, 0 
	ADDWF       R2, 1 
	MOVF        R1, 0 
	ADDWFC      R3, 1 
	MOVF        R5, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_customChar420
	MOVF        R4, 0 
	SUBWF       R2, 0 
L__display_customChar420:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_customChar203
;gfx_library.h,870 :: 		cursor_x = display_width;
	MOVF        __width+0, 0 
	MOVWF       _cursor_x+0 
	MOVLW       0
	MOVWF       _cursor_x+1 
L_display_customChar203:
;gfx_library.h,872 :: 		if (wrap && (cursor_x + (textsize * 5)) > display_width)
	MOVF        _wrap+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_display_customChar206
	MOVLW       5
	MULWF       _textsize+0 
	MOVF        PRODL+0, 0 
	MOVWF       R0 
	MOVF        PRODH+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	ADDWF       _cursor_x+0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	ADDWFC      _cursor_x+1, 0 
	MOVWF       R3 
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_customChar421
	MOVF        R2, 0 
	SUBWF       __width+0, 0 
L__display_customChar421:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_customChar206
L__display_customChar331:
;gfx_library.h,874 :: 		cursor_x = 0;
	CLRF        _cursor_x+0 
	CLRF        _cursor_x+1 
;gfx_library.h,875 :: 		cursor_y += textsize * 8;
	MOVLW       3
	MOVWF       R0 
	MOVF        _textsize+0, 0 
	MOVWF       R2 
	MOVLW       0
	MOVWF       R3 
	MOVF        R0, 0 
L__display_customChar422:
	BZ          L__display_customChar423
	RLCF        R2, 1 
	BCF         R2, 0 
	RLCF        R3, 1 
	ADDLW       255
	GOTO        L__display_customChar422
L__display_customChar423:
	MOVF        R2, 0 
	ADDWF       _cursor_y+0, 0 
	MOVWF       R4 
	MOVF        R3, 0 
	ADDWFC      _cursor_y+1, 0 
	MOVWF       R5 
	MOVF        R4, 0 
	MOVWF       _cursor_y+0 
	MOVF        R5, 0 
	MOVWF       _cursor_y+1 
;gfx_library.h,876 :: 		if( cursor_y > ((uint16_t)display_height + textsize * 8) )
	MOVF        __height+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R0, 0 
	ADDWF       R2, 1 
	MOVF        R1, 0 
	ADDWFC      R3, 1 
	MOVF        R5, 0 
	SUBWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_customChar424
	MOVF        R4, 0 
	SUBWF       R2, 0 
L__display_customChar424:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_customChar207
;gfx_library.h,877 :: 		cursor_y = display_height;
	MOVF        __height+0, 0 
	MOVWF       _cursor_y+0 
	MOVLW       0
	MOVWF       _cursor_y+1 
L_display_customChar207:
;gfx_library.h,878 :: 		}
L_display_customChar206:
;gfx_library.h,879 :: 		}
L_end_display_customChar:
	RETURN      0
; end of _display_customChar

_display_drawChar:

;gfx_library.h,893 :: 		uint8_t size) {
;gfx_library.h,894 :: 		uint16_t prev_x     = cursor_x,
	MOVF        _cursor_x+0, 0 
	MOVWF       display_drawChar_prev_x_L0+0 
	MOVF        _cursor_x+1, 0 
	MOVWF       display_drawChar_prev_x_L0+1 
;gfx_library.h,895 :: 		prev_y     = cursor_y,
	MOVF        _cursor_y+0, 0 
	MOVWF       display_drawChar_prev_y_L0+0 
	MOVF        _cursor_y+1, 0 
	MOVWF       display_drawChar_prev_y_L0+1 
;gfx_library.h,896 :: 		prev_color = textcolor,
	MOVF        _textcolor+0, 0 
	MOVWF       display_drawChar_prev_color_L0+0 
	MOVF        _textcolor+1, 0 
	MOVWF       display_drawChar_prev_color_L0+1 
;gfx_library.h,897 :: 		prev_bg    = textbgcolor;
	MOVF        _textbgcolor+0, 0 
	MOVWF       display_drawChar_prev_bg_L0+0 
	MOVF        _textbgcolor+1, 0 
	MOVWF       display_drawChar_prev_bg_L0+1 
;gfx_library.h,898 :: 		uint8_t  prev_size  = textsize;
	MOVF        _textsize+0, 0 
	MOVWF       display_drawChar_prev_size_L0+0 
;gfx_library.h,900 :: 		display_setCursor(x, y);
	MOVF        FARG_display_drawChar_x+0, 0 
	MOVWF       FARG_display_setCursor_x+0 
	MOVF        FARG_display_drawChar_x+1, 0 
	MOVWF       FARG_display_setCursor_x+1 
	MOVF        FARG_display_drawChar_y+0, 0 
	MOVWF       FARG_display_setCursor_y+0 
	MOVF        FARG_display_drawChar_y+1, 0 
	MOVWF       FARG_display_setCursor_y+1 
	CALL        _display_setCursor+0, 0
;gfx_library.h,901 :: 		display_setTextSize(size);
	MOVF        FARG_display_drawChar_size+0, 0 
	MOVWF       FARG_display_setTextSize_s+0 
	CALL        _display_setTextSize+0, 0
;gfx_library.h,902 :: 		display_setTextColor(color, bg);
	MOVF        FARG_display_drawChar_color+0, 0 
	MOVWF       FARG_display_setTextColor_c+0 
	MOVF        FARG_display_drawChar_color+1, 0 
	MOVWF       FARG_display_setTextColor_c+1 
	MOVF        FARG_display_drawChar_bg+0, 0 
	MOVWF       FARG_display_setTextColor_bg+0 
	MOVF        FARG_display_drawChar_bg+1, 0 
	MOVWF       FARG_display_setTextColor_bg+1 
	CALL        _display_setTextColor+0, 0
;gfx_library.h,903 :: 		display_putc(c);
	MOVF        FARG_display_drawChar_c+0, 0 
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
;gfx_library.h,905 :: 		cursor_x    = prev_x;
	MOVF        display_drawChar_prev_x_L0+0, 0 
	MOVWF       _cursor_x+0 
	MOVF        display_drawChar_prev_x_L0+1, 0 
	MOVWF       _cursor_x+1 
;gfx_library.h,906 :: 		cursor_y    = prev_y;
	MOVF        display_drawChar_prev_y_L0+0, 0 
	MOVWF       _cursor_y+0 
	MOVF        display_drawChar_prev_y_L0+1, 0 
	MOVWF       _cursor_y+1 
;gfx_library.h,907 :: 		textcolor   = prev_color;
	MOVF        display_drawChar_prev_color_L0+0, 0 
	MOVWF       _textcolor+0 
	MOVF        display_drawChar_prev_color_L0+1, 0 
	MOVWF       _textcolor+1 
;gfx_library.h,908 :: 		textbgcolor = prev_bg;
	MOVF        display_drawChar_prev_bg_L0+0, 0 
	MOVWF       _textbgcolor+0 
	MOVF        display_drawChar_prev_bg_L0+1, 0 
	MOVWF       _textbgcolor+1 
;gfx_library.h,909 :: 		textsize    = prev_size;
	MOVF        display_drawChar_prev_size_L0+0, 0 
	MOVWF       _textsize+0 
;gfx_library.h,910 :: 		}
L_end_display_drawChar:
	RETURN      0
; end of _display_drawChar

_display_setCursor:

;gfx_library.h,919 :: 		void display_setCursor(uint16_t x, uint16_t y) {
;gfx_library.h,920 :: 		cursor_x = x;
	MOVF        FARG_display_setCursor_x+0, 0 
	MOVWF       _cursor_x+0 
	MOVF        FARG_display_setCursor_x+1, 0 
	MOVWF       _cursor_x+1 
;gfx_library.h,921 :: 		cursor_y = y;
	MOVF        FARG_display_setCursor_y+0, 0 
	MOVWF       _cursor_y+0 
	MOVF        FARG_display_setCursor_y+1, 0 
	MOVWF       _cursor_y+1 
;gfx_library.h,922 :: 		}
L_end_display_setCursor:
	RETURN      0
; end of _display_setCursor

_display_getCursorX:

;gfx_library.h,930 :: 		uint16_t display_getCursorX(void) {
;gfx_library.h,931 :: 		return cursor_x;
	MOVF        _cursor_x+0, 0 
	MOVWF       R0 
	MOVF        _cursor_x+1, 0 
	MOVWF       R1 
;gfx_library.h,932 :: 		}
L_end_display_getCursorX:
	RETURN      0
; end of _display_getCursorX

_display_getCursorY:

;gfx_library.h,940 :: 		uint16_t display_getCursorY(void) {
;gfx_library.h,941 :: 		return cursor_y;
	MOVF        _cursor_y+0, 0 
	MOVWF       R0 
	MOVF        _cursor_y+1, 0 
	MOVWF       R1 
;gfx_library.h,942 :: 		}
L_end_display_getCursorY:
	RETURN      0
; end of _display_getCursorY

_display_setTextSize:

;gfx_library.h,950 :: 		void display_setTextSize(uint8_t s) {
;gfx_library.h,951 :: 		textsize = (s > 0) ? s : 1;
	MOVF        FARG_display_setTextSize_s+0, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_display_setTextSize208
	MOVF        FARG_display_setTextSize_s+0, 0 
	MOVWF       R1 
	GOTO        L_display_setTextSize209
L_display_setTextSize208:
	MOVLW       1
	MOVWF       R1 
L_display_setTextSize209:
	MOVF        R1, 0 
	MOVWF       _textsize+0 
;gfx_library.h,952 :: 		}
L_end_display_setTextSize:
	RETURN      0
; end of _display_setTextSize

_display_setTextColor:

;gfx_library.h,961 :: 		void display_setTextColor(uint16_t c, uint16_t b) {
;gfx_library.h,962 :: 		textcolor   = c;
	MOVF        FARG_display_setTextColor_c+0, 0 
	MOVWF       _textcolor+0 
	MOVF        FARG_display_setTextColor_c+1, 0 
	MOVWF       _textcolor+1 
;gfx_library.h,963 :: 		textbgcolor = b;
	MOVF        FARG_display_setTextColor_b+0, 0 
	MOVWF       _textbgcolor+0 
	MOVF        FARG_display_setTextColor_b+1, 0 
	MOVWF       _textbgcolor+1 
;gfx_library.h,964 :: 		}
L_end_display_setTextColor:
	RETURN      0
; end of _display_setTextColor

_display_setTextWrap:

;gfx_library.h,972 :: 		void display_setTextWrap(bool w) {
;gfx_library.h,973 :: 		wrap = w;
	MOVF        FARG_display_setTextWrap_w+0, 0 
	MOVWF       _wrap+0 
;gfx_library.h,974 :: 		}
L_end_display_setTextWrap:
	RETURN      0
; end of _display_setTextWrap

_display_getRotation:

;gfx_library.h,982 :: 		uint8_t display_getRotation(void) {
;gfx_library.h,983 :: 		return rotation;
	MOVF        _rotation+0, 0 
	MOVWF       R0 
;gfx_library.h,984 :: 		}
L_end_display_getRotation:
	RETURN      0
; end of _display_getRotation

_display_getWidth:

;gfx_library.h,992 :: 		uint16_t display_getWidth(void) {
;gfx_library.h,993 :: 		return display_width;
	MOVF        __width+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
;gfx_library.h,994 :: 		}
L_end_display_getWidth:
	RETURN      0
; end of _display_getWidth

_display_getHeight:

;gfx_library.h,1002 :: 		uint16_t display_getHeight(void) {
;gfx_library.h,1003 :: 		return display_height;
	MOVF        __height+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
;gfx_library.h,1004 :: 		}
L_end_display_getHeight:
	RETURN      0
; end of _display_getHeight

_display_color565:

;gfx_library.h,1018 :: 		uint16_t display_color565(uint8_t red, uint8_t green, uint8_t blue) {
;gfx_library.h,1019 :: 		return ((uint16_t)(red & 0xF8) << 8) | ((uint16_t)(green & 0xFC) << 3) | (blue >> 3);
	MOVLW       248
	ANDWF       FARG_display_color565_red+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R6 
	CLRF        R5 
	MOVLW       252
	ANDWF       FARG_display_color565_green+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVF        R4, 0 
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVF        R0, 0 
	IORWF       R5, 0 
	MOVWF       R2 
	MOVF        R6, 0 
	IORWF       R1, 0 
	MOVWF       R3 
	MOVF        FARG_display_color565_blue+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
	IORWF       R0, 1 
	MOVF        R3, 0 
	IORWF       R1, 1 
;gfx_library.h,1020 :: 		}
L_end_display_color565:
	RETURN      0
; end of _display_color565

_display_drawBitmapV1:

;gfx_library.h,1035 :: 		uint16_t color) {
;gfx_library.h,1037 :: 		for( i = 0; i < h/8; i++)
	CLRF        display_drawBitmapV1_i_L0+0 
	CLRF        display_drawBitmapV1_i_L0+1 
L_display_drawBitmapV1210:
	MOVF        FARG_display_drawBitmapV1_h+0, 0 
	MOVWF       R1 
	MOVF        FARG_display_drawBitmapV1_h+1, 0 
	MOVWF       R2 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R2, 7 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R2, 7 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R2, 7 
	MOVF        R2, 0 
	SUBWF       display_drawBitmapV1_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawBitmapV1437
	MOVF        R1, 0 
	SUBWF       display_drawBitmapV1_i_L0+0, 0 
L__display_drawBitmapV1437:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawBitmapV1211
;gfx_library.h,1039 :: 		for( j = 0; j < w * 8; j++)
	CLRF        display_drawBitmapV1_j_L0+0 
	CLRF        display_drawBitmapV1_j_L0+1 
L_display_drawBitmapV1213:
	MOVF        FARG_display_drawBitmapV1_w+0, 0 
	MOVWF       R1 
	MOVF        FARG_display_drawBitmapV1_w+1, 0 
	MOVWF       R2 
	RLCF        R1, 1 
	BCF         R1, 0 
	RLCF        R2, 1 
	RLCF        R1, 1 
	BCF         R1, 0 
	RLCF        R2, 1 
	RLCF        R1, 1 
	BCF         R1, 0 
	RLCF        R2, 1 
	MOVF        R2, 0 
	SUBWF       display_drawBitmapV1_j_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawBitmapV1438
	MOVF        R1, 0 
	SUBWF       display_drawBitmapV1_j_L0+0, 0 
L__display_drawBitmapV1438:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawBitmapV1214
;gfx_library.h,1041 :: 		if( bitmap[j/8 + i*w] & (1 << (j % 8)) )
	MOVF        display_drawBitmapV1_j_L0+0, 0 
	MOVWF       FLOC__display_drawBitmapV1+0 
	MOVF        display_drawBitmapV1_j_L0+1, 0 
	MOVWF       FLOC__display_drawBitmapV1+1 
	RRCF        FLOC__display_drawBitmapV1+1, 1 
	RRCF        FLOC__display_drawBitmapV1+0, 1 
	BCF         FLOC__display_drawBitmapV1+1, 7 
	RRCF        FLOC__display_drawBitmapV1+1, 1 
	RRCF        FLOC__display_drawBitmapV1+0, 1 
	BCF         FLOC__display_drawBitmapV1+1, 7 
	RRCF        FLOC__display_drawBitmapV1+1, 1 
	RRCF        FLOC__display_drawBitmapV1+0, 1 
	BCF         FLOC__display_drawBitmapV1+1, 7 
	MOVF        display_drawBitmapV1_i_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_i_L0+1, 0 
	MOVWF       R1 
	MOVF        FARG_display_drawBitmapV1_w+0, 0 
	MOVWF       R4 
	MOVF        FARG_display_drawBitmapV1_w+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        FLOC__display_drawBitmapV1+0, 0 
	ADDWF       R0, 1 
	MOVF        FLOC__display_drawBitmapV1+1, 0 
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV1_bitmap+0, 0 
	MOVWF       TBLPTR+0 
	MOVF        R1, 0 
	ADDWFC      FARG_display_drawBitmapV1_bitmap+1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      FARG_display_drawBitmapV1_bitmap+2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, R3
	MOVLW       7
	ANDWF       display_drawBitmapV1_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_j_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__display_drawBitmapV1439:
	BZ          L__display_drawBitmapV1440
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__display_drawBitmapV1439
L__display_drawBitmapV1440:
	MOVF        R3, 0 
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_display_drawBitmapV1216
;gfx_library.h,1042 :: 		display_drawPixel(x + j/8, y + i*8 + (j % 8), color);
	MOVF        display_drawBitmapV1_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_j_L0+1, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV1_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVLW       3
	MOVWF       R1 
	MOVF        display_drawBitmapV1_i_L0+0, 0 
	MOVWF       R0 
	MOVF        R1, 0 
L__display_drawBitmapV1441:
	BZ          L__display_drawBitmapV1442
	RLCF        R0, 1 
	BCF         R0, 0 
	ADDLW       255
	GOTO        L__display_drawBitmapV1441
L__display_drawBitmapV1442:
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV1_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVLW       7
	ANDWF       display_drawBitmapV1_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_j_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_drawPixel_y+0, 1 
	MOVF        FARG_display_drawBitmapV1_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawBitmapV1_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
L_display_drawBitmapV1216:
;gfx_library.h,1039 :: 		for( j = 0; j < w * 8; j++)
	INFSNZ      display_drawBitmapV1_j_L0+0, 1 
	INCF        display_drawBitmapV1_j_L0+1, 1 
;gfx_library.h,1043 :: 		}
	GOTO        L_display_drawBitmapV1213
L_display_drawBitmapV1214:
;gfx_library.h,1037 :: 		for( i = 0; i < h/8; i++)
	INFSNZ      display_drawBitmapV1_i_L0+0, 1 
	INCF        display_drawBitmapV1_i_L0+1, 1 
;gfx_library.h,1044 :: 		}
	GOTO        L_display_drawBitmapV1210
L_display_drawBitmapV1211:
;gfx_library.h,1045 :: 		}
L_end_display_drawBitmapV1:
	RETURN      0
; end of _display_drawBitmapV1

_display_drawBitmapV1_bg:

;gfx_library.h,1061 :: 		uint16_t color, uint16_t bg) {
;gfx_library.h,1063 :: 		for( i = 0; i < h/8; i++)
	CLRF        display_drawBitmapV1_bg_i_L0+0 
	CLRF        display_drawBitmapV1_bg_i_L0+1 
L_display_drawBitmapV1_bg217:
	MOVF        FARG_display_drawBitmapV1_bg_h+0, 0 
	MOVWF       R1 
	MOVF        FARG_display_drawBitmapV1_bg_h+1, 0 
	MOVWF       R2 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R2, 7 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R2, 7 
	RRCF        R2, 1 
	RRCF        R1, 1 
	BCF         R2, 7 
	MOVF        R2, 0 
	SUBWF       display_drawBitmapV1_bg_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawBitmapV1_bg444
	MOVF        R1, 0 
	SUBWF       display_drawBitmapV1_bg_i_L0+0, 0 
L__display_drawBitmapV1_bg444:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawBitmapV1_bg218
;gfx_library.h,1065 :: 		for( j = 0; j < w * 8; j++)
	CLRF        display_drawBitmapV1_bg_j_L0+0 
	CLRF        display_drawBitmapV1_bg_j_L0+1 
L_display_drawBitmapV1_bg220:
	MOVF        FARG_display_drawBitmapV1_bg_w+0, 0 
	MOVWF       R1 
	MOVF        FARG_display_drawBitmapV1_bg_w+1, 0 
	MOVWF       R2 
	RLCF        R1, 1 
	BCF         R1, 0 
	RLCF        R2, 1 
	RLCF        R1, 1 
	BCF         R1, 0 
	RLCF        R2, 1 
	RLCF        R1, 1 
	BCF         R1, 0 
	RLCF        R2, 1 
	MOVF        R2, 0 
	SUBWF       display_drawBitmapV1_bg_j_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawBitmapV1_bg445
	MOVF        R1, 0 
	SUBWF       display_drawBitmapV1_bg_j_L0+0, 0 
L__display_drawBitmapV1_bg445:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawBitmapV1_bg221
;gfx_library.h,1067 :: 		if( bitmap[j/8 + i*w] & (1 << (j % 8)) )
	MOVF        display_drawBitmapV1_bg_j_L0+0, 0 
	MOVWF       FLOC__display_drawBitmapV1_bg+0 
	MOVF        display_drawBitmapV1_bg_j_L0+1, 0 
	MOVWF       FLOC__display_drawBitmapV1_bg+1 
	RRCF        FLOC__display_drawBitmapV1_bg+1, 1 
	RRCF        FLOC__display_drawBitmapV1_bg+0, 1 
	BCF         FLOC__display_drawBitmapV1_bg+1, 7 
	RRCF        FLOC__display_drawBitmapV1_bg+1, 1 
	RRCF        FLOC__display_drawBitmapV1_bg+0, 1 
	BCF         FLOC__display_drawBitmapV1_bg+1, 7 
	RRCF        FLOC__display_drawBitmapV1_bg+1, 1 
	RRCF        FLOC__display_drawBitmapV1_bg+0, 1 
	BCF         FLOC__display_drawBitmapV1_bg+1, 7 
	MOVF        display_drawBitmapV1_bg_i_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_bg_i_L0+1, 0 
	MOVWF       R1 
	MOVF        FARG_display_drawBitmapV1_bg_w+0, 0 
	MOVWF       R4 
	MOVF        FARG_display_drawBitmapV1_bg_w+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        FLOC__display_drawBitmapV1_bg+0, 0 
	ADDWF       R0, 1 
	MOVF        FLOC__display_drawBitmapV1_bg+1, 0 
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV1_bg_bitmap+0, 0 
	MOVWF       TBLPTR+0 
	MOVF        R1, 0 
	ADDWFC      FARG_display_drawBitmapV1_bg_bitmap+1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      FARG_display_drawBitmapV1_bg_bitmap+2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, R3
	MOVLW       7
	ANDWF       display_drawBitmapV1_bg_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_bg_j_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__display_drawBitmapV1_bg446:
	BZ          L__display_drawBitmapV1_bg447
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__display_drawBitmapV1_bg446
L__display_drawBitmapV1_bg447:
	MOVF        R3, 0 
	ANDWF       R0, 1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_display_drawBitmapV1_bg223
;gfx_library.h,1068 :: 		display_drawPixel(x + j/8, y + i*8 + (j % 8), color);
	MOVF        display_drawBitmapV1_bg_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_bg_j_L0+1, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV1_bg_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVLW       3
	MOVWF       R1 
	MOVF        display_drawBitmapV1_bg_i_L0+0, 0 
	MOVWF       R0 
	MOVF        R1, 0 
L__display_drawBitmapV1_bg448:
	BZ          L__display_drawBitmapV1_bg449
	RLCF        R0, 1 
	BCF         R0, 0 
	ADDLW       255
	GOTO        L__display_drawBitmapV1_bg448
L__display_drawBitmapV1_bg449:
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV1_bg_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVLW       7
	ANDWF       display_drawBitmapV1_bg_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_bg_j_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_drawPixel_y+0, 1 
	MOVF        FARG_display_drawBitmapV1_bg_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawBitmapV1_bg_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
	GOTO        L_display_drawBitmapV1_bg224
L_display_drawBitmapV1_bg223:
;gfx_library.h,1070 :: 		display_drawPixel(x + j/8, y + i*8 + (j % 8), bg);
	MOVF        display_drawBitmapV1_bg_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_bg_j_L0+1, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R1, 7 
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV1_bg_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVLW       3
	MOVWF       R1 
	MOVF        display_drawBitmapV1_bg_i_L0+0, 0 
	MOVWF       R0 
	MOVF        R1, 0 
L__display_drawBitmapV1_bg450:
	BZ          L__display_drawBitmapV1_bg451
	RLCF        R0, 1 
	BCF         R0, 0 
	ADDLW       255
	GOTO        L__display_drawBitmapV1_bg450
L__display_drawBitmapV1_bg451:
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV1_bg_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVLW       7
	ANDWF       display_drawBitmapV1_bg_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV1_bg_j_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_drawPixel_y+0, 1 
	MOVF        FARG_display_drawBitmapV1_bg_bg+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawBitmapV1_bg_bg+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
L_display_drawBitmapV1_bg224:
;gfx_library.h,1065 :: 		for( j = 0; j < w * 8; j++)
	INFSNZ      display_drawBitmapV1_bg_j_L0+0, 1 
	INCF        display_drawBitmapV1_bg_j_L0+1, 1 
;gfx_library.h,1071 :: 		}
	GOTO        L_display_drawBitmapV1_bg220
L_display_drawBitmapV1_bg221:
;gfx_library.h,1063 :: 		for( i = 0; i < h/8; i++)
	INFSNZ      display_drawBitmapV1_bg_i_L0+0, 1 
	INCF        display_drawBitmapV1_bg_i_L0+1, 1 
;gfx_library.h,1072 :: 		}
	GOTO        L_display_drawBitmapV1_bg217
L_display_drawBitmapV1_bg218:
;gfx_library.h,1073 :: 		}
L_end_display_drawBitmapV1_bg:
	RETURN      0
; end of _display_drawBitmapV1_bg

_display_drawBitmapV2:

;gfx_library.h,1088 :: 		uint16_t color) {
;gfx_library.h,1090 :: 		uint16_t byteWidth = (w + 7) / 8; // Bitmap scanline pad = whole byte
	MOVLW       7
	ADDWF       FARG_display_drawBitmapV2_w+0, 0 
	MOVWF       display_drawBitmapV2_byteWidth_L0+0 
	MOVLW       0
	ADDWFC      FARG_display_drawBitmapV2_w+1, 0 
	MOVWF       display_drawBitmapV2_byteWidth_L0+1 
	RRCF        display_drawBitmapV2_byteWidth_L0+1, 1 
	RRCF        display_drawBitmapV2_byteWidth_L0+0, 1 
	BCF         display_drawBitmapV2_byteWidth_L0+1, 7 
	RRCF        display_drawBitmapV2_byteWidth_L0+1, 1 
	RRCF        display_drawBitmapV2_byteWidth_L0+0, 1 
	BCF         display_drawBitmapV2_byteWidth_L0+1, 7 
	RRCF        display_drawBitmapV2_byteWidth_L0+1, 1 
	RRCF        display_drawBitmapV2_byteWidth_L0+0, 1 
	BCF         display_drawBitmapV2_byteWidth_L0+1, 7 
;gfx_library.h,1091 :: 		uint8_t _byte = 0;
	CLRF        display_drawBitmapV2__byte_L0+0 
;gfx_library.h,1094 :: 		for(j = 0; j < h; j++, y++) {
	CLRF        display_drawBitmapV2_j_L0+0 
	CLRF        display_drawBitmapV2_j_L0+1 
L_display_drawBitmapV2225:
	MOVF        FARG_display_drawBitmapV2_h+1, 0 
	SUBWF       display_drawBitmapV2_j_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawBitmapV2453
	MOVF        FARG_display_drawBitmapV2_h+0, 0 
	SUBWF       display_drawBitmapV2_j_L0+0, 0 
L__display_drawBitmapV2453:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawBitmapV2226
;gfx_library.h,1095 :: 		for( i = 0; i < w; i++ ) {
	CLRF        display_drawBitmapV2_i_L0+0 
	CLRF        display_drawBitmapV2_i_L0+1 
L_display_drawBitmapV2228:
	MOVF        FARG_display_drawBitmapV2_w+1, 0 
	SUBWF       display_drawBitmapV2_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawBitmapV2454
	MOVF        FARG_display_drawBitmapV2_w+0, 0 
	SUBWF       display_drawBitmapV2_i_L0+0, 0 
L__display_drawBitmapV2454:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawBitmapV2229
;gfx_library.h,1096 :: 		if(i & 7) _byte <<= 1;
	MOVLW       7
	ANDWF       display_drawBitmapV2_i_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV2_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_display_drawBitmapV2231
	RLCF        display_drawBitmapV2__byte_L0+0, 1 
	BCF         display_drawBitmapV2__byte_L0+0, 0 
	GOTO        L_display_drawBitmapV2232
L_display_drawBitmapV2231:
;gfx_library.h,1097 :: 		else      _byte   = bitmap[j * byteWidth + i / 8];
	MOVF        display_drawBitmapV2_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV2_j_L0+1, 0 
	MOVWF       R1 
	MOVF        display_drawBitmapV2_byteWidth_L0+0, 0 
	MOVWF       R4 
	MOVF        display_drawBitmapV2_byteWidth_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        display_drawBitmapV2_i_L0+0, 0 
	MOVWF       R2 
	MOVF        display_drawBitmapV2_i_L0+1, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	RRCF        R2, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	RRCF        R2, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	RRCF        R2, 1 
	BCF         R3, 7 
	MOVF        R2, 0 
	ADDWF       R0, 1 
	MOVF        R3, 0 
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV2_bitmap+0, 0 
	MOVWF       TBLPTR+0 
	MOVF        R1, 0 
	ADDWFC      FARG_display_drawBitmapV2_bitmap+1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      FARG_display_drawBitmapV2_bitmap+2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, display_drawBitmapV2__byte_L0+0
L_display_drawBitmapV2232:
;gfx_library.h,1098 :: 		if(_byte & 0x80)
	BTFSS       display_drawBitmapV2__byte_L0+0, 7 
	GOTO        L_display_drawBitmapV2233
;gfx_library.h,1099 :: 		display_drawPixel(x+i, y, color);
	MOVF        display_drawBitmapV2_i_L0+0, 0 
	ADDWF       FARG_display_drawBitmapV2_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        FARG_display_drawBitmapV2_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawBitmapV2_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawBitmapV2_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
L_display_drawBitmapV2233:
;gfx_library.h,1095 :: 		for( i = 0; i < w; i++ ) {
	INFSNZ      display_drawBitmapV2_i_L0+0, 1 
	INCF        display_drawBitmapV2_i_L0+1, 1 
;gfx_library.h,1100 :: 		}
	GOTO        L_display_drawBitmapV2228
L_display_drawBitmapV2229:
;gfx_library.h,1094 :: 		for(j = 0; j < h; j++, y++) {
	INFSNZ      display_drawBitmapV2_j_L0+0, 1 
	INCF        display_drawBitmapV2_j_L0+1, 1 
	INFSNZ      FARG_display_drawBitmapV2_y+0, 1 
	INCF        FARG_display_drawBitmapV2_y+1, 1 
;gfx_library.h,1101 :: 		}
	GOTO        L_display_drawBitmapV2225
L_display_drawBitmapV2226:
;gfx_library.h,1102 :: 		}
L_end_display_drawBitmapV2:
	RETURN      0
; end of _display_drawBitmapV2

_display_drawBitmapV2_bg:

;gfx_library.h,1118 :: 		uint16_t color, uint16_t bg) {
;gfx_library.h,1120 :: 		uint16_t byteWidth = (w + 7) / 8; // Bitmap scanline pad = whole byte
	MOVLW       7
	ADDWF       FARG_display_drawBitmapV2_bg_w+0, 0 
	MOVWF       display_drawBitmapV2_bg_byteWidth_L0+0 
	MOVLW       0
	ADDWFC      FARG_display_drawBitmapV2_bg_w+1, 0 
	MOVWF       display_drawBitmapV2_bg_byteWidth_L0+1 
	RRCF        display_drawBitmapV2_bg_byteWidth_L0+1, 1 
	RRCF        display_drawBitmapV2_bg_byteWidth_L0+0, 1 
	BCF         display_drawBitmapV2_bg_byteWidth_L0+1, 7 
	RRCF        display_drawBitmapV2_bg_byteWidth_L0+1, 1 
	RRCF        display_drawBitmapV2_bg_byteWidth_L0+0, 1 
	BCF         display_drawBitmapV2_bg_byteWidth_L0+1, 7 
	RRCF        display_drawBitmapV2_bg_byteWidth_L0+1, 1 
	RRCF        display_drawBitmapV2_bg_byteWidth_L0+0, 1 
	BCF         display_drawBitmapV2_bg_byteWidth_L0+1, 7 
;gfx_library.h,1121 :: 		uint8_t _byte = 0;
	CLRF        display_drawBitmapV2_bg__byte_L0+0 
;gfx_library.h,1123 :: 		for(j = 0; j < h; j++, y++) {
	CLRF        display_drawBitmapV2_bg_j_L0+0 
	CLRF        display_drawBitmapV2_bg_j_L0+1 
L_display_drawBitmapV2_bg234:
	MOVF        FARG_display_drawBitmapV2_bg_h+1, 0 
	SUBWF       display_drawBitmapV2_bg_j_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawBitmapV2_bg456
	MOVF        FARG_display_drawBitmapV2_bg_h+0, 0 
	SUBWF       display_drawBitmapV2_bg_j_L0+0, 0 
L__display_drawBitmapV2_bg456:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawBitmapV2_bg235
;gfx_library.h,1124 :: 		for(i = 0; i < w; i++ ) {
	CLRF        display_drawBitmapV2_bg_i_L0+0 
	CLRF        display_drawBitmapV2_bg_i_L0+1 
L_display_drawBitmapV2_bg237:
	MOVF        FARG_display_drawBitmapV2_bg_w+1, 0 
	SUBWF       display_drawBitmapV2_bg_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display_drawBitmapV2_bg457
	MOVF        FARG_display_drawBitmapV2_bg_w+0, 0 
	SUBWF       display_drawBitmapV2_bg_i_L0+0, 0 
L__display_drawBitmapV2_bg457:
	BTFSC       STATUS+0, 0 
	GOTO        L_display_drawBitmapV2_bg238
;gfx_library.h,1125 :: 		if(i & 7) _byte <<= 1;
	MOVLW       7
	ANDWF       display_drawBitmapV2_bg_i_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV2_bg_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	ANDWF       R1, 1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_display_drawBitmapV2_bg240
	RLCF        display_drawBitmapV2_bg__byte_L0+0, 1 
	BCF         display_drawBitmapV2_bg__byte_L0+0, 0 
	GOTO        L_display_drawBitmapV2_bg241
L_display_drawBitmapV2_bg240:
;gfx_library.h,1126 :: 		else      _byte   = bitmap[j * byteWidth + i / 8];
	MOVF        display_drawBitmapV2_bg_j_L0+0, 0 
	MOVWF       R0 
	MOVF        display_drawBitmapV2_bg_j_L0+1, 0 
	MOVWF       R1 
	MOVF        display_drawBitmapV2_bg_byteWidth_L0+0, 0 
	MOVWF       R4 
	MOVF        display_drawBitmapV2_bg_byteWidth_L0+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        display_drawBitmapV2_bg_i_L0+0, 0 
	MOVWF       R2 
	MOVF        display_drawBitmapV2_bg_i_L0+1, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	RRCF        R2, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	RRCF        R2, 1 
	BCF         R3, 7 
	RRCF        R3, 1 
	RRCF        R2, 1 
	BCF         R3, 7 
	MOVF        R2, 0 
	ADDWF       R0, 1 
	MOVF        R3, 0 
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_display_drawBitmapV2_bg_bitmap+0, 0 
	MOVWF       TBLPTR+0 
	MOVF        R1, 0 
	ADDWFC      FARG_display_drawBitmapV2_bg_bitmap+1, 0 
	MOVWF       TBLPTR+1 
	MOVLW       0
	ADDWFC      FARG_display_drawBitmapV2_bg_bitmap+2, 0 
	MOVWF       TBLPTR+2 
	TBLRD*+
	MOVFF       TABLAT+0, display_drawBitmapV2_bg__byte_L0+0
L_display_drawBitmapV2_bg241:
;gfx_library.h,1127 :: 		if(_byte & 0x80)
	BTFSS       display_drawBitmapV2_bg__byte_L0+0, 7 
	GOTO        L_display_drawBitmapV2_bg242
;gfx_library.h,1128 :: 		display_drawPixel(x+i, y, color);
	MOVF        display_drawBitmapV2_bg_i_L0+0, 0 
	ADDWF       FARG_display_drawBitmapV2_bg_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        FARG_display_drawBitmapV2_bg_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawBitmapV2_bg_color+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawBitmapV2_bg_color+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
	GOTO        L_display_drawBitmapV2_bg243
L_display_drawBitmapV2_bg242:
;gfx_library.h,1130 :: 		display_drawPixel(x+i, y, bg);
	MOVF        display_drawBitmapV2_bg_i_L0+0, 0 
	ADDWF       FARG_display_drawBitmapV2_bg_x+0, 0 
	MOVWF       FARG_drawPixel_x+0 
	MOVF        FARG_display_drawBitmapV2_bg_y+0, 0 
	MOVWF       FARG_drawPixel_y+0 
	MOVF        FARG_display_drawBitmapV2_bg_bg+0, 0 
	MOVWF       FARG_drawPixel_color+0 
	MOVF        FARG_display_drawBitmapV2_bg_bg+1, 0 
	MOVWF       FARG_drawPixel_color+1 
	CALL        _drawPixel+0, 0
L_display_drawBitmapV2_bg243:
;gfx_library.h,1124 :: 		for(i = 0; i < w; i++ ) {
	INFSNZ      display_drawBitmapV2_bg_i_L0+0, 1 
	INCF        display_drawBitmapV2_bg_i_L0+1, 1 
;gfx_library.h,1131 :: 		}
	GOTO        L_display_drawBitmapV2_bg237
L_display_drawBitmapV2_bg238:
;gfx_library.h,1123 :: 		for(j = 0; j < h; j++, y++) {
	INFSNZ      display_drawBitmapV2_bg_j_L0+0, 1 
	INCF        display_drawBitmapV2_bg_j_L0+1, 1 
	INFSNZ      FARG_display_drawBitmapV2_bg_y+0, 1 
	INCF        FARG_display_drawBitmapV2_bg_y+1, 1 
;gfx_library.h,1132 :: 		}
	GOTO        L_display_drawBitmapV2_bg234
L_display_drawBitmapV2_bg235:
;gfx_library.h,1133 :: 		}
L_end_display_drawBitmapV2_bg:
	RETURN      0
; end of _display_drawBitmapV2_bg

_printNumber:

;gfx_library.h,1135 :: 		uint8_t printNumber(uint32_t n, int8_t n_width, uint8_t _flags) {
;gfx_library.h,1136 :: 		uint8_t i=0, j, buff[10];
	CLRF        printNumber_i_L0+0 
;gfx_library.h,1137 :: 		do {
L_printNumber244:
;gfx_library.h,1138 :: 		buff[i] = (uint8_t)( n % (_flags & 0x1F) );
	MOVLW       printNumber_buff_L0+0
	MOVWF       FLOC__printNumber+0 
	MOVLW       hi_addr(printNumber_buff_L0+0)
	MOVWF       FLOC__printNumber+1 
	MOVF        printNumber_i_L0+0, 0 
	ADDWF       FLOC__printNumber+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FLOC__printNumber+1, 1 
	MOVLW       31
	ANDWF       FARG_printNumber__flags+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_printNumber_n+0, 0 
	MOVWF       R0 
	MOVF        FARG_printNumber_n+1, 0 
	MOVWF       R1 
	MOVF        FARG_printNumber_n+2, 0 
	MOVWF       R2 
	MOVF        FARG_printNumber_n+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVFF       FLOC__printNumber+0, FSR1L+0
	MOVFF       FLOC__printNumber+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;gfx_library.h,1139 :: 		if (buff[i] > 9)
	MOVLW       printNumber_buff_L0+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(printNumber_buff_L0+0)
	MOVWF       FSR0L+1 
	MOVF        printNumber_i_L0+0, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 0 
	SUBLW       9
	BTFSC       STATUS+0, 0 
	GOTO        L_printNumber247
;gfx_library.h,1140 :: 		buff[i] += (_flags & 0x80) ? 0x07 : 0x27;
	MOVLW       printNumber_buff_L0+0
	MOVWF       R1 
	MOVLW       hi_addr(printNumber_buff_L0+0)
	MOVWF       R2 
	MOVF        printNumber_i_L0+0, 0 
	ADDWF       R1, 1 
	BTFSC       STATUS+0, 0 
	INCF        R2, 1 
	BTFSS       FARG_printNumber__flags+0, 7 
	GOTO        L_printNumber248
	MOVLW       7
	MOVWF       ?FLOC___printNumberT557+0 
	GOTO        L_printNumber249
L_printNumber248:
	MOVLW       39
	MOVWF       ?FLOC___printNumberT557+0 
L_printNumber249:
	MOVFF       R1, FSR0L+0
	MOVFF       R2, FSR0H+0
	MOVF        ?FLOC___printNumberT557+0, 0 
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1L+0
	MOVFF       R2, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
L_printNumber247:
;gfx_library.h,1141 :: 		buff[i++] += '0';
	MOVLW       printNumber_buff_L0+0
	MOVWF       R1 
	MOVLW       hi_addr(printNumber_buff_L0+0)
	MOVWF       R2 
	MOVF        printNumber_i_L0+0, 0 
	ADDWF       R1, 1 
	BTFSC       STATUS+0, 0 
	INCF        R2, 1 
	MOVFF       R1, FSR0L+0
	MOVFF       R2, FSR0H+0
	MOVLW       48
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1L+0
	MOVFF       R2, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INCF        printNumber_i_L0+0, 1 
;gfx_library.h,1142 :: 		n /= (_flags & 0x1F);
	MOVLW       31
	ANDWF       FARG_printNumber__flags+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_printNumber_n+0, 0 
	MOVWF       R0 
	MOVF        FARG_printNumber_n+1, 0 
	MOVWF       R1 
	MOVF        FARG_printNumber_n+2, 0 
	MOVWF       R2 
	MOVF        FARG_printNumber_n+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_printNumber_n+0 
	MOVF        R1, 0 
	MOVWF       FARG_printNumber_n+1 
	MOVF        R2, 0 
	MOVWF       FARG_printNumber_n+2 
	MOVF        R3, 0 
	MOVWF       FARG_printNumber_n+3 
;gfx_library.h,1143 :: 		} while (n);
	MOVF        R0, 0 
	IORWF       R1, 0 
	IORWF       R2, 0 
	IORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_printNumber244
;gfx_library.h,1144 :: 		j = i;
	MOVF        printNumber_i_L0+0, 0 
	MOVWF       printNumber_j_L0+0 
;gfx_library.h,1145 :: 		if(_flags & 0x40) {
	BTFSS       FARG_printNumber__flags+0, 6 
	GOTO        L_printNumber250
;gfx_library.h,1146 :: 		n_width--;
	DECF        FARG_printNumber_n_width+0, 1 
;gfx_library.h,1147 :: 		j++;
	INCF        printNumber_j_L0+0, 1 
;gfx_library.h,1148 :: 		if(_flags & 0x20) {    // put '-' before the zeros
	BTFSS       FARG_printNumber__flags+0, 5 
	GOTO        L_printNumber251
;gfx_library.h,1149 :: 		display_putc('-');
	MOVLW       45
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
;gfx_library.h,1150 :: 		_flags &= ~0x40;
	BCF         FARG_printNumber__flags+0, 6 
;gfx_library.h,1151 :: 		}
L_printNumber251:
;gfx_library.h,1152 :: 		}
L_printNumber250:
;gfx_library.h,1153 :: 		while (i < n_width--) {
L_printNumber252:
	MOVF        FARG_printNumber_n_width+0, 0 
	MOVWF       R1 
	DECF        FARG_printNumber_n_width+0, 1 
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	BTFSC       R1, 7 
	MOVLW       127
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__printNumber459
	MOVF        R1, 0 
	SUBWF       printNumber_i_L0+0, 0 
L__printNumber459:
	BTFSC       STATUS+0, 0 
	GOTO        L_printNumber253
;gfx_library.h,1154 :: 		if (_flags & 0x20)  display_putc('0');
	BTFSS       FARG_printNumber__flags+0, 5 
	GOTO        L_printNumber254
	MOVLW       48
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
	GOTO        L_printNumber255
L_printNumber254:
;gfx_library.h,1155 :: 		else                display_putc(' ');
	MOVLW       32
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
L_printNumber255:
;gfx_library.h,1156 :: 		}
	GOTO        L_printNumber252
L_printNumber253:
;gfx_library.h,1157 :: 		if (_flags & 0x40)
	BTFSS       FARG_printNumber__flags+0, 6 
	GOTO        L_printNumber256
;gfx_library.h,1158 :: 		display_putc('-');
	MOVLW       45
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
L_printNumber256:
;gfx_library.h,1159 :: 		do {
L_printNumber257:
;gfx_library.h,1160 :: 		display_putc(buff[--i]);
	DECF        printNumber_i_L0+0, 1 
	MOVLW       printNumber_buff_L0+0
	MOVWF       FSR0L+0 
	MOVLW       hi_addr(printNumber_buff_L0+0)
	MOVWF       FSR0L+1 
	MOVF        printNumber_i_L0+0, 0 
	ADDWF       FSR0L+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0L+1, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
;gfx_library.h,1161 :: 		} while(i);
	MOVF        printNumber_i_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_printNumber257
;gfx_library.h,1162 :: 		return j;
	MOVF        printNumber_j_L0+0, 0 
	MOVWF       R0 
;gfx_library.h,1163 :: 		}
L_end_printNumber:
	RETURN      0
; end of _printNumber

_printFloat:

;gfx_library.h,1165 :: 		void printFloat(float float_n, int8_t f_width, int8_t decimal, uint8_t _flags) {
;gfx_library.h,1166 :: 		int32_t int_part = float_n;
	MOVF        FARG_printFloat_float_n+0, 0 
	MOVWF       R0 
	MOVF        FARG_printFloat_float_n+1, 0 
	MOVWF       R1 
	MOVF        FARG_printFloat_float_n+2, 0 
	MOVWF       R2 
	MOVF        FARG_printFloat_float_n+3, 0 
	MOVWF       R3 
	CALL        _double2longint+0, 0
	MOVF        R0, 0 
	MOVWF       printFloat_int_part_L0+0 
	MOVF        R1, 0 
	MOVWF       printFloat_int_part_L0+1 
	MOVF        R2, 0 
	MOVWF       printFloat_int_part_L0+2 
	MOVF        R3, 0 
	MOVWF       printFloat_int_part_L0+3 
;gfx_library.h,1168 :: 		if(decimal == 0)  decimal = 1;
	MOVF        FARG_printFloat_decimal+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_printFloat260
	MOVLW       1
	MOVWF       FARG_printFloat_decimal+0 
L_printFloat260:
;gfx_library.h,1169 :: 		if(float_n < 0) {
	CLRF        R4 
	CLRF        R5 
	CLRF        R6 
	CLRF        R7 
	MOVF        FARG_printFloat_float_n+0, 0 
	MOVWF       R0 
	MOVF        FARG_printFloat_float_n+1, 0 
	MOVWF       R1 
	MOVF        FARG_printFloat_float_n+2, 0 
	MOVWF       R2 
	MOVF        FARG_printFloat_float_n+3, 0 
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_printFloat261
;gfx_library.h,1170 :: 		_flags |= 0x40;
	BSF         FARG_printFloat__flags+0, 6 
;gfx_library.h,1171 :: 		rem_part = (float)int_part - float_n;
	MOVF        printFloat_int_part_L0+0, 0 
	MOVWF       R0 
	MOVF        printFloat_int_part_L0+1, 0 
	MOVWF       R1 
	MOVF        printFloat_int_part_L0+2, 0 
	MOVWF       R2 
	MOVF        printFloat_int_part_L0+3, 0 
	MOVWF       R3 
	CALL        _longint2double+0, 0
	MOVF        FARG_printFloat_float_n+0, 0 
	MOVWF       R4 
	MOVF        FARG_printFloat_float_n+1, 0 
	MOVWF       R5 
	MOVF        FARG_printFloat_float_n+2, 0 
	MOVWF       R6 
	MOVF        FARG_printFloat_float_n+3, 0 
	MOVWF       R7 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       printFloat_rem_part_L0+0 
	MOVF        R1, 0 
	MOVWF       printFloat_rem_part_L0+1 
	MOVF        R2, 0 
	MOVWF       printFloat_rem_part_L0+2 
	MOVF        R3, 0 
	MOVWF       printFloat_rem_part_L0+3 
;gfx_library.h,1172 :: 		int_part = ~int_part + 1;
	COMF        printFloat_int_part_L0+0, 1 
	COMF        printFloat_int_part_L0+1, 1 
	COMF        printFloat_int_part_L0+2, 1 
	COMF        printFloat_int_part_L0+3, 1 
	MOVLW       1
	ADDWF       printFloat_int_part_L0+0, 1 
	MOVLW       0
	ADDWFC      printFloat_int_part_L0+1, 1 
	ADDWFC      printFloat_int_part_L0+2, 1 
	ADDWFC      printFloat_int_part_L0+3, 1 
;gfx_library.h,1173 :: 		}
	GOTO        L_printFloat262
L_printFloat261:
;gfx_library.h,1175 :: 		rem_part = float_n - (float)int_part;
	MOVF        printFloat_int_part_L0+0, 0 
	MOVWF       R0 
	MOVF        printFloat_int_part_L0+1, 0 
	MOVWF       R1 
	MOVF        printFloat_int_part_L0+2, 0 
	MOVWF       R2 
	MOVF        printFloat_int_part_L0+3, 0 
	MOVWF       R3 
	CALL        _longint2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        FARG_printFloat_float_n+0, 0 
	MOVWF       R0 
	MOVF        FARG_printFloat_float_n+1, 0 
	MOVWF       R1 
	MOVF        FARG_printFloat_float_n+2, 0 
	MOVWF       R2 
	MOVF        FARG_printFloat_float_n+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       printFloat_rem_part_L0+0 
	MOVF        R1, 0 
	MOVWF       printFloat_rem_part_L0+1 
	MOVF        R2, 0 
	MOVWF       printFloat_rem_part_L0+2 
	MOVF        R3, 0 
	MOVWF       printFloat_rem_part_L0+3 
L_printFloat262:
;gfx_library.h,1176 :: 		_flags |= 10;
	MOVLW       10
	IORWF       FARG_printFloat__flags+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       FARG_printFloat__flags+0 
;gfx_library.h,1177 :: 		f_width -= printNumber(int_part, f_width - decimal - 1, _flags);
	MOVF        printFloat_int_part_L0+0, 0 
	MOVWF       FARG_printNumber_n+0 
	MOVF        printFloat_int_part_L0+1, 0 
	MOVWF       FARG_printNumber_n+1 
	MOVF        printFloat_int_part_L0+2, 0 
	MOVWF       FARG_printNumber_n+2 
	MOVF        printFloat_int_part_L0+3, 0 
	MOVWF       FARG_printNumber_n+3 
	MOVF        FARG_printFloat_decimal+0, 0 
	SUBWF       FARG_printFloat_f_width+0, 0 
	MOVWF       FARG_printNumber_n_width+0 
	DECF        FARG_printNumber_n_width+0, 1 
	MOVF        R0, 0 
	MOVWF       FARG_printNumber__flags+0 
	CALL        _printNumber+0, 0
	MOVF        R0, 0 
	SUBWF       FARG_printFloat_f_width+0, 1 
;gfx_library.h,1178 :: 		display_putc('.');
	MOVLW       46
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
;gfx_library.h,1179 :: 		f_width--;
	DECF        FARG_printFloat_f_width+0, 1 
;gfx_library.h,1180 :: 		if(f_width < 1)  f_width = 1;
	MOVLW       128
	XORWF       FARG_printFloat_f_width+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       1
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_printFloat263
	MOVLW       1
	MOVWF       FARG_printFloat_f_width+0 
L_printFloat263:
;gfx_library.h,1181 :: 		if(decimal > f_width)  decimal = f_width;
	MOVLW       128
	XORWF       FARG_printFloat_f_width+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_printFloat_decimal+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_printFloat264
	MOVF        FARG_printFloat_f_width+0, 0 
	MOVWF       FARG_printFloat_decimal+0 
L_printFloat264:
;gfx_library.h,1182 :: 		while( decimal > 0 && (rem_part != 0 || decimal > 0) ) {
L_printFloat265:
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_printFloat_decimal+0, 0 
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_printFloat266
	MOVF        printFloat_rem_part_L0+0, 0 
	MOVWF       R0 
	MOVF        printFloat_rem_part_L0+1, 0 
	MOVWF       R1 
	MOVF        printFloat_rem_part_L0+2, 0 
	MOVWF       R2 
	MOVF        printFloat_rem_part_L0+3, 0 
	MOVWF       R3 
	CLRF        R4 
	CLRF        R5 
	CLRF        R6 
	CLRF        R7 
	CALL        _Equals_Double+0, 0
	MOVLW       0
	BTFSS       STATUS+0, 2 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__printFloat333
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_printFloat_decimal+0, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L__printFloat333
	GOTO        L_printFloat266
L__printFloat333:
L__printFloat332:
;gfx_library.h,1183 :: 		decimal--;
	DECF        FARG_printFloat_decimal+0, 1 
;gfx_library.h,1184 :: 		rem_part *= 10;
	MOVF        printFloat_rem_part_L0+0, 0 
	MOVWF       R0 
	MOVF        printFloat_rem_part_L0+1, 0 
	MOVWF       R1 
	MOVF        printFloat_rem_part_L0+2, 0 
	MOVWF       R2 
	MOVF        printFloat_rem_part_L0+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       printFloat_rem_part_L0+0 
	MOVF        R1, 0 
	MOVWF       printFloat_rem_part_L0+1 
	MOVF        R2, 0 
	MOVWF       printFloat_rem_part_L0+2 
	MOVF        R3, 0 
	MOVWF       printFloat_rem_part_L0+3 
;gfx_library.h,1185 :: 		display_putc( (uint8_t)rem_part + '0' );
	CALL        _double2byte+0, 0
	MOVLW       48
	ADDWF       R0, 0 
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
;gfx_library.h,1186 :: 		rem_part -= (uint8_t)rem_part;
	MOVF        printFloat_rem_part_L0+0, 0 
	MOVWF       R0 
	MOVF        printFloat_rem_part_L0+1, 0 
	MOVWF       R1 
	MOVF        printFloat_rem_part_L0+2, 0 
	MOVWF       R2 
	MOVF        printFloat_rem_part_L0+3, 0 
	MOVWF       R3 
	CALL        _double2byte+0, 0
	CALL        _byte2double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVF        printFloat_rem_part_L0+0, 0 
	MOVWF       R0 
	MOVF        printFloat_rem_part_L0+1, 0 
	MOVWF       R1 
	MOVF        printFloat_rem_part_L0+2, 0 
	MOVWF       R2 
	MOVF        printFloat_rem_part_L0+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       printFloat_rem_part_L0+0 
	MOVF        R1, 0 
	MOVWF       printFloat_rem_part_L0+1 
	MOVF        R2, 0 
	MOVWF       printFloat_rem_part_L0+2 
	MOVF        R3, 0 
	MOVWF       printFloat_rem_part_L0+3 
;gfx_library.h,1187 :: 		}
	GOTO        L_printFloat265
L_printFloat266:
;gfx_library.h,1188 :: 		}
L_end_printFloat:
	RETURN      0
; end of _printFloat

_v_printf:

;gfx_library.h,1190 :: 		void v_printf(const char *fmt, va_list arp) {
;gfx_library.h,1191 :: 		uint8_t _flags, c, d=0, w=0;
	CLRF        v_printf_d_L0+0 
	CLRF        v_printf_w_L0+0 
;gfx_library.h,1193 :: 		while (1) {
L_v_printf271:
;gfx_library.h,1194 :: 		c = *fmt++;
	MOVF        FARG_v_printf_fmt+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_v_printf_fmt+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_v_printf_fmt+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 0 
	MOVWF       v_printf_c_L0+0 
	MOVLW       1
	ADDWF       FARG_v_printf_fmt+0, 1 
	MOVLW       0
	ADDWFC      FARG_v_printf_fmt+1, 1 
	ADDWFC      FARG_v_printf_fmt+2, 1 
;gfx_library.h,1196 :: 		if (!c)
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_v_printf273
;gfx_library.h,1197 :: 		break;
	GOTO        L_v_printf272
L_v_printf273:
;gfx_library.h,1199 :: 		if (c != '%') {
	MOVF        v_printf_c_L0+0, 0 
	XORLW       37
	BTFSC       STATUS+0, 2 
	GOTO        L_v_printf274
;gfx_library.h,1200 :: 		display_putc(c);
	MOVF        v_printf_c_L0+0, 0 
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
;gfx_library.h,1201 :: 		continue;
	GOTO        L_v_printf271
;gfx_library.h,1202 :: 		}
L_v_printf274:
;gfx_library.h,1204 :: 		_flags = 0;
	CLRF        v_printf__flags_L0+0 
;gfx_library.h,1205 :: 		c = *fmt++;
	MOVF        FARG_v_printf_fmt+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_v_printf_fmt+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_v_printf_fmt+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R1, 0 
	MOVWF       v_printf_c_L0+0 
	MOVLW       1
	ADDWF       FARG_v_printf_fmt+0, 1 
	MOVLW       0
	ADDWFC      FARG_v_printf_fmt+1, 1 
	ADDWFC      FARG_v_printf_fmt+2, 1 
;gfx_library.h,1207 :: 		if (c == '0') {
	MOVF        R1, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_v_printf275
;gfx_library.h,1208 :: 		_flags |= 0x20;  // zero flag
	BSF         v_printf__flags_L0+0, 5 
;gfx_library.h,1209 :: 		c = *fmt++;
	MOVF        FARG_v_printf_fmt+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_v_printf_fmt+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_v_printf_fmt+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, v_printf_c_L0+0
	MOVLW       1
	ADDWF       FARG_v_printf_fmt+0, 1 
	MOVLW       0
	ADDWFC      FARG_v_printf_fmt+1, 1 
	ADDWFC      FARG_v_printf_fmt+2, 1 
;gfx_library.h,1210 :: 		}
L_v_printf275:
;gfx_library.h,1212 :: 		for (w = 0; c >= '0' && c <= '9'; c = *fmt++)   // width
	CLRF        v_printf_w_L0+0 
L_v_printf276:
	MOVLW       48
	SUBWF       v_printf_c_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_v_printf277
	MOVF        v_printf_c_L0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_v_printf277
L__v_printf338:
;gfx_library.h,1213 :: 		w = w * 10 + c - '0';
	MOVLW       10
	MULWF       v_printf_w_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       v_printf_w_L0+0 
	MOVF        v_printf_c_L0+0, 0 
	ADDWF       v_printf_w_L0+0, 1 
	MOVLW       48
	SUBWF       v_printf_w_L0+0, 1 
;gfx_library.h,1212 :: 		for (w = 0; c >= '0' && c <= '9'; c = *fmt++)   // width
	MOVF        FARG_v_printf_fmt+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_v_printf_fmt+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_v_printf_fmt+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, v_printf_c_L0+0
	MOVLW       1
	ADDWF       FARG_v_printf_fmt+0, 1 
	MOVLW       0
	ADDWFC      FARG_v_printf_fmt+1, 1 
	ADDWFC      FARG_v_printf_fmt+2, 1 
;gfx_library.h,1213 :: 		w = w * 10 + c - '0';
	GOTO        L_v_printf276
L_v_printf277:
;gfx_library.h,1215 :: 		if (c == '.') {
	MOVF        v_printf_c_L0+0, 0 
	XORLW       46
	BTFSS       STATUS+0, 2 
	GOTO        L_v_printf281
;gfx_library.h,1216 :: 		c = *fmt++;
	MOVF        FARG_v_printf_fmt+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_v_printf_fmt+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_v_printf_fmt+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, v_printf_c_L0+0
	MOVLW       1
	ADDWF       FARG_v_printf_fmt+0, 1 
	MOVLW       0
	ADDWFC      FARG_v_printf_fmt+1, 1 
	ADDWFC      FARG_v_printf_fmt+2, 1 
;gfx_library.h,1217 :: 		for (d = 0; c >= '0' && c <= '9'; c = *fmt++)   // decimals width
	CLRF        v_printf_d_L0+0 
L_v_printf282:
	MOVLW       48
	SUBWF       v_printf_c_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_v_printf283
	MOVF        v_printf_c_L0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_v_printf283
L__v_printf337:
;gfx_library.h,1218 :: 		d = d * 10 + c - '0';
	MOVLW       10
	MULWF       v_printf_d_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       v_printf_d_L0+0 
	MOVF        v_printf_c_L0+0, 0 
	ADDWF       v_printf_d_L0+0, 1 
	MOVLW       48
	SUBWF       v_printf_d_L0+0, 1 
;gfx_library.h,1217 :: 		for (d = 0; c >= '0' && c <= '9'; c = *fmt++)   // decimals width
	MOVF        FARG_v_printf_fmt+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_v_printf_fmt+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_v_printf_fmt+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, v_printf_c_L0+0
	MOVLW       1
	ADDWF       FARG_v_printf_fmt+0, 1 
	MOVLW       0
	ADDWFC      FARG_v_printf_fmt+1, 1 
	ADDWFC      FARG_v_printf_fmt+2, 1 
;gfx_library.h,1218 :: 		d = d * 10 + c - '0';
	GOTO        L_v_printf282
L_v_printf283:
;gfx_library.h,1219 :: 		}
L_v_printf281:
;gfx_library.h,1221 :: 		if(c == 'f' || c == 'F') {    // if float number
	MOVF        v_printf_c_L0+0, 0 
	XORLW       102
	BTFSC       STATUS+0, 2 
	GOTO        L__v_printf336
	MOVF        v_printf_c_L0+0, 0 
	XORLW       70
	BTFSC       STATUS+0, 2 
	GOTO        L__v_printf336
	GOTO        L_v_printf289
L__v_printf336:
;gfx_library.h,1222 :: 		printFloat(va_arg(arp, float), w, d, _flags);
	MOVFF       FARG_v_printf_arp+0, FSR0L+0
	MOVFF       FARG_v_printf_arp+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_printFloat_float_n+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_printFloat_float_n+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_printFloat_float_n+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_printFloat_float_n+3 
	MOVF        v_printf_w_L0+0, 0 
	MOVWF       FARG_printFloat_f_width+0 
	MOVF        v_printf_d_L0+0, 0 
	MOVWF       FARG_printFloat_decimal+0 
	MOVF        v_printf__flags_L0+0, 0 
	MOVWF       FARG_printFloat__flags+0 
	CALL        _printFloat+0, 0
	MOVFF       FARG_v_printf_arp+0, FSR0L+0
	MOVFF       FARG_v_printf_arp+1, FSR0H+0
	MOVLW       4
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      POSTINC0+0, 0 
	MOVWF       R1 
	MOVFF       FARG_v_printf_arp+0, FSR1L+0
	MOVFF       FARG_v_printf_arp+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;gfx_library.h,1223 :: 		continue;
	GOTO        L_v_printf271
;gfx_library.h,1224 :: 		}
L_v_printf289:
;gfx_library.h,1226 :: 		if (c == 'l' || c == 'L') {   // long number (4 bytes)
	MOVF        v_printf_c_L0+0, 0 
	XORLW       108
	BTFSC       STATUS+0, 2 
	GOTO        L__v_printf335
	MOVF        v_printf_c_L0+0, 0 
	XORLW       76
	BTFSC       STATUS+0, 2 
	GOTO        L__v_printf335
	GOTO        L_v_printf292
L__v_printf335:
;gfx_library.h,1227 :: 		_flags |= 0x40;    // long number flag
	BSF         v_printf__flags_L0+0, 6 
;gfx_library.h,1228 :: 		c = *fmt++;
	MOVF        FARG_v_printf_fmt+0, 0 
	MOVWF       TBLPTRL+0 
	MOVF        FARG_v_printf_fmt+1, 0 
	MOVWF       TBLPTRH+0 
	MOVF        FARG_v_printf_fmt+2, 0 
	MOVWF       TBLPTRU+0 
	TBLRD*+
	MOVFF       TABLAT+0, v_printf_c_L0+0
	MOVLW       1
	ADDWF       FARG_v_printf_fmt+0, 1 
	MOVLW       0
	ADDWFC      FARG_v_printf_fmt+1, 1 
	ADDWFC      FARG_v_printf_fmt+2, 1 
;gfx_library.h,1229 :: 		}
L_v_printf292:
;gfx_library.h,1231 :: 		if (!c)   // end of format?
	MOVF        v_printf_c_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_v_printf293
;gfx_library.h,1232 :: 		break;
	GOTO        L_v_printf272
L_v_printf293:
;gfx_library.h,1234 :: 		if(c == 'X') {
	MOVF        v_printf_c_L0+0, 0 
	XORLW       88
	BTFSS       STATUS+0, 2 
	GOTO        L_v_printf294
;gfx_library.h,1235 :: 		_flags |= 0x80;   // upper case hex flag
	BSF         v_printf__flags_L0+0, 7 
;gfx_library.h,1236 :: 		}
L_v_printf294:
;gfx_library.h,1238 :: 		if (c >= 'a')   // if lower case, switch to upper
	MOVLW       97
	SUBWF       v_printf_c_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_v_printf295
;gfx_library.h,1239 :: 		c -= 0x20;
	MOVLW       32
	SUBWF       v_printf_c_L0+0, 1 
L_v_printf295:
;gfx_library.h,1240 :: 		switch (c) {
	GOTO        L_v_printf296
;gfx_library.h,1241 :: 		case 'C' :        // character
L_v_printf298:
;gfx_library.h,1242 :: 		display_putc( (uint8_t)va_arg(arp, uint8_t) ); continue;
	MOVFF       FARG_v_printf_arp+0, FSR0L+0
	MOVFF       FARG_v_printf_arp+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0L+0
	MOVFF       R1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
	MOVFF       FARG_v_printf_arp+0, FSR0L+0
	MOVFF       FARG_v_printf_arp+1, FSR0H+0
	MOVLW       1
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      POSTINC0+0, 0 
	MOVWF       R1 
	MOVFF       FARG_v_printf_arp+0, FSR1L+0
	MOVFF       FARG_v_printf_arp+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	GOTO        L_v_printf271
;gfx_library.h,1243 :: 		case 'B' :        // binary
L_v_printf299:
;gfx_library.h,1244 :: 		_flags |= 2;  break;
	BSF         v_printf__flags_L0+0, 1 
	GOTO        L_v_printf297
;gfx_library.h,1245 :: 		case 'O' :        // octal
L_v_printf300:
;gfx_library.h,1246 :: 		_flags |= 8;  break;
	BSF         v_printf__flags_L0+0, 3 
	GOTO        L_v_printf297
;gfx_library.h,1247 :: 		case 'D' :        // signed decimal
L_v_printf301:
;gfx_library.h,1248 :: 		case 'U' :        // unsigned decimal
L_v_printf302:
;gfx_library.h,1249 :: 		_flags |= 10; break;
	MOVLW       10
	IORWF       v_printf__flags_L0+0, 1 
	GOTO        L_v_printf297
;gfx_library.h,1250 :: 		case 'X' :        // hexadecimal
L_v_printf303:
;gfx_library.h,1251 :: 		_flags |= 16; break;
	BSF         v_printf__flags_L0+0, 4 
	GOTO        L_v_printf297
;gfx_library.h,1252 :: 		default:          // other
L_v_printf304:
;gfx_library.h,1253 :: 		display_putc(c); continue;
	MOVF        v_printf_c_L0+0, 0 
	MOVWF       FARG_display_putc_c+0 
	CALL        _display_putc+0, 0
	GOTO        L_v_printf271
;gfx_library.h,1254 :: 		}
L_v_printf296:
	MOVF        v_printf_c_L0+0, 0 
	XORLW       67
	BTFSC       STATUS+0, 2 
	GOTO        L_v_printf298
	MOVF        v_printf_c_L0+0, 0 
	XORLW       66
	BTFSC       STATUS+0, 2 
	GOTO        L_v_printf299
	MOVF        v_printf_c_L0+0, 0 
	XORLW       79
	BTFSC       STATUS+0, 2 
	GOTO        L_v_printf300
	MOVF        v_printf_c_L0+0, 0 
	XORLW       68
	BTFSC       STATUS+0, 2 
	GOTO        L_v_printf301
	MOVF        v_printf_c_L0+0, 0 
	XORLW       85
	BTFSC       STATUS+0, 2 
	GOTO        L_v_printf302
	MOVF        v_printf_c_L0+0, 0 
	XORLW       88
	BTFSC       STATUS+0, 2 
	GOTO        L_v_printf303
	GOTO        L_v_printf304
L_v_printf297:
;gfx_library.h,1256 :: 		if(_flags & 0x40)  // if long number
	BTFSS       v_printf__flags_L0+0, 6 
	GOTO        L_v_printf305
;gfx_library.h,1257 :: 		nbr = (c == 'D') ? va_arg(arp, int32_t) : va_arg(arp, uint32_t);
	MOVF        v_printf_c_L0+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_v_printf306
	MOVFF       FARG_v_printf_arp+0, FSR0L+0
	MOVFF       FARG_v_printf_arp+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       4
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVFF       FARG_v_printf_arp+0, FSR1L+0
	MOVFF       FARG_v_printf_arp+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R2, FSR0L+0
	MOVFF       R3, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT695+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT695+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT695+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT695+3 
	GOTO        L_v_printf307
L_v_printf306:
	MOVFF       FARG_v_printf_arp+0, FSR0L+0
	MOVFF       FARG_v_printf_arp+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       4
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVFF       FARG_v_printf_arp+0, FSR1L+0
	MOVFF       FARG_v_printf_arp+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R2, FSR0L+0
	MOVFF       R3, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT695+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT695+1 
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT695+2 
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT695+3 
L_v_printf307:
	MOVF        ?FLOC___v_printfT695+0, 0 
	MOVWF       v_printf_nbr_L0+0 
	MOVF        ?FLOC___v_printfT695+1, 0 
	MOVWF       v_printf_nbr_L0+1 
	MOVF        ?FLOC___v_printfT695+2, 0 
	MOVWF       v_printf_nbr_L0+2 
	MOVF        ?FLOC___v_printfT695+3, 0 
	MOVWF       v_printf_nbr_L0+3 
	GOTO        L_v_printf308
L_v_printf305:
;gfx_library.h,1259 :: 		nbr = (c == 'D') ? (int32_t)va_arg(arp, int16_t) : (uint32_t)va_arg(arp, uint16_t);
	MOVF        v_printf_c_L0+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_v_printf309
	MOVFF       FARG_v_printf_arp+0, FSR0L+0
	MOVFF       FARG_v_printf_arp+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       2
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVFF       FARG_v_printf_arp+0, FSR1L+0
	MOVFF       FARG_v_printf_arp+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R2, FSR0L+0
	MOVFF       R3, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       ?FLOC___v_printfT712+0 
	MOVF        R1, 0 
	MOVWF       ?FLOC___v_printfT712+1 
	MOVLW       0
	BTFSC       R1, 7 
	MOVLW       255
	MOVWF       ?FLOC___v_printfT712+2 
	MOVWF       ?FLOC___v_printfT712+3 
	GOTO        L_v_printf310
L_v_printf309:
	MOVFF       FARG_v_printf_arp+0, FSR0L+0
	MOVFF       FARG_v_printf_arp+1, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVLW       2
	ADDWF       R2, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       R1 
	MOVFF       FARG_v_printf_arp+0, FSR1L+0
	MOVFF       FARG_v_printf_arp+1, FSR1H+0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R2, FSR0L+0
	MOVFF       R3, FSR0H+0
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT712+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       ?FLOC___v_printfT712+1 
	MOVLW       0
	MOVWF       ?FLOC___v_printfT712+2 
	MOVWF       ?FLOC___v_printfT712+3 
L_v_printf310:
	MOVF        ?FLOC___v_printfT712+0, 0 
	MOVWF       v_printf_nbr_L0+0 
	MOVF        ?FLOC___v_printfT712+1, 0 
	MOVWF       v_printf_nbr_L0+1 
	MOVF        ?FLOC___v_printfT712+2, 0 
	MOVWF       v_printf_nbr_L0+2 
	MOVF        ?FLOC___v_printfT712+3, 0 
	MOVWF       v_printf_nbr_L0+3 
L_v_printf308:
;gfx_library.h,1260 :: 		if ( (c == 'D') &&  (nbr & 0x80000000) ) {
	MOVF        v_printf_c_L0+0, 0 
	XORLW       68
	BTFSS       STATUS+0, 2 
	GOTO        L_v_printf313
	BTFSS       v_printf_nbr_L0+3, 7 
	GOTO        L_v_printf313
L__v_printf334:
;gfx_library.h,1261 :: 		_flags |= 0x40;     // negative number flag
	BSF         v_printf__flags_L0+0, 6 
;gfx_library.h,1262 :: 		nbr = ~nbr + 1;     // change to positive form
	COMF        v_printf_nbr_L0+0, 1 
	COMF        v_printf_nbr_L0+1, 1 
	COMF        v_printf_nbr_L0+2, 1 
	COMF        v_printf_nbr_L0+3, 1 
	MOVLW       1
	ADDWF       v_printf_nbr_L0+0, 1 
	MOVLW       0
	ADDWFC      v_printf_nbr_L0+1, 1 
	ADDWFC      v_printf_nbr_L0+2, 1 
	ADDWFC      v_printf_nbr_L0+3, 1 
;gfx_library.h,1263 :: 		}
	GOTO        L_v_printf314
L_v_printf313:
;gfx_library.h,1265 :: 		_flags &= ~0x40;    // number is positive
	BCF         v_printf__flags_L0+0, 6 
L_v_printf314:
;gfx_library.h,1266 :: 		printNumber(nbr, w, _flags);
	MOVF        v_printf_nbr_L0+0, 0 
	MOVWF       FARG_printNumber_n+0 
	MOVF        v_printf_nbr_L0+1, 0 
	MOVWF       FARG_printNumber_n+1 
	MOVF        v_printf_nbr_L0+2, 0 
	MOVWF       FARG_printNumber_n+2 
	MOVF        v_printf_nbr_L0+3, 0 
	MOVWF       FARG_printNumber_n+3 
	MOVF        v_printf_w_L0+0, 0 
	MOVWF       FARG_printNumber_n_width+0 
	MOVF        v_printf__flags_L0+0, 0 
	MOVWF       FARG_printNumber__flags+0 
	CALL        _printNumber+0, 0
;gfx_library.h,1267 :: 		}
	GOTO        L_v_printf271
L_v_printf272:
;gfx_library.h,1268 :: 		}
L_end_v_printf:
	RETURN      0
; end of _v_printf

_display_printf:

;gfx_library.h,1270 :: 		void display_printf(const char *fmt, ...) {
;gfx_library.h,1272 :: 		va_start(arg, fmt);
	MOVLW       FARG_display_printf_fmt+3
	MOVWF       display_printf_arg_L0+0 
	MOVLW       hi_addr(FARG_display_printf_fmt+3)
	MOVWF       display_printf_arg_L0+1 
;gfx_library.h,1273 :: 		v_printf(fmt, arg);
	MOVF        FARG_display_printf_fmt+0, 0 
	MOVWF       FARG_v_printf_fmt+0 
	MOVF        FARG_display_printf_fmt+1, 0 
	MOVWF       FARG_v_printf_fmt+1 
	MOVF        FARG_display_printf_fmt+2, 0 
	MOVWF       FARG_v_printf_fmt+2 
	MOVLW       display_printf_arg_L0+0
	MOVWF       FARG_v_printf_arp+0 
	MOVLW       hi_addr(display_printf_arg_L0+0)
	MOVWF       FARG_v_printf_arp+1 
	CALL        _v_printf+0, 0
;gfx_library.h,1274 :: 		}
L_end_display_printf:
	RETURN      0
; end of _display_printf

_main:

;fdene.c,17 :: 		void main()
;fdene.c,19 :: 		OSCCON = 0x72;   // set internal oscillator to 16MHz
	MOVLW       114
	MOVWF       OSCCON+0 
;fdene.c,20 :: 		ANSELC = 0;      // configure all PORTC pins as digital
	CLRF        ANSELC+0 
;fdene.c,21 :: 		ANSELD = 0;      // configure all PORTD pins as digital
	CLRF        ANSELD+0 
;fdene.c,22 :: 		SPI1_Init();       // initialize the SPI1 module with default settings
	CALL        _SPI1_Init+0, 0
;fdene.c,25 :: 		tft_initR(INITR_BLACKTAB);      // Init ST7735S chip, black tab
	MOVLW       2
	MOVWF       FARG_tft_initR_options+0 
	CALL        _tft_initR+0, 0
;fdene.c,26 :: 		display_setTextWrap(1);  // allow text to run off right edge
	MOVLW       1
	MOVWF       FARG_display_setTextWrap_w+0 
	CALL        _display_setTextWrap+0, 0
;fdene.c,27 :: 		display_fillScreen(ST7735_BLACK);
	CLRF        FARG_fillScreen_color+0 
	CLRF        FARG_fillScreen_color+1 
	CALL        _fillScreen+0, 0
;fdene.c,39 :: 		display_drawBitmapV2(14,30,dene,100,100, ST7735_BLUE); //FOR pictures
	MOVLW       14
	MOVWF       FARG_display_drawBitmapV2_x+0 
	MOVLW       0
	MOVWF       FARG_display_drawBitmapV2_x+1 
	MOVLW       30
	MOVWF       FARG_display_drawBitmapV2_y+0 
	MOVLW       0
	MOVWF       FARG_display_drawBitmapV2_y+1 
	MOVLW       _dene+0
	MOVWF       FARG_display_drawBitmapV2_bitmap+0 
	MOVLW       hi_addr(_dene+0)
	MOVWF       FARG_display_drawBitmapV2_bitmap+1 
	MOVLW       higher_addr(_dene+0)
	MOVWF       FARG_display_drawBitmapV2_bitmap+2 
	MOVLW       100
	MOVWF       FARG_display_drawBitmapV2_w+0 
	MOVLW       0
	MOVWF       FARG_display_drawBitmapV2_w+1 
	MOVLW       100
	MOVWF       FARG_display_drawBitmapV2_h+0 
	MOVLW       0
	MOVWF       FARG_display_drawBitmapV2_h+1 
	MOVLW       31
	MOVWF       FARG_display_drawBitmapV2_color+0 
	MOVLW       0
	MOVWF       FARG_display_drawBitmapV2_color+1 
	CALL        _display_drawBitmapV2+0, 0
;fdene.c,41 :: 		while(1) {
L_main315:
;fdene.c,55 :: 		}
	GOTO        L_main315
;fdene.c,57 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
