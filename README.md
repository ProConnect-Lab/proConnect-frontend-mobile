# ProConnect Mobile

Application Flutter pour interagir avec l'API Laravel ProConnect.

## Architecture

```
lib/
├── app/
│   ├── exceptions/
│   ├── middlewares/
│   ├── models/
│   ├── modules/
│   ├── providers/ (contrôleurs GetX)
│   ├── repositories/
│   ├── routes/
│   └── services/
└── common/
```

Un espace `lib/app/_owner` reprend la même structure pour y placer du code spécifique au client.

## Configuration

1. Installer Flutter 3.19+.
2. Copier le fichier `.env.example` du backend et exposer l'URL de l'API déployée.
3. Mettre à jour la variable d'environnement au build si besoin :
   ```bash
   flutter run --dart-define=API_BASE_URL=https://votre-api.com/api
   ```

## Installation

```bash
flutter pub get
flutter run
```

L'application (pilotée par GetX pour la navigation et l'état) propose :
- Création de compte (privé ou professionnel)
- Connexion et affichage du profil
- Gestion de plusieurs entreprises
- Création / modification / suppression de publications
- Recherche textuelle des publications

L'application mobile est située dans le dossier frontend/ et utilise :

Framework : Flutter avec GetX pour la gestion d'état
Design : Material Design 3 avec Google Fonts (Inter)
Animations : flutter_animate pour les transitions fluides
Stockage : flutter_secure_storage pour la persistance de session
HTTP : Dio pour les appels API

Fonctionnalités :

✅ Design professionnel avec composants premium (PremiumCard, GradientHeader)
✅ Animations d'entrée et transitions (fade, slide, scale)
✅ Pull-to-refresh sur tous les onglets
✅ Shimmer loading pendant le chargement des données
✅ Édition de profil avec validation
✅ CRUD complet des entreprises avec animations
✅ Publications avec recherche, filtres et bottom sheet de détails
✅ Gestion des erreurs avec snackbars contextuelles
✅ Navigation personnalisée avec bottom bar animée
