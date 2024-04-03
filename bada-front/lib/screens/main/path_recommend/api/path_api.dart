class PathApi {
//   Future<void> pathRequest() async {
//     try {
//       var accessToken = await secureStorage.read(key: 'accessToken');
//       var url = Uri.parse('https://j10b207.p.ssafy.io/api/path');
//       var requestBody = json.encode({
//         "startLng": _departureLongitude.toString(),
//         "startLat": _departureLatitude.toString(),
//         "endLng": _destinationLongitude.toString(),
//         "endLat": _destinationLatitude.toString(),
//       });
//       var response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json', // Content-Type 헤더 설정
//           'Authorization': 'Bearer $accessToken',
//         },
//         body: requestBody,
//       );
//       debugPrint("액세스 토큰 : $accessToken");
//       debugPrint("요청 바디 : $requestBody");

//       if (response.statusCode == 200) {
//         debugPrint('서버로부터 응답 성공: ${response.body}');
//         // 경로 검색 기록 저장
//         final prefs = await SharedPreferences.getInstance();
//         if (_departureKeywordList.isEmpty) {
//           _departureKeywordList.add(_departureController.text);
//           _destinationKeywordList.add(_destinationController.text);
//           _departureLatitudeList.add(_departureLatitude.toString());
//           _departureLongitudeList.add(_departureLongitude.toString());
//           _destinationLatitudeList.add(_destinationLatitude.toString());
//           _destinationLongitudeList.add(_destinationLongitude.toString());
//         } else {
//           _departureKeywordList.insert(0, _departureController.text);
//           _destinationKeywordList.insert(0, _destinationController.text);
//           _departureLatitudeList.insert(0, _departureLatitude.toString());
//           _departureLongitudeList.insert(0, _departureLongitude.toString());
//           _destinationLatitudeList.insert(0, _destinationLatitude.toString());
//           _destinationLongitudeList.insert(0, _destinationLongitude.toString());
//         }

//         prefs.setStringList('departureKeywordList', _departureKeywordList);
//         prefs.setStringList('destinationKeywordList', _destinationKeywordList);
//         prefs.setStringList('departureLatitudeList', _departureLatitudeList);
//         prefs.setStringList('departureLongitudeList', _departureLongitudeList);
//         prefs.setStringList(
//           'destinationLatitudeList',
//           _destinationLatitudeList,
//         );
//         prefs.setStringList(
//           'destinationLongitudeList',
//           _destinationLongitudeList,
//         );

//         // TODO : 경로 요청 API Response를 파라미터로 넘겨주어 PathMap으로 이동
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => const PathMap()),
//         );
//       } else {
//         debugPrint('요청 실패: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('에러 발생: $e');
//     }
//   }
}
