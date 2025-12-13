import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// =============================================================================
// RESERVATION MODEL
// =============================================================================

class ReservationModel {
  final DateTime date;
  final TimeOfDay time;
  final int tableNumber;
  final String? customerName;
  final String? phoneNumber;
  final int? numberOfGuests;

  ReservationModel({
    required this.date,
    required this.time,
    required this.tableNumber,
    this.customerName,
    this.phoneNumber,
    this.numberOfGuests,
  });

  // API üçün JSON formatına çevir
  Map<String, dynamic> toJson() {
    return {
      'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      'table_number': tableNumber,
      'customer_name': customerName,
      'phone_number': phoneNumber,
      'number_of_guests': numberOfGuests,
    };
  }

  @override
  String toString() {
    return 'Reservation(date: ${date.day}.${date.month}.${date.year}, time: ${time.hour}:${time.minute.toString().padLeft(2, '0')}, table: $tableNumber, guests: $numberOfGuests)';
  }
}

// =============================================================================
// RESERVATION PROVIDER
// =============================================================================

class ReservationProvider extends ChangeNotifier {



ReservationModel? _lastConfirmedReservation;
  ReservationModel? get lastConfirmedReservation => _lastConfirmedReservation;

  // ... (digər sahələr) ...

  // Rezervasiyanı təsdiqlə və API-yə göndər
  @override
  Future<void> submitReservation() async {
    if (!isComplete) return;

    final reservation = createReservation()!;
    
    // API çağırışı
    debugPrint('📅 Rezervasiya göndərilir...');

    await Future.delayed(const Duration(milliseconds: 500));
    
    // 🆕 Uğurlu olduqdan sonra son rezervasiyanı saxla
    _lastConfirmedReservation = reservation; 

    // Əlavə məlumatları sıfırla, amma son nəticəni saxla
    _selectedDate = null;
    _selectedTime = null;
    _selectedTable = null;
    _customerName = null;
    _phoneNumber = null;
    _numberOfGuests = null;
    notifyListeners();
  }

  // Qeyd: clearReservation() metodu bu yeni sahəni də sıfırlamalıdır,
  // əgər istifadəçi onu tamamilə ləğv etmək istəsə.
  void clearReservation() {
    // ... (digər sıfırlamalar) ...
    _lastConfirmedReservation = null; // 🆕 Əlavə et
    notifyListeners();
  }

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int? _selectedTable;
  String? _customerName;
  String? _phoneNumber;
  int? _numberOfGuests;

  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;
  int? get selectedTable => _selectedTable;
  String? get customerName => _customerName;
  String? get phoneNumber => _phoneNumber;
  int? get numberOfGuests => _numberOfGuests;

  // Bütün məlumatlar seçilib?
  bool get isComplete => 
      _selectedDate != null && 
      _selectedTime != null && 
      _selectedTable != null;

  // Tarix seç
  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedTime = null; // Tarix dəyişəndə saatı sıfırla
    notifyListeners();
  }

  // Saat seç
  void selectTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  // Masa seç
  void selectTable(int table) {
    _selectedTable = table;
    notifyListeners();
  }

  // Müştəri məlumatlarını əlavə et
  void setCustomerName(String name) {
    _customerName = name;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  void setNumberOfGuests(int guests) {
    _numberOfGuests = guests;
    notifyListeners();
  }

  // Rezervasiya modelini yarat
  ReservationModel? createReservation() {
    if (!isComplete) return null;
    
    return ReservationModel(
      date: _selectedDate!,
      time: _selectedTime!,
      tableNumber: _selectedTable!,
      customerName: _customerName,
      phoneNumber: _phoneNumber,
      numberOfGuests: _numberOfGuests,
    );
  }

  // Rezervasiyanı təsdiqlə və API-yə göndər
  
}

// =============================================================================
// RESERVATION PAGE
// =============================================================================

class ReservationPage extends StatelessWidget {
  const ReservationPage({super.key});

  final List<int> tables = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  Future<void> _pickDate(BuildContext context) async {
    final theme = Theme.of(context);
    final provider = context.read<ReservationProvider>();

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) => Theme(
        data: theme,
        child: child!,
      ),
    );

    if (date != null) {
      provider.selectDate(date);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final theme = Theme.of(context);
    final provider = context.read<ReservationProvider>();

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: theme,
        child: child!,
      ),
    );

    if (time != null) {
      provider.selectTime(time);
    }
  }

  Future<void> _confirmReservation(BuildContext context) async {
    final provider = context.read<ReservationProvider>();
    
    // Rezervasiyanı təsdiqlə və API-yə göndər
    await provider.submitReservation();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reservation created sucsefully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ReservationProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation', style: theme.textTheme.titleMedium),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// DATE
            Text('Select Date', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: _Box(
                text: provider.selectedDate == null
                    ? 'Choose day'
                    : '${provider.selectedDate!.day}.${provider.selectedDate!.month}.${provider.selectedDate!.year}',
              ),
            ),

            const SizedBox(height: 16),

            /// TIME
            Text('Select Time', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            
            if (provider.selectedDate == null)
              Opacity(
                opacity: 0.5,
                child: _Box(text: 'Select date first'),
              )
            else
              GestureDetector(
                onTap: () => _pickTime(context),
                child: _Box(
                  text: provider.selectedTime == null
                      ? 'Choose time'
                      : '${provider.selectedTime!.hour}:${provider.selectedTime!.minute.toString().padLeft(2, '0')}',
                ),
              ),

            const SizedBox(height: 24),

            /// TABLE
            Text('Select Table', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),

            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tables.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final table = tables[index];
                  final isSelected = provider.selectedTable == table;

                  return GestureDetector(
                    onTap: () => provider.selectTable(table),
                    child: Container(
                      width: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Text(
                        'T$table',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            /// CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  disabledBackgroundColor: theme.colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: provider.isComplete
                    ? () => _confirmReservation(context)
                    : null,
                child: Text(
                  'Confirm Reservation',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: provider.isComplete
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface.withOpacity(0.38),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reusable themed box
class _Box extends StatelessWidget {
  final String text;

  const _Box({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        color: theme.cardColor,
      ),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}