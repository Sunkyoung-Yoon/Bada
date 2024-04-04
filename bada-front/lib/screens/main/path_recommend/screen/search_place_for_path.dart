import 'dart:convert';

import 'package:bada/models/search_history.dart';
import 'package:bada/models/search_results.dart';
import 'package:bada/screens/main/my_place/screen/search_map_screen.dart';
import 'package:bada/screens/main/path_recommend/api/search_place_api.dart';
import 'package:bada/screens/main/path_recommend/screen/search_map_for_path_screen.dart';
import 'package:bada/widgets/screensize.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchPlaceForPath extends StatefulWidget {
  const SearchPlaceForPath({super.key});

  @override
  State<SearchPlaceForPath> createState() => _SearchPlaceForPathState();
}

class _SearchPlaceForPathState extends State<SearchPlaceForPath> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Future<List<SearchResultItem>>? _searchResult;
  Future<void>? load;
  final bool _isSearching = false;
  SearchPlaceApi searchPlaceApi = SearchPlaceApi();

  @override
  void initState() {
    super.initState();
    load = searchPlaceApi.loadSearchHistory();

    // 화면이 로드되고 나서 바로 텍스트 필드에 포커스를 맞춥니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // FocusNode를 정리합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: load,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('검색'),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 0.1,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // controller.text로 검색
                          setState(() {
                            _searchResult = searchPlaceApi
                                .fetchSearchResults(_controller.text);
                          });
                        },
                      ),
                    ),
                    onSubmitted: (value) => setState(() {
                      _searchResult = searchPlaceApi.fetchSearchResults(value);
                    }),
                  ),
                ),
                SizedBox(height: UIhelper.scaleHeight(context) * 10),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: UIhelper.scaleWidth(context) * 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _isSearching
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '검색 결과',
                                  style: TextStyle(color: Colors.black26),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '검색 기록',
                                  style: TextStyle(color: Colors.black26),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
                // 검색 결과를 보여주는 부분
                Expanded(
                  child: FutureBuilder<List<SearchResultItem>>(
                    future: _searchResult,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // 데이터 로딩 중일 때
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData) {
                        // 데이터가 성공적으로 로드되었을 때
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            SearchResultItem item = snapshot.data![index];
                            return ListTile(
                              onTap: () async {
                                searchPlaceApi
                                    .resetSearchHistory(item.placeName);
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SearchMapForPathScreen(
                                      item: item,
                                      keyword: _controller.text,
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  Navigator.pop(context, result);
                                }
                              },
                              title: Text(item.placeName),
                              subtitle: Text(item.addressName),
                            );
                          },
                        );
                      } else {
                        // 데이터가 없을 때
                        return ListView.builder(
                          itemCount: searchPlaceApi.searchHistoryList.length,
                          itemBuilder: (context, index) {
                            final keyword =
                                searchPlaceApi.searchHistoryList[index].keyword;
                            final date = searchPlaceApi
                                .searchHistoryList[index].timestamp;
                            final formattedDate =
                                '${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
                            return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: UIhelper.scaleWidth(context) * 280,
                                    child: Text(
                                      keyword,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      color: Colors.black26,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // 검색어를 클릭했을 때의 동작
                                _controller.text = keyword;
                                setState(() {
                                  _searchResult = searchPlaceApi
                                      .fetchSearchResults(_controller.text);
                                });
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
