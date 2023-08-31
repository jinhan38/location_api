import 'package:location_api/air_pollution_model.dart';
import 'package:location_api/base_api.dart';
import 'package:sprintf/sprintf.dart';

import 'home_screen.dart';

class AirPollutionApi extends BaseApi {
  AirPollutionApi(super.dio, this._serviceKey);

  final String _serviceKey;

  Future<String> getStationName({
    required double tmN,
    required double tmE,
  }) async {
    String url = sprintf(stationListUrl, [tmE, tmN, _serviceKey]);

    var response = await dioGet(url);
    print('response : ${response?.data}');
    if (response == null) {
      return "";
    }
    var items = response.data["response"]["body"]["items"];
    String stationName = "";
    if (items != null) {
      if ((items as Iterable).isNotEmpty) {
        for (var i in items) {
          stationName = i["stationName"];
          break;
        }
      }
    }

    return stationName;
  }

  /// [stationName] 지역구 ex)강남구, 종로구
  Future<AirPollutionModel?> getData({required String stationName}) async {
    String url = sprintf(
      "${airPollutionBaseUrl}stationName=%s&dataTerm=%s&returnType=json&serviceKey=%s&numOfRows=1&ver=1.3",
      [stationName, "DAILY", _serviceKey],
    );
    var response = await dioGet(url);
    if (response == null) {
      return null;
    }

    AirPollutionModel airPollutionModel = AirPollutionModel.fromJson(
        response.data["response"]["body"]["items"][0]);
    return airPollutionModel;
  }
}
