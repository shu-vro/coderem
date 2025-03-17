import 'package:coderem/ApiCalls/user_contests_req.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:flutter/material.dart';

class RatingChangeGraph extends StatefulWidget {
  final List<UserContest> contests;
  final int maxRating;
  const RatingChangeGraph(
      {super.key, required this.contests, required this.maxRating});

  @override
  State<RatingChangeGraph> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<RatingChangeGraph> {
  List<Color> gradientColors = [
    Colors.deepPurple[300]!,
    Colors.deepPurple,
  ];

  List<List<int>> _getRatingChanges() {
    final ratingChanges = <List<int>>[];
    for (var i = widget.contests.length; i > 0; i--) {
      final contest = widget.contests[i - 1];
      // ratingChanges.add([widget.contests.length - i, contest.newRating]);
      ratingChanges.add([widget.contests.length - i, contest.newRating]);
    }
    return ratingChanges;
  }

  // int firstTimeSeconds = 0;
  // int lastTimeSeconds = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   firstTimeSeconds = widget.contests.last.ratingUpdateTimeSeconds;
  //   lastTimeSeconds = widget.contests.first.ratingUpdateTimeSeconds;
  // }

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              // showAvg ? avgData() : mainData(),
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      // case 2:
      //   text = const Text('MAR', style: style);
      //   break;
      // case 5:
      //   text = const Text('JUN', style: style);
      //   break;
      // case 8:
      //   text = const Text('SEP', style: style);
      //   break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      meta: meta,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );
    String text;

    int maxRating = widget.maxRating;
    int currRating = widget.contests.first.newRating;

    switch (value.toInt()) {
      case var value when value == maxRating:
        text = widget.maxRating.toString();
        text = widget.maxRating.toString();
        return Text(text, style: style.copyWith(color: Colors.red));
      case var value when value == currRating:
        text = currRating.toString();
        return Text(text, style: style.copyWith(color: Colors.deepPurple));
      case 1200:
        text = '1200';
        break;
      case 1400:
        text = '1400';
        break;
      case 1600:
        text = '1600';
        break;
      case 1900:
        text = '1900';
        break;
      case 2100:
        text = '2100';
        break;
      case 2300:
        text = '2300';
        break;
      case 2400:
        text = '2400';
        break;
      case 2600:
        text = '2600';
        break;
      case 3000:
        text = '3000';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
        horizontalInterval: widget.maxRating / 10,
        verticalInterval: (widget.contests.length) / 10,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: widget.contests.length.toDouble(),
      minY: widget.contests.last.newRating.toDouble(),
      maxY: widget.maxRating.toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: _getRatingChanges()
              .map((ratingChange) => FlSpot(
                  ratingChange[0].toDouble(), ratingChange[1].toDouble()))
              .toList(),
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.2))
                  .toList(),
            ),
          ),
        ),
      ],
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          _hrLine(1200, Colors.grey),
          _hrLine(1400, Colors.greenAccent),
          _hrLine(1600, Colors.blue[900]!),
          _hrLine(1900, Colors.deepPurple),
          _hrLine(2100, Colors.orangeAccent),
          _hrLine(2300, Colors.orangeAccent),
          _hrLine(2400, Colors.red),
          _hrLine(2600, Colors.red),
          _hrLine(3000, Colors.red),
        ],
      ),
    );
  }

  HorizontalLine _hrLine(double y, Color color) {
    return HorizontalLine(
      y: y,
      color: color,
      strokeWidth: 3,
      dashArray: [5, 5],
    );
  }
}
