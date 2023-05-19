class UserCryptoData {
  final String id;
  final String userId;
  final List<String> crypto;

  UserCryptoData({required this.id, required this.userId, required this.crypto});

  factory UserCryptoData.fromJson(Map<String, dynamic> json) {
    final id = json['_id'] as String;
    final userId = json['userId'] as String;
    final cryptoList = json['crypto'] as List<dynamic>;
    final crypto = cryptoList.map((dynamic item) => item as String).toList();

    return UserCryptoData(id: id, userId: userId, crypto: crypto);
  }
}
