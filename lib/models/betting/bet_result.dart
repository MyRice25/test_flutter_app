import 'bet_input.dart';

class BetResult {
  final String outcome;      // "win"|"halfWin"|"draw"|"halfLoss"|"loss"
  final double profitAmount;
  final double lossAmount;
  final double totalReceive;
  final String explanation;
  final BetInput originalBet;

  const BetResult({
    required this.outcome,
    required this.profitAmount,
    required this.lossAmount,
    required this.totalReceive,
    required this.explanation,
    required this.originalBet,
  });

  // Nhãn tiếng Việt cho outcome
  String get outcomeLabel {
    switch (outcome) {
      case 'win':
        return 'Thắng toàn phần';
      case 'halfWin':
        return 'Thắng nửa tiền';
      case 'draw':
        return 'Hoà (trả vốn)';
      case 'halfLoss':
        return 'Thua nửa tiền';
      case 'loss':
        return 'Thua toàn bộ';
      default:
        return outcome;
    }
  }

  String get outcomeEmoji {
    switch (outcome) {
      case 'win':
        return '🟢';
      case 'halfWin':
      case 'draw':
      case 'halfLoss':
        return '🟡';
      case 'loss':
        return '🔴';
      default:
        return '⚪';
    }
  }

  bool get isWin => outcome == 'win' || outcome == 'halfWin';
  bool get isLoss => outcome == 'loss' || outcome == 'halfLoss';
  bool get isDraw => outcome == 'draw';

  BetResult copyWith({
    String? outcome,
    double? profitAmount,
    double? lossAmount,
    double? totalReceive,
    String? explanation,
    BetInput? originalBet,
  }) {
    return BetResult(
      outcome: outcome ?? this.outcome,
      profitAmount: profitAmount ?? this.profitAmount,
      lossAmount: lossAmount ?? this.lossAmount,
      totalReceive: totalReceive ?? this.totalReceive,
      explanation: explanation ?? this.explanation,
      originalBet: originalBet ?? this.originalBet,
    );
  }

  factory BetResult.fromJson(Map<String, dynamic> json) => BetResult(
        outcome: (json['outcome'] as String?) ?? 'draw',
        profitAmount: (json['profitAmount'] as num?)?.toDouble() ?? 0,
        lossAmount: (json['lossAmount'] as num?)?.toDouble() ?? 0,
        totalReceive: (json['totalReceive'] as num?)?.toDouble() ?? 0,
        explanation: (json['explanation'] as String?) ?? '',
        originalBet: BetInput.fromJson(
            (json['originalBet'] as Map).cast<String, dynamic>()),
      );

  Map<String, dynamic> toJson() => {
        'outcome': outcome,
        'profitAmount': profitAmount,
        'lossAmount': lossAmount,
        'totalReceive': totalReceive,
        'explanation': explanation,
        'originalBet': originalBet.toJson(),
      };
}
