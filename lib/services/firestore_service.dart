import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class FirestoreService {
  final CollectionReference _productsCollection = FirebaseFirestore.instance
      .collection('produits');

  // Ajouter un produit
  Future<void> addProduct(Product product) {
    return _productsCollection.add(product.toMap());
  }

  // Lire les produits en temps réel (Stream)
  Stream<List<Product>> getProducts() {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Supprimer un produit
  Future<void> deleteProduct(String productId) {
    return _productsCollection.doc(productId).delete();
  }

  // Rechercher des produits par nom (recherche par préfixe, insensible à la casse approximative)
  Stream<List<Product>> searchProducts(String query) {
    if (query.isEmpty) {
      return getProducts(); // Retourner tous les produits si la requête est vide
    }
    return _productsCollection
        .where('nom_produit', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('nom_produit', isLessThan: query.toLowerCase() + '\uf8ff')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Product.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }
}
