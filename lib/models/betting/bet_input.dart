import 'bet_type.dart';
import 'single_bet.dart';

class BetInput {
  // --- Bắt buộc ---
  final double stake;
  final BetType betType;

  // --- Tài Xỉu / Góc / Hiệp 1 O/U ---
  final double? line;
  final String? ouSide;       // "over" | "under"
  final int? totalGoals;

  // --- Odds chung (Châu Á) ---
  final double? odds;

  // --- Châu Á / Châu Âu chấp ---
  final double? handicap;
  final String? hcpSide;      // "upper" | "lower"
  final int? goalsA;
  final int? goalsB;

  // --- 1X2 / Chấp Âu ---
  final String? predictionX2; // "home" | "draw" | "away"
  final double? oddsHome;
  final double? oddsDraw;
  final double? oddsAway;

  // --- Tỉ số chính xác ---
  final int? predictedA;
  final int? predictedB;
  final double? oddsCorrect;

  // --- BTTS ---
  final bool? bttsYes;
  final double? oddsBttsYes;
  final double? oddsBttsNo;

  // --- Góc ---
  final int? totalCorners;

  // --- Hiệp 1 ---
  final String? halfSubType;  // "1x2" | "overUnder"
  final int? halfGoalsA;
  final int? halfGoalsB;
  final double? halfLine;

  // --- Xiên ---
  final List<SingleBet>? parlayLegs;

  const BetInput({
    required this.stake,
    required this.betType,
    this.line,
    this.ouSide,
    this.totalGoals,
    this.odds,
    this.handicap,
    this.hcpSide,
    this.goalsA,
    this.goalsB,
    this.predictionX2,
    this.oddsHome,
    this.oddsDraw,
    this.oddsAway,
    this.predictedA,
    this.predictedB,
    this.oddsCorrect,
    this.bttsYes,
    this.oddsBttsYes,
    this.oddsBttsNo,
    this.totalCorners,
    this.halfSubType,
    this.halfGoalsA,
    this.halfGoalsB,
    this.halfLine,
    this.parlayLegs,
  });

  // Mock mặc định (overUnder)
  static BetInput get mock => mockOf(BetType.overUnder);

  // Mock theo từng loại kèo
  static BetInput mockOf(BetType type) {
    switch (type) {
      case BetType.overUnder:
        return const BetInput(
          stake: 100000,
          betType: BetType.overUnder,
          odds: 0.85,
          line: 2.5,
          ouSide: 'over',
          totalGoals: 3,
        );
      case BetType.asianHandicap:
        return const BetInput(
          stake: 200000,
          betType: BetType.asianHandicap,
          odds: 0.85,
          handicap: -0.5,
          hcpSide: 'upper',
          goalsA: 2,
          goalsB: 1,
        );
      case BetType.oneXTwo:
        return const BetInput(
          stake: 200000,
          betType: BetType.oneXTwo,
          oddsHome: 2.10,
          oddsDraw: 3.40,
          oddsAway: 3.20,
          predictionX2: 'home',
          goalsA: 2,
          goalsB: 1,
        );
      case BetType.europeanHcp:
        return const BetInput(
          stake: 100000,
          betType: BetType.europeanHcp,
          handicap: 1,
          oddsHome: 1.90,
          oddsDraw: 3.20,
          oddsAway: 2.40,
          predictionX2: 'home',
          goalsA: 0,
          goalsB: 2,
        );
      case BetType.correctScore:
        return const BetInput(
          stake: 50000,
          betType: BetType.correctScore,
          predictedA: 2,
          predictedB: 1,
          oddsCorrect: 12.0,
          goalsA: 2,
          goalsB: 1,
        );
      case BetType.btts:
        return const BetInput(
          stake: 100000,
          betType: BetType.btts,
          bttsYes: true,
          oddsBttsYes: 1.75,
          oddsBttsNo: 2.10,
          goalsA: 1,
          goalsB: 0,
        );
      case BetType.firstHalf:
        return const BetInput(
          stake: 100000,
          betType: BetType.firstHalf,
          halfSubType: 'overUnder',
          halfLine: 0.75,
          ouSide: 'over',
          odds: 0.88,
          halfGoalsA: 0,
          halfGoalsB: 1,
        );
      case BetType.corners:
        return const BetInput(
          stake: 100000,
          betType: BetType.corners,
          odds: 0.90,
          line: 9.5,
          ouSide: 'over',
          totalCorners: 10,
        );
      case BetType.parlay:
        return const BetInput(
          stake: 100000,
          betType: BetType.parlay,
          parlayLegs: [
            SingleBet(outcome: 'win', oddsLeg: 1.85, description: 'Kèo 1'),
            SingleBet(outcome: 'win', oddsLeg: 2.10, description: 'Kèo 2'),
            SingleBet(outcome: 'win', oddsLeg: 1.70, description: 'Kèo 3'),
          ],
        );
    }
  }

  BetInput copyWith({
    double? stake,
    BetType? betType,
    double? line,
    String? ouSide,
    int? totalGoals,
    double? odds,
    double? handicap,
    String? hcpSide,
    int? goalsA,
    int? goalsB,
    String? predictionX2,
    double? oddsHome,
    double? oddsDraw,
    double? oddsAway,
    int? predictedA,
    int? predictedB,
    double? oddsCorrect,
    bool? bttsYes,
    double? oddsBttsYes,
    double? oddsBttsNo,
    int? totalCorners,
    String? halfSubType,
    int? halfGoalsA,
    int? halfGoalsB,
    double? halfLine,
    List<SingleBet>? parlayLegs,
  }) {
    return BetInput(
      stake: stake ?? this.stake,
      betType: betType ?? this.betType,
      line: line ?? this.line,
      ouSide: ouSide ?? this.ouSide,
      totalGoals: totalGoals ?? this.totalGoals,
      odds: odds ?? this.odds,
      handicap: handicap ?? this.handicap,
      hcpSide: hcpSide ?? this.hcpSide,
      goalsA: goalsA ?? this.goalsA,
      goalsB: goalsB ?? this.goalsB,
      predictionX2: predictionX2 ?? this.predictionX2,
      oddsHome: oddsHome ?? this.oddsHome,
      oddsDraw: oddsDraw ?? this.oddsDraw,
      oddsAway: oddsAway ?? this.oddsAway,
      predictedA: predictedA ?? this.predictedA,
      predictedB: predictedB ?? this.predictedB,
      oddsCorrect: oddsCorrect ?? this.oddsCorrect,
      bttsYes: bttsYes ?? this.bttsYes,
      oddsBttsYes: oddsBttsYes ?? this.oddsBttsYes,
      oddsBttsNo: oddsBttsNo ?? this.oddsBttsNo,
      totalCorners: totalCorners ?? this.totalCorners,
      halfSubType: halfSubType ?? this.halfSubType,
      halfGoalsA: halfGoalsA ?? this.halfGoalsA,
      halfGoalsB: halfGoalsB ?? this.halfGoalsB,
      halfLine: halfLine ?? this.halfLine,
      parlayLegs: parlayLegs ?? this.parlayLegs,
    );
  }

  factory BetInput.fromJson(Map<String, dynamic> json) {
    final type = BetType.values.firstWhere(
      (e) => e.name == json['betType'],
      orElse: () => BetType.overUnder,
    );
    return BetInput(
      stake: (json['stake'] as num?)?.toDouble() ?? 0,
      betType: type,
      line: (json['line'] as num?)?.toDouble(),
      ouSide: json['ouSide'] as String?,
      totalGoals: (json['totalGoals'] as num?)?.toInt(),
      odds: (json['odds'] as num?)?.toDouble(),
      handicap: (json['handicap'] as num?)?.toDouble(),
      hcpSide: json['hcpSide'] as String?,
      goalsA: (json['goalsA'] as num?)?.toInt(),
      goalsB: (json['goalsB'] as num?)?.toInt(),
      predictionX2: json['predictionX2'] as String?,
      oddsHome: (json['oddsHome'] as num?)?.toDouble(),
      oddsDraw: (json['oddsDraw'] as num?)?.toDouble(),
      oddsAway: (json['oddsAway'] as num?)?.toDouble(),
      predictedA: (json['predictedA'] as num?)?.toInt(),
      predictedB: (json['predictedB'] as num?)?.toInt(),
      oddsCorrect: (json['oddsCorrect'] as num?)?.toDouble(),
      bttsYes: json['bttsYes'] as bool?,
      oddsBttsYes: (json['oddsBttsYes'] as num?)?.toDouble(),
      oddsBttsNo: (json['oddsBttsNo'] as num?)?.toDouble(),
      totalCorners: (json['totalCorners'] as num?)?.toInt(),
      halfSubType: json['halfSubType'] as String?,
      halfGoalsA: (json['halfGoalsA'] as num?)?.toInt(),
      halfGoalsB: (json['halfGoalsB'] as num?)?.toInt(),
      halfLine: (json['halfLine'] as num?)?.toDouble(),
      parlayLegs: (json['parlayLegs'] as List?)
          ?.map((e) => SingleBet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'stake': stake,
        'betType': betType.name,
        'line': line,
        'ouSide': ouSide,
        'totalGoals': totalGoals,
        'odds': odds,
        'handicap': handicap,
        'hcpSide': hcpSide,
        'goalsA': goalsA,
        'goalsB': goalsB,
        'predictionX2': predictionX2,
        'oddsHome': oddsHome,
        'oddsDraw': oddsDraw,
        'oddsAway': oddsAway,
        'predictedA': predictedA,
        'predictedB': predictedB,
        'oddsCorrect': oddsCorrect,
        'bttsYes': bttsYes,
        'oddsBttsYes': oddsBttsYes,
        'oddsBttsNo': oddsBttsNo,
        'totalCorners': totalCorners,
        'halfSubType': halfSubType,
        'halfGoalsA': halfGoalsA,
        'halfGoalsB': halfGoalsB,
        'halfLine': halfLine,
        'parlayLegs': parlayLegs?.map((e) => e.toJson()).toList(),
      };
}
