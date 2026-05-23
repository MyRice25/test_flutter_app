import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/data_state/data_state.dart';

class DsAnimatedSwitcher<T> extends StatelessWidget {
  const DsAnimatedSwitcher({
    super.key,
    required this.state,
    required this.fetched,
    required this.loading,
    required this.failed,
  });

  final Rx<Ds<T>> state;
  final Widget Function(T data) fetched;
  final Widget Function() loading;
  final Widget Function(Object error) failed;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final child = state.value.onState(
        fetched: (data) {
          return fetched(data);
        },
        loading: () => loading(),
        failed: (error) => failed(error),
      );

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: child,
      );
    });
  }
}
