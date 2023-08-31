class AirPollutionModel {
  /// 미세먼지 등급
  /// 1 = 좋음, 2 = 보통, 3 = 나쁨, 4 = 매우 나쁨
  int pm10Grade;
  String pm10GradeText;

  /// 초미세먼지 등급
  /// 1 = 좋음, 2 = 보통, 3 = 나쁨, 4 = 매우 나쁨
  int pm25Grade;
  String pm25GradeText;

  AirPollutionModel({
    required this.pm10Grade,
    required this.pm25Grade,
    required this.pm10GradeText,
    required this.pm25GradeText,
  });

  factory AirPollutionModel.fromJson(Map<String, dynamic> json) {
    int pm10GradeValue =
        json["pm10Grade"] == null ? -1 : int.parse(json["pm10Grade"]);
    int pm25GradeValue =
        json["pm25Grade"] == null ? -1 : int.parse(json["pm25Grade"]);
    return AirPollutionModel(
      pm10Grade: pm10GradeValue,
      pm25Grade: pm25GradeValue,
      pm10GradeText: _calcGrade(grade: pm10GradeValue),
      pm25GradeText: _calcGrade(grade: pm25GradeValue),
    );
  }

  static String _calcGrade({required int grade}) {
    String result = "보통";
    switch (grade) {
      case 1:
        result = "좋음";
        break;
      case 2:
        result = "보통";
        break;
      case 3:
        result = "나쁨";
        break;
      case 4:
        result = "매우나쁨";
        break;
    }
    return result;
  }

  @override
  String toString() {
    return 'AirPollutionModel{pm10Grade: $pm10Grade, pm10GradeText: $pm10GradeText, pm25Grade: $pm25Grade, pm25GradeText: $pm25GradeText}';
  }
}
