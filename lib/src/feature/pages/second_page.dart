import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ⚠️ QEYD: Bu səhifənin işləməsi üçün OrderModel, ReservationModel, 
// BasketItem və OrderProvider siniflərinin digər fayllardan import edildiyini fərz edirik.
// Aşağıda Provider-in işləməsi üçün minimalist nümunələr verilib.

// =============================================================================
// I. MÖVCUD MODELLƏR (Minimalist Nümunə)
// =============================================================================

class ReservationModel {
  final DateTime date;
  final TimeOfDay time;
  final int tableNumber;
  final String? customerName;
  ReservationModel({required this.date, required this.time, required this.tableNumber, this.customerName});
  Map<String, dynamic> toJson() => {'date': date.toIso8601String(), 'table': tableNumber};
  String get formattedTime => '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
}

class BasketItem {
  final String name;
  final double price;
  int quantity;
  BasketItem({required this.name, required this.price, this.quantity = 1});
}

class OrderModel {
  final String orderId;
  final List<BasketItem> items;
  final double totalPrice;
  final ReservationModel? reservation; // Əsas
  final String paymentStatus; // "paid", "unpaid", "pending"
  final String orderStatus; // "preparing", "ready", "delivered"

  OrderModel({
    required this.orderId,
    required this.items,
    required this.totalPrice,
    this.reservation,
    this.paymentStatus = 'unpaid',
    this.orderStatus = 'pending',
  });
}

class OrderProvider extends ChangeNotifier {
  // Simulyasiya: Ən son sifariş burada saxlanır
  OrderModel? _lastOrder;

  OrderModel? get lastOrder => _lastOrder;

  // Nümunə sifariş yaradır
  void setDummyOrder({bool isPaid = false, bool isReservation = true}) {
    _lastOrder = OrderModel(
      orderId: 'ORD-12345',
      totalPrice: 45.99,
      items: [
        BasketItem(name: 'Classic Burger', price: 8.5, quantity: 2),
        BasketItem(name: 'Cola', price: 2.5, quantity: 4),
        BasketItem(name: 'Fries', price: 4.99, quantity: 1),
      ],
      reservation: isReservation
          ? ReservationModel(
              date: DateTime.now().add(const Duration(days: 1)),
              time: const TimeOfDay(hour: 19, minute: 30),
              tableNumber: 7,
              customerName: 'Əli Əliyev',
            )
          : null,
      paymentStatus: isPaid ? 'paid' : 'unpaid',
      orderStatus: 'preparing',
    );
    notifyListeners();
  }

  // Ödəniş funksiyası (düyməyə basıldıqda)
  Future<void> makePayment() async {
    if (_lastOrder != null && _lastOrder!.paymentStatus == 'unpaid') {
      debugPrint("Ödəniş həyata keçirilir...");
      // Simulyasiya: 1 saniyə sonra statusu "paid" et
      await Future.delayed(const Duration(seconds: 1));
      _lastOrder = OrderModel(
        orderId: _lastOrder!.orderId,
        totalPrice: _lastOrder!.totalPrice,
        items: _lastOrder!.items,
        reservation: _lastOrder!.reservation,
        paymentStatus: 'paid', // ⭐️ Dəyişiklik burada
        orderStatus: _lastOrder!.orderStatus,
      );
      notifyListeners();
      debugPrint("Ödəniş Uğurlu!");
    }
  }
}

// =============================================================================
// II. YENİ SƏHİFƏ: OrderSummaryPage
// =============================================================================

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // OrderProvider-ı dinləyirik ki, status dəyişəndə səhifə yenilənsin
    final orderProvider = context.watch<OrderProvider>();
    final lastOrder = orderProvider.lastOrder;
    final theme = Theme.of(context);

    if (lastOrder == null) {
      // Əgər sifariş yoxdursa, (məsələn, səhifəyə birbaşa gəlibsə)
      return Scaffold(
        appBar: AppBar(title: const Text('Sifariş Xülasəsi')),
        body: const Center(child: Text('Aktiv sifariş tapılmadı.')),
      );
    }

    // Ödənilməmiş vəziyyət
    final needsPayment = lastOrder.paymentStatus == 'unpaid';

    return Scaffold(
      appBar: AppBar(
        title: Text('Sifariş #${lastOrder.orderId}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Sifariş Statusu ---
            _buildStatusCard(
              theme,
              title: 'Sifarişin Vəziyyəti',
              status: lastOrder.orderStatus,
              icon: Icons.delivery_dining,
            ),
            const SizedBox(height: 16),

            // --- 2. Rezervasiya Məlumatı ---
            if (lastOrder.reservation != null)
              _buildReservationDetails(theme, lastOrder.reservation!),
            
            const SizedBox(height: 16),

            // --- 3. Sifariş Edilən Məhsullar ---
            Text('Menyu (${lastOrder.items.length} məhsul)', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: lastOrder.items.length,
                itemBuilder: (context, index) {
                  final item = lastOrder.items[index];
                  return ListTile(
                    title: Text('${item.name} x ${item.quantity}'),
                    trailing: Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            
            const Divider(),
            
            // --- 4. Yekun Məbləğ ---
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Yekun Qiymət:', style: theme.textTheme.titleLarge),
                  Text('\$${lastOrder.totalPrice.toStringAsFixed(2)}', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // --- 5. Ödəniş Düyməsi (Şərtli) ---
            if (needsPayment)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await orderProvider.makePayment();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error, // Qırmızı düymə
                  ),
                  child: Text(
                    'Ödənişi Et (\$${lastOrder.totalPrice.toStringAsFixed(2)})',
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                ),
              )
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '💰 Ödəniş Artıq Tamamlanıb (${lastOrder.paymentStatus.toUpperCase()})',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- Yardımçı Widgetlər ---

  Widget _buildStatusCard(ThemeData theme, {required String title, required String status, required IconData icon}) {
    // Status rəngini təyin edirik
    Color statusColor;
    switch (status) {
      case 'preparing':
        statusColor = Colors.orange;
        break;
      case 'ready':
        statusColor = Colors.blue;
        break;
      case 'delivered':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 30, color: statusColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodySmall),
                Text(
                  status.toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationDetails(ThemeData theme, ReservationModel reservation) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rezervasiya Məlumatları', style: theme.textTheme.titleMedium),
            const Divider(height: 10),
            _buildDetailRow(
              icon: Icons.calendar_month,
              label: 'Tarix:',
              value: '${reservation.date.day}.${reservation.date.month}.${reservation.date.year}',
            ),
            _buildDetailRow(
              icon: Icons.access_time,
              label: 'Saat:',
              value: reservation.formattedTime,
            ),
            _buildDetailRow(
              icon: Icons.table_bar,
              label: 'Masa No:',
              value: 'T${reservation.tableNumber}',
            ),
            if (reservation.customerName != null)
              _buildDetailRow(
                icon: Icons.person,
                label: 'Müştəri:',
                value: reservation.customerName!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          Text(value),
        ],
      ),
    );
  }
}