// lib/core/constants/api_endpoints.dart

/// API Endpoints Configuration
///
/// This class centralizes all API endpoint definitions for the Gemify application.
/// Following Clean Architecture principles, this allows easy endpoint management
/// and testing through dependency injection.
///
/// Base URL should be configured through environment variables in production.
class ApiEndpoints {
  ApiEndpoints._(); // Private constructor to prevent instantiation

  //============================================================================
  // BASE CONFIGURATION
  //============================================================================

  /// Base API URL
  ///
  /// Production: Should use environment variables or flavor-specific configs
  /// Development: Points to local or staging server
  static const String baseUrl = 'http://34.35.110.190/gems';

  /// Alternative base URL for local development
  static const String localBaseUrl = 'http://127.0.0.1:5555/gems';

  //============================================================================
  // TIMEOUT CONFIGURATION
  //============================================================================

  /// Connection timeout duration
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Receive timeout duration
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Send timeout duration
  static const Duration sendTimeout = Duration(seconds: 30);

  //============================================================================
  // AUTHENTICATION ENDPOINTS
  //============================================================================

  /// Admin authentication endpoint
  /// POST /login
  /// Body: { "email": string, "password": string }
  static const String adminLogin = '/login';

  /// Admin registration endpoint
  /// POST /admin-registration
  /// Body: { "username": string, "phone": string, "email": string, "password": string }
  static const String adminRegistration = '/admin-registration';

  /// User registration endpoint
  /// POST /users
  /// Body: { "username": string, "email": string, "phone": string }
  static const String userRegistration = '/users';

  /// Request OTP for email verification
  /// POST /request-otp
  /// Body: { "email": string }
  static const String requestOTP = '/request-otp';

  /// Verify OTP code
  /// POST /verify-otp
  /// Body: { "email": string, "otp": string }
  static const String verifyOTP = '/verify-otp';

  /// Get current authenticated user
  /// GET /whoami
  /// Requires: Authorization header with Bearer token
  static const String whoami = '/whoami';

  /// Get user's OTP (admin function)
  /// GET /user/{id}/otp
  /// Requires: Authorization header with Bearer token
  static String getUserOTP(int userId) => '/user/$userId/otp';

  //============================================================================
  // ADMIN ENDPOINTS
  //============================================================================

  /// Update admin details or change password
  /// PUT /admins/{id}
  /// Body: { "currentPassword": string, "password": string, "phone": string }
  static String updateAdmin(int adminId) => '/admins/$adminId';

  /// Get bookings managed by admin
  /// GET /admin/{id}/bookings
  static String getAdminBookings(int adminId) => '/admin/$adminId/bookings';

  //============================================================================
  // USER ENDPOINTS
  //============================================================================

  /// Get all users
  /// GET /users
  static const String getAllUsers = '/users';

  /// Get user by ID
  /// GET /users/{id}
  static String getUserById(int userId) => '/users/$userId';

  /// Create new user
  /// POST /users
  /// Body: { "username": string, "email": string, "phone": string }
  static const String createUser = '/users';

  /// Update user details
  /// PUT /user/{id}
  /// Body: { "location": string, "password": string, etc. }
  static String updateUser(int userId) => '/user/$userId';

  /// Delete user
  /// DELETE /users/{id}
  static String deleteUser(int userId) => '/users/$userId';

  //============================================================================
  // BUSINESS ENDPOINTS
  //============================================================================

  /// Get all businesses
  /// GET /businesses
  static const String getAllBusinesses = '/businesses';

  /// Get business by ID
  /// GET /businesses/{id}
  static String getBusinessById(int businessId) => '/businesses/$businessId';

  /// Get businesses by owner ID
  /// GET /businesses/owner/{id}
  static String getBusinessesByOwner(int ownerId) =>
      '/businesses/owner/$ownerId';

  /// Create new business
  /// POST /businesses
  /// Body: { "name": string, "category": string, "location": string,
  ///         "description": string, "owner_id": int }
  static const String createBusiness = '/businesses';

  /// Update business details
  /// PUT /businesses/{id}
  /// Body: { "location": string, etc. }
  static String updateBusiness(int businessId) => '/businesses/$businessId';

  /// Delete business
  /// DELETE /businesses/{id}
  static String deleteBusiness(int businessId) => '/businesses/$businessId';

  //============================================================================
  // LISTING ENDPOINTS
  //============================================================================

  /// Get all listings
  /// GET /listings
  static const String getAllListings = '/listings';

  /// Get listing by ID
  /// GET /listings/{id}
  static String getListingById(int listingId) => '/listings/$listingId';

  /// Get listings by owner/user ID
  /// GET /listings/user/{id}
  static String getListingsByUser(int userId) => '/listings/user/$userId';

  /// Create new listing
  /// POST /listings
  /// Body: { "title": string, "business_id": int, "description": string,
  ///         "price": number, "category": string, "photo": string }
  static const String createListing = '/listings';

  /// Update listing status
  /// PUT /listings/{id}
  /// Body: { "status": string, etc. }
  static String updateListing(int listingId) => '/listings/$listingId';

  /// Delete listing
  /// DELETE /listings/{id}
  static String deleteListing(int listingId) => '/listings/$listingId';

  //============================================================================
  // BOOKING ENDPOINTS
  //============================================================================

  /// Get all bookings
  /// GET /bookings
  static const String getAllBookings = '/bookings';

  /// Get booking by ID
  /// GET /bookings/{id}
  static String getBookingById(int bookingId) => '/bookings/$bookingId';

  /// Create new booking
  /// POST /bookings
  /// Body: { "listing_id": int, "user_id": int, "quantity": int,
  ///         "name": string (optional), "email": string (optional) }
  static const String createBooking = '/bookings';

  /// Update booking status
  /// PUT /bookings/{id}
  /// Body: { "status": string } // e.g., "Cancelled", "Confirmed", etc.
  static String updateBookingStatus(int bookingId) => '/bookings/$bookingId';

  /// Delete booking
  /// DELETE /bookings/{id}
  static String deleteBooking(int bookingId) => '/bookings/$bookingId';

  //============================================================================
  // PAYMENT ENDPOINTS
  //============================================================================

  /// Get payments for a specific booking
  /// GET /payments/booking/{id}
  static String getBookingPayments(int bookingId) =>
      '/payments/booking/$bookingId';

  //============================================================================
  // HELPER METHODS
  //============================================================================

  /// Build full URL from endpoint
  ///
  /// Example:
  /// ```dart
  /// final url = ApiEndpoints.buildUrl(ApiEndpoints.getAllUsers);
  /// // Returns: "http://34.35.110.190/gems/users"
  /// ```
  static String buildUrl(String endpoint, {bool useLocalUrl = false}) {
    final base = useLocalUrl ? localBaseUrl : baseUrl;
    return '$base$endpoint';
  }

  /// Check if endpoint requires authentication
  ///
  /// Returns true for endpoints that need Authorization header
  static bool requiresAuth(String endpoint) {
    // Public endpoints that don't require authentication
    const publicEndpoints = [
      userRegistration,
      requestOTP,
      verifyOTP,
      adminLogin,
      getAllListings,
      getAllBusinesses,
    ];

    return !publicEndpoints.contains(endpoint);
  }

  /// Get HTTP method for endpoint
  ///
  /// Returns the appropriate HTTP method for common operations
  static String getHttpMethod(String endpoint) {
    if (endpoint.startsWith('/login') ||
        endpoint.startsWith('/request-otp') ||
        endpoint.startsWith('/verify-otp')) {
      return 'POST';
    }

    if (endpoint.contains('PUT') ||
        endpoint.contains('/admins/') ||
        endpoint.contains('/user/') ||
        endpoint.contains('/businesses/') ||
        endpoint.contains('/listings/') ||
        endpoint.contains('/bookings/')) {
      return 'PUT';
    }

    if (endpoint.contains('DELETE')) {
      return 'DELETE';
    }

    return 'GET';
  }
}

//============================================================================
// ENDPOINT CATEGORIES (for organization)
//============================================================================

/// Authentication-related endpoints
class AuthEndpoints {
  static const adminLogin = ApiEndpoints.adminLogin;
  static const adminRegistration = ApiEndpoints.adminRegistration;
  static const userRegistration = ApiEndpoints.userRegistration;
  static const requestOTP = ApiEndpoints.requestOTP;
  static const verifyOTP = ApiEndpoints.verifyOTP;
  static const whoami = ApiEndpoints.whoami;
}

/// User management endpoints
class UserEndpoints {
  static const getAll = ApiEndpoints.getAllUsers;
  static String getById(int id) => ApiEndpoints.getUserById(id);
  static const create = ApiEndpoints.createUser;
  static String update(int id) => ApiEndpoints.updateUser(id);
  static String delete(int id) => ApiEndpoints.deleteUser(id);
}

/// Business management endpoints
class BusinessEndpoints {
  static const getAll = ApiEndpoints.getAllBusinesses;
  static String getById(int id) => ApiEndpoints.getBusinessById(id);
  static String getByOwner(int ownerId) =>
      ApiEndpoints.getBusinessesByOwner(ownerId);
  static const create = ApiEndpoints.createBusiness;
  static String update(int id) => ApiEndpoints.updateBusiness(id);
  static String delete(int id) => ApiEndpoints.deleteBusiness(id);
}

/// Listing management endpoints
class ListingEndpoints {
  static const getAll = ApiEndpoints.getAllListings;
  static String getById(int id) => ApiEndpoints.getListingById(id);
  static String getByUser(int userId) => ApiEndpoints.getListingsByUser(userId);
  static const create = ApiEndpoints.createListing;
  static String update(int id) => ApiEndpoints.updateListing(id);
  static String delete(int id) => ApiEndpoints.deleteListing(id);
}

/// Booking management endpoints
class BookingEndpoints {
  static const getAll = ApiEndpoints.getAllBookings;
  static String getById(int id) => ApiEndpoints.getBookingById(id);
  static const create = ApiEndpoints.createBooking;
  static String updateStatus(int id) => ApiEndpoints.updateBookingStatus(id);
  static String delete(int id) => ApiEndpoints.deleteBooking(id);
}

/// Payment-related endpoints
class PaymentEndpoints {
  static String getBookingPayments(int bookingId) =>
      ApiEndpoints.getBookingPayments(bookingId);
}