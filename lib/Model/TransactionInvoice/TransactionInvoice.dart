import 'package:pharmasage/Model/OrderInvoice/Vendor.dart';

import 'TransactionStore.dart';
class TransactionInvoice{
  final TransactionInvoiceInfo info;
  final TransactionStore store;
  final List<TransactionInvoiceItem> items;

  const TransactionInvoice({
    required this.info,
    required this.store,
    required this.items,
  });
}

class TransactionInvoiceInfo {
  final String transactionId;
  final String transactionDate;
  final String transactionTime;
  final double tax;

  const TransactionInvoiceInfo({
    required this.transactionId,
    required this.transactionDate,
    required this.transactionTime,
    required this.tax,
  });
}

class TransactionInvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;

  const TransactionInvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });
}