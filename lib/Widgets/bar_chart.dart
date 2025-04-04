import 'package:coderem/ApiCalls/user_submissions_req.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample3 extends StatefulWidget {
  final List<UserSubmission> submissions;
  const BarChartSample3({super.key, required this.submissions});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  List<BarChartGroupData> barGroups = [];
  double maxY = 0;

  @override
  void initState() {
    super.initState();
    barGroups = getBarGroups();
  }

  List<MapEntry<int, int>> _getBarGroupsRaw() {
    // Keep only 'OK' submissions and ensure uniqueness by contestId + index
    final uniqueOkSubs = <String, UserSubmission>{};
    for (var submission in widget.submissions) {
      if (submission.verdict == 'OK') {
        final key =
            '${submission.problem.contestId}_${submission.problem.index}';
        uniqueOkSubs[key] = submission;
      }
    }

    final Map<int, int> problemsByRating = {};
    for (var submission in uniqueOkSubs.values) {
      final rating = submission.problem.rating.toInt();
      problemsByRating[rating] = (problemsByRating[rating] ?? 0) + 1;
    }

    maxY = problemsByRating.values.reduce((a, b) => a > b ? a : b).toDouble();

    final sortedEntries = problemsByRating.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return sortedEntries;
  }

  List<BarChartGroupData> getBarGroups() {
    final sortedEntries = _getBarGroupsRaw();

    return sortedEntries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          const Color(0xFFC2185B),
          const Color(0xFFE096B4),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 16,
        right: 48,
        top: 8,
      ),
      child: SizedBox(
        // aspectRatio: 1,
        height: _getBarGroupsRaw().length * 14.0,
        child: BarChart(
          BarChartData(
            barTouchData: barTouchData,
            titlesData: titlesData,
            borderData: borderData,
            barGroups: barGroups,
            gridData: const FlGridData(show: false),
            alignment: BarChartAlignment.spaceAround,
            rotationQuarterTurns: 1, // Rotate the chart 90 degrees clockwise
          ),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Color(0xFFE096B4),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.pink[700],
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final rating = value.toInt();
    final text = rating == 0 ? 'Unrated' : rating.toString();
    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 70,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );
}
