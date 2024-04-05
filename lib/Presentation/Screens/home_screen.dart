import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yogya_blusuk/Domain/Usecase/place_usecase.dart';
import 'package:yogya_blusuk/Domain/Usecase/vacationplan_usecase.dart';
import 'package:yogya_blusuk/Presentation/Screens/detail_screen.dart';
import 'package:yogya_blusuk/Presentation/Screens/login_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yogya_blusuk/Presentation/Screens/vacationplanadd_screen.dart';
import 'package:yogya_blusuk/Presentation/Screens/vacationplanedit_screen.dart';

import '../../Data/Datasources/api_datasource.dart';
import '../../Data/Repositories/api_repositories.dart';
import '../../Domain/Entities/api_domain_entities.dart';

class HomePage extends StatelessWidget {
  final PlaceRepository placeRepository;
  final VacationPlanRepository vacationPlanRepository;


  const HomePage({Key? key, required this.placeRepository, required this.vacationPlanRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.openBox('userBox');
    return Scaffold(
      body: HomeForm(placeRepository: placeRepository,
                     vacationPlanRepository : vacationPlanRepository,
                     userBox : userBox),
      );
  }
}
class HomeForm extends StatefulWidget {
  final PlaceRepository placeRepository;
  final VacationPlanRepository vacationPlanRepository;
  final Future<Box> userBox;

  const HomeForm({Key? key, required this.placeRepository, required this.vacationPlanRepository, required this.userBox}) : super(key: key);
  @override
  _HomeFormState createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  late Box _userBox; // Declare the userBox variable
  late PlaceRepository placeRepository;
  late VacationPlanRepository vacationPlanRepository;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    await Hive.initFlutter();
    _userBox = await Hive.openBox('userBox'); // Open the userBox
    setState(() {});
  }
  int _selectedIndex = 0;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    placeRepository = widget.placeRepository;
    vacationPlanRepository = widget.vacationPlanRepository;
    final List<Widget> _pages = [
      HomePageContent(placeRepository: placeRepository),
      SearchPageContent(placeRepository: placeRepository),
      VacationPlanPageContent(vacationPlanRepository: vacationPlanRepository,
                              placeRepository: placeRepository,
                              userBox: widget.userBox,),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Yogya Blusuk',
          style: TextStyle(
            fontFamily: 'Roboto', // Change 'Roboto' to the desired font
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              var box = await Hive.openBox('userBox');
              await box.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(accountRepository: AccountRepositoryImpl(ApiDataSource())
                ),
              ));
              // Logout functionality
              // You can add your logout logic here
            },
          ),
        ],
      ),
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_add),
            label: 'Vacation Plan',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  final PlaceRepository placeRepository;

  const HomePageContent({Key? key, required this.placeRepository}) : super(key: key);

  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FutureBuilder<List<GetAllPlaceWithRating>>(
          future: widget.placeRepository.getTop5PlacesAndRatingUC(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return
                Column(
                  children: [
                    CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 420,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        // setState(() {
                        // });
                      },
                    ),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index, realIndex) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Column(
                            children: [
                              Container(
                                width: 400, // specify the desired width
                                height: 300,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'https://app.actualsolusi.com/bsi/YogyaBlusuk/api/Places/GetImageByName?filename=${snapshot.data![index].preview}',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10), // Add some space between image and data
                              Text(
                                '${snapshot.data![index].name}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Rating: ${snapshot.data![index].averageRating}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          );

                        },
                      );
                    },
                                  ),
                  ],

                );
            } else {
              return Text('No data available');
            }
          },

        ),

      ],
    );
  }
}

class SearchPageContent extends StatefulWidget {
  final PlaceRepository placeRepository;

  SearchPageContent({Key? key, required this.placeRepository}) : super(key: key);

  @override
  _SearchPageContentState createState() => _SearchPageContentState();
}

class _SearchPageContentState extends State<SearchPageContent> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _controller,
            onChanged: (value) {
              setState(() {}); // Trigger rebuild when text changes
            },
            decoration: InputDecoration(
              hintText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Place>>(
            future: _controller.text == null || _controller.text.isEmpty
                ? widget.placeRepository.getAllPlaces() // Return all places if search text is empty
                : widget.placeRepository.getPlaceBySearchUC(_controller.text), // Return places based on search text
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
                        backgroundImage: NetworkImage( 'https://app.actualsolusi.com/bsi/YogyaBlusuk/api/Places/GetImageByName?filename=${snapshot.data![index].preview}',
                        ),
                      ),

                      title: Text(place.name ?? ''),
                      subtitle: Text(place.description ?? ''),
                      trailing: ElevatedButton( // Use ElevatedButton for the details button
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DetailPage(placeRepository: widget.placeRepository, placeId: place.placeId??0, placeName: place.name??"",)),
                          );
                          // Handle details button press
                          // You can navigate to a details screen or perform any other action here
                        },
                        child: Text('Details'),
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
    );
  }
}

class VacationPlanPageContent extends StatefulWidget {
  final VacationPlanRepository vacationPlanRepository;
  final PlaceRepository placeRepository;
  final Future<Box> userBox;

  VacationPlanPageContent({Key? key, required this.vacationPlanRepository,required this.userBox, required this.placeRepository}) : super(key: key);
  @override
  _VacationPlanPageContentState createState() => _VacationPlanPageContentState();
}

class _VacationPlanPageContentState extends State<VacationPlanPageContent> {
  String? _token;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final box = await widget.userBox;
    setState(() {
      _token = box.get('token');
      _userId = box.get('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Vacation Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddVacationPlanPage(placeRepository: widget.placeRepository,
                                                                                vacationPlanRepository: widget.vacationPlanRepository,
                                                                                userId : _userId)), // Add comma here
                  );
                  // Handle adding vacation plan
                },
                child: Text('Add Vacation Plan'),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: FutureBuilder<List<VacationPlan>>(
            future: widget.vacationPlanRepository.GetVacationPlanByUserIdUC(_userId ?? 0),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final plan = snapshot.data![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(plan.name??"No Plan"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(plan.description??"No Description"),
                              Text('Date: ${plan.createData}'),
                              Text((plan.isPublic??false) ? 'Public' : 'Private'), // Display public/private status
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditVacationPlanPage(
                                    placeRepository: widget.placeRepository,
                                    vacationPlanRepository: widget.vacationPlanRepository,
                                    userId : _userId,
                                    vacationPlan : plan)), // Add comma here
                              );
                            },
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );

              } else {
                return Center(child: Text('No vacation plans available'));
              }
            },
          ),
        ),
      ],
    );
  }
}
