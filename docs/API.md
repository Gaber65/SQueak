# 🌐 Squeak API Documentation

## Overview

This document outlines the API integration and networking architecture for the Squeak Flutter application.

Note: The Home screen "Did You Know?" tips currently load from a local asset (`assets/content/pet_tips.json`) via `PetTipsRepository` and are not fetched from the backend.

## 🔗 Base Configuration

### API Endpoints
```dart
// Base URL Configuration
baseApiUrlSqueak: "https://api.squeak.app/v1"
timeout: 30 seconds
contentType: "application/json"
```

### Authentication
```dart
// Headers
"Content-Type": "application/json"
"Accept-Language": "ar" | "en" 
"Authorization": "Bearer {token}"
```

## 🛠️ HTTP Client Configuration

### Dio Setup
```dart
class DioFinalHelper {
  static late Dio dio;
  
  // Interceptors
  - ChuckerDioInterceptor (debug mode)
  - Token refresh interceptor
  - Error handling interceptor
  - Logging interceptor
}
```

### Request/Response Flow
1. **Token Validation**: Check if access token is expired
2. **Auto Refresh**: Refresh token if needed
3. **Request Execution**: Send request with proper headers
4. **Response Handling**: Parse response or handle errors
5. **Error Recovery**: Retry logic for failed requests

## 🔐 Authentication Endpoints

### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email_or_phone": "string",
  "password": "string"
}

Response:
{
  "token": "string",
  "refresh_token": "string", 
  "expires_in": "number",
  "user": {
    "id": "number",
    "full_name": "string",
    "email": "string",
    "phone": "string"
  }
}
```

### Register
```http
POST /auth/register
Content-Type: application/json

{
  "full_name": "string",
  "email": "string", 
  "phone": "string",
  "password": "string",
  "country_id": "number",
  "clinic_code": "string" (optional)
}

Response:
{
  "message": "string",
  "user_id": "number"
}
```

### Forgot Password
```http
POST /auth/forgot-password
Content-Type: application/json

{
  "email": "string"
}

Response:
{
  "message": "string"
}
```

### Reset Password
```http
POST /auth/reset-password
Content-Type: application/json

{
  "email": "string",
  "token": "string",
  "password": "string"
}

Response:
{
  "message": "string"
}
```

### Verify User
```http
POST /auth/verify
Content-Type: application/json

{
  "email": "string",
  "verification_code": "string"
}

Response:
{
  "message": "string",
  "verified": "boolean"
}
```

## 🐾 Pet Management Endpoints

### Get Owner Pets
```http
GET /pets/owner
Authorization: Bearer {token}

Response:
{
  "data": [
    {
      "id": "number",
      "name": "string",
      "type": "string",
      "breed": "string",
      "age": "number",
      "weight": "number",
      "image": "string",
      "qr_code": "string",
      "created_at": "string"
    }
  ]
}
```

### Add Pet
```http
POST /pets
Authorization: Bearer {token}
Content-Type: multipart/form-data

{
  "name": "string",
  "type": "string",
  "breed": "string", 
  "birth_date": "string",
  "weight": "number",
  "gender": "string",
  "image": "file",
  "notes": "string"
}

Response:
{
  "message": "string",
  "pet": {
    "id": "number",
    "name": "string",
    "qr_code": "string"
  }
}
```

### Update Pet
```http
PUT /pets/{pet_id}
Authorization: Bearer {token}
Content-Type: multipart/form-data

{
  "name": "string",
  "breed": "string",
  "weight": "number",
  "image": "file" (optional),
  "notes": "string"
}

Response:
{
  "message": "string",
  "pet": { ... }
}
```

### Delete Pet
```http
DELETE /pets/{pet_id}
Authorization: Bearer {token}

Response:
{
  "message": "string"
}
```

## 🏥 Clinic & Appointment Endpoints

### Get Clinic Info
```http
GET /clinics/{clinic_code}
Authorization: Bearer {token}

Response:
{
  "data": {
    "clinic": {
      "id": "number",
      "name": "string",
      "code": "string",
      "phone": "string",
      "address": "string",
      "specialities": ["string"],
      "logo": "string",
      "working_hours": {
        "monday": "09:00-17:00",
        ...
      }
    }
  }
}
```

### Get Available Appointments
```http
GET /appointments/availability
Authorization: Bearer {token}
Query Parameters:
- clinic_id: number
- date: string (YYYY-MM-DD)
- doctor_id: number (optional)

Response:
{
  "data": [
    {
      "time": "string",
      "available": "boolean",
      "doctor": {
        "id": "number",
        "name": "string"
      }
    }
  ]
}
```

### Book Appointment
```http
POST /appointments
Authorization: Bearer {token}
Content-Type: application/json

{
  "clinic_id": "number",
  "pet_id": "number", 
  "doctor_id": "number",
  "appointment_date": "string",
  "appointment_time": "string",
  "notes": "string"
}

Response:
{
  "message": "string",
  "appointment": {
    "id": "number",
    "reference": "string",
    "status": "string"
  }
}
```

### Get User Appointments
```http
GET /appointments/user
Authorization: Bearer {token}
Query Parameters:
- page: number
- limit: number
- status: string (upcoming|completed|cancelled)

Response:
{
  "data": [
    {
      "id": "number",
      "reference": "string",
      "date": "string",
      "time": "string",
      "status": "string",
      "clinic": { ... },
      "pet": { ... },
      "doctor": { ... }
    }
  ],
  "pagination": {
    "total": "number",
    "page": "number",
    "limit": "number"
  }
}
```

## 💉 Vaccination Endpoints

### Get Pet Vaccinations
```http
GET /pets/{pet_id}/vaccinations
Authorization: Bearer {token}

Response:
{
  "data": [
    {
      "id": "number",
      "vaccine_name": "string",
      "vaccination_date": "string",
      "next_due_date": "string",
      "clinic": { ... },
      "notes": "string"
    }
  ]
}
```

### Add Vaccination Record
```http
POST /pets/{pet_id}/vaccinations
Authorization: Bearer {token}
Content-Type: application/json

{
  "vaccine_name": "string",
  "vaccination_date": "string",
  "next_due_date": "string",
  "clinic_id": "number",
  "notes": "string"
}

Response:
{
  "message": "string",
  "vaccination": { ... }
}
```

## 🔗 QR Code Endpoints

### Link Pet to Clinic
```http
POST /qr/link
Authorization: Bearer {token}
Content-Type: application/json

{
  "pet_id": "number",
  "clinic_code": "string"
}

Response:
{
  "message": "string"
}
```

### Unlink Pet from Clinic
```http
POST /qr/unlink
Authorization: Bearer {token}
Content-Type: application/json

{
  "pet_id": "number",
  "clinic_id": "number"
}

Response:
{
  "message": "string"
}
```

### Get Pet by QR Code
```http
GET /qr/pet/{qr_code}
Authorization: Bearer {token}

Response:
{
  "data": {
    "pet": { ... },
    "owner": { ... },
    "medical_history": [ ... ]
  }
}
```

## 🌍 Utility Endpoints

### Get Countries
```http
GET /countries

Response:
{
  "data": [
    {
      "id": "number",
      "name": "string",
      "code": "string",
      "phone_code": "string"
    }
  ]
}
```

### Contact Us
```http
POST /contact
Content-Type: application/json

{
  "name": "string",
  "email": "string",
  "phone": "string",
  "country_id": "number",
  "subject": "string",
  "message": "string"
}

Response:
{
  "message": "string"
}
```

### Get App Version
```http
GET /app/version
Query Parameters:
- platform: string (ios|android)

Response:
{
  "data": {
    "version": "string",
    "build_number": "number",
    "force_update": "boolean",
    "update_url": "string"
  }
}
```

## 🔔 Firebase Endpoints

### Save FCM Token
```http
POST /fcm/token
Authorization: Bearer {token}
Content-Type: application/json

{
  "token": "string",
  "platform": "string"
}

Response:
{
  "message": "string"
}
```

### Get Notifications
```http
GET /notifications
Authorization: Bearer {token}
Query Parameters:
- page: number
- limit: number

Response:
{
  "data": [
    {
      "id": "number",
      "title": "string",
      "body": "string",
      "type": "string",
      "data": { ... },
      "read": "boolean",
      "created_at": "string"
    }
  ]
}
```

## ⚠️ Error Handling

### Standard Error Response
```json
{
  "message": "string",
  "errors": {
    "field_name": ["error message"]
  },
  "code": "number"
}
```

### Common Error Codes
- `400`: Bad Request - Invalid input data
- `401`: Unauthorized - Invalid or expired token
- `403`: Forbidden - Insufficient permissions
- `404`: Not Found - Resource not found
- `422`: Unprocessable Entity - Validation errors
- `500`: Internal Server Error - Server error

### Error Handling in App
```dart
try {
  final response = await DioFinalHelper.getData(method: '/endpoint');
  // Handle success
} catch (error) {
  if (error is ServerException) {
    // Handle API errors
    final message = extractFirstErrorAuth(error.errorMessageModel);
    errorToast(context, message);
  }
}
```

## 🔄 Token Management

### Access Token
- **Lifetime**: 24 hours
- **Storage**: Secure storage (CacheHelper)
- **Auto Refresh**: Before each API call

### Refresh Token
- **Lifetime**: 30 days
- **Storage**: Secure storage
- **Usage**: Automatic token refresh

### Token Refresh Flow
```dart
class TokenManager {
  static Future<bool> isAccessTokenExpired() { ... }
  static Future<void> refreshToken() { ... }
  static void saveToken(String token, int expiresIn, String refreshToken) { ... }
}
```

## 📊 API Response Caching

### Cache Strategy
- **User Data**: Cache for offline access
- **Pet Data**: Real-time with local cache
- **Appointments**: Real-time only
- **Static Data**: Long-term cache (countries, etc.)

### Implementation
```dart
// SQLite for structured data
// SharedPreferences for simple data
// FastCachedNetworkImage for images
```

## 🔍 API Testing

### Tools Used
- **Chucker**: Network inspector for debugging
- **Postman**: API testing and documentation
- **Unit Tests**: Repository layer testing
- **Integration Tests**: End-to-end API testing

### Testing Guidelines
- Test all happy path scenarios
- Test error conditions
- Test authentication flows
- Test network failure scenarios
- Validate response parsing

---

**Note**: All API endpoints require proper error handling and loading states as implemented in the app's loading indicators system.
