import 'package:equatable/equatable.dart';

class CatBreed extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? temperament;
  final String? origin;
  final String? lifeSpan;
  final int? intelligence;
  final String? wikipediaUrl;
  final String? imageUrl;
  final Weight? weight;
  final String? vetstreetUrl;
  final String? countryCodes;
  final String? countryCode;
  final int? indoor;
  final String? altNames;
  final int? adaptability;
  final int? affectionLevel;
  final int? childFriendly;
  final int? dogFriendly;
  final int? energyLevel;
  final int? grooming;
  final int? healthIssues;
  final int? sheddingLevel;
  final int? socialNeeds;
  final int? strangerFriendly;
  final int? vocalisation;
  final int? experimental;
  final int? hairless;
  final int? natural;
  final int? rare;
  final int? rex;
  final int? suppressedTail;
  final int? shortLegs;
  final int? hypoallergenic;
  final String? referenceImageId;

  const CatBreed({
    required this.id,
    required this.name,
    this.description,
    this.temperament,
    this.origin,
    this.lifeSpan,
    this.intelligence,
    this.wikipediaUrl,
    this.imageUrl,
    this.weight,
    this.vetstreetUrl,
    this.countryCodes,
    this.countryCode,
    this.indoor,
    this.altNames,
    this.adaptability,
    this.affectionLevel,
    this.childFriendly,
    this.dogFriendly,
    this.energyLevel,
    this.grooming,
    this.healthIssues,
    this.sheddingLevel,
    this.socialNeeds,
    this.strangerFriendly,
    this.vocalisation,
    this.experimental,
    this.hairless,
    this.natural,
    this.rare,
    this.rex,
    this.suppressedTail,
    this.shortLegs,
    this.hypoallergenic,
    this.referenceImageId,
  });

  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      temperament: json['temperament'],
      origin: json['origin'],
      lifeSpan: json['life_span'],
      intelligence: json['intelligence'],
      wikipediaUrl: json['wikipedia_url'],
      imageUrl: json['image']?['url'],
      weight: json['weight'] != null ? Weight.fromJson(json['weight']) : null,
      vetstreetUrl: json['vetstreet_url'],
      countryCodes: json['country_codes'],
      countryCode: json['country_code'],
      indoor: json['indoor'],
      altNames: json['alt_names'],
      adaptability: json['adaptability'],
      affectionLevel: json['affection_level'],
      childFriendly: json['child_friendly'],
      dogFriendly: json['dog_friendly'],
      energyLevel: json['energy_level'],
      grooming: json['grooming'],
      healthIssues: json['health_issues'],
      sheddingLevel: json['shedding_level'],
      socialNeeds: json['social_needs'],
      strangerFriendly: json['stranger_friendly'],
      vocalisation: json['vocalisation'],
      experimental: json['experimental'],
      hairless: json['hairless'],
      natural: json['natural'],
      rare: json['rare'],
      rex: json['rex'],
      suppressedTail: json['suppressed_tail'],
      shortLegs: json['short_legs'],
      hypoallergenic: json['hypoallergenic'],
      referenceImageId: json['reference_image_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'temperament': temperament,
      'origin': origin,
      'life_span': lifeSpan,
      'intelligence': intelligence,
      'wikipedia_url': wikipediaUrl,
      'image': imageUrl != null ? {'url': imageUrl} : null,
      'weight': weight?.toJson(),
      'vetstreet_url': vetstreetUrl,
      'country_codes': countryCodes,
      'country_code': countryCode,
      'indoor': indoor,
      'alt_names': altNames,
      'adaptability': adaptability,
      'affection_level': affectionLevel,
      'child_friendly': childFriendly,
      'dog_friendly': dogFriendly,
      'energy_level': energyLevel,
      'grooming': grooming,
      'health_issues': healthIssues,
      'shedding_level': sheddingLevel,
      'social_needs': socialNeeds,
      'stranger_friendly': strangerFriendly,
      'vocalisation': vocalisation,
      'experimental': experimental,
      'hairless': hairless,
      'natural': natural,
      'rare': rare,
      'rex': rex,
      'suppressed_tail': suppressedTail,
      'short_legs': shortLegs,
      'hypoallergenic': hypoallergenic,
      'reference_image_id': referenceImageId,
    };
  }

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'CatBreed(id: $id, name: $name)';
  }
}

class Weight extends Equatable {
  final String imperial;
  final String metric;

  const Weight({
    required this.imperial,
    required this.metric,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      imperial: json['imperial'] ?? '',
      metric: json['metric'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imperial': imperial,
      'metric': metric,
    };
  }

  @override
  List<Object?> get props => [imperial, metric];
}
