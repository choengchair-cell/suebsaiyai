import 'package:equatable/equatable.dart';

class DistrictEntity extends Equatable {
  const DistrictEntity({
    required this.id,
    required this.name,
    required this.province,
    required this.region,
    this.description,
    this.coverImageUrl,
    this.storyCount = 0,
    this.coordinates,
  });

  final String id;
  final String name;
  final String province;
  final String region;
  final String? description;
  final String? coverImageUrl;
  final int storyCount;
  final GeoCoordinates? coordinates;

  @override
  List<Object?> get props => [id, name, province, region];
}

class GeoCoordinates extends Equatable {
  const GeoCoordinates({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [latitude, longitude];
}
