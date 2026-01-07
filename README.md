# TP Flutter Firebase

Une application mobile développée avec Flutter pour la gestion de produits, intégrant Firebase pour l'authentification et la base de données Firestore.

## Description

Ce projet est un TP (Travail Pratique en groupe de 5) de programmation mobile utilisant Flutter et Firebase. L'application permet aux utilisateurs de s'inscrire et se connecter via email/mot de passe ou Google, puis de gérer une liste de produits stockés dans Firestore. Les fonctionnalités incluent l'ajout, la recherche, la liste et la suppression de produits.

## Fonctionnalités

- **Authentification** :
  - Inscription et connexion avec email/mot de passe
  - Connexion avec Google
  - Déconnexion
  - Persistance de la session via SharedPreferences

- **Gestion des Produits** :
  - Ajouter un nouveau produit (code, nom, description, prix, quantité, seuil d'alerte, statut)
  - Lister tous les produits en temps réel
  - Rechercher des produits par nom
  - Supprimer un produit (avec confirmation)

## Prérequis

- Flutter SDK (version 3.10.4 ou supérieure)
- Dart SDK
- Android Studio ou VS Code
- Un compte Google pour Firebase
- Un émulateur Android ou un appareil physique

## Installation

1. Clonez le repository :
   ```bash
   git clone https://github.com/gshimatu/flutter-and-firebase.git
   cd flutter-and-firebase
   ```

2. Installez les dépendances :
   ```bash
   flutter pub get
   ```

3. Configurez Firebase (voir section Configuration ci-dessous).

4. Lancez l'application :
   ```bash
   flutter run
   ```

## Configuration Firebase

1. Créez un projet sur [Firebase Console](https://console.firebase.google.com/).

2. Activez Firestore :
   - Allez dans "Firestore Database" > "Créer une base de données".
   - Choisissez le mode (test ou production).
   - Sélectionnez une région.

3. Activez l'authentification :
   - Allez dans "Authentication" > "Commencer".
   - Activez "Email/Mot de passe".
   - Activez "Google" et configurez avec votre ID client.

4. Pour Android :
   - Téléchargez `google-services.json` depuis les paramètres du projet.
   - Placez-le dans `android/app/`.

5. Initialisez Firebase dans le code (déjà fait dans `main.dart`).

## Utilisation

1. Lancez l'app : L'écran de connexion s'affiche.

2. Inscrivez-vous ou connectez-vous avec email/mot de passe ou Google.

3. Une fois connecté, accédez au menu des produits :
   - Utilisez la barre de recherche pour filtrer les produits.
   - Appuyez sur le bouton flottant (+) pour ajouter un produit.
   - Appuyez sur l'icône de suppression pour supprimer un produit.
   - L'icône d'édition est réservée pour une future mise à jour.

## Structure du Projet

```
lib/
├── main.dart                 # Point d'entrée de l'app
├── firebase_options.dart     # Configuration Firebase
├── models/
│   └── product_model.dart    # Modèle de données Produit
├── pages/
│   ├── login_page.dart       # Page de connexion
│   ├── signup_page.dart      # Page d'inscription
│   └── menu_page.dart        # Page principale de gestion des produits
└── services/
    ├── auth_service.dart     # Service d'authentification
    └── firestore_service.dart # Service Firestore pour les produits
```

## Technologies Utilisées

- **Flutter** : Framework pour le développement mobile
- **Firebase** :
  - Authentication : Gestion des utilisateurs
  - Firestore : Base de données NoSQL
- **Packages Dart** :
  - `firebase_core` : Initialisation Firebase
  - `firebase_auth` : Authentification
  - `cloud_firestore` : Base de données
  - `google_sign_in` : Connexion Google
  - `shared_preferences` : Persistance locale
  - `font_awesome_flutter` : Icônes

## Dépannage

- **Erreurs de compilation** : Assurez-vous que `flutter pub get` a été exécuté.
- **Problèmes Firebase** : Vérifiez `google-services.json` et la configuration dans la console.
- **Authentification Google** : Assurez-vous que les scopes sont corrects et que l'app est enregistrée dans Google Cloud.

## Contributeurs

- [gshimatu](https://github.com/gshimatu) - Développeur
- [Horeb2025](https://github.com/Horeb2025) - Développeur
- [jael785](https://github.com/jael785) - Développeur 
- [niatipaola35-a11y](https://github.com/niatipaola35-a11y) - Développeur
- [nmusekedi](https://github.com/nmusekedi) - Développeur
- [Tovo2003](https://github.com/Tovo2003) - Développeur
- [grdiakiese-ops](https://github.com/diakiese-ops) - Développeur
- [WARDOG-70](https://github.com/WARDOG-70) - Développeur
-


## Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.
