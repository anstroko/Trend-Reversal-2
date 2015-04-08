
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
bool NewTraid;
bool TraidToday;

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

if (NewTraid==true){
   for(int in=0;in<OrdersTotal();in++)
     {      if(OrderSelect(in,SELECT_BY_POS)==true)
        {
         if((OrderSymbol()==Symbol())&&(OrderMagicNumber()==Magic_Number) )
           {
           OpenOrder=true;
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
     if (((High[1]-Low[1])>CandleSize*k*Point)||((Low[1]-High[1])>CandleSize*k*Point)&&(OpenOrder==false))        {   
        if ((((Close[1]-Open[1])>BodySize*k*Point))&&(Bid>(Low[1]-filtr*k*Point-10*k*Point))&&(Bid<(Low[1]-filtr*k*Point))&&(TraidToday==false)) {        
      
   
    RefreshRates();
    if (IsTradeAllowed()) { 
    
    
    if(OrderSend(Symbol(),OP_SELL,lot,Bid,Slipage*k,NULL,NULL,"TrendReversal2",Magic_Number,0,Red) < 0) 
      
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
   RefreshRates();
 if (IsTradeAllowed()) { if(    OrderSend(Symbol(),OP_BUY,lot,Ask,Slipage*k,NULL,NULL,"TrendReversal2",Magic_Number,0,Blue) < 0) 
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

