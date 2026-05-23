import '../../../models/betting/bet_input.dart';
import '../../../models/betting/bet_result.dart';

class BettingService {
  // Dung sai so sánh số thực (tránh sai số dấu phẩy động)
  static const double _eps = 1e-9;

  Future<BetResult> calculateBet(BetInput input) async {
    if (input.stake <= 0) {
      throw ArgumentError('Số tiền cược phải lớn hơn 0');
    }
    if (input.odds <= 0) {
      throw ArgumentError('Tỉ lệ kèo phải lớn hơn 0');
    }

    switch (input.betType) {
      case BetType.overUnder:
        return _calcOverUnder(input);
      case BetType.handicap:
        return _calcHandicap(input);
      case BetType.oneXTwo:
        return _calcOneXTwo(input);
    }
  }

  // === Tài Xỉu ===
  BetResult _calcOverUnder(BetInput input) {
    final total = input.goalsA + input.goalsB;
    final line = input.line;
    final isOver = input.overUnderSide == OverUnderSide.over;
    final sideLabel = input.overUnderSide.label;
    final diff = total - line; // dương => cược Tài đang thắng về giá trị so với mốc

    // Quyết định mức thắng/thua theo bội số 0.25 của mốc
    // Xác định "khoảng cách" của phía người chơi so với mốc (âm = đang thua hướng cược)
    final playerDiff = isOver ? diff : -diff;

    // Mốc nguyên (vd 3.0) — hoà nếu đúng mốc
    if (_isNearlyEqual(playerDiff, 0)) {
      return _buildResult(
        input: input,
        outcome: BetOutcome.push,
        explanation: 'Tổng bàn $total = mốc ${_fmt(line)} → Hoà, trả lại vốn',
      );
    }

    // Mốc .25 / .75 → luôn thắng/thua nửa tiền (theo quy ước trong spec)
    if (_isHalfStep(line)) {
      final outcome =
          playerDiff > 0 ? BetOutcome.halfWin : BetOutcome.halfLose;
      return _buildResult(
        input: input,
        outcome: outcome,
        explanation: outcome == BetOutcome.halfWin
            ? 'Tổng bàn $total, mốc ${_fmt(line)} → $sideLabel thắng nửa'
            : 'Tổng bàn $total, mốc ${_fmt(line)} → $sideLabel thua nửa',
      );
    }

    // Thắng/thua toàn bộ
    final outcome = playerDiff > 0 ? BetOutcome.win : BetOutcome.lose;
    final compare = total > line ? '>' : '<';
    final winnerSide = total > line ? 'Tài' : 'Xỉu';
    final explanation = outcome == BetOutcome.win
        ? 'Tổng bàn $total $compare mốc ${_fmt(line)} → $winnerSide thắng'
        : 'Tổng bàn $total $compare mốc ${_fmt(line)} → $sideLabel thua';
    return _buildResult(
      input: input,
      outcome: outcome,
      explanation: explanation,
    );
  }

  // === Kèo Châu Á - Chấp ===
  BetResult _calcHandicap(BetInput input) {
    final isUpper = input.handicapSide == HandicapSide.upper;
    final sideLabel = input.handicapSide.label;

    // Team = đội mà người chơi đặt; Opp = đội còn lại
    // Kèo trên: đội A chấp đội B → adjusted = goalsA - goalsB + handicap
    // Kèo dưới: adjusted = goalsB - goalsA + (-handicap)  (người chơi hưởng chấp ngược lại)
    final double adjusted = isUpper
        ? (input.goalsA - input.goalsB) + input.handicap
        : (input.goalsB - input.goalsA) + (-input.handicap);

    if (_isNearlyEqual(adjusted, 0)) {
      return _buildResult(
        input: input,
        outcome: BetOutcome.push,
        explanation:
            'Tỉ số ${input.goalsA}-${input.goalsB}, chấp ${_fmtSigned(input.handicap)} → $sideLabel hoà, trả lại vốn',
      );
    }

    // Mốc nửa bước (chấp .25 / .75) → luôn thắng/thua nửa tiền
    if (_isHalfStep(input.handicap)) {
      final outcome =
          adjusted > 0 ? BetOutcome.halfWin : BetOutcome.halfLose;
      return _buildResult(
        input: input,
        outcome: outcome,
        explanation: outcome == BetOutcome.halfWin
            ? 'Tỉ số ${input.goalsA}-${input.goalsB}, chấp ${_fmtSigned(input.handicap)} → $sideLabel thắng nửa'
            : 'Tỉ số ${input.goalsA}-${input.goalsB}, chấp ${_fmtSigned(input.handicap)} → $sideLabel thua nửa',
      );
    }

    final outcome = adjusted > 0 ? BetOutcome.win : BetOutcome.lose;
    return _buildResult(
      input: input,
      outcome: outcome,
      explanation: outcome == BetOutcome.win
          ? 'Tỉ số ${input.goalsA}-${input.goalsB}, chấp ${_fmtSigned(input.handicap)} → $sideLabel thắng'
          : 'Tỉ số ${input.goalsA}-${input.goalsB}, chấp ${_fmtSigned(input.handicap)} → $sideLabel thua',
    );
  }

  // === Kèo 1X2 ===
  BetResult _calcOneXTwo(BetInput input) {
    if (input.oneXTwoPick == input.oneXTwoActual) {
      return _buildResult(
        input: input,
        outcome: BetOutcome.win,
        explanation:
            'Dự đoán ${input.oneXTwoPick.label} trùng kết quả thực tế → Thắng',
      );
    }
    return _buildResult(
      input: input,
      outcome: BetOutcome.lose,
      explanation:
          'Dự đoán ${input.oneXTwoPick.label}, kết quả ${input.oneXTwoActual.label} → Thua',
    );
  }

  // === Tính tiền theo outcome ===
  BetResult _buildResult({
    required BetInput input,
    required BetOutcome outcome,
    required String explanation,
  }) {
    final stake = input.stake;
    final odds = input.odds;

    double profit = 0;
    double loss = 0;
    double totalReceive = 0;

    switch (outcome) {
      case BetOutcome.win:
        profit = stake * odds;
        totalReceive = stake + profit;
        break;
      case BetOutcome.halfWin:
        profit = stake * odds / 2;
        totalReceive = stake + profit;
        break;
      case BetOutcome.push:
        totalReceive = stake;
        break;
      case BetOutcome.halfLose:
        loss = stake / 2;
        totalReceive = stake - loss;
        break;
      case BetOutcome.lose:
        loss = stake;
        totalReceive = 0;
        break;
    }

    return BetResult(
      outcome: outcome,
      profit: profit,
      loss: loss,
      totalReceive: totalReceive,
      explanation: explanation,
    );
  }

  // === Helpers ===
  bool _isNearlyEqual(double a, double b) => (a - b).abs() < _eps;

  // Mốc .25 hoặc .75 (ví dụ 2.25, 2.75, -0.75)
  bool _isHalfStep(double v) {
    final frac = (v.abs() * 100).round() % 100;
    return frac == 25 || frac == 75;
  }

  String _fmt(double v) {
    if (v == v.truncateToDouble()) return v.toStringAsFixed(1);
    return v.toString();
  }

  String _fmtSigned(double v) {
    final s = _fmt(v.abs());
    if (v > 0) return '+$s';
    if (v < 0) return '-$s';
    return s;
  }
}
