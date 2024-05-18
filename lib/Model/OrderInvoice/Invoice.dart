import 'package:pharmasage/Model/OrderInvoice/Vendor.dart';
import 'Store.dart';
class Invoice{
  final InvoiceInfo info;
  final Supplier supplier;
  final Store store;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.store,
    required this.items,
  });
}

class InvoiceInfo {
  final String orderId;
  final String orderStatus;
  final String orderDate;
  final String orderTime;
  final double delivery;

  const InvoiceInfo({
    required this.orderId,
    required this.orderStatus,
    required this.orderDate,
    required this.orderTime,
    required this.delivery
  });
}

class InvoiceItem {
  final String description;
  final int quantity;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });
}