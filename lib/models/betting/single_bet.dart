// Một "chân" (leg) trong cược xiên
class SingleBet {
  final String outcome;    // "win"|"halfWin"|"draw"|"halfLoss"|"loss"
  final double oddsLeg;    // Tỉ lệ Châu Âu của leg này (VD 1.85)
  final String description;

  const SingleBet({
    required this.outcome,
    required this.oddsLeg,
    required this.description,
  });

  SingleBet copyWith({
    String? outcome,
    double? oddsLeg,
    String? description,
  }) {
    return SingleBet(
      outcome: outcome ?? this.outcome,
      oddsLeg: oddsLeg ?? this.oddsLeg,
      description: description ?? this.description,
    );
  }

  factory SingleBet.fromJson(Map<String, dynamic> json) => SingleBet(
        outcome: (json['outcome'] as String?) ?? 'win',
        oddsLeg: (json['oddsLeg'] as num?)?.toDouble() ?? 1.0,
        description: (json['description'] as String?) ?? '',
      );

  Map<String, dynamic> toJson() => {
        'outcome': outcome,
        'oddsLeg': oddsLeg,
        'description': description,
      };

  static SingleBet get mock => const SingleBet(
        outcome: 'win',
        oddsLeg: 1.85,
        description: 'Kèo đơn mẫu',
      );
}
