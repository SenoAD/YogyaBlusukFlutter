import 'package:flutter/material.dart';
import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';
import 'package:yogya_blusuk/Domain/Usecase/place_usecase.dart';
import 'package:yogya_blusuk/Domain/Usecase/vacationplan_usecase.dart';
import 'package:yogya_blusuk/Presentation/Screens/home_screen.dart';

class AddVacationPlanPage extends StatefulWidget {
  final VacationPlanRepository vacationPlanRepository;
  final PlaceRepository placeRepository;
  final int? userId;

  AddVacationPlanPage({required this.vacationPlanRepository, required this.placeRepository, required this.userId});

  @override
  _AddVacationPlanPageState createState() => _AddVacationPlanPageState();
}

class _AddVacationPlanPageState extends State<AddVacationPlanPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _planNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<PlaceWithDate> _selectedPlaces = []; // List to store selected places with dates
  List<CreatePlanItem> _planItem = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Vacation Plan'),
        actions: [
          IconButton(
            onPressed: () async {
              DateTime currentDate = DateTime.now();

              // Add your logic to handle the save button press here
              if (_formKey.currentState!.validate()) {
                try {
                  await widget.vacationPlanRepository.InsertVacationPlanUC(
                      CreateVacationPlan(
                          userId: widget.userId,
                          name: _planNameController.text,
                          description: _descriptionController.text,
                          createdDate: currentDate,
                          planItems: _planItem));

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        HomePage(placeRepository: widget.placeRepository, vacationPlanRepository: widget.vacationPlanRepository)),
                  );

                } catch (e) {
                  // Handle registration error
                  print('Registration failed: $e');
                }
              }

            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _planNameController,
                decoration: InputDecoration(labelText: 'Plan Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Plan Name cannot be empty';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description cannot be empty';
                  }
                  return null;
                },
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Places:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _selectedPlaces.map((placeWithDate) {
                          return ListTile(
                            title: Text(
                              placeWithDate.place.name ?? '',
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  placeWithDate.place.description ?? '',
                                  style: TextStyle(fontSize: 12),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Date: ${placeWithDate.date}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedPlaces.remove(placeWithDate);
                                });
                              },
                              icon: Icon(Icons.remove),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild when text changes
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Place>>(
                  future: _searchController.text.isEmpty
                      ? widget.placeRepository.getAllPlaces()
                      : widget.placeRepository.getPlaceBySearchUC(_searchController.text),
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
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://app.actualsolusi.com/bsi/YogyaBlusuk/api/Places/GetImageByName?filename=${snapshot.data![index].preview}',
                              ),
                            ),
                            title: Text(
                              place.name ?? '',
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              place.description ?? '',
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                _showDatePicker(place);
                              },
                              icon: Icon(Icons.add),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show date picker and add selected place with date to the list
  Future<void> _showDatePicker(Place place) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _planItem.add(CreatePlanItem(placeId: place.placeId, planDate: pickedDate));
        _selectedPlaces.add(PlaceWithDate(place: place, date: pickedDate));
      });
    }
  }
}

class PlaceWithDate {
  final Place place;
  final DateTime date;

  PlaceWithDate({required this.place, required this.date});
}
