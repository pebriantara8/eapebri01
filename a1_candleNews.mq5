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
// trade.SetAsyncMode(true);

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

  if (bNewBarEvent)
  {
    Print("Candle Baru");
    // DeletePendingOrder();
    // if (PositionsTotal() < 0)
    // {
    //   double TPBuy = highPri + 1200 * _Point;
    //   double SLBuy = highPri + 500 * _Point;
    //   double TPSell = lowPri - 1200 * _Point;
    //   double SLSell = lowPri - 500 * _Point;

    //   trade.BuyStop(
    //       0.01,                    // lots
    //       highPri + 1000 * _Point, // buy price
    //       NULL,                    // current symbol
    //       SLBuy,                   // stop loss
    //       TPBuy,                   // take profit
    //       ORDER_TIME_GTC,          // order lifetime
    //       0,                       // order expiration time
    //       "Buy Stop By pebriantara");

    //   trade.SellStop(
    //       0.01,                    // lots
    //       highPri - 1000 * _Point, // price
    //       NULL,                    // current symbol
    //       SLSell,                  // stop loss
    //       TPSell,                  // take profit
    //       ORDER_TIME_GTC,          // order lifetime
    //       0,                       // order expiration time
    //       "Sell Stop By pebriantara");
    // }
  }
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