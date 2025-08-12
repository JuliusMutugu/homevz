/// User role enumeration for HomeVZ app
enum UserRole {
  tenant('tenant', 'Tenant', 'Looking for a place to rent'),
  owner('owner', 'Property Owner', 'I have properties to rent out');

  const UserRole(this.value, this.title, this.description);

  final String value;
  final String title;
  final String description;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.tenant,
    );
  }
}

/// User model with role-based properties
class AppUser {
  final String id;
  final String email;
  final String fullName;
  final String? phoneNumber;
  final UserRole role;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime? updatedAt;
  
  // Role-specific properties
  final Map<String, dynamic>? tenantProfile;
  final Map<String, dynamic>? ownerProfile;

  const AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    this.phoneNumber,
    required this.role,
    this.profileImage,
    required this.createdAt,
    this.updatedAt,
    this.tenantProfile,
    this.ownerProfile,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      role: UserRole.fromString(json['role'] as String),
      profileImage: json['profileImage'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
      tenantProfile: json['tenantProfile'] as Map<String, dynamic>?,
      ownerProfile: json['ownerProfile'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'role': role.value,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'tenantProfile': tenantProfile,
      'ownerProfile': ownerProfile,
    };
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    UserRole? role,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? tenantProfile,
    Map<String, dynamic>? ownerProfile,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tenantProfile: tenantProfile ?? this.tenantProfile,
      ownerProfile: ownerProfile ?? this.ownerProfile,
    );
  }

  bool get isTenant => role == UserRole.tenant;
  bool get isOwner => role == UserRole.owner;
}
