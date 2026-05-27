import 'package:dartz/dartz.dart';
import 'package:suebsaiyai/core/errors/failure.dart';
import 'package:suebsaiyai/domain/entities/cultural_term_entity.dart';
import 'package:suebsaiyai/domain/entities/taxonomy_entity.dart';

abstract class TaxonomyRepository {
  Future<Either<Failure, List<TaxonomyEntity>>> getAllTaxonomies();
  Future<Either<Failure, TaxonomyEntity>> createTaxonomy(TaxonomyEntity taxonomy);
  Future<Either<Failure, CulturalTermEntity>> createCulturalTerm(CulturalTermEntity term);
  Future<Either<Failure, List<CulturalTermEntity>>> getCulturalTermsByDistrict(String districtId);
  Future<Either<Failure, List<CulturalTermEntity>>> searchCulturalTerms(String query);
  Stream<List<TaxonomyEntity>> watchTaxonomies();
}
