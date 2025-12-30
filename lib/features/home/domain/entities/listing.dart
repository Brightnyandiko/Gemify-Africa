// lib/features/home/domain/entities/listing.dart

import 'package:equatable/equatable.dart';

/// Listing Entity - Core business object for hotel/property listings
///
/// This represents a property listing in pure business logic terms,
/// independent of any data source or presentation concerns.
class Listing extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;  // 'hotel', 'villa', 'apartment', 'cafe'
  final String? photo;
  final int businessId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Business relationship data
  final Business? business;  // The business that owns this listing

  // Computed properties for UI convenience
  String get pricePerNight => '\$${price.toStringAsFixed(0)} /night';
  String get categoryDisplay => _capitalizeFirst(category);

  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    this.photo,
    required this.businessId,
    this.createdAt,
    this.updatedAt,
    this.business,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    category,
    photo,
    businessId,
    createdAt,
    updatedAt,
    business,
  ];

  /// Create a copy with modified fields
  Listing copyWith({
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
    return Listing(
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

  @override
  String toString() {
    return 'Listing(id: $id, title: $title, category: $category, price: $price)';
  }

  /// Helper method to capitalize first letter
  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }
}

/// Business Entity - Represents the business/owner of listings
class Business extends Equatable {
  final int id;
  final String name;
  final String category;
  final String location;
  final String description;
  final int ownerId;
  final DateTime? createdAt;

  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.location,
    required this.description,
    required this.ownerId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    category,
    location,
    description,
    ownerId,
    createdAt,
  ];

  Business copyWith({
    int? id,
    String? name,
    String? category,
    String? location,
    String? description,
    int? ownerId,
    DateTime? createdAt,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      location: location ?? this.location,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'Business(id: $id, name: $name, location: $location)';
}