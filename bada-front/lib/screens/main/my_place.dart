import 'package:bada/models/my_place_model.dart';
import 'package:bada/widgets/buttons.dart';
import 'package:flutter/material.dart';

class PlaceIndicator extends StatelessWidget {
  final int numberOfPlaces;
  final VoidCallback onAddPlace;

  const PlaceIndicator({
    super.key,
    required this.numberOfPlaces,
    required this.onAddPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('6개의 장소중 $numberOfPlaces개의 장소를 저장했습니다.'),
        const Spacer(),
        if (numberOfPlaces < 6)
          (IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAddPlace,
          )),
      ],
    );
  }
}

class MyPlace extends StatefulWidget {
  const MyPlace({super.key});

  @override
  State<MyPlace> createState() => _MyPlaceState();
}

class _MyPlaceState extends State<MyPlace> {
  late Future<List<Place>> myPlaces;

  void _addNewPlace() {}

  @override
  void initState() {
    super.initState();
    myPlaces = MyPlaceData.loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 장소'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: [
            FutureBuilder<List<Place>>(
              future: myPlaces,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return PlaceIndicator(
                    numberOfPlaces: snapshot.data!.length,
                    onAddPlace: _addNewPlace,
                  );
                } else {
                  return Container();
                }
              },
            ),
            Expanded(
              child: FutureBuilder<List<Place>>(
                future: myPlaces,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      var places = snapshot.data!;
                      return ListView.builder(
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              MyPlaceButton(label: places[index].placeName),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return const Center(child: Text('No places to display.'));
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
