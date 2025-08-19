//+------------------------------------------------------------------+
//|                                                           a1.mq5 |
//|                                                      pebriantara |
//|                                    https://www.pebriantara.my.id |
//+----s--------------------------------------------------------------+
#property copyright "pebriantara"
#property link "https://www.pebriantara.my.id"
#property version "1.00"

#include <Trade\Trade.mqh>
CTrade trade;

int PricePlus = 500;
int SLPoin = 450;
int TPPoin = 600;

void OnTick()
{
  // get Ask Price
  double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

  // create array for the price
  MqlRates PriceInfo[];

  // Sort the price array from the current candle downward
  ArraySetAsSeries(PriceInfo, true);

  // find array with the price data
  int PriceData = CopyRates(_Symbol, _Period, 0, 3, PriceInfo);

  // when the candle is bullish
  // if(PriceInfo[1].close > PriceInfo[1].open){

  // }

  // if we have no position
  // if(PositionsTotal()==0){
  //   trade.Buy(
  //     0.01, // lots
  //     NULL, // current symbol
  //     Ask, // buy price
  //     Ask-300*_Point, // stop loss
  //     Ask+500*_Point, // take profit
  //     "O rder Buy pebriantara"); // comment
  // }

  // if(PositionsTotal()==0){
  //       trade.Buy(
  //         0.01, // lots
  //         NULL, // current symbol
  //         Ask, // buy price
  //         Ask-300*_Point, // stop loss
  //         Ask+500*_Point, // take profit
  //         "O rder Buy pebriantara");
  // }

  // if(PositionsTotal()==0){
  //   trade.BuyStop(
  //     0.01, // lots
  //     Ask+50*_Point, // buy price
  //     NULL, // current symbol
  //     Ask-50*_Point, // stop loss
  //     Ask+200*_Point, // take profit
  //     ORDER_TIME_GTC, // order lifetime
  //     0, // order expiration time
  //     "O rder Buy pebriantara");
  // }

  // if(PositionsTotal()==0){
  //   trade.BuyStop(
  //     0.01, // lots
  //     Ask+50*_Point, // buy price
  //     NULL, // current symbol
  //     0, // stop loss
  //     0, // take profit
  //     ORDER_TIME_GTC, // order lifetime
  //     0, // order expiration time
  //     "O rder Buy pebriantara");
  // }

  // closeAllPositions();

  // pending order di atas harga

  // CHECK APA ADA CANDLE BARU
  static datetime dtBarCurrent = WRONG_VALUE;
  datetime dtBarPrevious = dtBarCurrent;
  dtBarCurrent = iTime(_Symbol, _Period, 0);
  bool bNewBarEvent = (dtBarCurrent != dtBarPrevious);

  if (bNewBarEvent)
  {

    int count = 0;
    double p_gapBuy = 20;
    double poin_tambah = 0;
    double Ask_buy = 75;
    // for (int i = 8; i > count; i++)
    // {
    // Ask_buy = (Ask_buy+poin_tambah)*_Point;
    // poin_tambah = 20+poin_tambah;
    // double tp_buy = ((Ask_buy/_Point)+100)*_Point;

    // JIKA CANDLE MERAH MAKAT SELL STOP
    double openPri = iOpen(Symbol(), 0, 1);
    double closePri = iClose(Symbol(), 0, 1);
    double highPri = iHigh(Symbol(), 0, 1);
    double lowPri = iLow(Symbol(), 0, 1);

    // JIKA CANDLE NAIK
    // if (openPri < closePri)
    // {
    //   if ((highPri - closePri) < (openPri - lowPri))
    //   {
    //     buyStopA();
    //   }
    // }

    // BUY JIKA NOW PRICE LEBIH TINGGI DARI HIGH CANDLE

    if (PositionsTotal() < 1)
    {
      // Print("higtPri=" + highPri + "-------Ask=" + Ask);
      // buyA();
      trade.BuyStop(
          0.01,                    // lots
          highPri + 50 * _Point,   // buy price
          NULL,                    // current symbol
          highPri - 9000 * _Point, // stop loss
          highPri + 500 * _Point,  // take profit
          ORDER_TIME_GTC,          // order lifetime
          0,                       // order expiration time
          "Buy Stop By pebriantara");
    }
    else
    {
      closeAllPositions();
    }
  }
}

void buyA()
{
  double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
  trade.Buy(
      0.01, // lots
      NULL, // current symbol
      Ask,  // buy price
      0,    // stop loss
      0,    // take profit
      "O rder Buy pebriantara");
}

void sellA()
{
  double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
  trade.Sell(
      0.01,               // lots
      NULL,               // current symbol
      Bid,                // buy price
      Bid + 100 * _Point, // stop loss
      Bid - 120 * _Point, // take profit
      "O rder Buy pebriantara");
}

void buyStopA()
{
  double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

  trade.BuyStop(
      0.1,                // lots
      Ask + 500 * _Point, // buy price
      NULL,               // current symbol
      Ask + 300 * _Point, // stop loss
      Ask + 570 * _Point, // take profit
      ORDER_TIME_GTC,     // order lifetime
      0,                  // order expiration time
      "Buy Stop By pebriantara");
}

void sellStopA()
{
  double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

  trade.SellStop(
      0.1,                      // lots
      Bid - PricePlus * _Point, // buy price
      NULL,                     // current symbol
      0,                        // stop loss
      Bid - TPPoin * _Point,    // take profit
      ORDER_TIME_GTC,           // order lifetime
      0,                        // order expiration time
      "Sell Stop By pebriantara");
}

void closeAllPositions()
{
  for (int i = PositionsTotal() - 1; i >= 0; i++)
  {
    ulong ticket = PositionGetTicket(i);
    trade.PositionClose(ticket);
  }
}