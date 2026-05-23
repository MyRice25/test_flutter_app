import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../data/services/betting/betting_service.dart';
import '../../models/betting/bet_input.dart';
import '../../models/betting/bet_result.dart';
import '../../models/data_state/data_state.dart';

class BettingController extends GetxController {
  final BettingService _service = BettingService();

  // Input/Output state
  final betInput = Rx<BetInput>(BetInput.mock);
  final betResult = Rx<Ds<BetResult>>(Ds<BetResult>.empty());

  // Text controllers cho form
  late final TextEditingController stakeCtrl;
  late final TextEditingController oddsCtrl;
  late final TextEditingController lineCtrl;
  late final TextEditingController handicapCtrl;
  late final TextEditingController goalsACtrl;
  late final TextEditingController goalsBCtrl;
  late final TextEditingController totalGoalsCtrl;

  // Format số tiền "100,000"
  final NumberFormat _moneyFmt = NumberFormat('#,###');

  @override
  void onInit() {
    super.onInit();
    final init = betInput.value;
    stakeCtrl = TextEditingController(text: _moneyFmt.format(init.stake));
    oddsCtrl = TextEditingController(text: init.odds.toString());
    lineCtrl = TextEditingController(text: init.line.toString());
    handicapCtrl = TextEditingController(text: init.handicap.toString());
    goalsACtrl = TextEditingController(text: init.goalsA.toString());
    goalsBCtrl = TextEditingController(text: init.goalsB.toString());
    totalGoalsCtrl = TextEditingController(
      text: (init.goalsA + init.goalsB).toString(),
    );
  }

  @override
  void onClose() {
    stakeCtrl.dispose();
    oddsCtrl.dispose();
    lineCtrl.dispose();
    handicapCtrl.dispose();
    goalsACtrl.dispose();
    goalsBCtrl.dispose();
    totalGoalsCtrl.dispose();
    super.onClose();
  }

  // === Public handlers ===

  void onBetTypeChanged(BetType type) {
    betInput.value = betInput.value.copyWith(betType: type);
    // reset kết quả mỗi khi đổi loại kèo
    betResult.value = Ds<BetResult>.empty();
  }

  void onOverUnderSideChanged(OverUnderSide side) {
    betInput.value = betInput.value.copyWith(overUnderSide: side);
  }

  void onHandicapSideChanged(HandicapSide side) {
    betInput.value = betInput.value.copyWith(handicapSide: side);
  }

  void onOneXTwoPickChanged(OneXTwoPick pick) {
    betInput.value = betInput.value.copyWith(oneXTwoPick: pick);
  }

  void onOneXTwoActualChanged(OneXTwoPick actual) {
    betInput.value = betInput.value.copyWith(oneXTwoActual: actual);
  }

  void formatStake(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) {
      stakeCtrl.value = const TextEditingValue(text: '');
      return;
    }
    final value = int.tryParse(cleaned) ?? 0;
    final formatted = _moneyFmt.format(value);
    stakeCtrl.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> calculate() async {
    try {
      betResult.value = Loading<BetResult>();
      final input = _readInputFromForm();
      betInput.value = input;
      final result = await _service.calculateBet(input);
      betResult.value = Fetched<BetResult>(result);
    } catch (e) {
      betResult.value = Failed<BetResult>(e);
    }
  }

  void reset() {
    final mock = BetInput.mock;
    betInput.value = mock;
    betResult.value = Ds<BetResult>.empty();

    stakeCtrl.text = _moneyFmt.format(mock.stake);
    oddsCtrl.text = mock.odds.toString();
    lineCtrl.text = mock.line.toString();
    handicapCtrl.text = mock.handicap.toString();
    goalsACtrl.text = mock.goalsA.toString();
    goalsBCtrl.text = mock.goalsB.toString();
    totalGoalsCtrl.text = (mock.goalsA + mock.goalsB).toString();
  }

  // === Helpers ===

  BetInput _readInputFromForm() {
    final current = betInput.value;

    final stake = _parseMoney(stakeCtrl.text);
    final odds = double.tryParse(oddsCtrl.text.trim()) ?? current.odds;
    final line = double.tryParse(lineCtrl.text.trim()) ?? current.line;
    final handicap =
        double.tryParse(handicapCtrl.text.trim()) ?? current.handicap;
    // Tài Xỉu: chỉ cần tổng bàn → gom vào goalsA, goalsB=0
    // Kèo Châu Á: cần tỉ số riêng của 2 đội
    final int goalsA;
    final int goalsB;
    if (current.betType == BetType.overUnder) {
      goalsA = int.tryParse(totalGoalsCtrl.text.trim()) ??
          (current.goalsA + current.goalsB);
      goalsB = 0;
    } else {
      goalsA = int.tryParse(goalsACtrl.text.trim()) ?? current.goalsA;
      goalsB = int.tryParse(goalsBCtrl.text.trim()) ?? current.goalsB;
    }

    return current.copyWith(
      stake: stake,
      odds: odds,
      line: line,
      handicap: handicap,
      goalsA: goalsA,
      goalsB: goalsB,
    );
  }

  double _parseMoney(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return 0;
    return double.tryParse(cleaned) ?? 0;
  }

  String formatMoney(num value) => _moneyFmt.format(value.round());
}
