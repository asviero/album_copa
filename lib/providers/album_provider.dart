import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sticker.dart';

class AlbumProvider with ChangeNotifier {
  final List<Sticker> _stickers = [];
  final SharedPreferences _prefs;

  AlbumProvider(this._prefs) {
    _generateInitialStickers();
    _loadData();
  }

  List<Sticker> get stickers => _stickers;

  int get collectedCount => _stickers.where((s) => s.isCollected).length;

  Map<String, Map<String, List<Sticker>>> get stickersByGroup {
    final map = <String, Map<String, List<Sticker>>>{};

    for (var sticker in _stickers) {
      if (!map.containsKey(sticker.group)) {
        map[sticker.group] = {};
      }
      if (!map[sticker.group]!.containsKey(sticker.team)) {
        map[sticker.group]![sticker.team] = [];
      }
      map[sticker.group]![sticker.team]!.add(sticker);
    }

    final sortedGroups = map.keys.toList()..sort();
    final sortedMap = <String, Map<String, List<Sticker>>>{};

    for (var group in sortedGroups) {
      final teamsMap = map[group]!;
      final originalTeams = teamsMap.keys.toList();
      final sortedTeamsMap = <String, List<Sticker>>{};

      for (var team in originalTeams) {
        sortedTeamsMap[team] = teamsMap[team]!;
      }
      sortedMap[group] = sortedTeamsMap;
    }

    return sortedMap;
  }

  void _generateInitialStickers() {
    final groups = {
      'Grupo A': {
        'MEX': 'México',
        'RSA': 'África do Sul',
        'KOR': 'Coreia do Sul',
        'CZE': 'República Tcheca',
      },
      'Grupo B': {
        'CAN': 'Canadá',
        'BIH': 'Bósnia e Herzegovina',
        'QAT': 'Catar',
        'SUI': 'Suíça',
      },
      'Grupo C': {
        'BRA': 'Brasil',
        'MAR': 'Marrocos',
        'HAI': 'Haiti',
        'SCO': 'Escócia',
      },
      'Grupo D': {
        'USA': 'Estados Unidos',
        'PAR': 'Paraguai',
        'AUS': 'Austrália',
        'TUR': 'Turquia',
      },
      'Grupo E': {
        'GER': 'Alemanha',
        'CUW': 'Curaçao',
        'CIV': 'Costa do Marfim',
        'ECU': 'Equador',
      },
      'Grupo F': {
        'NED': 'Holanda',
        'JPN': 'Japão',
        'SWE': 'Suécia',
        'TUN': 'Tunísia',
      },
      'Grupo G': {
        'BEL': 'Bélgica',
        'EGY': 'Egito',
        'IRN': 'Irã',
        'NZL': 'Nova Zelândia',
      },
      'Grupo H': {
        'ESP': 'Espanha',
        'CPV': 'Cabo Verde',
        'KSA': 'Arábia Saudita',
        'URU': 'Uruguai',
      },
      'Grupo I': {
        'FRA': 'França',
        'SEN': 'Senegal',
        'IRQ': 'Iraque',
        'NOR': 'Noruega',
      },
      'Grupo J': {
        'ARG': 'Argentina',
        'ALG': 'Argélia',
        'AUT': 'Áustria',
        'JOR': 'Jordânia',
      },
      'Grupo K': {
        'POR': 'Portugal',
        'COD': 'RD Congo',
        'UZB': 'Uzbequistão',
        'COL': 'Colômbia',
      },
      'Grupo L': {
        'ENG': 'Inglaterra',
        'CRO': 'Croácia',
        'GHA': 'Gana',
        'PAN': 'Panamá',
      },
    };

    groups.forEach((groupName, teams) {
      teams.forEach((prefix, name) {
        for (int i = 1; i <= 20; i++) {
          String tipo = i == 1
              ? 'Bandeira/Escudo'
              : (i == 2 ? 'Foto do Time' : 'Jogador');
          _stickers.add(
            Sticker(
              code: '$prefix$i',
              team: name,
              type: tipo,
              group: groupName,
            ),
          );
        }
      });
    });

    // Fifa World Cup
    for (int i = 1; i <= 19; i++) {
      _stickers.add(
        Sticker(
          code: 'FWC $i',
          team: 'Fifa World Cup',
          type: 'Especial',
          group: 'Especiais',
        ),
      );
    }

    // Coca-Cola
    for (int i = 1; i <= 14; i++) {
      _stickers.add(
        Sticker(
          code: 'CC$i',
          team: 'Coca-Cola',
          type: 'Especial',
          group: 'Especiais',
        ),
      );
    }
  }

  // --- SALVAMENTO---
  void _loadData() {
    final collectedCodes = _prefs.getStringList('collected_stickers') ?? [];

    for (var sticker in _stickers) {
      if (collectedCodes.contains(sticker.code)) {
        sticker.isCollected = true;
      }
    }
  }

  void _saveData() {
    final collectedCodes = _stickers
        .where((s) => s.isCollected)
        .map((s) => s.code)
        .toList();
    _prefs.setStringList('collected_stickers', collectedCodes);
  }

  void toggleSticker(String code) {
    final sticker = _stickers.firstWhere((s) => s.code == code);
    sticker.isCollected = !sticker.isCollected;
    _saveData();
    notifyListeners();
  }
}
