import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_api/air_pollution_api.dart';
import 'package:location_api/tm_calculation.dart';

const airPollutionBaseUrl =
    "https://api.odcloud.kr/api/RltmArpltnInforInqireSvrc/v1/getMsrstnAcctoRltmMesureDnsty?";

const stationListUrl =
    "http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getNearbyMsrstnList?tmX=%s&tmY=%s&returnType=json&serviceKey=%s";

//http://apis.data.go.kr/B552584/MsrstnInfoInqireSvc/getNearbyMsrstnList?tmX=244148.546388&tmY=412423.75772&returnType=xml&serviceKey=서비스키
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 공공데이터 serviceKey
  final _serviceKey =
      "btrU2bHbl7QmVMQ8QUzX330i%2BhW31SS8rreaRi3g%2F6Q8Lb1Vzak6sHSbHBfrThZumWxWoqYTJMTuB94AtthP6w%3D%3D";

  late final AirPollutionApi airPollutionApi;

  @override
  void initState() {
    Dio dio = Dio()
      ..options = BaseOptions(
          baseUrl: airPollutionBaseUrl,
          contentType: 'application/json',
          responseType: ResponseType.json,
          connectTimeout: const Duration(milliseconds: 40000));
    airPollutionApi = AirPollutionApi(dio, _serviceKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
              onPressed: () async {
                dynamic result = await const MethodChannel("android")
                    .invokeMethod("getCoordinate");
                double latitude = result["latitude"];
                double longitude = result["longitude"];
                print('latitude : $latitude, longitude : $longitude');
                TMCalculation(
                  lat: latitude,
                  long: longitude,
                  callback: (n, e) async {
                    print('n : $n, e : $e');
                    String stationName = await airPollutionApi.getStationName(
                        tmN: 470021.68051, tmE: 216663.16156);
                    print('stationName : $stationName');
                    var result =
                        await airPollutionApi.getData(stationName: stationName);
                    print('result : $result');
                  },
                );
              },
              child: const Text("데이터 호출")),
        ],
      ),
    );
  }
}
