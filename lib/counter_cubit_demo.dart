import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

class CounterCubitDemoPage extends StatelessWidget {
  const CounterCubitDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterCubitView(),
    );
  }
}

class CounterCubitView extends StatelessWidget {
  const CounterCubitView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: BlocBuilder<CounterCubit, int>(
            builder: (context, count) {
              return Text(
                '$count',
                key: const Key('counter_text'),
                style: const TextStyle(fontSize: 32),
              );
            },
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              key: const Key('increment_button'),
              onPressed: () => context.read<CounterCubit>().increment(),
              child: const Icon(Icons.add),
            ),
            Icon(Icons.navigate_next),
            Icon(Icons.navigate_before),
            const SizedBox(height: 12),
            FloatingActionButton(
              key: const Key('decrement_button'),
              onPressed: () => context.read<CounterCubit>().decrement(),
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}


child: CommonText.rich(
          TextSpan(
            children: [
              TextSpan(text: largeText, style: largeStyle),
              TextSpan(text: '($smallText)', style: smallStyle),
            ],
          ),
          key: ValueKey(_showAmountFirst),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: '$largeText ($smallText)',
        ),


Widget _buildSearchCard() {
    final df = DateFormat('yyyy/M/d', 'ja');

    final canEditDates = _preset == _BillingPeriodPreset.custom;

    return Card(
      color: context.iosColors.secondaryGroupedBackground,
      elevation: 1,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.iosColors.separator, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _PresetButton(
                    label: L10n.of(context).today,
                    selected:
                        _showDatePresetSelection &&
                        _preset == _BillingPeriodPreset.today,
                    onTap: () => _applyPreset(_BillingPeriodPreset.today),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PresetButton(
                    label: L10n.of(context).thisWeek,
                    selected:
                        _showDatePresetSelection &&
                        _preset == _BillingPeriodPreset.thisWeek,
                    onTap: () => _applyPreset(_BillingPeriodPreset.thisWeek),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PresetButton(
                    label: L10n.of(context).thisMonth,
                    selected:
                        _showDatePresetSelection &&
                        _preset == _BillingPeriodPreset.thisMonth,
                    onTap: () => _applyPreset(_BillingPeriodPreset.thisMonth),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: _PresetButton(
                    label: L10n.of(context).periodShort,
                    selected:
                        _showDatePresetSelection &&
                        _preset == _BillingPeriodPreset.custom,
                    onTap: () => _applyPreset(_BillingPeriodPreset.custom),
                  ),
                ),
              ],
            ),
            if (_preset == _BillingPeriodPreset.custom)
              Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: canEditDates ? _pickStartDate : null,
                          child: _DateBox(
                            label: L10n.of(context).start,
                            value: df.format(_startDate),
                            disabled: !canEditDates,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: InkWell(
                          onTap: canEditDates ? _pickEndDate : null,
                          child: _DateBox(
                            label: L10n.of(context).end,
                            value: df.format(_endDate),
                            disabled: !canEditDates,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSwitch({required int visibleCount}) {
    final labels = [
      L10n.of(context).historyListCount(visibleCount),
      L10n.of(context).csvExport,
      L10n.of(context).reportView,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final sharedFontSize = _resolveModeSwitchFontSize(
            context: context,
            labels: labels,
            availableWidth: constraints.maxWidth,
          );

          return Row(
            children: [
              Expanded(
                child: _PresetButton(
                  label: labels[0],
                  selected: _displayMode == _BillingDisplayMode.list,
                  onTap:
                      () => setState(
                        () => _displayMode = _BillingDisplayMode.list,
                      ),
                  enabled: true,
                  disabledStyle: true,
                  fontSize: sharedFontSize,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PresetButton(
                  label: labels[2],
                  selected: _displayMode == _BillingDisplayMode.report,
                  onTap:
                      () => setState(
                        () => _displayMode = _BillingDisplayMode.report,
                      ),
                  fontSize: sharedFontSize,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _PresetButton(
                  label: labels[1],
                  selected: false,
                  onTap: () {
                    final sessions = _getDisplaySessions(
                      context.read<HistoryCubit>().state,
                    );
                    final masterState = context.read<MasterCubit>().state;
                    final settingsState = context.read<SettingsCubit>().state;
                    final filtered = sessions.where(_matchesFilters).toList();
                    final visible = _hidePendingDeletes(filtered);
                    _exportCsv(
                      sessions: visible,
                      masterState: masterState,
                      settingsState: settingsState,
                    );
                  },
                  fontSize: sharedFontSize,
                ),
              ),
            ],
          );
        },
      ),
    );
  }