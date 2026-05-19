import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sticker.dart';

class AlbumProvider with ChangeNotifier {
  final List<Sticker> _stickers = [];
  SharedPreferences? _prefs;
  Timer? _saveDebounce;
  Map<String, Map<String, List<Sticker>>>? _stickersByGroupCache;

  AlbumProvider() {
    _generateInitialStickers();
    _loadData();
  }

  List<Sticker> get stickers => _stickers;

  int get collectedCount => _stickers.where((s) => s.isCollected).length;

  Map<String, Map<String, List<Sticker>>> get stickersByGroup {
    if (_stickersByGroupCache != null) return _stickersByGroupCache!;

    final map = <String, Map<String, List<Sticker>>>{};
    for (var sticker in _stickers) {
      (map[sticker.group] ??= {})[sticker.team] ??= [];
      map[sticker.group]![sticker.team]!.add(sticker);
    }
    final sortedKeys = map.keys.toList()..sort();
    _stickersByGroupCache = {for (var k in sortedKeys) k: map[k]!};
    return _stickersByGroupCache!;
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
          final tipo = i == 1
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

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    final collectedCodes = _prefs?.getStringList('collected_stickers') ?? [];
    for (var sticker in _stickers) {
      if (collectedCodes.contains(sticker.code)) sticker.isCollected = true;
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    if (_prefs == null) return;
    final codes = _stickers
        .where((s) => s.isCollected)
        .map((s) => s.code)
        .toList();
    await _prefs!.setStringList('collected_stickers', codes);
  }

  void toggleSticker(String code) {
    final sticker = _stickers.firstWhere((s) => s.code == code);
    sticker.isCollected = !sticker.isCollected;
    notifyListeners();
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), _saveData);
  }

  @override
  void dispose() {
    _saveDebounce?.cancel();
    super.dispose();
  }
}
