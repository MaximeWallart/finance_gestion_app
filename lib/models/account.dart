class Account {
  int balance;

  Account({required this.balance});

  Account.fromJson(Map<String, Object> json)
      : this(balance: json['balance'] as int);

  Map<String, Object> toJson() => <String, Object>{'balance': balance};
}
