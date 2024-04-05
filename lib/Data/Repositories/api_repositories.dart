import 'dart:convert';

import 'package:yogya_blusuk/Data/Datasources/api_datasource.dart';
import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';
import 'package:yogya_blusuk/Domain/Usecase/place_usecase.dart';
import 'package:yogya_blusuk/Domain/Usecase/account_usecase.dart';
import 'package:yogya_blusuk/Domain/Usecase/vacationplan_usecase.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final ApiDataSource _apiDataSource;

  PlaceRepositoryImpl(this._apiDataSource);

  @override
  Future<List<Place>> getAllPlaces() async {
    try {
      final String response = await _apiDataSource.getAllPlace();
      // Here you would parse the response and map it to a list of Place objects
      // For now, let's assume the response is in JSON format and contains a list of places
      final List<dynamic> jsonList = json.decode(response);
      return jsonList.map((json) => Place.fromJson(json)).toList();
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }

  @override
  Future<List<Place>> getPlaceBySearchUC(String search) async {
    try {
      final String response = await _apiDataSource.getPlaceBySearch(search);
      // Here you would parse the response and map it to a list of Place objects
      // For now, let's assume the response is in JSON format and contains a list of places
      final List<dynamic> jsonList = json.decode(response);
      return jsonList.map((json) => Place.fromJson(json)).toList();
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }

  @override
  Future<List<GetAllPlaceWithRating>> getTop5PlacesAndRatingUC() async {
    try {
      final String response = await _apiDataSource.getTop5PlaceAndRating();
      // Here you would parse the response and map it to a list of Place objects
      // For now, let's assume the response is in JSON format and contains a list of places
      final List<dynamic> jsonList = json.decode(response);
      return jsonList.map((json) => GetAllPlaceWithRating.fromJson(json)).toList();
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }

  @override
  Future<List<ImageEntity>> getImagebyPlaceIdUC(int placeId) async {
    try {
      final String response = await _apiDataSource.getImageByPlaceId(placeId);
      // Here you would parse the response and map it to a list of Place objects
      // For now, let's assume the response is in JSON format and contains a list of places
      final List<dynamic> jsonList = json.decode(response);
      return jsonList.map((json) => ImageEntity.fromJson(json)).toList();
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }

  @override
  Future<Place> getPlacebyIdUC(int placeId) async {
    try {
      final String response = await _apiDataSource.getPlaceById(placeId);
      // Here you would parse the response and map it to a list of Place objects
      // For now, let's assume the response is in JSON format and contains a list of places
      final dynamic jsonPlace = json.decode(response);
      return Place.fromJson(jsonPlace);
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }

  @override
  Future<List<GetPlaceReviewWithName>> getPlaceReviewWithNamebyPlaceIDUC(int placeId) async {
    try {
      final String response = await _apiDataSource.getPlaceReviewWithNameById(placeId);
      // Here you would parse the response and map it to a list of Place objects
      // For now, let's assume the response is in JSON format and contains a list of places
      final List<dynamic> jsonList = json.decode(response);
      return jsonList.map((json) => GetPlaceReviewWithName.fromJson(json)).toList();
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }
}

class AccountRepositoryImpl implements AccountRepository {
  final ApiDataSource _apiDataSource;

  AccountRepositoryImpl(this._apiDataSource);

  @override
  Future<UserWithToken> loginToken (String username, String password) async {
    try {
      final String response = await _apiDataSource.login(username, password);
      final Map<String, dynamic> jsonResponse = json.decode(response);

      // Assuming the response contains user data
      return UserWithToken.fromJson(jsonResponse);
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }

  @override
  Future register(UserCreate userCreate) async {
    try {
      _apiDataSource.register(userCreate);

      // Assuming the response contains user data
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }
}

class VacationPlanRepositoryImpl implements VacationPlanRepository {
  final ApiDataSource _apiDataSource;

  VacationPlanRepositoryImpl(this._apiDataSource);

  @override
  Future<List<VacationPlan>> GetVacationPlanByUserIdUC(int userId) async {
    try {
      final String response = await _apiDataSource.getVacationPlanByUserId(userId);
      // Here you would parse the response and map it to a list of VacationPlan objects
      // For now, let's assume the response is in JSON format and contains a list of vacation plans
      final List<dynamic> jsonList = json.decode(response);
      return jsonList.map((json) => VacationPlan.fromJson(json)).toList();
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }

  @override
  Future InsertVacationPlanUC(CreateVacationPlan createVacationPlan) async {
    try {
      _apiDataSource.insertVacationPlan(createVacationPlan);

      // Assuming the response contains user data
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }

  @override
  Future<VacationPlan> GetVacationPlanByPlanIdUC(int planId) async {
    try {
      final String response = await _apiDataSource.getPlaceById(planId);
      // Here you would parse the response and map it to a list of Place objects
      // For now, let's assume the response is in JSON format and contains a list of places
      final dynamic jsonPlace = json.decode(response);
      return VacationPlan.fromJson(jsonPlace);
    } catch (e) {
      throw e; // You might want to handle errors differently here
    }
  }
}



