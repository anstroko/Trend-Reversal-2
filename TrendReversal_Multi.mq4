
#property copyright "AlexanderS"
extern string Пapаметры=" Параметры советника";
extern int TP=210;
extern int SL=200;
extern int filtr=-50;
extern double RiskOnTreid;
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


double TotalLoose;
double Koef=1;
double CurSum;
double RiskSumm;
int kk;

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
double S;

int init()
{
   if((Digits==3)||(Digits==5)) { k=10;}
   if((Digits==4)||(Digits==2)) { k=1;}

   if (Digits==2){kk=100;}
     if (Digits==3){kk=1000;}
       if (Digits==4){kk=10000;}
          if (Digits==5){kk=10000;}
          Koef=1;
   StoimPunkt();
   
   return(0);
}

int deinit()
{
   return(0);
}

int start()
{


 ObjectCreate("label_object1",OBJ_LABEL,0,0,0);
ObjectSet("label_object1",OBJPROP_CORNER,4);
ObjectSet("label_object1",OBJPROP_XDISTANCE,10);
ObjectSet("label_object1",OBJPROP_YDISTANCE,10);
ObjectSetText("label_object1","Сумма убытка "+TotalLoose+ "Количество убытков"+loose,12,"Arial",Blue);

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
      if (CommentNextOrder=="1"){
   MMTrueFunctionSell();}
 Print("Открываем ордер на продажу ",CommentNextOrder);
    RefreshRates();
    if (IsTradeAllowed()) { 
    
    if(OrderSend(Symbol(),OP_SELL,Lot*NormalizeDouble(Koef,0),Bid,Slipage*k,NULL,NULL,CommentNextOrder,Magic_Number,0,Red) < 0) 
      
      { 
        Alert("Ошибка открытия позиции № ", GetLastError()); 
      }
      else
      {
      NewTraid=true;TraidToday=true;SendMail("Открыт ордер на продажу "+Symbol(),"Торгуем"+Lot+" Ордер по счету "+CommentNextOrder);
      } 
      Sleep(SleepTime*100); 
      }}    
if (((Open[1]-Close[1])>BodySize*k*Point)&&(Ask<(High[1]+filtr*k*Point+10*k*Point))&&(Ask>(High[1]+filtr*k*Point))&&(TraidToday==false)){
   CheckLastOrder();
   CheckNextLot();
   if (CommentNextOrder=="1"){
   MMTrueFunctionBuy();}
   RefreshRates();
 Print("Открываем ордер на покупку ",CommentNextOrder);
 if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,Lot*NormalizeDouble(Koef,0),Ask,Slipage*k,NULL,NULL,CommentNextOrder,Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError());
      }
      else
      {
      NewTraid=true;TraidToday=true;SendMail("Открыт ордер на покупку "+Symbol(),"Торгуем c лотом "+Lot+" Ордер по счету "+CommentNextOrder);
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
for (int iei=totalh-1; iei>=0; iei--)
{
if(OrderSelect(iei, SELECT_BY_POS,MODE_HISTORY ))
{

if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic_Number) && (OrderProfit()<0)&&(loose<8)){
loose=loose+1;
TotalLoose=OrderProfit()+TotalLoose;
break;
}
if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic_Number) && (OrderProfit()<0)&&(loose==8)){
TotalLoose=OrderProfit()+TotalLoose; break;
}
if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic_Number) && (OrderProfit()>0)&&(loose<8)){
if ((OrderProfit()-TotalLoose)>0) {TotalLoose=0;loose=0;break;}
else {TotalLoose=TotalLoose+OrderProfit();}
}
if(OrderSymbol()==Symbol() && (OrderMagicNumber()==Magic_Number) && (OrderProfit()>0)&&(loose==8)){
TotalLoose=TotalLoose+OrderProfit();
if (TotalLoose>0){TotalLoose=0;loose=0;}
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


return(Lot); }

double StoimPunkt()
{RefreshRates();
if(MarketInfo(Symbol(),MODE_TICKVALUE)!=0&&MarketInfo(Symbol(),MODE_TICKSIZE)!=0&&MarketInfo(Symbol(),MODE_POINT)!=0){
S = MarketInfo(Symbol(),MODE_TICKVALUE)/(MarketInfo(Symbol(),MODE_TICKSIZE)/MarketInfo(Symbol(),MODE_POINT));}
return(S);}


double MMTrueFunctionBuy ()
{ RiskSumm=(AccountBalance())*RiskOnTreid/100;

CurSum=0;
Koef=1;
while (RiskSumm>CurSum)
{CurSum=(SL)*Koef*Lot*S*10;
Koef=Koef+0.1;

}


return (Koef);}


double MMTrueFunctionSell ()
{ RiskSumm=(AccountBalance())*RiskOnTreid/100;

CurSum=0;
Koef=1;
while (RiskSumm>CurSum)
{CurSum=(SL)*Koef*Lot*S*10;
Koef=Koef+0.1;

}


return (Koef);}

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

