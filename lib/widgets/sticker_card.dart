import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/sticker.dart';
import '../providers/album_provider.dart';

class StickerCard extends StatelessWidget {
  final Sticker sticker;

  const StickerCard({super.key, required this.sticker});

  @override
  Widget build(BuildContext context) {
    final isCollected = context.select<AlbumProvider, bool>(
      (p) => p.stickers.firstWhere((s) => s.code == sticker.code).isCollected,
    );

    return GestureDetector(
      onTap: () => context.read<AlbumProvider>().toggleSticker(sticker.code),
      child: Container(
        decoration: BoxDecoration(
          color: isCollected
              ? const Color(0xFF007A5E)
              : const Color(0xFF2D2D30),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCollected ? const Color(0xFF00A881) : Colors.white12,
            width: 2,
          ),
          boxShadow: isCollected
              ? const [
                  BoxShadow(
                    color: Color(0x6600A881),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        alignment: Alignment.center,
        child: Text(
          sticker.code,
          style: TextStyle(
            color: isCollected ? Colors.white : Colors.white38,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
