// Replace with this simpler version that doesn't use Freezed
class User {
  final String id;
  final String username;
  final String phoneNumber;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String role;
  final String? profilePicture;
  final bool isPhoneVerified;
  final String? homeAddress;
  final String? workAddress;
  
  User({
    required this.id,
    required this.username,
    required this.phoneNumber,
    this.email,
    this.firstName,
    this.lastName,
    required this.role,
    this.profilePicture,
    this.isPhoneVerified = false,
    this.homeAddress,
    this.workAddress,
  });
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      profilePicture: json['profile_picture'],
      isPhoneVerified: json['is_phone_verified'] ?? false,
      homeAddress: json['home_address'],
      workAddress: json['work_address'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'phone_number': phoneNumber,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'profile_picture': profilePicture,
      'is_phone_verified': isPhoneVerified,
      'home_address': homeAddress,
      'work_address': workAddress,
    };
  }
}