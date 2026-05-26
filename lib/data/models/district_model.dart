import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:suebsaiyai/domain/entities/district_entity.dart';

class DistrictModel {
  const DistrictModel({
    required this.id,
    required this.name,
    required this.province,
    required this.region,
    this.description,
    this.coverImageUrl,
    this.storyCount = 0,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String name;
  final String province;
  final String region;
  final String? description;
  final String? coverImageUrl;
  final int storyCount;
  final double? latitude;
  final double? longitude;

  factory DistrictModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final geo = data['coordinates'] as Map<String, dynamic>?;
    return DistrictModel(
      id: doc.id,
      name: data['name'] as String,
      province: data['province'] as String? ?? '',
      region: data['region'] as String? ?? '',
      description: data['description'] as String?,
      coverImageUrl: data['coverImageUrl'] as String?,
      storyCount: data['storyCount'] as int? ?? 0,
      latitude: (geo?['latitude'] as num?)?.toDouble(),
      longitude: (geo?['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'name': name,
        'province': province,
        'region': region,
        if (description != null) 'description': description,
        if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
        'storyCount': storyCount,
        if (latitude != null && longitude != null)
          'coordinates': {'latitude': latitude, 'longitude': longitude},
      };

  DistrictEntity toEntity() => DistrictEntity(
        id: id,
        name: name,
        province: province,
        region: region,
        description: description,
        coverImageUrl: coverImageUrl,
        storyCount: storyCount,
        coordinates: latitude != null && longitude != null
            ? GeoCoordinates(latitude: latitude!, longitude: longitude!)
            : null,
      );
}
