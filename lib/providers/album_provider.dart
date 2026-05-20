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
        'RSA': 'África do Sul',
        'KOR': 'Coreia do Sul',
        'MEX': 'México',
        'CZE': 'República Tcheca',
      },
      'Grupo B': {
        'BIH': 'Bósnia e Herzegovina',
        'CAN': 'Canadá',
        'QAT': 'Catar',
        'SUI': 'Suíça',
      },
      'Grupo C': {
        'BRA': 'Brasil',
        'SCO': 'Escócia',
        'HAI': 'Haiti',
        'MAR': 'Marrocos',
      },
      'Grupo D': {
        'AUS': 'Austrália',
        'USA': 'Estados Unidos',
        'PAR': 'Paraguai',
        'TUR': 'Turquia',
      },
      'Grupo E': {
        'GER': 'Alemanha',
        'CIV': 'Costa do Marfim',
        'CUW': 'Curaçao',
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
        'KSA': 'Arábia Saudita',
        'CPV': 'Cabo Verde',
        'ESP': 'Espanha',
        'URU': 'Uruguai',
      },
      'Grupo I': {
        'FRA': 'França',
        'IRQ': 'Iraque',
        'NOR': 'Noruega',
        'SEN': 'Senegal',
      },
      'Grupo J': {
        'ALG': 'Argélia',
        'ARG': 'Argentina',
        'AUT': 'Áustria',
        'JOR': 'Jordânia',
      },
      'Grupo K': {
        'COL': 'Colômbia',
        'POR': 'Portugal',
        'COD': 'RD Congo',
        'UZB': 'Uzbequistão',
      },
      'Grupo L': {
        'CRO': 'Croácia',
        'GHA': 'Gana',
        'ENG': 'Inglaterra',
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
