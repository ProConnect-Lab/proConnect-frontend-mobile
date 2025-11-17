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
