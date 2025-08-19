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

  // CHECK APA ADA CANDLE BARU
  static datetime dtBarCurrent = WRONG_VALUE;
  datetime dtBarPrevious = dtBarCurrent;
  dtBarCurrent = iTime(_Symbol, _Period, 0);
  bool bNewBarEvent = (dtBarCurrent != dtBarPrevious);

  if (bNewBarEvent)
  {
    closeAllPositions();
    double openPri = iOpen(Symbol(), 0, 1);
    double closePri = iClose(Symbol(), 0, 1);
    double highPri = iHigh(Symbol(), 0, 1);
    double lowPri = iLow(Symbol(), 0, 1);

    if (openPri < closePri)
    // JIKA CANDLE NAIK
    {
      if ((highPri - closePri) < (openPri - lowPri))
      {
        double TP = closePri - openPri;
        double SL = TP;
        Print("BUY");
        trade.Buy(
            0.01,     // lots
            NULL,     // current symbol
            Ask,      // buy price
            Ask - TP, // stop loss
            Ask + TP, // take profit
            "O rder Buy pebriantara");
      }
      else
      {
      }
    }
    else
    {
      // JIKA CANDLE TURUN
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