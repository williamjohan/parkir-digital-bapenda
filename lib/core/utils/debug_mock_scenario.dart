// core/widgets/debug/mock_scenario_fab.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parkir_digital_bapenda/core/network/debug_mock_interceptor.dart';

class MockScenarioFab extends StatefulWidget {
  const MockScenarioFab({super.key});

  @override
  State<MockScenarioFab> createState() => _MockScenarioFabState();
}

class _MockScenarioFabState extends State<MockScenarioFab> {
  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    final isActive = MockConfig.active != MockScenario.none;

    return PopupMenuButton<MockScenario>(
      tooltip: 'QC Mock Scenario',
      initialValue: MockConfig.active,
      onSelected: (scenario) {
        setState(() => MockConfig.active = scenario);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mock aktif: ${MockConfig.scenarioLabel(scenario)}'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      itemBuilder: (_) => MockScenario.values
          .map(
            (s) => PopupMenuItem(
              value: s,
              child: Text(MockConfig.scenarioLabel(s)),
            ),
          )
          .toList(),
      child: FloatingActionButton.small(
        onPressed: null, // trigger lewat PopupMenuButton
        backgroundColor: isActive ? Colors.orange : Colors.grey,
        child: Icon(isActive ? Icons.bug_report : Icons.bug_report_outlined),
      ),
    );
  }
}
