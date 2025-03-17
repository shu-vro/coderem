import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FutureBuilderCustom<T> extends StatefulWidget {
  final Future<List<T>> future;
  final Widget Function(BuildContext context, List<T> data) builder;

  const FutureBuilderCustom({
    super.key,
    required this.future,
    required this.builder,
  });

  @override
  State<FutureBuilderCustom<T>> createState() => _FutureBuilderCustomState<T>();
}

class _FutureBuilderCustomState<T> extends State<FutureBuilderCustom<T>> {
  late Future<List<T>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.future;
  }

  void _retry() {
    setState(() {
      _future = widget.future;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/images/error.svg"),
                Text(
                  'Something Went Wrong',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _retry,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data found'));
        } else {
          return widget.builder(context, snapshot.data!);
        }
      },
    );
  }
}
