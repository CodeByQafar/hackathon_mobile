import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// =============================================================================
// I. DATA MODELLƏRİ
// =============================================================================

// Səbətdəki bir elementi təmsil edir
class BasketItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  BasketItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  // JSON-a çevirmə (API-yə göndərmək üçün)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'totalPrice': price * quantity,
    };
  }
}

// 🆕 Çatdırılma ünvan modeli
class DeliveryAddress {
  final String street;
  final String city;
  final String zipCode;
  final String? apartment;
  final String? note;

  DeliveryAddress({
    required this.street,
    required this.city,
    required this.zipCode,
    this.apartment,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'zipCode': zipCode,
      'apartment': apartment,
      'note': note,
    };
  }
}

// 🆕 Ödəniş məlumat modeli
class PaymentInfo {
  final String paymentMethod; // 'cash', 'card', 'online'
  final String? cardNumber;
  final String? cardHolderName;

  PaymentInfo({
    required this.paymentMethod,
    this.cardNumber,
    this.cardHolderName,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod,
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
    };
  }
}

// 🆕 YEKUNSİFARİŞ MODELİ (Database-ə göndəriləcək)
class OrderModel {
  final String orderId;
  final DateTime orderDate;
  final List<BasketItem> items;
  final double totalPrice;
  final int totalItems;
  final DeliveryAddress? deliveryAddress;
  final PaymentInfo? paymentInfo;
  final String status; // 'pending', 'confirmed', 'delivered', etc.
  final String? customerNote;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.items,
    required this.totalPrice,
    required this.totalItems,
    this.deliveryAddress,
    this.paymentInfo,
    this.status = 'pending',
    this.customerNote,
  });

  // JSON formatında göndərmək üçün
  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'orderDate': orderDate.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'totalItems': totalItems,
      'deliveryAddress': deliveryAddress?.toJson(),
      'paymentInfo': paymentInfo?.toJson(),
      'status': status,
      'customerNote': customerNote,
    };
  }
}

// Məhsulun məlumatlarını saxlayır
class ProductModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}

// Məhsul məlumatları (Nümunə Data)
const Map<String, List<ProductModel>> DUMMY_PRODUCTS = {
  'Burger': [
    ProductModel(id: 'B1', name: 'Classic Burger', price: 8.50, imageUrl: 'https://images.unsplash.com/photo-1571091655789-405eb7663aae'),
    ProductModel(id: 'B2', name: 'Cheeseburger', price: 9.75, imageUrl: 'https://images.unsplash.com/photo-1565299624942-4c229f791176'),
  ],
  'Pizza': [
    ProductModel(id: 'P1', name: 'Pepperoni Pizza', price: 15.00, imageUrl: 'https://images.unsplash.com/photo-1628840042767-3490716c5b96'),
    ProductModel(id: 'P2', name: 'Margarita Pizza', price: 12.50, imageUrl: 'https://images.unsplash.com/photo-1593560704563-cd795a62f15e'),
  ],
  'Kabab': [
    ProductModel(id: 'K1', name: 'Lülə Kabab', price: 12.99, imageUrl: 'https://images.unsplash.com/photo-1604908812284-3b1a3e9a3c0b'),
    ProductModel(id: 'K2', name: 'Toyuq Kababı', price: 10.50, imageUrl: 'https://images.unsplash.com/photo-1627958934575-b6d3a82e9b0b'),
  ],
  'Pasta': [
    ProductModel(id: 'PA1', name: 'Spaghetti Bolognese', price: 9.75, imageUrl: 'https://images.unsplash.com/photo-1563379929948-438ac1f44e16'),
    ProductModel(id: 'PA2', name: 'Fettuccine Alfredo', price: 11.20, imageUrl: 'https://images.unsplash.com/photo-1525755662778-989d0524087e'),
  ],
};

// =============================================================================
// II. PROVIDER SİNİFİ (GLOBAL STATE MANAGEMENT)
// =============================================================================

class OrderProvider extends ChangeNotifier {
  // Səbətdəki məhsullar


OrderModel? _lastConfirmedOrder;
  OrderModel? get lastConfirmedOrder => _lastConfirmedOrder;

  // ... (digər sahələr) ...

  // 🆕 Sifarişi API-yə göndərmə (Nümunə)
  @override
  Future<void> submitOrder() async {
    final order = createOrder();
    
    // API çağırışı burada olacaq...
    print('📦 Sifariş göndərilir...');
    
    // 🆕 Uğurlu olduqdan sonra son sifarişi saxla
    _lastConfirmedOrder = order;

    // Səbəti təmizləmək
    _basketItems.clear();
    _deliveryAddress = null;
    _paymentInfo = null;
    _customerNote = null;
    notifyListeners();
  }

  // Səbəti təmizləmək
  void clearBasket() {
    // ... (digər sıfırlamalar) ...
    _lastConfirmedOrder = null; // 🆕 Əlavə et
    notifyListeners();
  }





  final Map<String, BasketItem> _basketItems = {};
  
  // Çatdırılma və ödəniş məlumatları (gələcəkdə əlavə ediləcək)
  DeliveryAddress? _deliveryAddress;
  PaymentInfo? _paymentInfo;
  String? _customerNote;

  // Getters
  Map<String, BasketItem> get basketItems => _basketItems;
  DeliveryAddress? get deliveryAddress => _deliveryAddress;
  PaymentInfo? get paymentInfo => _paymentInfo;
  String? get customerNote => _customerNote;

  int get totalItems {
    int total = 0;
    for (var item in _basketItems.values) {
      total += item.quantity;
    }
    return total;
  }

  double get totalPrice {
    double total = 0;
    for (var item in _basketItems.values) {
      total += item.price * item.quantity;
    }
    return total;
  }

  // Səbətə məhsul əlavə etmə
  void addItem({
    required String id,
    required String name,
    required double price,
  }) {
    if (_basketItems.containsKey(id)) {
      _basketItems[id]!.quantity++;
    } else {
      _basketItems[id] = BasketItem(
        id: id,
        name: name,
        price: price,
      );
    }
    notifyListeners();
  }

  // Quantity artırma
  void increaseQuantity(String id) {
    if (_basketItems.containsKey(id)) {
      _basketItems[id]!.quantity++;
      notifyListeners();
    }
  }

  // Quantity azaltma
  void decreaseQuantity(String id) {
    if (_basketItems.containsKey(id)) {
      if (_basketItems[id]!.quantity > 1) {
        _basketItems[id]!.quantity--;
      } else {
        _basketItems.remove(id);
      }
      notifyListeners();
    }
  }

  // Məhsulu səbətdən silmə
  void removeItem(String id) {
    _basketItems.remove(id);
    notifyListeners();
  }

  // 🆕 Çatdırılma ünvanını əlavə etmə
  void setDeliveryAddress(DeliveryAddress address) {
    _deliveryAddress = address;
    notifyListeners();
  }

  // 🆕 Ödəniş məlumatını əlavə etmə
  void setPaymentInfo(PaymentInfo payment) {
    _paymentInfo = payment;
    notifyListeners();
  }

  // 🆕 Müştəri qeydini əlavə etmə
  void setCustomerNote(String note) {
    _customerNote = note;
    notifyListeners();
  }

  // 🆕 YEKUNSİFARİŞİ HAZIRLAMAQ (Database-ə göndərmək üçün)
  OrderModel createOrder() {
    final orderId = 'ORD_${DateTime.now().millisecondsSinceEpoch}';
    
    return OrderModel(
      orderId: orderId,
      orderDate: DateTime.now(),
      items: _basketItems.values.toList(),
      totalPrice: totalPrice,
      totalItems: totalItems,
      deliveryAddress: _deliveryAddress,
      paymentInfo: _paymentInfo,
      customerNote: _customerNote,
    );
  }

  // 🆕 Sifarişi API-yə göndərmə (Nümunə)

}

// =============================================================================
// III. WIDGETLƏR
// =============================================================================

// Kateqoriya elementini göstərən kart
class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, size: 50)),
              ),
            ),
            Positioned.fill(
              child: Container(
                color: theme.colorScheme.onBackground.withOpacity(0.35),
              ),
            ),
            Center(
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Səbəti göstərən aşağıdakı çubuq
class BasketBar extends StatelessWidget {
  const BasketBar({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final theme = Theme.of(context);

    if (orderProvider.totalItems == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BasketPage()),
        );
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.shopping_basket, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  '${orderProvider.totalItems} items',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              '\$${orderProvider.totalPrice.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Məhsul siyahısındakı bir elementi göstərir
class ProductListItem extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onAddToBasket;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onAddToBasket,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 50),
          ),
        ),
        title: Text(product.name),
        subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          color: theme.colorScheme.primary,
          onPressed: onAddToBasket,
        ),
      ),
    );
  }
}

// Səbətdəki məhsulları göstərmək üçün widget
class BasketItemTile extends StatelessWidget {
  final BasketItem item;

  const BasketItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.read<OrderProvider>();
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(
            'Total: \$${(item.price * item.quantity).toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, size: 20),
              onPressed: () => orderProvider.decreaseQuantity(item.id),
              color: theme.colorScheme.primary,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '${item.quantity}',
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () => orderProvider.increaseQuantity(item.id),
              color: theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// IV. SƏHİFƏLƏR (PAGES)
// =============================================================================

// Kateqoriyaların siyahısını göstərir
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, String>> categories = const [
    {
      'name': 'Burger',
      'image': 'https://images.unsplash.com/photo-1550547660-d9450f859349'
    },
    {
      'name': 'Pizza',
      'image': 'https://images.unsplash.com/photo-1548365328-9f547fb09537'
    },
    {
      'name': 'Kabab',
      'image': 'https://images.unsplash.com/photo-1604908812284-3b1a3e9a3c0b'
    },
    {
      'name': 'Pasta',
      'image': 'https://images.unsplash.com/photo-1525755662778-989d0524087e'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu', style: theme.textTheme.titleMedium),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, orderProvider.totalItems > 0 ? 90 : 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];
          return CategoryCard(
            title: item['name']!,
            imageUrl: item['image']!,
            onTap: () {
              final categoryName = item['name']!;
              final products = DUMMY_PRODUCTS[categoryName] ?? [];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryProductsPage(
                    categoryName: categoryName,
                    products: products,
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: orderProvider.totalItems > 0
          ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: BasketBar(),
            )
          : null,
    );
  }
}

// Seçilmiş kateqoriyanın məhsullarını göstərir
class CategoryProductsPage extends StatelessWidget {
  final String categoryName;
  final List<ProductModel> products;

  const CategoryProductsPage({
    super.key,
    required this.categoryName,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, orderProvider.totalItems > 0 ? 90 : 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductListItem(
            product: product,
            onAddToBasket: () {
              context.read<OrderProvider>().addItem(
                    id: product.id,
                    name: product.name,
                    price: product.price,
                  );
            },
          );
        },
      ),
      bottomNavigationBar: orderProvider.totalItems > 0
          ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: BasketBar(),
            )
          : null,
    );
  }
}

// Səbətin ətraflı məlumatlarını göstərir
class BasketPage extends StatelessWidget {
  const BasketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final theme = Theme.of(context);

    final basketItems = orderProvider.basketItems.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Basket')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: basketItems.length,
              itemBuilder: (context, index) {
                return BasketItemTile(item: basketItems[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Items:', style: theme.textTheme.titleMedium),
                    Text('${orderProvider.totalItems}',
                        style: theme.textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Price:',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${orderProvider.totalPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    // 🆕 Sifarişi təsdiqləyib göndərmə
                    await orderProvider.submitOrder();
                    
                    // Uğurlu mesaj
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Sifariş uğurla yaradıldı!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Create Order',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}