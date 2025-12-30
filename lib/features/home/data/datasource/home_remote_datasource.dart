// lib/features/home/data/datasources/home_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/listing_model.dart';

/// Abstract Data Source Interface
///
/// Defines the contract for fetching home page data.
/// This abstraction allows for easy testing and potential
/// implementation swapping (e.g., mock data for testing).
abstract class HomeRemoteDataSource {
  /// Fetch all listings from the API
  Future<List<ListingModel>> getAllListings();

  /// Fetch listings filtered by category
  ///
  /// Categories: 'hotel', 'villa', 'apartment', 'cafe'
  Future<List<ListingModel>> getListingsByCategory(String category);

  /// Fetch a single listing by ID
  Future<ListingModel> getListingById(int id);

  /// Fetch featured/popular listings
  ///
  /// This could be based on bookings, ratings, or a featured flag
  /// For now, we'll return the first N listings
  Future<List<ListingModel>> getFeaturedListings({int limit = 10});
}

/// Remote Data Source Implementation
///
/// Handles all HTTP communication with the Flask backend.
/// Transforms API responses into our domain models.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl(this.dioClient);

  //========================================================================
  // GET ALL LISTINGS
  //========================================================================

  @override
  Future<List<ListingModel>> getAllListings() async {
    try {
      print('📡 [HomeRemoteDataSource] Fetching all listings...');

      // Make GET request to /gems/listings
      final response = await dioClient.get(
        '/listings',  // Endpoint from Postman collection
      );

      print('📥 [HomeRemoteDataSource] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // API returns an array of listing objects
        final List<dynamic> listingsJson = response.data as List<dynamic>;

        print('📊 [HomeRemoteDataSource] Found ${listingsJson.length} listings');

        // Convert each JSON object to ListingModel
        final listings = listingsJson
            .map((json) => ListingModel.fromJson(json as Map<String, dynamic>))
            .toList();

        print('✅ [HomeRemoteDataSource] Successfully parsed listings');
        return listings;

      } else {
        throw ServerException(
          message: 'Failed to fetch listings',
          statusCode: response.statusCode,
        );
      }

    } on DioException catch (e) {
      print('❌ [HomeRemoteDataSource] DioException: ${e.message}');
      throw ErrorHandler.handleDioError(e);

    } catch (e) {
      print('❌ [HomeRemoteDataSource] Unexpected error: $e');
      throw ServerException(message: 'Failed to fetch listings');
    }
  }

  //========================================================================
  // GET LISTINGS BY CATEGORY
  //========================================================================

  @override
  Future<List<ListingModel>> getListingsByCategory(String category) async {
    try {
      print('📡 [HomeRemoteDataSource] Fetching listings for category: $category');

      // Fetch all listings first
      final allListings = await getAllListings();

      // Filter by category on client side
      // Note: In production, you'd want a backend endpoint for this
      // to reduce data transfer and improve performance
      final filteredListings = allListings
          .where((listing) => listing.category.toLowerCase() == category.toLowerCase())
          .toList();

      print('📊 [HomeRemoteDataSource] Found ${filteredListings.length} listings in category: $category');

      return filteredListings;

    } catch (e) {
      print('❌ [HomeRemoteDataSource] Error filtering by category: $e');
      rethrow;
    }
  }

  //========================================================================
  // GET LISTING BY ID
  //========================================================================

  @override
  Future<ListingModel> getListingById(int id) async {
    try {
      print('📡 [HomeRemoteDataSource] Fetching listing with ID: $id');

      // Make GET request to /gems/listings/{id}
      final response = await dioClient.get(
        '/listings/$id',
      );

      print('📥 [HomeRemoteDataSource] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final listing = ListingModel.fromJson(
          response.data as Map<String, dynamic>,
        );

        print('✅ [HomeRemoteDataSource] Successfully fetched listing: ${listing.title}');
        return listing;

      } else if (response.statusCode == 404) {
        throw ServerException(
          message: 'Listing not found',
          statusCode: 404,
        );

      } else {
        throw ServerException(
          message: 'Failed to fetch listing',
          statusCode: response.statusCode,
        );
      }

    } on DioException catch (e) {
      print('❌ [HomeRemoteDataSource] DioException: ${e.message}');

      if (e.response?.statusCode == 404) {
        throw ServerException(
          message: 'Listing not found',
          statusCode: 404,
        );
      }

      throw ErrorHandler.handleDioError(e);

    } catch (e) {
      print('❌ [HomeRemoteDataSource] Unexpected error: $e');
      throw ServerException(message: 'Failed to fetch listing');
    }
  }

  //========================================================================
  // GET FEATURED LISTINGS
  //========================================================================

  @override
  Future<List<ListingModel>> getFeaturedListings({int limit = 10}) async {
    try {
      print('📡 [HomeRemoteDataSource] Fetching featured listings (limit: $limit)...');

      // Fetch all listings
      final allListings = await getAllListings();

      // Sort by price (descending) to get "premium" listings
      // In production, you'd have a "featured" flag or sorting endpoint
      final featured = List<ListingModel>.from(allListings)
        ..sort((a, b) => b.price.compareTo(a.price));

      // Take only the requested number
      final result = featured.take(limit).toList();

      print('✅ [HomeRemoteDataSource] Returning ${result.length} featured listings');
      return result;

    } catch (e) {
      print('❌ [HomeRemoteDataSource] Error fetching featured listings: $e');
      rethrow;
    }
  }
}