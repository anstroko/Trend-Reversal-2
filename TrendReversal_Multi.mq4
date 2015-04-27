
#property copyright "AlexanderS"
extern string Пapаметры=" Параметры советника";
extern int TP=210;
extern int SL=200;
extern int filtr=-50;
extern bool TradeWithBu=true;
extern bool TradeWithTralling=true;
extern int BU=100;
extern int Trall=150;
extern double lot = 0.03;
extern int CandleSize=400;
extern int BodySize=0;
extern int Magic_Number = 68705;
extern int Slipage=3;
extern int SleepTime=2;
extern double lot1=0.01;
extern double lot2=0.01;
extern double lot3=0.01;
extern double lot4=0.02;
extern double lot5=0.03;
extern double lot6=0.04;
extern double lot7=0.06;
extern double lot8=0.09;
extern double lot9=0.13;
extern double lot10=0.19;
extern double lot11=0.28;
extern double lot12=0.42;
extern double lot13=0.62;
extern double lot14=0.9;
extern double lot15=0.28;
extern double lot16=0.42;
extern double lot17=0.62;
extern double lot18=0.9;
extern double lot19=0.28;
extern double lot20=0.42;
extern double lot21=0.62;





int k;
bool BuTranz=false;
double Stop;
bool flag_sell=false,flag_buy=false;
int i;
bool NewTraid;
bool TraidToday;
string CommentLastOrder;
string CommentNextOrder;
int loose;
double Lot;
bool OpenOrder=false;
int init()
{
   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}
   return(0);
}

int deinit()
{
   return(0);
}

int start()
{
OpenOrder=false;

int total=OrdersTotal();
   for(int inn=0;inn<OrdersTotal();inn++)
     {      if(OrderSelect(inn,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
           OpenOrder=true;
           
    
           }
        }
     }
     Comment(OpenOrder);
if (NewTraid==true){
   for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
         
            if(OrderType()==OP_BUY){OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-SL*k*Point,OrderOpenPrice()+TP*k*Point,0,Orange); }
            if(OrderType()==OP_SELL){OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+SL*k*Point,OrderOpenPrice()-TP*k*Point,0,Orange);}
    
           }
        }
     }
     }
  
  if ((TradeWithBu==true)&&(BuTranz==false)){
for(int qq=0;qq<total;qq++)
   {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
      if(OrderSelect(qq, SELECT_BY_POS)==true){ 
    if (( OrderSymbol() == Symbol())&& (OrderMagicNumber() == Magic_Number )) {

    }
          
          if (OrderType()==OP_BUY) { 
               
          if ((MarketInfo(OrderSymbol(), MODE_ASK)-OrderOpenPrice()>BU*k*Point)&&(OrderMagicNumber() == Magic_Number )) {
        if (IsTradeAllowed() ){OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Blue); 
           BuTranz=true;}
         }
        
            }
           
 if (OrderType()==OP_SELL) { 
          if ((MarketInfo(OrderSymbol(), MODE_ASK)-OrderOpenPrice()<-BU*k*Point)&&(OrderMagicNumber() == Magic_Number )) {
        if (IsTradeAllowed() ){ OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Blue); 
            BuTranz=true; }}
       }}}}
  
  
    if ((TradeWithTralling==true)&&(BuTranz==true)){
for(int qqq=0;qqq<total;qqq++)
   {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
      if(OrderSelect(qqq, SELECT_BY_POS)==true){ 
    if (( OrderSymbol() == Symbol())&& (OrderMagicNumber() == Magic_Number )) {

    }
          
          if (OrderType()==OP_BUY) { 
               
          if ((MarketInfo(OrderSymbol(), MODE_ASK)-OrderStopLoss()>Trall*k*Point)&&(OrderMagicNumber() == Magic_Number )) {
            Stop=(MarketInfo(OrderSymbol(), MODE_ASK)-Trall*k*Point);
           Print (Stop);
        if (IsTradeAllowed() ){OrderModify(OrderTicket(),OrderOpenPrice(),Stop,OrderTakeProfit(),0,Blue); 
           }
         }
        
            }
           
 if (OrderType()==OP_SELL) { 
          if ((MarketInfo(OrderSymbol(), MODE_BID)-OrderStopLoss()<-Trall*k*Point)&&(OrderMagicNumber() == Magic_Number )) {
          Stop=(MarketInfo(OrderSymbol(), MODE_BID)+Trall*k*Point);
            Print (Stop);
        if (IsTradeAllowed() ){ OrderModify(OrderTicket(),OrderOpenPrice(),Stop,OrderTakeProfit(),0,Blue); 
             }}
       }}}}
  
  
  
    NewTraid=false;
     if ((((High[1]-Low[1])>CandleSize*k*Point)||((Low[1]-High[1])>CandleSize*k*Point))&&(Hour()>1)&&(OpenOrder==false)){   
        if ((((Close[1]-Open[1])>BodySize*k*Point))&&(Bid>(Low[1]-filtr*k*Point-10*k*Point))&&(Bid<(Low[1]-filtr*k*Point))&&(TraidToday==false)) {        
      
   CheckLastOrder();
   CheckNextLot();
 
    RefreshRates();
    if (IsTradeAllowed()) { 
    
    Print(OpenOrder);
    if(OrderSend(Symbol(),OP_SELL,Lot,Bid,Slipage*k,NULL,NULL,CommentNextOrder,Magic_Number,0,Red) < 0) 
      
      { 
        Alert("Ошибка открытия позиции № ", GetLastError()); 
      }
      else
      {
      NewTraid=true;TraidToday=true;
      } 
      Sleep(SleepTime*100); 
      }}    
if (((Open[1]-Close[1])>BodySize*k*Point)&&(Ask<(High[1]+filtr*k*Point+10*k*Point))&&(Ask>(High[1]+filtr*k*Point))&&(TraidToday==false)){
   CheckLastOrder();
   CheckNextLot();
   RefreshRates();
  Print(OpenOrder);
 if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot,Ask,Slipage*k,NULL,NULL,CommentNextOrder,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
      else
      {
      NewTraid=true;TraidToday=true;
      }   
         Sleep(SleepTime*100);
      } }
 }
  
  
  
  
  
  
  
  
  
  if(!isNewBar())return(0);
   BuTranz=false;TraidToday=false;
   Sleep(SleepTime*100);

     

   
   
   
   
  if(
  Orders_Total_by_type(OP_BUY, Magic_Number, Symbol()) > 0)

   
 if(
 Orders_Total_by_type(OP_SELL, Magic_Number, Symbol()) > 0)
  
   
   return(0);
  }
//+------------------------------------------------------------------+



double CheckLastOrder(){

int totalh=OrdersHistoryTotal();
for (int iei=totalh; iei>=0; iei--)
{
if(OrderSelect(iei, SELECT_BY_POS,MODE_HISTORY ))
{

if(OrderSymbol()==Symbol() &&OrderMagicNumber()==Magic_Number && (OrderProfit()<0)){
loose=loose+1;
break;
}
if(OrderSymbol()==Symbol() &&OrderMagicNumber()==Magic_Number && (OrderProfit()>0)){
loose=0;
break;
}


}}

if(loose==0){CommentNextOrder="1";}
if(loose=="1"){CommentNextOrder="2";}
if(loose=="2"){CommentNextOrder="3";}
if(loose=="3"){CommentNextOrder="4";}
if(loose=="4"){CommentNextOrder="5";}
if(loose=="5"){CommentNextOrder="6";}
if(loose=="6"){CommentNextOrder="7";}
if(loose=="7"){CommentNextOrder="8";}
if(loose=="8"){CommentNextOrder="9";}
if(loose=="9"){CommentNextOrder="10";}
if(loose=="10"){CommentNextOrder="11";}
if(loose=="11"){CommentNextOrder="12";}
if(loose=="12"){CommentNextOrder="13";}
if(loose=="13"){CommentNextOrder="14";}
if(loose=="14"){CommentNextOrder="15";}
if(loose=="15"){CommentNextOrder="16";}
if(loose=="16"){CommentNextOrder="17";}
if(loose=="17"){CommentNextOrder="18";}
if(loose=="18"){CommentNextOrder="19";}
if(loose=="19"){CommentNextOrder="20";}
if(loose=="20"){CommentNextOrder="21";}
if(loose=="21"){CommentNextOrder="21";}


return(CommentNextOrder); }


double CheckNextLot(){


if(CommentNextOrder=="1"){Lot=lot1;}
if(CommentNextOrder=="2"){Lot=lot2;}
if(CommentNextOrder=="3"){Lot=lot3;}
if(CommentNextOrder=="4"){Lot=lot4;}
if(CommentNextOrder=="5"){Lot=lot5;}
if(CommentNextOrder=="6"){Lot=lot6;}
if(CommentNextOrder=="7"){Lot=lot7;}
if(CommentNextOrder=="8"){Lot=lot8;}
if(CommentNextOrder=="9"){Lot=lot9;}
if(CommentNextOrder=="10"){Lot=lot10;}
if(CommentNextOrder=="11"){Lot=lot11;}
if(CommentNextOrder=="12"){Lot=lot12;}
if(CommentNextOrder=="13"){Lot=lot13;}
if(CommentNextOrder=="14"){Lot=lot14;}
if(CommentNextOrder=="15"){Lot=lot15;}
if(CommentNextOrder=="16"){Lot=lot16;}
if(CommentNextOrder=="17"){Lot=lot17;}
if(CommentNextOrder=="18"){Lot=lot18;}
if(CommentNextOrder=="19"){Lot=lot19;}
if(CommentNextOrder=="20"){Lot=lot20;}
if(CommentNextOrder=="21"){Lot=lot21;}

return(Lot); }


bool isNewBar()
  {
  static datetime BarTime;  
   bool res=false;
    
   if (BarTime!=Time[0]) 
      {
         BarTime=Time[0];  
         res=true;
      } 
   return(res);
  }
  
//---- Возвращает количество ордеров указанного типа ордеров ----//
int Orders_Total_by_type(int type, int mn, string sym)
{
   int num_orders=0;
   for(int i= OrdersTotal()-1;i>=0;i--)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber() == mn && type == OrderType() && sym==OrderSymbol())
         num_orders++;
   }
   return(num_orders);
}

