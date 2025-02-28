import 'package:coderem/ApiCalls/user_submissions_req.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartCustom extends StatelessWidget {
  final List<UserSubmission> submissions;
  const PieChartCustom({super.key, required this.submissions});

  Map<String, int> get submissionsByLanguage {
    final Map<String, int> submissionsByLanguage = {};
    submissions.forEach((submission) {
      final language = submission.programmingLanguage;
      if (submissionsByLanguage.containsKey(language)) {
        submissionsByLanguage[language] = submissionsByLanguage[language]! + 1;
      } else {
        submissionsByLanguage[language] = 1;
      }
    });
    return submissionsByLanguage;
  }

  List<Color> get uniqueColors => [
        Color(0xFFF569AC),
        Color(0xFFF37272),
        Color(0xffF1C40F),
        Color(0xff2ECC71),
        Color(0xff3498DB),
        Color(0xff9B59B6),
      ];

  List<PieChartSectionData> getPieChartSections() {
    final submissionsByLanguage = this.submissionsByLanguage;
    final sortedLanguages = submissionsByLanguage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topLanguages = sortedLanguages.take(5).toList();
    final otherLanguagesCount = sortedLanguages.skip(5).fold<int>(
        0, (previousValue, element) => previousValue + element.value);
    if (otherLanguagesCount > 0) {
      topLanguages.add(MapEntry('Others', otherLanguagesCount));
    }
    final List<PieChartSectionData> sections = [];
    final colors = uniqueColors;
    int colorIndex = 0;
    for (var entry in topLanguages) {
      final count = entry.value;
      sections.add(PieChartSectionData(
        value: count.toDouble(),
        title: "",
        radius: 150,
        color: colors[colorIndex % colors.length],
      ));
      colorIndex++;
    }
    return sections;
  }

  List<Widget> getLegendItems() {
    final submissionsByLanguage = this.submissionsByLanguage;
    final sortedLanguages = submissionsByLanguage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topLanguages = sortedLanguages.take(5).toList();
    final otherLanguagesCount = sortedLanguages.skip(5).fold<int>(
        0, (previousValue, element) => previousValue + element.value);
    if (otherLanguagesCount > 0) {
      topLanguages.add(MapEntry('Others', otherLanguagesCount));
    }
    final List<Widget> legendItems = [];
    final colors = uniqueColors;
    int colorIndex = 0;
    for (var entry in topLanguages) {
      final language = entry.key;
      legendItems.add(Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              color: colors[colorIndex % colors.length],
            ),
            SizedBox(width: 8),
            Text(language),
          ],
        ),
      ));
      colorIndex++;
    }
    return legendItems;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 350,
          padding: EdgeInsets.all(16),
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 0,
              sectionsSpace: 8,
              sections: getPieChartSections(),
            ),
          ),
        ),
        Column(
          children: getLegendItems(),
        ),
      ],
    );
  }
}
