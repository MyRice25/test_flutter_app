import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../components/base/base_screen.dart';
import '../../models/betting/bet_input.dart';
import '../../models/betting/bet_result.dart';
import 'betting_controller.dart';

class BettingCalculatorScreen extends BaseScreen<BettingController> {
  const BettingCalculatorScreen({super.key});

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Máy tính cược bóng đá',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0.5,
    );
  }

  @override
  Color backgroundColor(BuildContext context) => const Color(0xFFF6F7F9);

  @override
  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildBetTypeSelector(),
          const SizedBox(height: 12),
          _buildCommonInputs(),
          const SizedBox(height: 12),
          _buildBetTypeSpecificInputs(),
          const SizedBox(height: 12),
          _buildActionButtons(context),
          const SizedBox(height: 16),
          _buildResultSection(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // === Section: chọn loại kèo ===
  Widget _buildBetTypeSelector() {
    return _card(
      title: 'Loại kèo',
      child: Obx(() {
        final current = controller.betInput.value.betType;
        return SegmentedButton<BetType>(
          segments: BetType.values
              .map((t) =>
                  ButtonSegment<BetType>(value: t, label: Text(t.label)))
              .toList(),
          selected: {current},
          showSelectedIcon: false,
          onSelectionChanged: (selected) {
            if (selected.isNotEmpty) {
              controller.onBetTypeChanged(selected.first);
            }
          },
        );
      }),
    );
  }

  // === Section: số tiền + odds ===
  Widget _buildCommonInputs() {
    return _card(
      title: 'Thông tin cược',
      child: Column(
        children: [
          _labeledField(
            label: 'Số tiền cược (VNĐ)',
            child: TextField(
              controller: controller.stakeCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: controller.formatStake,
              decoration: _inputDecoration(hint: 'VD: 100,000'),
            ),
          ),
          const SizedBox(height: 12),
          _labeledField(
            label: 'Tỉ lệ kèo (odds)',
            child: TextField(
              controller: controller.oddsCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: _inputDecoration(hint: 'VD: 0.85 / 0.95 / 1.00'),
            ),
          ),
        ],
      ),
    );
  }

  // === Section: input theo loại kèo ===
  Widget _buildBetTypeSpecificInputs() {
    return Obx(() {
      switch (controller.betInput.value.betType) {
        case BetType.overUnder:
          return _buildOverUnderInputs();
        case BetType.handicap:
          return _buildHandicapInputs();
        case BetType.oneXTwo:
          return _buildOneXTwoInputs();
      }
    });
  }

  Widget _buildOverUnderInputs() {
    return _card(
      title: 'Tài Xỉu',
      child: Column(
        children: [
          _labeledField(
            label: 'Mốc (số trái)',
            child: TextField(
              controller: controller.lineCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: _inputDecoration(hint: 'VD: 2.5 / 2.75'),
            ),
          ),
          const SizedBox(height: 12),
          _labeledField(
            label: 'Chọn Tài / Xỉu',
            child: Obx(() {
              final side = controller.betInput.value.overUnderSide;
              final isOver = side == OverUnderSide.over;
              return ToggleButtons(
                isSelected: [isOver, !isOver],
                onPressed: (index) => controller.onOverUnderSideChanged(
                  index == 0 ? OverUnderSide.over : OverUnderSide.under,
                ),
                borderRadius: BorderRadius.circular(8),
                constraints:
                    const BoxConstraints(minHeight: 40, minWidth: 100),
                children: const [Text('Tài'), Text('Xỉu')],
              );
            }),
          ),
          const SizedBox(height: 12),
          _labeledField(
            label: 'Tổng bàn thắng thực tế',
            child: TextField(
              controller: controller.totalGoalsCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration(hint: 'VD: 3'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandicapInputs() {
    return _card(
      title: 'Kèo Châu Á',
      child: Column(
        children: [
          _labeledField(
            label: 'Mức chấp (đội A chấp đội B)',
            child: TextField(
              controller: controller.handicapCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
              ],
              decoration: _inputDecoration(hint: 'VD: -0.5 / +1 / -0.75'),
            ),
          ),
          const SizedBox(height: 12),
          _labeledField(
            label: 'Phía cược',
            child: Obx(() {
              final side = controller.betInput.value.handicapSide;
              final isUpper = side == HandicapSide.upper;
              return ToggleButtons(
                isSelected: [isUpper, !isUpper],
                onPressed: (index) => controller.onHandicapSideChanged(
                  index == 0 ? HandicapSide.upper : HandicapSide.lower,
                ),
                borderRadius: BorderRadius.circular(8),
                constraints:
                    const BoxConstraints(minHeight: 40, minWidth: 100),
                children: const [Text('Kèo trên'), Text('Kèo dưới')],
              );
            }),
          ),
          const SizedBox(height: 12),
          _goalsRow(),
        ],
      ),
    );
  }

  Widget _buildOneXTwoInputs() {
    return _card(
      title: 'Kèo 1X2',
      child: Column(
        children: [
          _labeledField(
            label: 'Dự đoán của bạn',
            child: Obx(() {
              final pick = controller.betInput.value.oneXTwoPick;
              return Wrap(
                spacing: 8,
                children: OneXTwoPick.values.map((p) {
                  return ChoiceChip(
                    label: Text(p.label),
                    selected: pick == p,
                    onSelected: (_) => controller.onOneXTwoPickChanged(p),
                  );
                }).toList(),
              );
            }),
          ),
          const SizedBox(height: 12),
          _labeledField(
            label: 'Kết quả thực tế',
            child: Obx(() {
              final actual = controller.betInput.value.oneXTwoActual;
              return Wrap(
                spacing: 8,
                children: OneXTwoPick.values.map((p) {
                  return ChoiceChip(
                    label: Text(p.label),
                    selected: actual == p,
                    onSelected: (_) => controller.onOneXTwoActualChanged(p),
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _goalsRow() {
    return Row(
      children: [
        Expanded(
          child: _labeledField(
            label: 'Bàn thắng đội A',
            child: TextField(
              controller: controller.goalsACtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration(hint: '0'),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _labeledField(
            label: 'Bàn thắng đội B',
            child: TextField(
              controller: controller.goalsBCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: _inputDecoration(hint: '0'),
            ),
          ),
        ),
      ],
    );
  }

  // === Section: nút hành động ===
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: controller.reset,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Đặt lại'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: controller.calculate,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF783C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Tính ngay',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  // === Section: kết quả ===
  Widget _buildResultSection() {
    return Obx(() {
      return controller.betResult.value.onState(
        initial: () => const SizedBox.shrink(),
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        ),
        failed: (error) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Text(
            'Có lỗi xảy ra: $error',
            style: TextStyle(color: Colors.red.shade700),
          ),
        ),
        fetched: (data) => _buildResultCard(data),
      );
    });
  }

  Widget _buildResultCard(BetResult result) {
    final bg = _bgForOutcome(result.outcome);
    final border = _borderForOutcome(result.outcome);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                result.outcome.emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Text(
                'Kết quả: ${result.outcome.label}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            result.explanation,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const Divider(height: 24),
          if (result.profit > 0)
            _resultRow('Tiền thắng',
                '+${controller.formatMoney(result.profit)} đ',
                valueColor: Colors.green.shade700),
          if (result.loss > 0)
            _resultRow('Tiền lỗ',
                '-${controller.formatMoney(result.loss)} đ',
                valueColor: Colors.red.shade700),
          _resultRow(
            'Tổng nhận về',
            '${controller.formatMoney(result.totalReceive)} đ',
            valueColor: Colors.black,
            bold: true,
          ),
        ],
      ),
    );
  }

  // === Helpers UI ===
  Color _bgForOutcome(BetOutcome o) {
    switch (o) {
      case BetOutcome.win:
        return Colors.green.shade50;
      case BetOutcome.lose:
        return Colors.red.shade50;
      case BetOutcome.halfWin:
      case BetOutcome.halfLose:
      case BetOutcome.push:
        return Colors.amber.shade50;
    }
  }

  Color _borderForOutcome(BetOutcome o) {
    switch (o) {
      case BetOutcome.win:
        return Colors.green.shade200;
      case BetOutcome.lose:
        return Colors.red.shade200;
      case BetOutcome.halfWin:
      case BetOutcome.halfLose:
      case BetOutcome.push:
        return Colors.amber.shade200;
    }
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _labeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFFF783C), width: 1.4),
      ),
    );
  }

  Widget _resultRow(
    String label,
    String value, {
    Color? valueColor,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 16 : 14,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
