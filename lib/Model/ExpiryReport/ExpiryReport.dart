
import 'ExpiryStore.dart';

class ExpiryInvoice{
  final ExpiryInvoiceInfo info;
  final ExpiryStore store;
  final List<ExpiryInvoiceItem> items;

  const ExpiryInvoice({
    required this.info,
    required this.store,
    required this.items,
  });
}

class ExpiryInvoiceInfo {
  final int expireNo;
  final String currentDate;
  final String currentTime;

  const ExpiryInvoiceInfo({
    required this.expireNo,
    required this.currentDate,
    required this.currentTime,
  });
}

class ExpiryInvoiceItem {
  final String expiryProductId;
  final String description;
  final String Category;
  final double costPrice;
  final String expiryDate;

  const ExpiryInvoiceItem({
    required this.expiryProductId,
    required this.description,
    required this.Category,
    required this.costPrice,
    required this.expiryDate,
  });
}