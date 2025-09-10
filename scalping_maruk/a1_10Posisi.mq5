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
// CTrade sTrade;
// trade.SetAsyncMode(true);
input double pointChangeOpen = 170;
input double pointSL = 300;
input double pointSLFirstRunning = 100;
input double pointSLDiffRunning = 100;
input double lotA = 0.01;
input double iJarakPoint = 200;

void OnTick()
{
  // DEKLARASI ASK
  double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
  double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

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

  // TENTUKAN RANGE WAKTU BACKTEST
  // datetime time1 = D'2025.09.01 01:57';
  // datetime time2 = D'2025.09.01 02:13';
  // if (TimeCurrent() > time2)
  // if (TimeCurrent() > time1 && TimeCurrent() < time2)
  // {
  // JIKA TIDAK ADA POSISI TERBUKA
  if (OrdersTotal() <= 0)
  {
    double jarakPointAwal = 0;
    double jarakPoint = iJarakPoint;
    double lotAwal = lotA;
    for (int i = 0; i < 20; i++)
    {
      trade.BuyStop(
          lotAwal,                       // lots
          Ask - jarakPointAwal * _Point, // price
          NULL,                          // current symbol
          0,                             // stop loss
          0,                             // take profit
          ORDER_TIME_GTC,                // order lifetime
          0,                             // order expiration time
          "Sell Stop By pebriantara");

      trade.SellStop(
          lotAwal,                       // lots
          Bid + jarakPointAwal * _Point, // price
          NULL,                          // current symbol
          0,                             // stop loss
          0,                             // take profit
          ORDER_TIME_GTC,                // order lifetime
          0,                             // order expiration time
          "Sell Stop By pebriantara");

      jarakPointAwal = jarakPointAwal + iJarakPoint;
      lotAwal = lotAwal + 0.01;
    }
  }
  else
  {
    // APABILA ADA POSISI TERBUKA
    if (aeA > abA + 1)
    {
      closeAllPositions();
      DeletePendingOrder();
    }
  }
}

void tambahPosisi(double lotTambah, double minusA)
{
  double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
  // ANTISIPASI RUNNING
  //--- SELECT POSITION BUY
  if (!PositionGetTicket(0))
  {
    Print("ERROR - failed to SELECT POSITION with ticket #0 POSISI 0");
  }
  else
  {
    // TAMBAH POSISI JIKA
    double pP = PositionGetDouble(POSITION_PROFIT);
    if (pP <= minusA)
    {
      // Print("POSITION PROFITNYAAAA:" +PositionsTotal());
      trade.Buy(
          lotTambah, // lots
          NULL,      // current symbol
          Ask,       // buy price
          0,         // stop loss
          0,         // take profit
          "Buy ea");
    }
  }
  if (!PositionGetTicket(1))
  {
    Print("ERROR - failed to SELECT POSITION with ticket #0 POSISI 0");
  }
  else
  {
    // TAMBAH POSISI JIKA
    double pP = PositionGetDouble(POSITION_PROFIT);
    if (pP <= minusA)
    {
      trade.Sell(
          lotTambah, // lots
          NULL,      // current symbol
          Ask,       // buy price
          0,         // stop loss
          0,         // take profit
          "Sell ea");
    }
  }
  return;
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