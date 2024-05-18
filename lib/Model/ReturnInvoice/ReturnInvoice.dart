import 'ReturnStore.dart';
class ReturnInvoice{
  final ReturnInvoiceInfo info;
  final ReturnStore store;
  final List<ReturnInvoiceItem> items;

  const ReturnInvoice({
    required this.info,
    required this.store,
    required this.items,
  });
}

class ReturnInvoiceInfo {
  final String returnId;
  final String returnDate;
  final String returnTime;
  final String againstInvoice;
  final String comment;

  const ReturnInvoiceInfo({
    required this.returnId,
    required this.returnDate,
    required this.returnTime,
    required this.againstInvoice,
    required this.comment,
  });
}

class ReturnInvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;

  const ReturnInvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });
}