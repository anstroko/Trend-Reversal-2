
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


int k;
bool BuTranz=false;
double Stop;
bool flag_sell=false,flag_buy=false;
int i;

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

bool OpenOrder=false;
  int total=OrdersTotal();
  
  if ((TradeWithBu==true)&&(BuTranz==false)){
for(int qq=0;qq<total;qq++)
   {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
      if(OrderSelect(qq, SELECT_BY_POS)==true){ 
    if (( OrderSymbol() == Symbol())&& (OrderMagicNumber() == Magic_Number )) {

    }
          
          if (OrderType()==OP_BUY) { 
               
          if ((MarketInfo(OrderSymbol(), MODE_ASK)-OrderOpenPrice()>BU*Point)&&(OrderMagicNumber() == Magic_Number )) {
        if (IsTradeAllowed() ){OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice(),OrderTakeProfit(),0,Blue); 
           BuTranz=true;}
         }
        
            }
           
 if (OrderType()==OP_SELL) { 
          if ((MarketInfo(OrderSymbol(), MODE_ASK)-OrderOpenPrice()<-BU*Point)&&(OrderMagicNumber() == Magic_Number )) {
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
               
          if ((MarketInfo(OrderSymbol(), MODE_ASK)-OrderStopLoss()>Trall*Point)&&(OrderMagicNumber() == Magic_Number )) {
            Stop=(MarketInfo(OrderSymbol(), MODE_ASK)-Trall*Point);
           Print (Stop);
        if (IsTradeAllowed() ){OrderModify(OrderTicket(),OrderOpenPrice(),Stop,OrderTakeProfit(),0,Blue); 
           }
         }
        
            }
           
 if (OrderType()==OP_SELL) { 
          if ((MarketInfo(OrderSymbol(), MODE_BID)-OrderStopLoss()<-Trall*Point)&&(OrderMagicNumber() == Magic_Number )) {
          Stop=(MarketInfo(OrderSymbol(), MODE_BID)+Trall*Point);
            Print (Stop);
        if (IsTradeAllowed() ){ OrderModify(OrderTicket(),OrderOpenPrice(),Stop,OrderTakeProfit(),0,Blue); 
             }}
       }}}}
  
  
  
  
  if ((DayOfWeek()==5)&&(TimeHour(TimeCurrent())==22)&&(TimeMinute(TimeCurrent())==00)){
   for (int ii=OrdersTotal()-1; ii>=0; ii--)
   {
      if (!OrderSelect(ii,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_BUYSTOP  )&&(OrderMagicNumber() == Magic_Number )) OrderDelete(OrderTicket());
      if ((OrderType()==OP_SELLSTOP )&&(OrderMagicNumber() == Magic_Number )) OrderDelete(OrderTicket());
         }
  
  
  }
  
  
  
  
  
  
  
  
  
  if(!isNewBar())return(0);
   BuTranz=false;
   Sleep(SleepTime*100);
 for (int i=OrdersTotal()-1; i>=0; i--)
   {
      if (!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) break;
            if ((OrderType()==OP_BUYSTOP  )&&(OrderMagicNumber() == Magic_Number )) OrderDelete(OrderTicket());
      if ((OrderType()==OP_SELLSTOP )&&(OrderMagicNumber() == Magic_Number )) OrderDelete(OrderTicket());
         }
          OpenOrder=false; 
       for(int pos=0;pos<total;pos++)
   {
      // результат выбора проверки, так как ордер может быть закрыт или удален в это время!
      if(OrderSelect(pos, SELECT_BY_POS)==true){ 
    if (( OrderSymbol() == Symbol())&& (OrderMagicNumber() == Magic_Number )) {
    OpenOrder=true;  
    }}}    
        Sleep(SleepTime*100);    
     
     if (((High[1]-Low[1])>CandleSize*k*Point)||((Low[1]-High[1])>CandleSize*k*Point)&&(OpenOrder==false))        {   
        if ((Close[1]-Open[1])>BodySize*k*Point) {        
      
   
    RefreshRates();
    if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_SELLSTOP,lot,Low[1]-filtr*k*Point,Slipage*k,Low[1]-filtr*k*Point+SL*k*Point,Low[1]-filtr*k*Point-TP*k*Point,"TrendReversal2",Magic_Number,0,Red) < 0) 
      
      { 
        Alert("Ошибка открытия позиции № ", GetLastError()); 
      }}
Sleep(SleepTime*100);
    
      
    
  
}
      
        if ((Open[1]-Close[1])>BodySize*k*Point){
        
        
   
    RefreshRates();
 if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUYSTOP,lot,High[1]+filtr*k*Point,Slipage*k,High[1]+filtr*k*Point-SL*k*Point,High[1]+filtr*k*Point+TP*k*Point,"TrendReversal2",Magic_Number,0,Blue) < 0) 
      { 
        Alert("Ошибка открытия позиции № ", GetLastError()); 
      } }
Sleep(SleepTime*100);
    
      

}
        
      }
   
   
   
   
  if(
  Orders_Total_by_type(OP_BUY, Magic_Number, Symbol()) > 0)

   
 if(
 Orders_Total_by_type(OP_SELL, Magic_Number, Symbol()) > 0)
  
   
   return(0);
  }
//+------------------------------------------------------------------+

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

