import 'package:flutter/material.dart';
import 'package:hackathon_mobile/src/feature/pages/home_page.dart';
import 'package:hackathon_mobile/src/feature/pages/third_page.dart';
import 'package:provider/provider.dart';

// Rezervasiya və Sifariş Provider/Model importları buraya daxil edilməlidir

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  // --- Yardımçı Widget-lər ---

  // Başlıqlar üçün köməkçi metod
  Widget _buildTitle(ThemeData theme, String title, Color color) {
    // Burada emoji silindi və rəng parametrlə gəlməyə davam edir, lakin 
    // aşağıda çağırışda Theme rəngləri istifadə olunacaq.
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8),
      child: Text(
        title,
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // Rezervasiya məlumatlarını göstərən metod
  Widget _buildReservationDetails(
      ThemeData theme, ReservationModel reservation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
            theme, "Date:", reservation.date.toString().split(' ')[0], Icons.calendar_today),
        _buildDetailRow(theme, "Time:",
            '${reservation.time.hour}:${reservation.time.minute.toString().padLeft(2, '0')}', Icons.access_time),
        _buildDetailRow(
            theme, "Table:", '№ ${reservation.tableNumber}', Icons.table_chart),
        if (reservation.numberOfGuests != null)
          _buildDetailRow(
              theme, "Guests:", '${reservation.numberOfGuests}', Icons.group),
      ],
    );
  }

  // Sifariş məlumatlarını göstərən metod
  Widget _buildOrderDetails(ThemeData theme, OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
            theme, "Order ID:", order.orderId.substring(4), Icons.receipt),
        _buildDetailRow(theme, "Total Items:", '${order.totalItems}', Icons.format_list_numbered),
        _buildDetailRow(theme, "Total Price:", '\$${order.totalPrice.toStringAsFixed(2)}', Icons.payments),
        _buildDetailRow(theme, "Status:", order.status.toUpperCase(), Icons.local_shipping),
        const SizedBox(height: 8),
        Text(
          "Items (${order.items.length}):",
          // Theme'dən gələn əsas rənglərdən istifadə etmək
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface, // Əsas yazı rəngi
          ),
        ),
        ...order.items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4),
                child: Text(
                  '${item.quantity}x ${item.name} (\$${(item.price * item.quantity).toStringAsFixed(2)})',
                  style: theme.textTheme.bodyMedium, // Theme'dən gələn bodyMedium rəngi
                ),
              ),
            )
            .toList(),
      ],
    );
  }

  // Detalları bir cərgədə göstərən universal metod
  Widget _buildDetailRow(
      ThemeData theme, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon rəngini Theme'in primary rənginə uyğunlaşdırırıq
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.displaySmall!.color,
            ), // Theme'dən gələn bodyLarge rəngi
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
color: theme.textTheme.displaySmall!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resProvider = context.watch<ReservationProvider>();
    final orderProvider = context.watch<OrderProvider>();

    final reservation = resProvider.lastConfirmedReservation;
    final order = orderProvider.lastConfirmedOrder;

    final hasData = reservation != null || order != null;
    final theme = Theme.of(context);

    if (!hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(Icons.info_outline, size: 50, color: theme.colorScheme.secondary), // Rəng dəyişdirildi
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
              
                "No active orders or reservations.",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Text("Please create an order or reservation first.",
              textAlign: TextAlign.center,

                style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    // 2. Məlumat olduqda Card-ı göstər
    return Scaffold(
      appBar: AppBar(
        title:  Text("Your Status" ,style: Theme.of( context).textTheme.titleMedium),
        centerTitle: true,
      
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          // Kartın fon rəngi avtomatik Theme-də təyin olunmuş cardColor/surface rəngini götürəcək
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reservation != null) ...[
                  _buildTitle(
                    theme, 
                    "Latest Reservation", 
                    theme.colorScheme.primary, // Theme'in əsas rəngi
                  ),
                  _buildReservationDetails(theme, reservation),
                  if (order != null) const Divider(height: 30),
                ],
                if (order != null) ...[
                  _buildTitle(
                    theme, 
                    "Latest Order", 
                    theme.colorScheme.primary, // Theme'in əsas rəngi (və ya secondary istifadə edə bilərsiniz)
                  ),
                  _buildOrderDetails(theme, order),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}