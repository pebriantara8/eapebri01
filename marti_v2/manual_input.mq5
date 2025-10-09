//+------------------------------------------------------------------+
//|                                                           a1.mq5 |
//|                                                      pebriantara |
//|                                    https://www.pebriantara.my.id |
//+----s--------------------------------------------------------------+
// OPEN BERDASARKAN WAKTU SETIAP SATU MENIT OPEN POSISI MARTINGALE
// AKUN ZERO
#property copyright "pebriantara"
#property link "https://www.pebriantara.my.id"
#property version "1.00"

#include <Trade\Trade.mqh>
CTrade trade;
// trade.SetAsyncMode(true);

input double lotA = 0.01;
input double lostPlus = 0.01;
input double pointRange = 1000;
input double profitDouble = true;

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
  // datetime time1 = D'2025.09.01 05:35';
  // datetime time2 = D'2025.09.01 09:00';
  // if (TimeCurrent() > time1 && TimeCurrent() < time2)
  // if (TimeCurrent() > time2)
  // {
  // JIKA ADA POSISI MAKA CLOSE ALL IF

  double manyPositionBuy = 0;
  double manyPositionSell = 0;
  double PositionProfitBuy = 0;
  double PositionProfitSell = 0;
  int lastBuy = 999;
  int lastSell = 999;
  double lastPriceBuy = 0;
  double lastPriceSell = 0;
  double lastLotBuy = 999;
  double lastLotSell = 999;

  if (!PositionGetTicket(0))
  {
  }
  else
  {
    // CEK BERAPA BANYAK OPEN ORDER
    for (int cnt = PositionsTotal() - 1; cnt >= 0 && !IsStopped(); cnt--)
    {
      if (PositionGetTicket(cnt))
      {
        ENUM_POSITION_TYPE posisiType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        double pPriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
        double posisiProfit = PositionGetDouble(POSITION_PROFIT);
        double pVolume = PositionGetDouble(POSITION_VOLUME);
        if (posisiType == 0)
        {
          manyPositionBuy = manyPositionBuy + 1;
          PositionProfitBuy = PositionProfitBuy + posisiProfit;
          if (lastBuy == 999)
          {
            lastBuy = cnt - 1;
            lastPriceBuy = pPriceOpen;
            lastLotBuy = pVolume;
          }
        }
        if (posisiType == 1)
        {
          manyPositionSell = manyPositionBuy + 1;
          PositionProfitSell = PositionProfitSell + posisiProfit;
          if (lastSell == 999)
          {
            lastSell = cnt - 1;
            lastPriceSell = pPriceOpen;
            lastLotSell = pVolume;
          }
        }
      }
    }

    // BUY PLUS SATU
    if (Ask <= lastPriceBuy - (pointRange * _Point) && lastPriceBuy != 0)
    {
      trade.Buy(
          lastLotBuy + 0.01, // lots
          NULL,              // current symbol
          Ask,               // buy price
          0,                 // stop loss
          0,                 // take profit
          "Buy ea");
    }
    if (Bid >= lastPriceSell + (pointRange * _Point) && lastPriceSell != 0)
    {
      trade.Sell(
          lastLotSell + 0.01, // lots
          NULL,               // current symbol
          Bid,                // buy price
          0,                  // stop loss
          0,                  // take profit
          "Sell ea");
    }

    if (aeA + 2400 < abA)
    {
      // Print("ABA = " + abA);
      // Print("AEA = " + aeA);
      // closeAllPositions();
      // Sleep(5000);
    }
  }

  // CLOSE POSISITON PROFIT
  if (PositionProfitBuy >= 1)
  {
    for (int cnt = PositionsTotal() - 1; cnt >= 0 && !IsStopped(); cnt--)
    {
      if (PositionGetTicket(cnt))
      {
        ENUM_POSITION_TYPE posisiType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        if (posisiType == 0)
        {
          trade.PositionClose(PositionGetInteger(POSITION_TICKET), 100);
          uint code = trade.ResultRetcode();
          Print(IntegerToString(code));
        }
      }
    }
  }
  if (PositionProfitSell >= 1)
  {
    for (int cnt = PositionsTotal() - 1; cnt >= 0 && !IsStopped(); cnt--)
    {
      if (PositionGetTicket(cnt))
      {
        ENUM_POSITION_TYPE posisiType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        if (posisiType == 1)
        {
          trade.PositionClose(PositionGetInteger(POSITION_TICKET), 100);
          uint code = trade.ResultRetcode();
          Print(IntegerToString(code));
        }
      }
    }
  }

  // }
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