class TickerData {
  final String eventType;
  final int eventTime;
  final String symbol;
  final String priceChange;
  final String priceChangePercent;
  final String weightedAvgPrice;
  final String prevClosePrice;
  final String lastPrice;
  final String lastQty;
  final String bidPrice;
  final String bidQty;
  final String askPrice;
  final String askQty;
  final String openPrice;
  final String highPrice;
  final String lowPrice;
  final String volume;
  final String quoteVolume;
  final int openTime;
  final int closeTime;
  final int firstTradeId;
  final int lastTradeId;
  final int tradeCount;

  TickerData({
    required this.eventType,
    required this.eventTime,
    required this.symbol,
    required this.priceChange,
    required this.priceChangePercent,
    required this.weightedAvgPrice,
    required this.prevClosePrice,
    required this.lastPrice,
    required this.lastQty,
    required this.bidPrice,
    required this.bidQty,
    required this.askPrice,
    required this.askQty,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.quoteVolume,
    required this.openTime,
    required this.closeTime,
    required this.firstTradeId,
    required this.lastTradeId,
    required this.tradeCount,
  });

  factory TickerData.fromJson(Map<String, dynamic> json) {
    return TickerData(
      eventType: json['e'],
      eventTime: json['E'],
      symbol: json['s'],
      priceChange: json['p'],
      priceChangePercent: json['P'],
      weightedAvgPrice: json['w'],
      prevClosePrice: json['x'],
      lastPrice: json['c'],
      lastQty: json['Q'],
      bidPrice: json['b'],
      bidQty: json['B'],
      askPrice: json['a'],
      askQty: json['A'],
      openPrice: json['o'],
      highPrice: json['h'],
      lowPrice: json['l'],
      volume: json['v'],
      quoteVolume: json['q'],
      openTime: json['O'],
      closeTime: json['C'],
      firstTradeId: json['F'],
      lastTradeId: json['L'],
      tradeCount: json['n'],
    );
  }
}
