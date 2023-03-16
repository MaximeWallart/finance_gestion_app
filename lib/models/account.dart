Account account = Account(balance: 0);

class Account {
  double balance;

  Account({required this.balance});

  Account.fromJson(Map<String, Object> json)
      : this(balance: json['balance'] as double);

  Map<String, Object> toJson() => <String, Object>{'balance': balance};
}
