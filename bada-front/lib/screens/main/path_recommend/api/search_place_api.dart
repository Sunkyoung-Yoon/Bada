import 'dart:convert';

import 'package:bada/models/search_history.dart';
import 'package:bada/models/search_results.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchPlaceApi {
  bool _isSearching = false;
  List<SearchHistory> searchHistoryList = [];

  Future<List<SearchResultItem>> fetchSearchResults(String keyword) async {
    var url = Uri.parse(
      'https://dapi.kakao.com/v2/local/search/keyword.json?query=$keyword',
    );

    var response = await http.get(
      url,
      headers: {'Authorization': 'KakaoAK be8a38ff76c199cc88b459e8c29957be'},
    );

    if (response.statusCode == 200) {
      _isSearching = true;
      List<dynamic> jsonList = json.decode(response.body)['documents'];
      List<SearchResultItem> items = jsonList
          .map((jsonItem) => SearchResultItem.fromJson(jsonItem))
          .toList();
      return items;
    } else {
      throw Exception('Failed to load search results');
    }
  }

  Future<void> loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonStringList = prefs.getStringList('searchHistory');
    if (jsonStringList != null) {
      // JSON 문자열을 SearchHistory 객체로 변환
      final List<SearchHistory> loadedSearchHistory =
          jsonStringList.map((jsonString) {
        final decoded = jsonDecode(jsonString);
        return SearchHistory.fromJson(decoded);
      }).toList();

      searchHistoryList = loadedSearchHistory;
    }
  }

  Future<void> saveSearchKeyword(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    final searchHistory =
        SearchHistory(keyword: keyword, timestamp: DateTime.now());
    searchHistoryList.insert(0, searchHistory); // 새로운 검색어를 맨 앞에 추가

    // 검색 기록을 JSON 문자열 리스트로 변환
    List<String> jsonStringList = searchHistoryList
        .map((history) => jsonEncode(history.toJson()))
        .toList();
    prefs.setStringList('searchHistory', jsonStringList);
  }

  Future<void> resetSearchHistory(String keyword) async {
    final prefs = await SharedPreferences.getInstance();

    // 특정 키워드와 일치하는 모든 기록을 제거합니다.
    searchHistoryList.removeWhere((item) => item.keyword == keyword);

    // 새로운 검색 기록을 생성하고 맨 앞에 추가합니다.
    final searchHistory =
        SearchHistory(keyword: keyword, timestamp: DateTime.now());
    searchHistoryList.insert(0, searchHistory);

    // 변경된 검색 기록을 JSON 문자열 리스트로 변환합니다.
    List<String> jsonStringList = searchHistoryList
        .map((history) => jsonEncode(history.toJson()))
        .toList();

    // 변경된 검색 기록을 SharedPreferences에 저장합니다.
    await prefs.setStringList('searchHistory', jsonStringList);

    // 검색 기록을 다시 로드합니다.
    loadSearchHistory();
  }
}
