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

int OpenBuyPositions()
{
  int BuyPositionNumer = 0;
  for (int a = PositionsTotal() - 1; a >= 0; a--)
  {
    long PositionType = PositionGetInteger(POSITION_TYPE);
    if (PositionType == POSITION_TYPE_BUY)
    {
      BuyPositionNumer = BuyPositionNumer + 1;
    }
  }
  return BuyPositionNumer;
}

int SellBuyPositions()
{
  int BuyPositionNumer = 0;
  for (int a = PositionsTotal() - 1; a >= 0; a--)
  {
    long PositionType = PositionGetInteger(POSITION_TYPE);
    if (PositionType == POSITION_TYPE_SELL)
    {
      BuyPositionNumer = BuyPositionNumer + 1;
    }
  }
  return BuyPositionNumer;
}

bool candleSebelumnyaNaik()
{
  double openPri = iOpen(Symbol(), 0, 1);
  double closePri = iClose(Symbol(), 0, 1);
  double highPri = iHigh(Symbol(), 0, 1);
  double lowPri = iLow(Symbol(), 0, 1);
  // CEK APA CANDLE SEBELUMNYA NAIK
  if (openPri < closePri)
  {
    return true;
  }
  else
  {
    return false;
  }
}
bool candleSebelumnyaNaik2()
{
  double openPri = iOpen(Symbol(), 0, 1);
  double closePri = iClose(Symbol(), 0, 1);
  double highPri = iHigh(Symbol(), 0, 1);
  double lowPri = iLow(Symbol(), 0, 1);
  // CEK APA CANDLE SEBELUMNYA NAIK
  if (openPri < closePri)
  {
    return true;
  }
  else
  {
    return false;
  }
}
bool candleSebelumnyaNaik3()
{
  double openPri = iOpen(Symbol(), 0, 1);
  double closePri = iClose(Symbol(), 0, 1);
  double highPri = iHigh(Symbol(), 0, 1);
  double lowPri = iLow(Symbol(), 0, 1);
  // CEK APA CANDLE SEBELUMNYA NAIK
  if (openPri < closePri)
  {
    return true;
  }
  else
  {
    return false;
  }
}

void OnTick()
{
  double openPri = iOpen(Symbol(), 0, 1);
  double closePri = iClose(Symbol(), 0, 1);
  double highPri = iHigh(Symbol(), 0, 1);
  double lowPri = iLow(Symbol(), 0, 1);

  // DEKLARASI CHECK APA ADA CANDLE BARU
  static datetime dtBarCurrent = WRONG_VALUE;
  datetime dtBarPrevious = dtBarCurrent;
  dtBarCurrent = iTime(_Symbol, _Period, 0);
  bool bNewBarEvent = (dtBarCurrent != dtBarPrevious);

  // DEKLARASI ASK
  double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

  // CEK BALANCE DAN EQUITY
  double abA = AccountInfoDouble(ACCOUNT_BALANCE);
  double aeA = AccountInfoDouble(ACCOUNT_EQUITY);
  double amA = AccountInfoDouble(ACCOUNT_MARGIN);
  double afmA = AccountInfoDouble(ACCOUNT_MARGIN_FREE);

  // CEK APABILA SALDO AWAL SAMA DENGAN SALDO SAAT INI
  static double balanceCurrentA = WRONG_VALUE;
  double balancePreviousA = balanceCurrentA;
  balanceCurrentA = abA;
  bool newBalanceA = (balanceCurrentA != balancePreviousA);
  if (newBalanceA)
  {
  }

  // JIKA EQUITY LEBIH BESAR DARI BALANCE
  // if (aeA > (abA + 1.5))
  // {
  //   Print("AccountBalance" + abA + " ----- AccountEquity" + aeA);
  //   closeAllPositions();
  // }

  if (bNewBarEvent)
  {
    bool openSatuSaja = true;
  }

  // JIKA EQUITY LEBIH BESAR DARI BALANCE
  if (aeA > (abA + 1))
  {
    Print("AccountBalance" + abA + " ----- AccountEquity=" + aeA + " ---- AccountEquityPlus 1=" + (aeA + 1));
    closeAllPositions();
  }

  if (bNewBarEvent)
  {

    DeletePendingOrder();
    // closeAllPositions();

    trade.BuyStop(
        0.01,                    // lots
        highPri + 1000 * _Point, // buy price
        NULL,                    // current symbol
        0,                       // stop loss
        0,                       // take profit
        ORDER_TIME_GTC,          // order lifetime
        0,                       // order expiration time
        "Buy Stop By pebriantara");

    // if (candleSebelumnyaNaik)
    // {
    //   if((highPri-lowPri)>(closePri-openPri)){

    //   }
    // }

    trade.SellStop(
        0.01,                   // lots
        lowPri - 1000 * _Point, // buy price
        NULL,                   // current symbol
        0,                      // stop loss
        0,                      // take profit
        ORDER_TIME_GTC,         // order lifetime
        0,                      // order expiration time
        "Sell Stop By pebriantara");
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
  double openPri = iOpen(Symbol(), 0, 1);
  double closePri = iClose(Symbol(), 0, 1);
  double highPri = iHigh(Symbol(), 0, 1);
  double lowPri = iLow(Symbol(), 0, 1);
  double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

  trade.BuyStop(
      0.1,                    // lots
      highPri + 200 * _Point, // buy price
      NULL,                   // current symbol
      0,                      // stop loss
      0,                      // take profit
      ORDER_TIME_GTC,         // order lifetime
      0,                      // order expiration time
      "Buy Stop By pebriantara");

  trade.BuyStop(
      0.01,                   // lots
      highPri + 200 * _Point, // buy price
      NULL,                   // current symbol
      lowPri,                 // stop loss
      highPri + 450 * _Point, // take profit
      ORDER_TIME_GTC,         // order lifetime
      0,                      // order expiration time
      "Buy Stop By pebriantara");
}

void sellStopA()
{
  double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

  trade.SellStop(
      0.01,               // lots
      Bid - 200 * _Point, // buy price
      NULL,               // current symbol
      0,                  // stop loss
      Bid - 200 * _Point, // take profit
      ORDER_TIME_GTC,     // order lifetime
      0,                  // order expiration time
      "Sell Stop By pebriantara");
}

void closeAllPositions()
{
  ulong st = GetMicrosecondCount();

  CTrade sTrade;
  sTrade.SetAsyncMode(true); // true:Async, false:Sync

  for (int cnt = PositionsTotal() - 1; cnt >= 0 && !IsStopped(); cnt--)
  {
    if (PositionGetTicket(cnt))
    {
      sTrade.PositionClose(PositionGetInteger(POSITION_TICKET), 100);
      uint code = sTrade.ResultRetcode();
      Print(IntegerToString(code));
    }
  }

  for (int i = 0; i < 100; i++)
  {
    Print(IntegerToString(GetMicrosecondCount() - st) + "micro " + IntegerToString(PositionsTotal()));
    if (PositionsTotal() <= 0)
    {
      break;
    }
    Sleep(100);
  }
}

void DeletePendingOrder()
{
  int ord_total = OrdersTotal();
  if (ord_total > 0)
  {
    for (int i = ord_total - 1; i >= 0; i--)
    {
      ulong ticket = OrderGetTicket(i);
      if (OrderSelect(ticket) && OrderGetString(ORDER_SYMBOL) == Symbol())
      {
        // CTrade *trade = new CTrade();
        trade.OrderDelete(ticket);
        // delete trade;
      }
    }
  }
  //---
  return;
}