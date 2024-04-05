import 'package:flutter/material.dart';
import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';
import 'package:yogya_blusuk/Domain/Usecase/place_usecase.dart';
import 'package:yogya_blusuk/Data/Repositories/api_repositories.dart';

class PlacesScreen extends StatefulWidget {
  final PlaceRepository placeRepository;

  const PlacesScreen({required this.placeRepository, Key? key}) : super(key: key);

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  late Future<List<Place>> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = widget.placeRepository.getAllPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Places'),
      ),
      body: FutureBuilder<List<Place>>(
        future: _placesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final place = snapshot.data![index];
                return ListTile(
                  title: Text(place.name ?? ''),
                  subtitle: Text(place.description ?? ''),
                  // You can display other properties of Place as needed
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
