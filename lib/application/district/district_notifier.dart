import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suebsaiyai/application/providers/repository_providers.dart';
import 'package:suebsaiyai/domain/entities/district_entity.dart';

final allDistrictsProvider = FutureProvider.autoDispose<List<DistrictEntity>>((ref) async {
  final repo = ref.watch(districtRepositoryProvider);
  final result = await repo.getAllDistricts();
  return result.fold((f) => throw Exception(f.message), (districts) => districts);
});

final districtDetailProvider = FutureProvider.autoDispose.family<DistrictEntity, String>((ref, id) async {
  final repo = ref.watch(districtRepositoryProvider);
  final result = await repo.getDistrict(id);
  return result.fold((f) => throw Exception(f.message), (d) => d);
});
