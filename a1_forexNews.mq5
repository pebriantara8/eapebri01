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

  // if ((int)TimeCurrent() > (int)"2024.04.14 12:29:30")
  // {
  // }
  if (bNewBarEvent)
  {
    DeletePendingOrder();
    datetime time1 = D'2025.08.18 15:59';
    datetime time2 = D'2025.08.18 16:01';
    if (TimeCurrent() > time1 && TimeCurrent() < time2)
    {
      if (PositionsTotal() <= 0)
      // Print("Candle Baru Position Total = " + PositionsTotal());
      {
        double TPBuy = highPri + 1200 * _Point;
        double SLBuy = highPri + 500 * _Point;
        double TPSell = lowPri - 1200 * _Point;
        double SLSell = lowPri - 500 * _Point;

        // trade.BuyStop(
        //     0.05,                   // lots
        //     highPri + 500 * _Point, // buy price
        //     NULL,                   // current symbol
        //     0,                      // stop loss
        //     0,                      // take profit
        //     ORDER_TIME_GTC,         // order lifetime
        //     0,                      // order expiration time
        //     "Buy Stop By pebriantara");

        trade.SellStop(
            0.05,                // lots
            lowPri - 2 * _Point, // price
            NULL,                // current symbol
            0,                   // stop loss
            0,                   // take profit
            ORDER_TIME_GTC,      // order lifetime
            0,                   // order expiration time
            "Sell Stop By pebriantara");

        // trade.Buy(
        //     0.01, // lots
        //     NULL, // current symbol
        //     Ask,  // buy price
        //     0,    // stop loss
        //     0,    // take profit
        //     "Buy Order pebriantara");
      }
    }
  }

  // MODIFY TP DAN SL
  if (PositionsTotal() > 0)
  {
    CTrade sTrade;
    // sTrade.SetAsyncMode(true); // true:Async, false:Sync

    if (PositionGetTicket(0))
    {
      // CEK APA ADA UPDATE POSISI
      datetime n = (datetime)PositionGetInteger(POSITION_TIME);
      datetime nUpdate = (datetime)PositionGetInteger(POSITION_TIME_UPDATE);
      double SLNew = 0;
      // Print("NNNNNNNNNN = " + n);
      // Print("NNNNNNNNNN UPDATE = " + nUpdate);
      if (n != nUpdate)
      {
        // Print("SLLLLL UPDATEEEEEEEEE");
        // JIKA SL KURANG DARI SL SEKARANG, JANGAN UBAH SL
        SLNew = Ask - 2 * _Point;
        if (SLNew < PositionGetDouble(POSITION_SL))
        {
          SLNew = Ask + 2 * _Point;
          sTrade.PositionModify(
              PositionGetInteger(POSITION_TICKET),
              SLNew,
              0);
        }
        else
        {
          // SLNew = PositionGetDouble(POSITION_SL);
        }
      }
      else
      {
        // CEK APAKAH ADA TAMBAHAN SL JIKA HARGA MENYENTUH HARGAS ASK TERTENTU
        if (PositionGetDouble(POSITION_PRICE_OPEN) > Ask - 4 * _Point)
        {
          // Print("UPDATE SL PERTAMAAAAA");
          SLNew = Ask + 2 * _Point;
          sTrade.PositionModify(
              PositionGetInteger(POSITION_TICKET),
              SLNew,
              0);
        }
      }
      // Print("POSITION TYPE INI BRO= " + (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE));
      double hargaOpenPosisi = PositionGetDouble(POSITION_PRICE_OPEN);
      long posisiTipe = PositionGetInteger(POSITION_TYPE);
      // CEK APAKAH POSITION BUY
      if (posisiTipe = 1)
      {
        // Print("SELLLL OPENNNNNN SELLL");
        // double SLNew = PositionGetDouble(POSITION_SL) + 100 * _Point;
        // sTrade.PositionModify(
        //     PositionGetInteger(POSITION_TICKET),
        //     SLNew,
        //     0);
      }
      if (Ask > PositionGetDouble(POSITION_PRICE_OPEN) - 4 * _Point)
      {
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