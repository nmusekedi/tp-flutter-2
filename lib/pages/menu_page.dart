import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';
import 'login_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  User? _currentUser;
  String _searchQuery = '';
  Stream<List<Product>> _productsStream = Stream.empty();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _productsStream = _firestoreService.getProducts();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _productsStream = _firestoreService.getProducts();
      } else {
        _productsStream = _firestoreService.searchProducts(query);
      }
    });
  }

  Future<void> _logout() async {
    await _authService.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showAddProductDialog() {
    final _formKey = GlobalKey<FormState>();
    final _codeController = TextEditingController();
    final _nomController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _prixController = TextEditingController();
    final _quantiteController = TextEditingController();
    final _seuilController = TextEditingController();
    String _statut = 'Disponible';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un Produit'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _codeController,
                    decoration: const InputDecoration(
                      labelText: 'Code Produit',
                    ),
                    validator: (value) => value!.isEmpty ? 'Requis' : null,
                  ),
                  TextFormField(
                    controller: _nomController,
                    decoration: const InputDecoration(labelText: 'Nom Produit'),
                    validator: (value) => value!.isEmpty ? 'Requis' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) => value!.isEmpty ? 'Requis' : null,
                  ),
                  TextFormField(
                    controller: _prixController,
                    decoration: const InputDecoration(
                      labelText: 'Prix Unitaire',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Requis' : null,
                  ),
                  TextFormField(
                    controller: _quantiteController,
                    decoration: const InputDecoration(
                      labelText: 'Quantité Stock',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Requis' : null,
                  ),
                  TextFormField(
                    controller: _seuilController,
                    decoration: const InputDecoration(
                      labelText: 'Seuil Alerte',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => value!.isEmpty ? 'Requis' : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _statut,
                    items: ['Disponible', 'Indisponible', 'En rupture']
                        .map(
                          (statut) => DropdownMenuItem(
                            value: statut,
                            child: Text(statut),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => _statut = value!,
                    decoration: const InputDecoration(labelText: 'Statut'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Product newProduct = Product(
                    id: '', // Sera généré par Firestore
                    codeProduit: _codeController.text,
                    nomProduit: _nomController.text,
                    description: _descriptionController.text,
                    prixUnitaire: double.parse(_prixController.text),
                    quantiteStock: int.parse(_quantiteController.text),
                    seuilAlerte: int.parse(_seuilController.text),
                    statut: _statut,
                  );
                  await _firestoreService.addProduct(newProduct);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Produit ajouté')),
                  );
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(String productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text(
            'Êtes-vous sûr de vouloir supprimer ce produit ?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _firestoreService.deleteProduct(productId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Produit supprimé')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.signOutAlt, color: Colors.white),
            onPressed: _logout,
            tooltip: 'Se Déconnecter',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: _updateSearch,
                decoration: InputDecoration(
                  labelText: 'Rechercher un produit',
                  prefixIcon: Icon(Icons.search, color: Colors.blue[700]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[700]!),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: _productsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  }
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const Center(child: Text('Aucun produit trouvé'));
                  }
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          title: Text(
                            product.nomProduit,
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                          subtitle: Text(
                            '${product.description}\nPrix: ${product.prixUnitaire}€ | Stock: ${product.quantiteStock} | Statut: ${product.statut}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  // Modification à implémenter plus tard
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Modification bientôt disponible',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                ),
                                onPressed: () => _confirmDelete(product.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        backgroundColor: Colors.blue[700],
        child: FaIcon(FontAwesomeIcons.plus, color: Colors.white),
      ),
    );
  }
}
