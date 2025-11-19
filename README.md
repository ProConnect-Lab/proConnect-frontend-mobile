
# 📱 ProConnect Mobile

Application mobile développée avec **Flutter** permettant d’interagir avec l’API **Laravel ProConnect**.
Elle offre une interface moderne, fluide et intuitive destinée aux utilisateurs professionnels ou privés pour gérer leurs entreprises et leurs publications.

---

## 🚀 Architecture du projet

```
lib/
├── app/
│   ├── exceptions/
│   ├── middlewares/
│   ├── models/
│   ├── modules/         (conteneurs logiques)
│   ├── providers/       (controllers GetX)
│   ├── repositories/    (abstraction API)
│   ├── routes/          (navigation GetX)
│   └── services/        (helpers & gestion état)
└── common/              (widgets & styles partagés)
```

📌 Le dossier `lib/app/_owner` permet d’intégrer des éléments spécifiques à un client.

---

## 🛠️ Prérequis

* **Flutter 3.19+**
* **Dart >= 3.3**
* Accès à l’API Laravel en ligne

---

## 🔧 Configuration

1. Copier l’URL de l’API (backend Laravel).
2. Lancer l’application en spécifiant l’URL :

```bash
flutter run --dart-define=API_BASE_URL=https://votre-api.com/api
```

Ou l’ajouter dans le fichier `.env` Flutter (via Flutter DotEnv si activé).

---

## 📦 Installation & exécution

```bash
flutter pub get
flutter run
```

---

## 📚 Stack technique

| Composant                                    | Utilisation                  |
| -------------------------------------------- | ---------------------------- |
| **Flutter + GetX**                           | Gestion d’état et navigation |
| **Material Design 3 + Google Fonts (Inter)** | UI moderne                   |
| **flutter_secure_storage**                   | Stockage sécurisé session    |
| **Dio**                                      | Requêtes HTTP                |
| **flutter_animate**                          | Animations fluides           |
| **Pull to Refresh / Shimmer**                | UX avancée                   |

---

## ✨ Fonctionnalités principales

✔️ **Authentification complète** (privée ou professionnelle)
✔️ **Affichage et édition du profil utilisateur**
✔️ **Gestion multi-entreprises (CRUD complet)**
✔️ **Création, modification et suppression de publications**
✔️ **Recherche intelligente + filtres avancés**
✔️ **Bottom sheet de détails publication**
✔️ **Pull-to-refresh sur tous les écrans**
✔️ **Animations fluides sur transitions et actions**
✔️ **Système de notification (Snackbars contextuelles)**
✔️ **Barre de navigation animée & gérée dynamiquement**

---

## 🧪 Exemple d’exécution

```bash
flutter run --dart-define=API_BASE_URL=https://proconnect-api.onrender.com/api
```

---

## 🔒 Gestion des erreurs & performance

* Gestion contextuelle via **intercepteurs Dio**
* Exceptions personnalisées
* Fallback UI en cas de perte réseau
* Optimisation des vues avec lazy loading

---

## 📈 Bonnes pratiques respectées

✔ Architecture modulaire
✔ Gestion d’état centralisée
✔ Séparation logique UI / Business / Data
✔ Évolutivité prévue pour ajout d’autres modules

---

## 📎 Auteur

**Urbain BALOGOU**
Développeur Full Stack – Flutter & Laravel
📅 Exercice réalisé dans le cadre d’un test technique


