class CreatePlaceReview {
  final int userId;
  final int placeId;
  final String? reviewText;
  final double rating;

  CreatePlaceReview({
    required this.userId,
    required this.placeId,
    this.reviewText,
    required this.rating,
  });
}

class GetAllPlaceWithRating {
  final int? placeId;
  final String? name;
  final String? description;
  final String? location;
  final int? categoryType;
  final double? averagePrice;
  final double? averageRating;
  final String? preview;

  GetAllPlaceWithRating({
    required this.placeId,
    required this.name,
    required this.description,
    required this.location,
    required this.categoryType,
    this.averagePrice,
    this.averageRating,
    this.preview
  });

  factory GetAllPlaceWithRating.fromJson(Map<String, dynamic> json) {
    return GetAllPlaceWithRating(
      placeId: json['placeId'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      categoryType: json['categoryType'],
      averagePrice: json['averagePrice']?.toDouble(),
      averageRating: json['averageRating']?.toDouble(),
      preview: json['preview']
    );
  }
}


class CreateVacationPlan {
  CreateVacationPlan({
    required this.userId,
    required this.name,
    required this.description,
    required this.createdDate,
    required this.planItems,
  });

  final int? userId;
  final String? name;
  final String? description;
  final DateTime? createdDate;
  final List<CreatePlanItem> planItems;

  factory CreateVacationPlan.fromJson(Map<String, dynamic> json){
    return CreateVacationPlan(
      userId: json["userID"],
      name: json["name"],
      description: json["description"],
      createdDate: DateTime.tryParse(json["createdDate"] ?? ""),
      planItems: json["planItems"] == null ? [] : List<CreatePlanItem>.from(json["planItems"]!.map((x) => CreatePlanItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    "userID": userId,
    "name": name,
    "description": description,
    "createdDate": createdDate?.toIso8601String(),
    "planItems": planItems.map((x) => x?.toJson()).toList(),
  };

}


class UserWithToken {
  final int userId;
  final String username;
  final String token;

  UserWithToken({
    required this.userId,
    required this.username,
    required this.token
  });

  factory UserWithToken.fromJson(Map<String, dynamic> json) {
    return UserWithToken(
      userId: json['userId'] as int,
      username: json['username'] as String,
      token: json['token'] as String
    );
  }
}

class PlaceCreate {
  final String? name;
  final String? description;
  final String? location;
  final double? rating;
  final int? categoryType;
  final double? averagePrice;

  PlaceCreate({
    this.name,
    this.description,
    this.location,
    this.rating,
    this.categoryType,
    this.averagePrice,
  });
}

class Place {
  final int? placeId;
  final String? name;
  final String? description;
  final String? location;
  final int? categoryType;
  final double? averagePrice;
  final String? preview;

  Place({
    required this.placeId,
    this.name,
    this.description,
    this.location,
    this.categoryType,
    this.averagePrice,
    this.preview
  });

    factory Place.fromJson(Map<String, dynamic> json) {
      return Place(
        placeId: json['placeId'],
        name: json['name'],
        description: json['description'],
        location: json['location'],
        categoryType: json['categoryType'],
        averagePrice: json['averagePrice']?.toDouble(),
        preview: json['preview']
      );
    }
}

class GetPlaceReviewWithName {
  GetPlaceReviewWithName({
    required this.reviewId,
    required this.userId,
    required this.placeId,
    required this.reviewText,
    required this.rating,
    required this.date,
    required this.firstName,
    required this.lastName,
  });

  final int? reviewId;
  final int? userId;
  final int? placeId;
  final String? reviewText;
  final double? rating;
  final DateTime? date;
  final String? firstName;
  final String? lastName;

  factory GetPlaceReviewWithName.fromJson(Map<String, dynamic> json){
    return GetPlaceReviewWithName(
      reviewId: json["reviewId"],
      userId: json["userId"],
      placeId: json["placeId"],
      reviewText: json["reviewText"],
      rating: json["rating"],
      date: DateTime.tryParse(json["date"] ?? ""),
      firstName: json["firstName"],
      lastName: json["lastName"],
    );
  }

}


class PlaceReview {
  final int reviewId;
  final int userId;
  final int placeId;
  final String? reviewText;
  final double rating;
  final DateTime date;

  PlaceReview({
    required this.reviewId,
    required this.userId,
    required this.placeId,
    this.reviewText,
    required this.rating,
    required this.date,
  });
}

class CreatePlanItem {
  CreatePlanItem({
    required this.placeId,
    required this.planDate,
  });

  final int? placeId;
  final DateTime? planDate;

  factory CreatePlanItem.fromJson(Map<String, dynamic> json){
    return CreatePlanItem(
      placeId: json["placeID"],
      planDate: DateTime.tryParse(json["planDate"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "placeID": placeId,
    "planDate": planDate?.toIso8601String(),
  };

}


class PlanItem {
  final int itemId;
  final int planId;
  final int placeId;
  final DateTime planDate;

  PlanItem({
    required this.itemId,
    required this.planId,
    required this.placeId,
    required this.planDate,
  });
}

class RoleCreate {
  final String roleName;

  RoleCreate({
    required this.roleName,
  });
}

class Role {
  final int roleId;
  final String roleName;

  Role({
    required this.roleId,
    required this.roleName,
  });
}

class TagCreate {
  final String tagName;
  final int categoryId;

  TagCreate({
    required this.tagName,
    required this.categoryId,
  });
}

class Tag {
  final int tagId;
  final String tagName;
  final int categoryId;

  Tag({
    required this.tagId,
    required this.tagName,
    required this.categoryId,
  });
}

class ImageEntity {
  final int imageId;
  final String imageUrl;
  final int placeId;

  ImageEntity({
    required this.imageUrl,
    required this.imageId,
    required this.placeId,
  });

  factory ImageEntity.fromJson(Map<String, dynamic> json) {
    return ImageEntity(
        imageId: json['imageId'] as int,
        imageUrl: json['imageUrl'] as String,
        placeId: json['placeId'] as int
    );
  }
}

class UserCreate {
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;

  UserCreate({
    required this.username,
    required this.password,
    required this.email,
    required this.firstName,
    required this.lastName,
  });
}

class User {
  final int userId;
  final String username;
  final String password;
  final String email;
  final String firstName;
  final String lastName;
  final List<Role> roles;

  User({
    required this.userId,
    required this.username,
    required this.password,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.roles = const [],
  });
}

class VacationPlan {
  VacationPlan({
    required this.planId,
    required this.userId,
    required this.name,
    required this.description,
    this.createData,
    this.isPublic,
    this.planItem,
  });

  final int? planId;
  final int? userId;
  final String? name;
  final String? description;
  final DateTime? createData;
  final bool? isPublic;
  final dynamic planItem;

  factory VacationPlan.fromJson(Map<String, dynamic> json){
    return VacationPlan(
      planId: json["planId"],
      userId: json["userId"],
      name: json["name"],
      description: json["description"],
      createData: DateTime.tryParse(json["createData"] ?? ""),
      isPublic: json["isPublic"],
      planItem: json["planItem"],
    );
  }

  Map<String, dynamic> toJson() => {
    "planId": planId,
    "userId": userId,
    "name": name,
    "description": description,
    "createData": createData?.toIso8601String(),
    "isPublic": isPublic,
    "planItem": planItem,
  };

}

