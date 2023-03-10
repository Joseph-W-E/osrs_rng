import 'package:flutter/foundation.dart';

class Activity {
  const Activity(this.name, this.weight);

  Activity.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        weight = json['weight'];

  final String name;
  final int weight;

  String? get assetPath {
    const assetMap = {
      'osrs_nightmare.webp': {'nm', 'nightmare', 'phosani', 'pnm'},
      'osrs_olm.webp': {'cox', 'chambers', 'olm', 'cms'},
      'osrs_tempoross.webp': {'tempoross'},
      'osrs_verzik.webp': {'tob', 'theater', 'theatre', 'verzik'},
      'osrs_wardens.webp': {'toa', 'tombs', 'amascut', 'warden'},
      'osrs_wintertodt.png': {'wt', 'wintertodt'},
      'osrs_zalcano.webp': {'zalcano'},
      'osrs_nex.webp': {'nex'},
    };

    for (final assetPath in assetMap.keys) {
      final keywords = assetMap[assetPath] ?? {};
      if (keywords.contains(name.toLowerCase())) {
        if (kDebugMode) {
          return assetPath;
        }
        return 'assets/$assetPath';
      }
    }

    return null;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'weight': weight,
      };
}
