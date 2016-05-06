#include <REG320.h>
#include<intrins.h>


void Timer1();
void ShowSeg();
void SettingIO(void);
void delay(unsigned int time);
void delay2(unsigned int time);
void carry(int sign);
unsigned char numbers[]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x83,0xD8,0x80,0x98,0xff};   //數字0-9,0xff表示都不亮       
unsigned char numbers2[]={0xC0,0xF9,0xA4,0xB0}; 
unsigned char seg_num[]={0xF7,0xFB,0xFD,0xFE};										//控制七段顯示器哪顆亮
unsigned char digit0 = 0,digit1 = 0,digit2 = 0,digit3 = 0;			//用digit0-3代表存放七段顯示器要顯示的數值
//Timer副程式,interrupt 3 = vector 在0x1B的位置上

int count=1;

void Timer1() interrupt 3
{
	//重設計時站存器  TH1 TL1
	TH1 = 0x63;
	TL1 = 0xC0;
	if(digit0 < 9)
		digit0 = digit0 + 1;
	else
		digit0 = 0;
}
//顯示數值在七段顯示器上
void ShowSeg() 
{
	unsigned char segIndex = 0;
	int i;
	
	
	
	/*P0 = seg_num[segIndex] + numbers[digit0];
	delay(5);
	P0 = seg_num[segIndex+1] + numbers[digit1];
	delay(5);
	P0 = seg_num[segIndex+2] + numbers[digit2];
	delay(5);
	P0 = seg_num[segIndex+3] + numbers[digit3];
	delay(5);*/
	P0 = numbers[0];
	P2 = seg_num[2];
	delay2(1);
	
	
	for(i=0;i<10;i++){	
		P0 = numbers[i];
		P2 = seg_num[3];		
		delay(5);								
	}
	
	P0 = numbers[1];
		P2 = seg_num[2];
		delay2(1);
	
	for(i=0;i<10;i++){	
		P0 = numbers[i];
		P2 = seg_num[3];		
		delay(2);								
	}
	P0 = numbers[2];
	P2 = seg_num[2];
		delay2(1);
	
	for(i=0;i<10;i++){	
		P0 = numbers[i];
		P2 = seg_num[3];		
		delay(2);								
	}
	
	P0 = numbers[3];
	P2 = seg_num[2];
		delay2(1);
	
	
		/*if(count==4)
			count=1;
		
		carry(count);
	
	count++;	*/
	
}	


void carry(int sign)
{
	
	
	if(sign==1)
	{
		
		P0 = numbers[sign];
		P2 = seg_num[2];
		delay(20);
	}
	else if(sign==2)
	{
		
		P0 = numbers[sign];
		P2 = seg_num[2];
		delay(20);
		
	}
	else if(sign==3)
	{
		
		P0 = numbers[sign];
		P2 = seg_num[2];
		delay(20);
		
	}
	
	
	
}
	

void delay2(unsigned int time)
{
  unsigned int i,j;
	
	/*while(time>0)
	{
		n=10; 
		while(n>0) 
			n--;
		time--;
	}*/
	for(i=0;i<time;i++)
		for(j=0;j<50;j++)
			;
	
}


//延遲副程式
void delay(unsigned int time)
{
  unsigned int i,j;
	
	/*while(time>0)
	{
		n=10; 
		while(n>0) 
			n--;
		time--;
	}*/
	for(i=0;i<time;i++)
		for(j=0;j<120;j++)
			;
	
}
//設定會需要用到的IO
void SettingIO(void)
{
	//CLKCON = 0x03; 		//預設值慢鐘80K
	//IE = 0x088;	  		//開Timer1 中斷
	//TMOD = 0x10;	  	//Timer1 mode 1:16 Bits counter
	
	//Timer累加一次為2個system clk時間 =  1/40k 秒
	//故1秒 = Timer1累加40k次後溢位，又Timer1設為16Bits
	//65536-40000 = 25536 = 0x63C0
	//TH1 = 0x63;
	//TL1 = 0xC0;

	//TR1 = 0x01; 		//Timer1 RUN
	
	p0oe = 0xff;
	p2oe =0xff;	
	P0 = 0xff;
	//P3MODL = 0x00; 		//設定P3.0~3為pull up input  ;20140123 debug
	//P3MODH = 0xaa; 		//設定P3.4~7為CMOS output    ;20140123 debug
	//P3 = 0xff;
}

void main()
{
	SettingIO();
	while(1){
		
		ShowSeg();
	}
	
}