# 📒 Álbum Copa 2026

Aplicativo mobile para controlar sua coleção de figurinhas da Copa do Mundo 2026.

## Funcionalidades

- Marcar e desmarcar figurinhas como coletadas
- Visualização por grupos e seleções
- Barra de progresso geral e por time
- Indicador de time completo
- Dados salvos localmente no dispositivo

## Tecnologias

- [Flutter](https://flutter.dev/) — framework mobile
- [Provider](https://pub.dev/packages/provider) — gerenciamento de estado
- [Shared Preferences](https://pub.dev/packages/shared_preferences) — persistência local
- [Google Fonts](https://pub.dev/packages/google_fonts) — tipografia (Inter)

## Como rodar

```bash
# Instalar dependências
flutter pub get

# Rodar em modo debug
flutter run

# Gerar APK de produção
flutter build apk --release --split-per-abi
```

## Estrutura

```
lib/
├── main.dart
├── models/
│   └── sticker.dart
├── providers/
│   └── album_provider.dart
├── screens/
│   └── home_screen.dart
└── widgets/
    └── sticker_card.dart
```

## Dados do álbum
 
12 grupos · 48 seleções · 20 figurinhas por time  
1 grupo especial · 19 figurinhas da FIFA World Cup · 14 figurinhas da Coca-Cola
 
**993 figurinhas no total**

---

Desenvolvido por [@asviero](https://github.com/asviero)