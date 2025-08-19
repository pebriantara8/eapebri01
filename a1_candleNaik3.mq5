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

int tigaCandleSebelumnyaNaik()
{
  double oP = iOpen(Symbol(), Period(), 1);
  double cP = iClose(Symbol(), Period(), 1);
  double hP = iHigh(Symbol(), Period(), 1);
  double lP = iLow(Symbol(), Period(), 1);

  double oP2 = iOpen(Symbol(), Period(), 2);
  double cP2 = iClose(Symbol(), Period(), 2);
  double hP2 = iHigh(Symbol(), Period(), 2);
  double lP2 = iLow(Symbol(), Period(), 2);

  double oP3 = iOpen(Symbol(), Period(), 3);
  double cP3 = iClose(Symbol(), Period(), 3);
  double hP3 = iHigh(Symbol(), Period(), 3);
  double lP3 = iLow(Symbol(), Period(), 3);

  int send = 0;

  // CEK APA CANDLE SEBELUMNYA NAIK
  if (oP < cP)
  {
    if (oP2 < cP2)
    {
      if (oP3 < cP3)
      {
        send = 1;
      }
      else
      {
        send = 2;
      }
    }
    else
    {
      send = 3;
    }
  }
  else
  {
    send = 4;
  }
  return send;
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

  if (bNewBarEvent)
  {
    DeletePendingOrder();
    Print(tigaCandleSebelumnyaNaik());

    if (PositionsTotal() > 0)
    {
    }
    else
    {
      if (tigaCandleSebelumnyaNaik() == 1)
      {
        double TP = Ask + (closePri - openPri);
        double SL = closePri;
        // double TP = highPri + 3000 * _Point;
        // double SL = highPri - 1000 * _Point;
        // JIKA CANDLE SEBELUMNYA TERLALU BESAR
        if (highPri - lowPri > 5000 * _Point)
        {
          TP = highPri + 4000 * _Point;
          SL = highPri - 2000 * _Point;
        }
        trade.BuyStop(
            0.01,                    // lots
            highPri + 1000 * _Point, // buy price
            NULL,                    // current symbol
            SL,                      // stop loss
            TP,                      // take profit
            ORDER_TIME_GTC,          // order lifetime
            0,                       // order expiration time
            "Buy Stop By pebriantara");
      }
    }
  }

  // MODIFY TP DAN SL
  // if (PositionsTotal() > 0 && PositionsTotal() < 2)
  if (PositionsTotal() > 0)
  {
    // if (PositionGetDatetime(POSITION_TIME) !=)
    CTrade sTrade;
    // sTrade.SetAsyncMode(true); // true:Async, false:Sync

    if (PositionGetTicket(0))
    {
      string opAwal = "OP Awal";
      if (Ask > PositionGetDouble(POSITION_TP) - 1000 * _Point)
      {
        // CEK APA ADA UPDATE POSISI
        datetime n = (datetime)PositionGetInteger(POSITION_TIME);
        datetime nUpdate = (datetime)PositionGetInteger(POSITION_TIME_UPDATE);

        Print(nUpdate + " ===== " + n);
        double SLNew = highPri + 1200 * _Point;
        if (n != nUpdate)
        {
          SLNew = PositionGetDouble(POSITION_SL) + 100;
          // SLNew = PositionGetDouble(POSITION_SL) + 100 * _Point;
        }

        // sTrade.PositionModify(
        //     PositionGetInteger(POSITION_TICKET),
        //     SLNew,
        //     PositionGetDouble(POSITION_TP));
        // PositionGetDouble(POSITION_TP) + 100 * _Point);
      }
    }
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