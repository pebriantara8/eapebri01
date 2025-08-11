//+------------------------------------------------------------------+
//|                                                 antara_01_m1.mq5 |
//|                                                      pebriantara |
//|                                    https://www.pebriantara.my.id |
//+------------------------------------------------------------------+
#property copyright "pebriantara100"
#property link      "https://www.pebriantara.my.id"
#property version   "1.00"

input double Lots_atas = 0.01;

input int SLsell = 50;
input int TPsell = 100;
input int SLbuy = 50;
input int TPbuy = 100;
input int TrailingStop = 120;

input int FontSize = 8;

input group "-----------------";

#include <Trade\Trade.mqh>

CTrade trade;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    // get Ask Price
    double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

    // create array for the price
    MqlRates PriceInfo[];

    // Sort the price array from the current candle downward
    ArraySetAsSeries(PriceInfo, true);

    // find array with the price data
    int PriceData = CopyRates(_Symbol, _Period,0,3,PriceInfo);

    // when the candle is bullish
    if(PriceInfo[1].close > PriceInfo[1].open){

    }

    // if we have no position
    if(PositionsTotal()==0){
      trade.Buy(
        0.01, // lots
        NULL, // current symbol
        Ask, // buy price
        Ask-300*_Point, // stop loss
        Ask+500*_Point, // take profit
        "O rder Buy pebriantara"); // comment
    }


  //  orderbuy();
  }
//+------------------------------------------------------------------+

void orderbuy(){

  double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

  double Lots = 0.01;
  double SL = Ask-SLbuy*_Point;
  if(SLbuy == 0) SL = 0;
  double TP = Ask+TPbuy*_Point;
  if(TPbuy == 0) TP = 0;

  trade.Buy(Lots,NULL,Ask,SL,TP,"Komen EA Buy");
}