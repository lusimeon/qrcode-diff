import 'package:flutter/material.dart';

class ScanResultView extends StatelessWidget {
  const ScanResultView({
    super.key,
    required this.source,
    required this.target
  });

  final String source;

  final String target;

  List<Map<String, dynamic>> getRows() {
    return [
      {'label': 'Source', 'value': source, },
      {'label': 'Target', 'value': target, },
      {'label': 'Same?', 'value': target == source ? 'Same' : 'Not same', }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'See below the result of the scan',
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(),
                      children: [
                        for (var row in getRows())
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(row['label']),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(row['value'], textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
