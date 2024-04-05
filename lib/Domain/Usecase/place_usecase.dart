import 'package:yogya_blusuk/Domain/Entities/api_domain_entities.dart';

abstract class PlaceRepository {
  Future<List<Place>> getAllPlaces();
  Future<List<Place>> getPlaceBySearchUC(String search);
  Future<List<GetAllPlaceWithRating>> getTop5PlacesAndRatingUC();
  Future<List<ImageEntity>> getImagebyPlaceIdUC(int placeId);
  Future<Place> getPlacebyIdUC(int placeId);
  Future<List<GetPlaceReviewWithName>> getPlaceReviewWithNamebyPlaceIDUC(int placeId);
}

