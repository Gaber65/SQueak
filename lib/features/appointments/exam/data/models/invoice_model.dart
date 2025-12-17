import '../../domain/entities/invoice.dart';

class InvoiceModel extends Invoice {
  const InvoiceModel({
    required super.clinicName,
    required super.clientPhone,
    super.visitId,
    required super.visitDate,
    required super.petName,
    required super.species,
    required super.issueDate,
    required super.document,
    required super.code,
    super.breed,
    required super.sex,
    super.doB,
    super.saCode,
    required super.ownerName,
    required super.items,
    required super.packageOffers, // Added package offers
    required super.paymentHistories,
    required super.receiptTotal,
    required super.totalAfterVatAndDiscount,
    required super.discount,
    required super.paid,
    required super.debit,
    required super.vat,
    required super.invoiceCode,
    required super.isNeedSaQrCode,
    required super.isNeedPaymentHistory,
    required super.isNeedItems,
    super.crNumber,
    super.crName,
    super.zatcaNumber,
    super.checkIn,
    super.checkOut,
    super.rest,
    super.itemsCost,
    super.boardingCost,
    super.returnAndExchangePolicy,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    String clientPhone = json['clientPhone'].toString();
    if (clientPhone.startsWith('11') ||
        clientPhone.startsWith('10') ||
        clientPhone.startsWith('12') ||
        clientPhone.startsWith('15')) {
      clientPhone = '0$clientPhone';
    }

    return InvoiceModel(
      clinicName: json['clinicName'] ?? '-',
      clientPhone: clientPhone,
      saCode: json['saCode'] ?? '-',
      visitId: json['visitId'] ?? '-',
      visitDate: json['visitDate'] ?? '-',
      petName: json['petName'] ?? '-',
      species: json['species'] ?? '',
      document: json['document'] ?? '-',
      code: json['code'] ?? '-',
      breed: json['breed'] ?? '-',
      sex: json['sex'] ?? '-',
      doB: json['doB'] ?? '-',
      ownerName: json['ownerName'] ?? '-',
      items:
          (json['items'] as List<dynamic>? ?? [])
              .map((item) => ItemModel.fromJson(item as Map<String, dynamic>))
              .toList(),
      packageOffers:
          (json['packageOffer'] as List<dynamic>? ?? [])
              .map(
                (offer) =>
                    PackageOfferModel.fromJson(offer as Map<String, dynamic>),
              )
              .toList(),
      paymentHistories:
          (json['paymentHistories'] as List<dynamic>? ?? [])
              .map(
                (history) => PaymentHistoryModel.fromJson(
                  history as Map<String, dynamic>,
                ),
              )
              .toList(),
      receiptTotal: json['receiptTotal'] ?? 0.0,
      totalAfterVatAndDiscount: json['totalAfterVatAndDiscount'] ?? 0.0,
      discount: json['discount'] ?? 0.0,
      paid: json['paid'] ?? '-',
      debit: json['debit'] ?? '-',
      vat: json['vat'] ?? 0.0,
      invoiceCode: json['invoiceCode'] ?? '-',
      isNeedSaQrCode: json['isNeedSaQrCode'] ?? false,
      isNeedPaymentHistory: json['isNeedPaymentHistory'] ?? false,
      isNeedItems: json['isNeedItems'] ?? false,
      crNumber: json['crNumber'] ?? '-',
      crName: json['crName'] ?? '-',
      zatcaNumber: json['zatcaNumber'] ?? '-',
      checkIn: json['checkIn'] ?? '-',
      checkOut: json['checkOut'] ?? '-',
      rest: json['rest'] ?? '-',
      itemsCost: json['itemsCost'] ?? '-',
      issueDate: json['issueDate'] ?? '-',
      boardingCost: json['boardingCost'] ?? '-',
      returnAndExchangePolicy: json['returnAndExchangePolicy'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clinicName': clinicName,
      'clientPhone': clientPhone,
      'visitId': visitId,
      'visitDate': visitDate,
      'petName': petName,
      'species': species,
      'document': document,
      'code': code,
      'breed': breed,
      'sex': sex,
      'doB': doB,
      'ownerName': ownerName,
      'items': (items as List<ItemModel>).map((item) => item.toJson()).toList(),
      'packageOffer':
          (packageOffers as List<PackageOfferModel>)
              .map((offer) => offer.toJson())
              .toList(),
      'paymentHistories':
          (paymentHistories as List<PaymentHistoryModel>)
              .map((history) => history.toJson())
              .toList(),
      'receiptTotal': receiptTotal,
      'totalAfterVatAndDiscount': totalAfterVatAndDiscount,
      'discount': discount,
      'paid': paid,
      'debit': debit,
      'vat': vat,
      'invoiceCode': invoiceCode,
      'isNeedSaQrCode': isNeedSaQrCode,
      'isNeedPaymentHistory': isNeedPaymentHistory,
      'isNeedItems': isNeedItems,
      'crNumber': crNumber,
      'crName': crName,
      'zatcaNumber': zatcaNumber,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'rest': rest,
      'itemsCost': itemsCost,
      'boardingCost': boardingCost,
      'returnAndExchangePolicy': returnAndExchangePolicy,
    };
  }
}

class ItemModel extends ItemEntity {
  const ItemModel({
    required super.itemName,
    required super.price,
    required super.quantity,
    required super.total,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemName: json['itemName'] ?? '-',
      price: json['price'] ?? '-',
      quantity: json['quantity'] ?? '-',
      total: json['total'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }
}

class PackageOfferItemModel extends PackageOfferItemEntity {
  const PackageOfferItemModel({
    required super.itemName,
    required super.price,
    required super.quantity,
    required super.total,
  });

  factory PackageOfferItemModel.fromJson(Map<String, dynamic> json) {
    return PackageOfferItemModel(
      itemName: json['itemName'] ?? '-',
      price: json['price'] ?? '-',
      quantity: json['quantity'] ?? '-',
      total: json['total'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }
}

class PackageOfferModel extends PackageOfferEntity {
  const PackageOfferModel({
    required super.packageName,
    required super.packageQuantity,
    required super.packageItems,
  });

  factory PackageOfferModel.fromJson(Map<String, dynamic> json) {
    return PackageOfferModel(
      packageName: json['packageName'] ?? '-',
      packageQuantity: json['packageQuantity'] ?? 0,
      packageItems:
          (json['packageItem'] as List<dynamic>? ?? [])
              .map(
                (item) => PackageOfferItemModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'packageQuantity': packageQuantity,
      'packageItem':
          (packageItems as List<PackageOfferItemModel>)
              .map((item) => item.toJson())
              .toList(),
    };
  }
}

class PaymentHistoryModel extends PaymentHistoryEntity {
  const PaymentHistoryModel({
    required super.paymentName,
    required super.value,
    required super.paymentDate,
    required super.type,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      paymentName: json['paymentName'] ?? '-',
      value: json['value'] ?? '-',
      paymentDate: json['paymentDate'] ?? '-',
      type: json['type'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentName': paymentName,
      'value': value,
      'paymentDate': paymentDate,
      'type': type,
    };
  }
}

class PetPrintModel extends PetPrint {
  const PetPrintModel({
    required super.petName,
    required super.species,
    required super.sex,
  });

  factory PetPrintModel.fromJson(Map<String, dynamic> json) {
    return PetPrintModel(
      petName: json['petName'] ?? '',
      species: json['species'] ?? '',
      sex: json['sex'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'petName': petName, 'species': species, 'sex': sex};
  }
}

class OwnerPrintModel extends OwnerPrint {
  const OwnerPrintModel({required super.ownerName, required super.phone});

  factory OwnerPrintModel.fromJson(Map<String, dynamic> json) {
    return OwnerPrintModel(
      ownerName: json['ownerName'] ?? '-',
      phone: json['phone'] ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {'ownerName': ownerName, 'phone': phone};
  }
}
