class SearchResultItem {
  final String addressName;
  final String categoryGroupCode;
  final String categoryGroupName;
  final String placeName;
  final String roadAddressName;
  final String phone;
  final String x;
  final String y;

  SearchResultItem({
    required this.addressName,
    required this.categoryGroupCode,
    required this.categoryGroupName,
    required this.placeName,
    required this.roadAddressName,
    required this.phone,
    required this.x,
    required this.y,
  });

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      addressName: json['address_name'],
      categoryGroupCode: json['category_group_code'],
      categoryGroupName: json['category_group_name'],
      placeName: json['place_name'],
      roadAddressName: json['road_address_name'],
      phone: json['phone'],
      x: json['x'],
      y: json['y'],
    );
  }
}
