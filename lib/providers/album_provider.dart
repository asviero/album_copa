import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sticker.dart';

class AlbumProvider with ChangeNotifier {
  final List<Sticker> _stickers = [];
  SharedPreferences? _prefs;

  AlbumProvider() {
    _generateInitialStickers();
    _loadData();
  }

  List<Sticker> get stickers => _stickers;

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
      final sortedTeams = teamsMap.keys.toList()..sort();
      final sortedTeamsMap = <String, List<Sticker>>{};

      for (var team in sortedTeams) {
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
        'COD': 'RD Congo',
        'POR': 'Portugal',
        'UZB': 'Uzbequistão',
      },
      'Grupo L': {
        'CRO': 'Croácia',
        'ENG': 'Inglaterra',
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
  }

  // --- LÓGICA DE SALVAMENTO ---
  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    // Lista de códigos salvos
    final collectedCodes = _prefs?.getStringList('collected_stickers') ?? [];

    for (var sticker in _stickers) {
      if (collectedCodes.contains(sticker.code)) {
        sticker.isCollected = true;
      }
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    if (_prefs == null) return;
    final collectedCodes = _stickers
        .where((s) => s.isCollected)
        .map((s) => s.code)
        .toList();
    await _prefs?.setStringList('collected_stickers', collectedCodes);
  }

  void toggleSticker(String code) {
    final sticker = _stickers.firstWhere((s) => s.code == code);
    sticker.isCollected = !sticker.isCollected;
    _saveData();
    notifyListeners();
  }
}
