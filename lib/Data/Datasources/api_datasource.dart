import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';

class ApiDataSource {
  static const String baseUrl = 'https://app.actualsolusi.com/bsi/YogyaBlusuk/api';

  Future<String> getAllPlace() async {
    String apiEndpoint = '/Places/GetAll';
    final response = await http.get(Uri.parse(baseUrl + apiEndpoint));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> getTop5PlaceAndRating() async {
    String apiEndpoint = '/Places/GetTop5WithRating';
    final response = await http.get(Uri.parse(baseUrl + apiEndpoint));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> getImageByPlaceId(int placeId) async {
    String apiEndpoint = '/Images/GetByPlaceId';
    final response = await http.get(Uri.parse(baseUrl + apiEndpoint + '?placeId=$placeId'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> getPlaceById(int placeId) async {
    String apiEndpoint = '/Places/GetById';
    final response = await http.get(Uri.parse(baseUrl + apiEndpoint + '?id=$placeId'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> getPlaceReviewWithNameById(int placeId) async {
    String apiEndpoint = '/PlacesReviews/GetWithNameByPlaceId';
    final response = await http.get(Uri.parse(baseUrl + apiEndpoint + '?id=$placeId'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> getPlaceBySearch(String search) async {
    String apiEndpoint = '/Places/GetBySearch';
    final response = await http.get(Uri.parse(baseUrl + apiEndpoint + '?search=$search'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> login(String username, String password) async {
    String apiEndpoint = '/Account/login';

    // Define the request body with username and password
    Map<String, String> body = {
      'username': username,
      'password': password,
    };

    String encodedBody = jsonEncode(body);

    final response = await http.post(
      Uri.parse(baseUrl + apiEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
          body: encodedBody,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> register(UserCreate userCreate) async {
    String apiEndpoint = '/Account/InsertNew';

    // Define the request body with username and password
    Map<String, String> body = {
      'username': userCreate.username,
      'password': userCreate.password,
      'email': userCreate.email,
      'firstName': userCreate.firstName,
      'lastName': userCreate.lastName
    };

    String encodedBody = jsonEncode(body);

    final response = await http.post(
      Uri.parse(baseUrl + apiEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: encodedBody,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> insertVacationPlan(CreateVacationPlan vacationPlan) async {
    String apiEndpoint = '/VacationPlans/InsertNew';

    // Convert DateTime to ISO 8601 string
    String createdDateString = vacationPlan.createdDate?.toIso8601String() ?? '';

    // Convert list of plan items to a list of JSON objects
    List<Map<String, dynamic>> planItemsJson = vacationPlan.planItems.map((item) => item.toJson()).toList();

    // Define the request body with username and password
    Map<String, dynamic> body = {
      'userID': vacationPlan.userId,
      'name': vacationPlan.name,
      'description': vacationPlan.description,
      'createdDate': createdDateString,
      'planItems': planItemsJson,
    };

    String encodedBody = jsonEncode(body);

    final response = await http.post(
      Uri.parse(baseUrl + apiEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: encodedBody,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  }


  Future<String> getVacationPlanByUserId(int userId) async {
    String apiEndpoint = '/VacationPlans/GetByUserId';
    final response = await http.get(Uri.parse(baseUrl + apiEndpoint + '?id=$userId'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<String> getVacationPlanByPlanId(int planId) async {
    String apiEndpoint = '/VacationPlans/GetAllByPlanId';
    final response = await http.get(Uri.parse(baseUrl + apiEndpoint + '?id=$planId'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
