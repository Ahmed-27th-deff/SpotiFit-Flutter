import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kinedemo/models/user_model.dart';
import 'package:kinedemo/repositories/user_repository.dart';
import 'package:kinedemo/services/api_service.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final UserRepository? _userRepository;

  AuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    UserRepository? userRepository,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _userRepository = userRepository ?? UserRepository(ApiService());

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign up with email and password (basic signup - onboarding required)
  Future<UserModel> signUpBasic({
    required String email,
    required String password,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      // Create minimal user model
      final userModel = UserModel(
        uid: user.uid,
        firstName: '',
        lastName: '',
        email: email,
        password: password,
        gender: '',
        dateOfBirth: null,
        height: 0,
        weight: 0,
        fitnessLevel: '',
        fitnessGoals: [],
      );

      // Save minimal user data to Firestore
      await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

      // Store password temporarily for backend registration during onboarding
      await _firestore.collection('users').doc(user.uid).update({
        'tempPassword': password,
        'onboardingCompleted': false,
      });

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign up with email and password (full signup - deprecated, use signUpBasic + completeOnboarding)
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime dateOfBirth,
    required double height,
    required double weight,
    required String fitnessLevel,
    required List<String> fitnessGoals,
  }) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to create user');
      }

      // Create user model
      final userModel = UserModel(
        uid: user.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        gender: gender,
        dateOfBirth: dateOfBirth,
        height: height,
        weight: weight,
        fitnessLevel: fitnessLevel,
        fitnessGoals: fitnessGoals,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set(userModel.toJson());

      // Update display name
      final fullName = '$firstName $lastName';
      await user.updateDisplayName(fullName);

      // Store additional data for later use in onboarding
      await _firestore.collection('users').doc(user.uid).update({
        'tempPassword': password, // Store temporarily for backend API registration
      });

      // Register user in backend database immediately
      try {
        final backendResponse = await _userRepository?.registerUser(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          gender: gender,
          dateOfBirth: dateOfBirth,
          height: height,
          weight: weight,
          fitnessLevel: fitnessLevel,
          fitnessGoals: fitnessGoals,
        );
        
        print('✅ User registered in backend database: $email');
        print('Backend response: $backendResponse');
        
        // Store backend user ID and registration flag
        final backendUserId = backendResponse?['id'] as int?;
        await _firestore.collection('users').doc(user.uid).update({
          'backendRegistered': true,
          'backendUserId': backendUserId,
        });
      } catch (apiError) {
        // Log API error but don't fail the signup
        print('⚠️ Failed to register in backend database: $apiError');
        await _firestore.collection('users').doc(user.uid).update({
          'backendRegistered': false,
        });
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Failed to sign in');
      }

      // Get user data from Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      return UserModel.fromJson(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      
      if (!userDoc.exists) {
        return null;
      }

      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  // Complete onboarding
  Future<UserModel> completeOnboarding({
    required String uid,
    required String firstName,
    required String lastName,
    required String gender,
    required DateTime dateOfBirth,
    required double height,
    required double weight,
    required String fitnessLevel,
    required List<String> fitnessGoals,
  }) async {
    try {
      // Update Firebase Firestore
      await _firestore.collection('users').doc(uid).update({
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'height': height,
        'weight': weight,
        'fitness_level': fitnessLevel,
        'fitness_goals': fitnessGoals,
        'onboardingCompleted': true,
      });

      // Update display name
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final fullName = '$firstName $lastName';
        await user.updateDisplayName(fullName);
      }

      // Get updated user data from Firestore
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      final userData = userDoc.data()!;
      final userModel = UserModel.fromJson(userData);

      // Update user profile in backend API with onboarding data
      try {
        // Check if user was already registered in backend
        final backendRegistered = userData['backendRegistered'] as bool? ?? false;
        final backendUserId = userData['backendUserId'] as int?;

        if (backendRegistered && backendUserId != null) {
          // Update existing user profile in backend
          print('✅ Updating user profile in backend database (ID: $backendUserId)');
          
          await _userRepository?.updateUserProfile(
            backendUserId,
            firstName: firstName,
            lastName: lastName,
            gender: gender,
            dateOfBirth: dateOfBirth,
            height: height,
            weight: weight,
            fitnessLevel: fitnessLevel,
            fitnessGoals: fitnessGoals,
          );
          
          print('✅ User profile updated in backend database');
        } else {
          // User wasn't registered in backend during signup, register now
          final password = userData['tempPassword'] as String? ?? '';
          
          final backendResponse = await _userRepository?.registerUser(
            email: userModel.email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            gender: gender,
            dateOfBirth: dateOfBirth,
            height: height,
            weight: weight,
            fitnessLevel: fitnessLevel,
            fitnessGoals: fitnessGoals,
          );
          
          // Store backend user ID
          final newBackendUserId = backendResponse?['id'] as int?;
          await _firestore.collection('users').doc(uid).update({
            'backendRegistered': true,
            'backendUserId': newBackendUserId,
          });
          
          print('✅ User registered in backend database during onboarding');
        }
        
        // Remove temporary data after successful update
        await _firestore.collection('users').doc(uid).update({
          'tempPassword': FieldValue.delete(),
        });
      } catch (apiError) {
        // Log API error but don't fail the onboarding
        print('⚠️ Failed to sync with backend API: $apiError');
      }

      return userModel;
    } catch (e) {
      throw Exception('Failed to complete onboarding: ${e.toString()}');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed: ${e.message ?? 'Unknown error'}';
    }
  }
}
