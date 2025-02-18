import 'package:flutter/material.dart';

class FutureBuilderCustom<T> extends StatelessWidget {
  final Future<List<T>> future;
  final Widget Function(BuildContext context, List<T> data) builder;

  const FutureBuilderCustom({
    Key? key,
    required this.future,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        } else {
          return builder(context, snapshot.data!);
        }
      },
    );
  }
}
