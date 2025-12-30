// lib/features/home/data/models/listing_model.dart

import '../../domain/entities/listing.dart';

/// Listing Model - Data Transfer Object
///
/// Extends the domain entity and adds JSON serialization capabilities.
/// This is the bridge between API responses and our business logic.
class ListingModel extends Listing {

  const ListingModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    super.photo,
    required super.businessId,
    super.createdAt,
    super.updatedAt,
    super.business,
  });

  /// Create from JSON response
  ///
  /// Expected JSON structure from API:
  /// {
  ///   "id": 1,
  ///   "title": "Serenity Sands",
  ///   "description": "Beautiful beachfront property...",
  ///   "price": 270.0,
  ///   "category": "hotel",
  ///   "photo": "hotel1.jpg",
  ///   "business_id": 1,
  ///   "created_at": "2024-01-15T10:30:00Z",
  ///   "business": { ... }
  /// }
  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',

      // Handle price as either int or double from API
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'] as double,

      category: json['category'] as String,
      photo: json['photo'] as String?,
      businessId: json['business_id'] as int,

      // Parse timestamps if provided
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,

      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,

      // Parse nested business object if included
      business: json['business'] != null
          ? BusinessModel.fromJson(json['business'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'photo': photo,
      'business_id': businessId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      if (business != null) 'business': (business as BusinessModel).toJson(),
    };
  }

  /// Convert from domain entity to model
  factory ListingModel.fromEntity(Listing listing) {
    return ListingModel(
      id: listing.id,
      title: listing.title,
      description: listing.description,
      price: listing.price,
      category: listing.category,
      photo: listing.photo,
      businessId: listing.businessId,
      createdAt: listing.createdAt,
      updatedAt: listing.updatedAt,
      business: listing.business,
    );
  }

  /// Convert model to domain entity
  Listing toEntity() {
    return Listing(
      id: id,
      title: title,
      description: description,
      price: price,
      category: category,
      photo: photo,
      businessId: businessId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      business: business,
    );
  }

  @override
  ListingModel copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? photo,
    int? businessId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Business? business,
  }) {
    return ListingModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      photo: photo ?? this.photo,
      businessId: businessId ?? this.businessId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      business: business ?? this.business,
    );
  }
}

/// Business Model - Data Transfer Object for Business entity
class BusinessModel extends Business {

  const BusinessModel({
    required super.id,
    required super.name,
    required super.category,
    required super.location,
    required super.description,
    required super.ownerId,
    super.createdAt,
  });

  /// Create from JSON
  ///
  /// Expected structure:
  /// {
  ///   "id": 1,
  ///   "name": "Luxury Hotels Inc",
  ///   "category": "hotel",
  ///   "location": "Miami, FL",
  ///   "description": "Premium hotel chain...",
  ///   "owner_id": 1
  /// }
  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      location: json['location'] as String,
      description: json['description'] as String? ?? '',
      ownerId: json['owner_id'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'location': location,
      'description': description,
      'owner_id': ownerId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Convert from entity
  factory BusinessModel.fromEntity(Business business) {
    return BusinessModel(
      id: business.id,
      name: business.name,
      category: business.category,
      location: business.location,
      description: business.description,
      ownerId: business.ownerId,
      createdAt: business.createdAt,
    );
  }

  /// Convert to entity
  Business toEntity() {
    return Business(
      id: id,
      name: name,
      category: category,
      location: location,
      description: description,
      ownerId: ownerId,
      createdAt: createdAt,
    );
  }

  @override
  BusinessModel copyWith({
    int? id,
    String? name,
    String? category,
    String? location,
    String? description,
    int? ownerId,
    DateTime? createdAt,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}