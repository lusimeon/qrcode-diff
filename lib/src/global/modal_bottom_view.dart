import 'package:flutter/material.dart';

Widget _modalBottomInner(
  BuildContext context,
  Widget body,
  Widget? bar,
  String? title,
) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.85,
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Builder(
            builder: (context) {
              return bar ?? Text(title ?? '');
            },
          )
        ),
        Expanded(
          child: body,
        )
      ],
    )
  );
}

void showModalBottomView({
  required BuildContext context,
  required Widget body,
  String? title,
  Widget? bar,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => _modalBottomInner(context, body, bar, title),
  );
}
