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
CTrade sTrade;
// trade.SetAsyncMode(true);
input double pointChangeOpen = 100;
input double pointSL = 500;
input double pointSLFirstRunning = 300;
input double pointSLDiffRunning = 200;

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
  // datetime time1 = D'2025.09.01 01:00';
  datetime time2 = D '2025.09.01 23:00';
  if (TimeCurrent() > time2)
  // if (TimeCurrent() > time1 && TimeCurrent() < time2)
  {
    // JIKA TIDAK ADA POSISI TERBUKA
    if (PositionsTotal() <= 0)
    {

      // DEKLATASI VARIABEL GLOBAL SET ASK OPEN POSISI
      if (GlobalVariableGet("priceTerakhirSL"))
      {
        // Print("ADA GLOBAL VARIABEL" + GlobalVariableGet("priceTerakhirSL"));
        // GlobalVariableSet("priceTerakhirSL", (double)Ask);
      }
      else
      {
        // Print("TIDAKKKKKKK ADAA GLOBAL VARIABEL");
        GlobalVariableSet("priceTerakhirSL", (double)Ask);
      }

      if (Ask <= (GlobalVariableGet("priceTerakhirSL") - (pointChangeOpen * _Point)))
      {
        trade.Sell(
            0.1,                      // lots
            NULL,                     // current symbol
            Bid,                      // sell price
            Bid + (pointSL * _Point), // stop loss
            0,                        // take profit
            "Sell ea");
      }
      if (Ask >= (GlobalVariableGet("priceTerakhirSL") + (pointChangeOpen * _Point)))
      {
        trade.Buy(
            0.1,                      // lots
            NULL,                     // current symbol
            Ask,                      // sell price
            Ask - (pointSL * _Point), // stop loss
            0,                        // take profit
            "Sell ea");
      }
    }
    else
    {

      // APABILA ADA POSISI TERBUKA
      if (!PositionGetTicket(0))
      {
        Print("ERROR - failed to SELECT POSITION with ticket BUY OR SELL... GAGAL BRO...");
      }
      else
      {
        datetime n = (datetime)PositionGetInteger(POSITION_TIME);
        datetime nUpdate = (datetime)PositionGetInteger(POSITION_TIME_UPDATE);
        ENUM_POSITION_TYPE posisiType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        double posisiOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
        double posisiCurrentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
        double posisiTP = PositionGetDouble(POSITION_TP);
        double posisiSL = PositionGetDouble(POSITION_SL);
        double SLNew = posisiSL;

        // JIKA ADA UPDATE POSISI
        if (n == nUpdate)
        {
          // JIKA POSISI BUY
          if (posisiType == 0)
          {
            if (posisiCurrentPrice >= posisiOpenPrice + pointSLFirstRunning * _Point)
            {
              Print("SL UPDATE PERTAMA");
              SLNew = posisiCurrentPrice - pointSLDiffRunning * _Point;
              sTrade.PositionModify(
                  PositionGetInteger(POSITION_TICKET),
                  SLNew,
                  0);
              GlobalVariableSet("priceTerakhirSL", SLNew);
            }
          }
          if (posisiType == 1)
          {
            if (posisiCurrentPrice <= posisiOpenPrice - pointSLFirstRunning * _Point)
            {
              Print("SL UPDATE PERTAMA");
              SLNew = posisiCurrentPrice + pointSLDiffRunning * _Point;
              sTrade.PositionModify(
                  PositionGetInteger(POSITION_TICKET),
                  SLNew,
                  0);
              GlobalVariableSet("priceTerakhirSL", SLNew);
            }
          }
        }
        else
        {
          // JIKA SUDAH ADA UPDATE POSISI
          // if (posisiType == 0 && posisiCurrentPrice >= posisiSL + pointSLDiffRunning * _Point)
          // {
          //   Print("SL UPDATE KEDUA");
          //   SLNew = posisiCurrentPrice - pointSLDiffRunning * _Point;
          //   sTrade.PositionModify(
          //       PositionGetInteger(POSITION_TICKET),
          //       SLNew,
          //       0);
          //   GlobalVariableSet("priceTerakhirSL", SLNew);
          // }
          // if (posisiType == 1 && posisiCurrentPrice <= posisiSL - pointSLDiffRunning * _Point)
          // {
          //   Print("SL UPDATE KEDUA");
          //   SLNew = posisiCurrentPrice + pointSLDiffRunning * _Point;
          //   sTrade.PositionModify(
          //       PositionGetInteger(POSITION_TICKET),
          //       SLNew,
          //       0);
          //   GlobalVariableSet("priceTerakhirSL", SLNew);
          // }
        }
      }
    }
  }
}

void closeAllPositions()
{
  ulong st = GetMicrosecondCount();

  // CTrade sTrade;
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