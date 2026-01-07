class Product {
  String id; 
  String codeProduit;
  String nomProduit;
  String description;
  double prixUnitaire;
  int quantiteStock;
  int seuilAlerte;
  String statut;

  Product({
    required this.id,
    required this.codeProduit,
    required this.nomProduit,
    required this.description,
    required this.prixUnitaire,
    required this.quantiteStock,
    required this.seuilAlerte,
    required this.statut,
  });

  // Transformer un document Firestore en objet Product
  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      codeProduit: data['code_produit'] ?? '',
      nomProduit: data['nom_produit'] ?? '',
      description: data['description'] ?? '',
      prixUnitaire: (data['prix_unitaire'] ?? 0).toDouble(),
      quantiteStock: data['quantite_stock'] ?? 0,
      seuilAlerte: data['seuil_alerte'] ?? 0,
      statut: data['statut'] ?? 'Disponible',
    );
  }

  // Transformer notre objet en Map pour l'envoyer à Firestore
  Map<String, dynamic> toMap() {
    return {
      'code_produit': codeProduit,
      'nom_produit': nomProduit,
      'description': description,
      'prix_unitaire': prixUnitaire,
      'quantite_stock': quantiteStock,
      'seuil_alerte': seuilAlerte,
      'statut': statut,
    };
  }
}