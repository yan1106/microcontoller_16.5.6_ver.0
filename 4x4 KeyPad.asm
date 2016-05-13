;此程式是按按鍵把數字顯示在兩顆七段顯示器上面
;P0接到模組M6用來控制兩顆七段顯示器
;P3接到模組M9用來控制按鍵
#include "tx3703.inc"

digit1 equ 00h 		;七段顯示器數字一
digit2 equ 00h 		;七段顯示器數字二


org 00h

ajmp Start

org 400h
Start:

	acall IO	
	mov P2,#0ffh
S1:	acall ShowDigits
	
	; 檢查是否有按鍵被按下
CheckKey: 
	mov p3,#0ffh 	;清除按鍵狀態
	mov p3,#00fh 	;將鍵盤列位址(bits4~7)變成低電位、將鍵盤行位址(bits0~3)變成高電位
	nop	   			;暫存器存取緩衝
	nop
	nop
	nop
	nop
	mov A,p3 		;讀取鍵盤狀態，沒按鍵應是0FH
	add A,#0f0h 		;+F0H
	inc A 			;累加器A加一，如沒按鍵=0
	jz  S1			;判斷累加器A是否=0;沒按鍵(A=0)，回到S1;有按鍵則執行下行指令
	ajmp DeNoise 	;有按鍵，跳到DeNoise去除彈跳
	 	

	; 去除彈跳
DeNoise: 
	acall delay 
	;再次檢查是否有按鍵被按下
	mov p3,#0ffh 	;清除按鍵狀態
	mov p3,#00fh 	;將鍵盤列位址(bits4~7)變成低電位、將鍵盤行位址(bits0~3)變成高電位
	nop	 			;暫存器存取緩衝
	nop
	nop
	nop
	nop
	mov A,p3 		;讀取鍵盤狀態，沒按鍵應是0FH
	add A,#0f0h 	;+F0H
	inc A 			;累加器A加一，如沒按鍵=0
	jz S1 			;判斷累加器A是否=0;沒按鍵(A=0)，回到S1;有按鍵則執行下行指令
	ajmp Row1 		;有按鍵，到Row1檢查按了什麼鍵
	
Row1: ; 檢查第一列是否有按鍵被按下
	mov p3,#0ffh 		;清除按鍵狀態
	mov p3,#0efh 		;將鍵盤第一列(bit 4)變成低電位
	nop	 				;暫存器存取緩衝
	nop
	nop
	nop
	nop
	mov A,p3 			;讀取鍵盤狀態，沒按鍵應是efh
	add A,#10h 			;+10h
	inc A 				;累加器A加一，如沒按鍵=0
	jz Row2				;判斷累加器A是否=0;沒按鍵，檢查第二列;有按鍵則執行下行指令
	ajmp Key1 			;有按鍵，檢查是否按了'1'
Key1: 
	jnb p3. 0,K1 		;檢查'1'是否被按下
	ajmp Key2 			;'1'沒被按下，檢查是否按了'2'
K1: 					;'1'被按下，設定七段顯示器為01
	mov  digit1,#0F9h   ;設定七段顯示器的第一個數字為2
	;mov  digit2,#0f0h	;設定七段顯示器的第一個數字為0
	ajmp WaitRelease 	;等待按鍵放開
Key2: 
	jnb p3.1,K2 		;檢查'2'是否被按下
	ajmp Key3 			;'2'沒被按下，檢查是否按了'3'
K2:  					;'2'被按下，設定七段顯示器為02
	mov digit1,#0f2h 	;設定七段顯示器的第一個數字為2
	mov digit2,#0f0h 	;設定七段顯示器的第二個數字為0
	ajmp WaitRelease 	;等待按鍵放開
Key3: 
	jnb p3.2,K3 		;檢查'3'是否被按下
	ajmp KeyA 			;'3'沒被按下，所以是'A'被按下
K3: 					;'3'被按下，設定七段顯示器為03
	mov digit1,#0f3h 	;設定七段顯示器的第一個數字為3
	mov digit2,#0f0h 	;設定七段顯示器的第二個數字為0
	ajmp WaitRelease 	;等待按鍵放開	
KeyA: 					;'A'被按下，設定七段顯示器為10
	mov digit1,#0f0h 	;設定七段顯示器的第一個數字為0
	mov digit2,#0f1h 	;設定七段顯示器的第二個數字為1
	ajmp WaitRelease 	;等待按鍵放開
Row2: 					;檢查第二列是否有按鍵被按下
	mov p3,#0ffh 		;清除按鍵狀態
	mov p3,#0dfh 		;將鍵盤第二列(bit 5)變成低電位
	nop	 				;暫存器存取緩衝
	nop
	nop
	nop
	nop
	mov A,p3 			;讀取鍵盤狀態，沒按鍵應是dfh
	add A,#20h 			;+20h
	inc A 				;累加器A加一，如沒按鍵=0
	jz Row3				;判斷累加器A是否=0;沒按鍵，檢查第三列;有按鍵則執行下行指令
	ajmp Key4 			;有按鍵，檢查是否按了'4'
Key4:
	jnb p3.0,K4 		;檢查'4'是否被按下
	ajmp Key5 			;'4'沒被按下，檢查是否按了'5'
K4: 					;'4'被按下，設定七段顯示器為04
	mov  digit1,#0f4h 	;設定七段顯示器的第一個數字為4
	mov  digit2,#0f0h 	;設定七段顯示器的第一個數字為0
	ajmp WaitRelease 	;等待按鍵放開 
Key5: 
	jnb p3.1,K5 		;檢查'5'是否被按下
	ajmp Key6 			;'5'沒被按下，檢查是否按了'6'
K5: 					;'5'被按下，設定七段顯示器為05
	mov  digit1,#0f5h 	;設定七段顯示器的第一個數字為5
	mov  digit2,#0f0h 	;設定七段顯示器的第一個數字為0
	ajmp WaitRelease 	;等待按鍵放開 
Key6: 
	jnb p3.2,K6 		;檢查'6'是否被按下
	ajmp KeyB 			;'6'沒被按下，檢查是否按了'B'
K6: 					;'6'被按下，設定七段顯示器為06
	mov  digit1,#0f6h 	;設定七段顯示器的第一個數字為6
	mov  digit2,#0f0h 	;設定七段顯示器的第一個數字為0
	ajmp WaitRelease 	;等待按鍵放開 
KeyB:					;'B'被按下，設定七段顯示器為11 
	mov  digit1,#0f1h 	;設定七段顯示器的第一個數字為1
	mov  digit2,#0f1h 	;設定七段顯示器的第一個數字為1
	ajmp WaitRelease 	;等待按鍵放開
Row3: 					;檢查第三列是否有按鍵被按下
	mov p3,#0ffh 		;清除按鍵狀態
	mov p3,#0bfh 		;將鍵盤第一列(bit 6)變成低電位
	nop	 				;暫存器存取緩衝
	nop
	nop
	nop
	nop
	mov A,p3 			;讀取鍵盤狀態，沒按鍵應是bfh
	add A,#40h 			;+40h
   	inc A 				;累加器A加一，如沒按鍵=0 
	jz Row4				;判斷累加器A是否=0;沒按鍵，檢查第四列;有按鍵則執行下行指令
	ajmp Key7 			;有按鍵，檢查是否按了'7'
Key7:
	jnb p3.0,K7 		;檢查'7'是否被按下
	ajmp Key8 			;'7'沒被按下，檢查是否按了'8'
K7: 					;'7'被按下，設定七段顯示器為07
	mov  digit1,#0f7h 	;設定七段顯示器的第一個數字為7
	mov  digit2,#0f0h 	;設定七段顯示器的第一個數字為0
	ajmp WaitRelease 	;等待按鍵放開
Key8:
	jnb p3.1,K8 		;檢查'8'是否被按下
	ajmp Key9 			;'8'沒被按下，檢查是否按了'9'
K8: 					;'8'被按下，設定七段顯示器為08
	mov  digit1,#0f8h 	;設定七段顯示器的第一個數字為8
	mov  digit2,#0f0h 	;設定七段顯示器的第一個數字為0
	ajmp WaitRelease 	;等待按鍵放開  
Key9:
	jnb p3.2,K9 		;檢查'9'是否被按下
	ajmp KeyC 			;'9'沒被按下，檢查是否按了'C'
K9: 					;'9'被按下，設定七段顯示器為09
	mov  digit1,#0f9h	;設定七段顯示器的第一個數字為9
	mov  digit2,#0f0h	;設定七段顯示器的第一個數字為0
	ajmp WaitRelease 	;等待按鍵放開 
KeyC: 					;'C'被按下，設定七段顯示器為12
	mov  digit1,#0f2h 	;設定七段顯示器的第一個數字為2
	mov  digit2,#0f1h 	;設定七段顯示器的第一個數字為1
	ajmp WaitRelease 	;等待按鍵放開
Row4: 					;檢查第四列是否有按鍵被按下
	mov p3,#0ffh 		;清除按鍵狀態
	mov p3,#07fh 		;將鍵盤第一列(bit 7)變成低電位
	nop					;暫存器存取緩衝
	nop
	nop
	nop
	nop
	mov A,p3 			;讀取鍵盤狀態，沒按鍵應是bfh
	add A,#8h 			;+40h
	inc A 				;累加器A加一，如沒按鍵=0
	jz WaitRelease		;判斷累加器A是否=0;沒按鍵，等待按鍵放開;有按鍵則執行下行指令
	ajmp Key99 			;有按鍵，檢查是否按了'*' 
Key99:
	jnb p3.0,K99 		;檢查'*'是否被按下
	ajmp Key0 			;'*'沒被按下，檢查是否按了'0'
K99: 					;'*'被按下，設定七段顯示器為99
	mov  digit1,#0f9h	;設定七段顯示器的第一個數字為9
	mov  digit2,#0f9h	;設定七段顯示器的第一個數字為9
	ajmp WaitRelease 	;等待按鍵放開 
Key0:
	jnb p3.1,K0 		;檢查'0'是否被按下
	ajmp Key20 			;'0'沒被按下，檢查是否按了'#'
K0: 					;'0'被按下，設定七段顯示器為00
	mov  digit1,#0f0h	;設定七段顯示器的第一個數字為0
	mov  digit2,#0f0h	;設定七段顯示器的第一個數字為0
	ajmp WaitRelease 	;等待按鍵放開 
Key20:
	jnb p3.2,K20 		;檢查'#'是否被按下
	ajmp KeyD 			;'#'沒被按下，檢查是否按了'D'
K20: 					;'20'被按下，設定七段顯示器為20
	mov  digit1,#0f0h	;設定七段顯示器的第一個數字為0
	mov  digit2,#0f2h	;設定七段顯示器的第一個數字為2
	ajmp WaitRelease 	;等待按鍵放開 
KeyD: 					;'D'被按下，設定七段顯示器為13
	mov  digit1,#0f3h 	;設定七段顯示器的第一個數字為3
	mov  digit2,#0f1h 	;設定七段顯示器的第一個數字為1
	ajmp WaitRelease 	;等待按鍵放開
	
; 等待使用者放開按鍵
WaitRelease: 
	acall ShowDigits 	;顯示七段顯示器內容
	mov p3,#0ffh 		;清除按鍵狀態
	mov p3,#0fh  		;將0fh寫入PDD
	nop	 				;暫存器存取緩衝
	nop
	nop
	nop
	nop
	mov A,p3   			;讀取鍵盤狀態，若放開按鍵應是0fh
	add A,#0f0h			;+f0h
	inc A				;取得按鍵狀態，若放開按鍵應是ffh; 若按鍵狀態+1等於0，表示放開按鍵
	jz S11 				;回到S1
	ajmp WaitRelease	;沒放開按鍵，繼續等待
S11:
	ajmp S1				;回到S1
ShowDigits: 
						;顯示七段顯示器第一個數字
	mov P0,digit1 		;輸出第一個數字的內容
	clr P2.0 			;將第一個七段顯示器點亮
	acall delay 		;等待5ms
	;setb P2.0 			;將第一個七段顯示器關掉
						;顯示七段顯示器第二個數字
	;mov P0,digit2 		;輸出第二個數字的內容
	;clr P0.5 			;將第二個七段顯示器點亮
	;acall delay 		;等待5ms
	;setb P0.5 			;將第二個七段顯示器關掉
	ret 				;返回主程式

IO:						;設定IO以及初始值
	mov p0oe,#11111111b	;設定P0為CMOS輸出
	mov p0,#00000000b
	mov p2oe,#11111111b
	mov p2,#11111110b
	mov p3modl,#00000000b ;設定P3.0~3為pull up input  ;20140123 debug
	mov p3modh,#10101010b ;設定P3.4~7為CMOS output    ;20140123 debug
	mov p3,#11111111b
	ret
delay:
	MOV R5,#10
D1:	MOV R6,#20
	DJNZ R6,$
	DJNZ R5,D1
	RET	

	END
