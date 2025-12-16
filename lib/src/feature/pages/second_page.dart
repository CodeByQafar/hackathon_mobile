import 'package:flutter/material.dart';
import 'package:hackathon_mobile/src/core/init/theme/colors.dart';
import 'package:hackathon_mobile/src/feature/pages/home_page.dart';
import 'package:hackathon_mobile/src/feature/pages/third_page.dart';
import 'package:provider/provider.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  Widget _buildTitle(ThemeData theme, String title, Color color) {
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

  Widget _buildReservationDetails(
      ThemeData theme, ReservationModel reservation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          theme,
          "Date:",
          reservation.date.toString().split(' ')[0],
          Icons.calendar_today,
        ),
        _buildDetailRow(
          theme,
          "Time:",
          '${reservation.time.hour}:${reservation.time.minute.toString().padLeft(2, '0')}',
          Icons.access_time,
        ),
        _buildDetailRow(
          theme,
          "Table:",
          '№ ${reservation.tableNumber}',
          Icons.table_chart,
        ),
        if (reservation.numberOfGuests != null)
          _buildDetailRow(
            theme,
            "Guests:",
            '${reservation.numberOfGuests}',
            Icons.group,
          ),
      ],
    );
  }

  Widget _buildOrderDetails(ThemeData theme, OrderModel order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(
          theme,
          "Order ID:",
          order.orderId.substring(4),
          Icons.receipt,
        ),
        _buildDetailRow(
          theme,
          "Total Items:",
          '${order.totalItems}',
          Icons.format_list_numbered,
        ),
        _buildDetailRow(
          theme,
          "Total Price:",
          '\$${order.totalPrice.toStringAsFixed(2)}',
          Icons.payments,
        ),
        _buildDetailRow(
          theme,
          "Status:",
          order.status.toUpperCase(),
          Icons.local_shipping,
        ),
        const SizedBox(height: 8),
        Text(
          "Items (${order.items.length}):",
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        ...order.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4),
            child: Text(
              '${item.quantity}x ${item.name} (\$${(item.price * item.quantity).toStringAsFixed(2)})',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
      ThemeData theme, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.displaySmall!.color,
            ),
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

  // 🔽 PAY ORDER DIALOG
void _showPaymentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      final theme = Theme.of(context);

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: const [
            Icon(Icons.credit_card, size: 28),
            SizedBox(width: 8),
            Text("Card Payment"),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Card Number
              TextField(
                keyboardType: TextInputType.number,
                
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.credit_card),
                  labelText: "Card Number",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Card Holder
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: "Card Holder Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Expiry + CVV
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "MM/YY",
                        prefixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "CVV",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  disabledBackgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                  onPressed: () {Navigator.pop(context);},
                  child:  SizedBox(
                    width: 200,
                    height: 60,
                    child: Center(
                      child: Text(
                        "Pay Order",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onPrimary
                          
                      ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      
      );
    },
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
            Icon(Icons.info_outline,
                size: 50, color: theme.colorScheme.secondary),
            const SizedBox(height: 16),
            Text(
              "No active orders or reservations.",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            Text(
              "Please create an order or reservation first.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Status",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (reservation != null) ...[
                  _buildTitle(
                    theme,
                    "Latest Reservation",
                    theme.colorScheme.primary,
                  ),
                  _buildReservationDetails(theme, reservation),
                  if (order != null) const Divider(height: 30),
                ],
                if (order != null) ...[
                  _buildTitle(
                    theme,
                    "Latest Order",
                    theme.colorScheme.primary,
                  ),
                  _buildOrderDetails(theme, order),
                ],
              ],
            ),
          ),
        ),
      ),

      // 🔽 PAY ORDER BUTTON (AŞAĞIDA)
      bottomNavigationBar: order != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 50,
                child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  disabledBackgroundColor:
                      theme.colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                  onPressed: () => _showPaymentDialog(context),
                  child:  Text(
                    "Pay Order",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                        fontSize: 24,
                  ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
