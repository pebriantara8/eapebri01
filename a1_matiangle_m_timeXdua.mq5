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

  // TENTUKAN RANGE WAKTU BACKTEST
  datetime time1 = D'2025.09.01 01:00';
  datetime time2 = D'2025.09.01 04:00';
  // if (TimeCurrent() > time2)
  if (TimeCurrent() > time1 && TimeCurrent() < time2)
  {
    // JIKA ADA POSISI MAKA CLOSE ALL IF
    if (PositionsTotal() > 0){

      // JIKA POSISION TOTAL=2 ; 0.01
      if(PositionsTotal()==2){
        // Print("POSISI TOTALNYA SAAT INI: "+PositionsTotal());
        tambahPosisi(0.02,-1);
      }

      // JIKA POSISION TOTAL=3 ; 0.02
      if(PositionsTotal()==3){
        // Print("POSISI TOTALNYA SAAT INI: "+PositionsTotal());
        // IF EQUITY > $1
        if(aeA >= abA+1){
          // Print("POSISI BALANCE: "+PositionsTotal());
          // Print("POSISI EQUITYYY: "+PositionsTotal());
          closeAllPositions();
        }
        tambahPosisi(0.04,-2);
      }

      // JIKA POSISION TOTAL = 4 ; 0.04
      if(PositionsTotal()==4){
        // IF EQUITY > $2
        if(aeA >= abA+2){
          closeAllPositions();
        }
        tambahPosisi(0.08,-3);
      }

      // JIKA POSISION TOTAL = 4 ; 0.08
      if(PositionsTotal()==5){
        // IF EQUITY > $2
        if(aeA >= abA+3){
          closeAllPositions();
        }
        tambahPosisi(0.16,-4);
      }

      // JIKA POSISION TOTAL = 4 ; 0.16
      if(PositionsTotal()==6){
        // IF EQUITY > $2
        if(aeA >= abA+4){
          closeAllPositions();
        }
        tambahPosisi(0.32,-5);
      }

      // JIKA POSISION TOTAL = 4 ; 0.32
      if(PositionsTotal()==7){
        // IF EQUITY > $2
        if(aeA >= abA+5){
          closeAllPositions();
        }
        tambahPosisi(0.64,-6);
      }

      // JIKA POSISION TOTAL = 4 ; 0.64
      if(PositionsTotal()==8){
        // IF EQUITY > $2
        if(aeA >= abA+6){
          closeAllPositions();
        }
        // tambahPosisi(1.28,1000);
        if(aeA<=abA-100){
          if(!PositionGetTicket(7)) {
            Print("ERROR - failed to SELECT POSITION with ticket #0 POSISI 0");
          } else{
            // TAMBAH POSISI JIKA
            int typePosisi = PositionGetInteger(POSITION_TYPE);
            if(typePosisi==0){
              trade.Sell(
                1.28, // lots
                NULL, // current symbol
                Ask,  // buy price
                0,    // stop loss
                0,    // take profit
                "Sell ea");
            }else{
              trade.Buy(
                5, // lots
                NULL, // current symbol
                Ask,  // buy price
                0,    // stop loss
                0,    // take profit
                "Sell ea");
            }
          }
        }
      }

      if(PositionsTotal()==9){
        // IF EQUITY > $2
        if(aeA >= abA+1){
          closeAllPositions();
        }
      }
    }

    if(PositionsTotal() <= 0){
        trade.Buy(
      0.01, // lots
      NULL, // current symbol
      Ask,  // buy price
      0,    // stop loss
      0,    // take profit
      "Buy ea");

        trade.Sell(
      0.01, // lots
      NULL, // current symbol
      Ask,  // buy price
      0,    // stop loss
      0,    // take profit
      "Sell ea");
    }
  }
}

void tambahPosisi(double lotA,double minusA){
  double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
  // ANTISIPASI RUNNING
  //--- SELECT POSITION BUY
  if(!PositionGetTicket(0)) {
    Print("ERROR - failed to SELECT POSITION with ticket #0 POSISI 0");
  } else{
    // TAMBAH POSISI JIKA
    double pP = PositionGetDouble(POSITION_PROFIT);
    if(pP <= minusA){
      // Print("POSITION PROFITNYAAAA:" +PositionsTotal());
      trade.Buy(
        lotA, // lots
        NULL, // current symbol
        Ask,  // buy price
        0,    // stop loss
        0,    // take profit
        "Buy ea");
    }
  }
  if(!PositionGetTicket(1)) {
    Print("ERROR - failed to SELECT POSITION with ticket #0 POSISI 0");
  } else{
    // TAMBAH POSISI JIKA
    double pP = PositionGetDouble(POSITION_PROFIT);
    if(pP <= minusA){
      trade.Sell(
        lotA, // lots
        NULL, // current symbol
        Ask,  // buy price
        0,    // stop loss
        0,    // take profit
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