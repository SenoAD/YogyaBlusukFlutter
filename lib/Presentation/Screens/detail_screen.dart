import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';
import 'package:yogya_blusuk/Domain/Usecase/place_usecase.dart';

import '../../Data/Datasources/api_datasource.dart';
import '../../Data/Repositories/api_repositories.dart';
import 'login_screen.dart';

class DetailPage extends StatelessWidget {
  final PlaceRepository placeRepository;
  final int placeId;
  final String placeName;

  const DetailPage({Key? key, required this.placeRepository, required this.placeId, required this.placeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$placeName'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<ImageEntity>>(
                future: placeRepository.getImagebyPlaceIdUC(placeId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Column(
                      children: [
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 220,
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
                                return Container(
                                  width: 300, // specify the desired width
                                  height: 200,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://app.actualsolusi.com/bsi/YogyaBlusuk/api/Images/GetImageByName?filename=${snapshot.data![index].imageUrl}',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
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
              SizedBox(height: 20), // Add some space between image and data
              FutureBuilder<Place>(
                future: placeRepository.getPlacebyIdUC(placeId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${snapshot.data!.name}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Description:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${snapshot.data!.description}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Location:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${snapshot.data!.location}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Average Price:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Rp. ${snapshot.data!.averagePrice}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    );
                  } else {
                    return Text('No data available');
                  }
                },
              ),
              SizedBox(height: 20),
              // FutureBuilder for displaying reviews
              FutureBuilder<List<GetPlaceReviewWithName>>(
                future: placeRepository.getPlaceReviewWithNamebyPlaceIDUC(placeId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reviews:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey, // Specify the color of the border
                                      width: 1.0, // Specify the width of the border
                                    ),
                                    borderRadius: BorderRadius.circular(8.0), // Specify border radius
                                  ),
                                  child:
                                    ListTile(
                                      title: Text((snapshot.data![index].firstName??"") + ' ' + (snapshot.data![index].lastName??"")), // Assuming userName is a property in your Review model
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(snapshot.data![index].reviewText??""), // Assuming review is a property in your Review model
                                          SizedBox(height: 5),
                                          Text(
                                            'Date: ${snapshot.data![index].date}', // Assuming date is a property in your Review model
                                            style: TextStyle(fontStyle: FontStyle.italic),
                                          ),
                                          Text(
                                            'Rating: ${snapshot.data![index].rating}', // Assuming rating is a property in your Review model
                                            style: TextStyle(fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.favorite_border), // Change the icon as needed
                                        onPressed: () {
                                          // Handle the onPressed event for the heart icon
                                        },
                                      ),
                                    ),

                                ),
                                SizedBox(height: 10)
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return Text('No reviews available');
                  }
                },
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
