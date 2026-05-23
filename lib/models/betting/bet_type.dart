// Loại kèo bóng đá — 9 loại được hỗ trợ
enum BetType {
  overUnder,     // Tài Xỉu
  asianHandicap, // Kèo Châu Á (chấp)
  oneXTwo,       // Kèo 1X2 Châu Âu (thắng/hoà/thua)
  europeanHcp,   // Kèo Chấp Châu Âu (nguyên bàn)
  correctScore,  // Kèo Tỉ Số Chính Xác
  btts,          // Cả Hai Đội Ghi Bàn (Both Teams To Score)
  firstHalf,     // Kèo Hiệp 1 (con: 1X2 hoặc O/U)
  corners,       // Kèo Số Góc (Over/Under góc)
  parlay;        // Cược Xiên (combo)

  // Nhãn hiển thị tiếng Việt
  String get label {
    switch (this) {
      case BetType.overUnder:
        return 'Tài Xỉu';
      case BetType.asianHandicap:
        return 'Châu Á';
      case BetType.oneXTwo:
        return '1X2';
      case BetType.europeanHcp:
        return 'Chấp Âu';
      case BetType.correctScore:
        return 'Tỉ Số';
      case BetType.btts:
        return 'BTTS';
      case BetType.firstHalf:
        return 'Hiệp 1';
      case BetType.corners:
        return 'Góc';
      case BetType.parlay:
        return 'Xiên';
    }
  }

  // Dùng tỉ lệ kiểu Châu Á (0.85, 0.95) thay vì Châu Âu (2.10)
  bool get usesAsianOdds {
    switch (this) {
      case BetType.overUnder:
      case BetType.asianHandicap:
      case BetType.corners:
      case BetType.firstHalf:
        return true;
      default:
        return false;
    }
  }
}
