# User Database Testing Guide

## 📋 Overview

This guide shows you how to test the complete user system including registration, profile management, and data retrieval.

---

## ✅ What's Available

### **User Endpoints in ApiService**

- `registerUser()` → `POST /users/register`
- `getUserProfile()` → `GET /users/{userId}`
- `updateUserProfile()` → `PUT /users/{userId}`
- `deleteUser()` → `DELETE /users/{userId}`
- `getUserWorkoutHistory()` → `GET /progress/{userId}/history?type=workout`
- `getUserBodyHistory()` → `GET /progress/{userId}/history?type=body`

### **UserRepository Methods**

- `registerUser()` - Create new account with full profile
- `getUserProfile()` - Retrieve user account details
- `updateUserProfile()` - Update user information
- `getUserAccountSummary()` - Get profile + history counts
- `getWorkoutHistory()` - All workouts for user
- `getBodyHistory()` - All body measurements for user

### **DataSyncService Methods**

Easy-to-use wrappers for all user operations

---

## 🧪 Testing Scenarios

### **Scenario 1: Register a New User**

```dart
import 'package:kinedemo/services/data_sync_service.dart';

final syncService = DataSyncService();

void testRegisterUser() async {
  try {
    final result = await syncService.registerUser(
      email: 'ahmed@example.com',
      password: 'securePassword123',
      firstName: 'Ahmed',
      lastName: 'Hassan',
      phone: '+1234567890',
      age: 28,
      height: 180.0,
      weight: 75.0,
      gender: 'Male',
      fitnessLevel: 'Intermediate',
    );

    print('✅ User registered successfully!');
    print('User ID: ${result['id']}'); // Use this for future requests
    print('Email: ${result['email']}');
    print('Full Profile: $result');

  } catch (e) {
    print('❌ Registration failed: $e');
  }
}
```

**Expected Response:**

```json
{
  "id": 1,
  "email": "ahmed@example.com",
  "firstName": "Ahmed",
  "lastName": "Hassan",
  "phone": "+1234567890",
  "age": 28,
  "height": 180.0,
  "weight": 75.0,
  "gender": "Male",
  "fitnessLevel": "Intermediate",
  "createdAt": "2026-06-04T10:30:00Z"
}
```

---

### **Scenario 2: Fetch User Profile by ID**

```dart
void testGetUserProfile() async {
  try {
    final userId = 1; // From registration response

    final profile = await syncService.getUserProfile(userId);

    print('✅ User profile retrieved!');
    print('Name: ${profile['firstName']} ${profile['lastName']}');
    print('Email: ${profile['email']}');
    print('Age: ${profile['age']}');
    print('Height: ${profile['height']} cm');
    print('Weight: ${profile['weight']} kg');
    print('Fitness Level: ${profile['fitnessLevel']}');
    print('Full Profile: $profile');

  } catch (e) {
    print('❌ Failed to fetch profile: $e');
  }
}
```

---

### **Scenario 3: Update User Profile**

```dart
void testUpdateUserProfile() async {
  try {
    final userId = 1;

    final updated = await syncService.updateUserProfile(
      userId,
      weight: 72.5,  // Update weight after workout
      age: 29,       // Birthday passed
      fitnessLevel: 'Advanced',
    );

    print('✅ User profile updated!');
    print('New Weight: ${updated['weight']}');
    print('New Fitness Level: ${updated['fitnessLevel']}');

  } catch (e) {
    print('❌ Failed to update profile: $e');
  }
}
```

---

### **Scenario 4: Get User Account Summary**

```dart
void testGetUserSummary() async {
  try {
    final userId = 1;

    final summary = await syncService.getUserAccountSummary(userId);

    print('✅ User summary retrieved!');
    print('Profile: ${summary['profile']}');
    print('Total Workouts: ${summary['workoutCount']}');
    print('Total Body Records: ${summary['bodyRecordCount']}');
    print('Last Updated: ${summary['lastUpdated']}');

  } catch (e) {
    print('❌ Failed to get summary: $e');
  }
}
```

---

### **Scenario 5: Get User Workout History**

```dart
void testGetWorkoutHistory() async {
  try {
    final userId = 1;

    final workouts = await syncService.getUserWorkoutHistory(userId);

    print('✅ Workout history retrieved! Count: ${workouts.length}');

    for (var i = 0; i < workouts.length; i++) {
      final workout = workouts[i];
      print('Workout $i:');
      print('  - Exercise: ${workout['exerciseName']}');
      print('  - Sets: ${workout['sets']}');
      print('  - Reps: ${workout['reps']}');
      print('  - Weight: ${workout['weight']}kg');
      print('  - Duration: ${workout['durationSeconds']}s');
      print('  - Rating: ${workout['rating']}/10');
      print('  - Date: ${workout['timestamp']}');
    }

  } catch (e) {
    print('❌ Failed to fetch workout history: $e');
  }
}
```

---

### **Scenario 6: Get Body Progress History**

```dart
void testGetBodyHistory() async {
  try {
    final userId = 1;

    final bodyRecords = await syncService.getUserBodyHistory(userId);

    print('✅ Body history retrieved! Count: ${bodyRecords.length}');

    for (var record in bodyRecords) {
      print('Body Measurement:');
      print('  - Weight: ${record['weight']}kg');
      print('  - Body Fat: ${record['bodyFat']}%');
      print('  - Muscle: ${record['muscle']}kg');
      print('  - Water: ${record['water']}%');
      print('  - Date: ${record['timestamp']}');
    }

  } catch (e) {
    print('❌ Failed to fetch body history: $e');
  }
}
```

---

### **Scenario 7: Complete User Lifecycle Test**

```dart
void testCompleteUserLifecycle() async {
  try {
    print('\n=== 1. REGISTER USER ===');
    final registerResult = await syncService.registerUser(
      email: 'testuser@example.com',
      password: 'test123',
      firstName: 'Test',
      lastName: 'User',
      phone: '+1234567890',
      age: 25,
      height: 175.0,
      weight: 70.0,
      gender: 'Male',
      fitnessLevel: 'Beginner',
    );
    final userId = registerResult['id'] as int;
    print('✅ User registered with ID: $userId\n');

    print('=== 2. LOG WORKOUT ===');
    await syncService.logWorkout(
      userId: userId,
      exerciseName: 'Bench Press',
      sets: 3,
      reps: 10,
      weight: 80.0,
      durationSeconds: 600,
      rating: 8.0,
    );
    print('✅ Workout logged\n');

    print('=== 3. LOG BODY MEASUREMENT ===');
    await syncService.logBodyProgress(
      userId: userId,
      weight: 70.0,
      bodyFat: 18.0,
      muscle: 35.0,
      water: 60.0,
    );
    print('✅ Body measurement logged\n');

    print('=== 4. UPDATE USER PROFILE ===');
    await syncService.updateUserProfile(
      userId,
      fitnessLevel: 'Intermediate',
      weight: 70.5,
    );
    print('✅ Profile updated\n');

    print('=== 5. GET USER SUMMARY ===');
    final summary = await syncService.getUserAccountSummary(userId);
    print('✅ Summary:');
    print('   Workouts: ${summary['workoutCount']}');
    print('   Body Records: ${summary['bodyRecordCount']}\n');

    print('=== 6. GET WORKOUT HISTORY ===');
    final workouts = await syncService.getUserWorkoutHistory(userId);
    print('✅ Found ${workouts.length} workouts\n');

    print('=== 7. GET BODY HISTORY ===');
    final bodyRecords = await syncService.getUserBodyHistory(userId);
    print('✅ Found ${bodyRecords.length} body records\n');

    print('🎉 ALL TESTS PASSED!');

  } catch (e) {
    print('❌ Test failed: $e');
  }
}
```

---

## 🔍 Testing in Screen Code

### **Example: In a Settings/Profile Screen**

```dart
import 'package:flutter/material.dart';
import 'package:kinedemo/services/data_sync_service.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  const ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _syncService = DataSyncService();
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _syncService.getUserProfile(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: FutureBuilder(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final profile = snapshot.data as Map<String, dynamic>;

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              ListTile(
                title: Text('Name'),
                subtitle: Text('${profile['firstName']} ${profile['lastName']}'),
              ),
              ListTile(
                title: Text('Email'),
                subtitle: Text(profile['email']),
              ),
              ListTile(
                title: Text('Age'),
                subtitle: Text('${profile['age']}'),
              ),
              ListTile(
                title: Text('Height'),
                subtitle: Text('${profile['height']} cm'),
              ),
              ListTile(
                title: Text('Weight'),
                subtitle: Text('${profile['weight']} kg'),
              ),
              ListTile(
                title: Text('Fitness Level'),
                subtitle: Text(profile['fitnessLevel']),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _showUpdateDialog(profile),
                child: Text('Edit Profile'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showUpdateDialog(Map<String, dynamic> profile) {
    // Implement update dialog here
  }
}
```

---

## 📊 Testing Checklist

- [ ] **Register** - Create new user with all fields
- [ ] **Fetch** - Retrieve user by ID and verify all fields
- [ ] **Update** - Change profile info and verify changes
- [ ] **Log Data** - Add workouts and body measurements
- [ ] **History** - Retrieve all workout history
- [ ] **History** - Retrieve all body progress history
- [ ] **Summary** - Get user summary with counts
- [ ] **Error Handling** - Test with invalid IDs
- [ ] **Error Handling** - Test with network offline
- [ ] **Timestamps** - Verify all timestamps are correct

---

## 🐛 Debugging Tips

### Check Console Output

```
✅ User registered successfully: ahmed@example.com
✅ User profile fetched for user 1
✅ User profile updated for user 1
✅ Workout history fetched for user 1 (5 records)
✅ Body history fetched for user 1 (3 records)
```

### Network Issues

If you see errors, verify:

- API is running at `http://10.242.133.106:8000`
- User ID is correct and exists in database
- Request timeouts (10s limit) - check network

### Backend Issues

Check your local database PC:

- Is the API server running?
- Are the endpoints available?
- Did the data get inserted?

---

## 📞 Quick Reference

| Task           | Code                                         |
| -------------- | -------------------------------------------- |
| Register       | `syncService.registerUser(...)`              |
| Get Profile    | `syncService.getUserProfile(userId)`         |
| Update Profile | `syncService.updateUserProfile(userId, ...)` |
| Get Summary    | `syncService.getUserAccountSummary(userId)`  |
| Get Workouts   | `syncService.getUserWorkoutHistory(userId)`  |
| Get Body Data  | `syncService.getUserBodyHistory(userId)`     |
