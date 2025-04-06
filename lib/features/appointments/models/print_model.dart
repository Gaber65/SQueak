class PaymentHistory {
  final String paymentName;
  final String value;
  final String paymentDate;
  final String type;

  PaymentHistory({
    required this.paymentName,
    required this.value,
    required this.paymentDate,
    required this.type,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
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

class Item {
  final String itemName;
  final String price;
  final String quantity;
  final String total;

  Item({
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
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

class InvoicesModel {
  final String clinicName;
  final String clientPhone;
  final String? visitId;
  final String visitDate;
  final String issueDate;
  final String petName;
  final String species;
  final String document;
  final String code;
  final String? breed;
  final String sex;
  final String? doB;
  final String ownerName;
  final List<Item> items;
  final List<PaymentHistory> paymentHistories;
  final double receiptTotal;
  final double totalAfterVatAndDiscount;
  final double discount;
  final String paid;
  final String debit;
  final String? saCode;
  final double vat;
  final String invoiceCode;
  final bool isNeedSaQrCode;
  final bool isNeedPaymentHistory;
  final bool isNeedItems;
  final String? crNumber;
  final String? crName;
  final String? zatcaNumber;
  final String? checkIn;
  final String? checkOut;
  final String? rest;
  final String? itemsCost;
  final String? boardingCost;
  final String? returnAndExchangePolicy;

  InvoicesModel({
    required this.clinicName,
    required this.clientPhone,
    this.visitId,
    required this.visitDate,
    required this.petName,
    required this.species,
    required this.issueDate,
    required this.document,
    required this.code,
    this.breed,
    required this.sex,
    this.doB,
    this.saCode,
    required this.ownerName,
    required this.items,
    required this.paymentHistories,
    required this.receiptTotal,
    required this.totalAfterVatAndDiscount,
    required this.discount,
    required this.paid,
    required this.debit,
    required this.vat,
    required this.invoiceCode,
    required this.isNeedSaQrCode,
    required this.isNeedPaymentHistory,
    required this.isNeedItems,
    this.crNumber,
    this.crName,
    this.zatcaNumber,
    this.checkIn,
    this.checkOut,
    this.rest,
    this.itemsCost,
    this.boardingCost,
    this.returnAndExchangePolicy,
  });

  factory InvoicesModel.fromJson(Map<String, dynamic> json) {
    String clientPhone = json['clientPhone'].toString() ?? '-';
    if (clientPhone.startsWith('11') ||
        clientPhone.startsWith('10') ||
        clientPhone.startsWith('12') ||
        clientPhone.startsWith('15')) {
      clientPhone = '0' + clientPhone;
    }

    return InvoicesModel(
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
      items: (json['items'] as List<dynamic>)
          .map((item) => Item.fromJson(item as Map<String, dynamic>))
          .toList(),
      paymentHistories: (json['paymentHistories'] as List<dynamic>)
          .map((history) =>
              PaymentHistory.fromJson(history as Map<String, dynamic>))
          .toList(),
      receiptTotal: json['receiptTotal'] ?? null,
      totalAfterVatAndDiscount: json['totalAfterVatAndDiscount'] ?? null,
      discount: json['discount'] ?? null,
      paid: json['paid'] ?? '-',
      debit: json['debit'] ?? '-',
      vat: json['vat'] ?? null,
      invoiceCode: json['invoiceCode'] ?? '-',
      isNeedSaQrCode: json['isNeedSaQrCode'] ?? '-',
      isNeedPaymentHistory: json['isNeedPaymentHistory'] ?? '-',
      isNeedItems: json['isNeedItems'] ?? '-',
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
      'items': items.map((item) => item.toJson()).toList(),
      'paymentHistories':
          paymentHistories.map((history) => history.toJson()).toList(),
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

class PetModel {
  String petName;
  String species;
  String sex;

  PetModel({required this.petName, required this.species, required this.sex});

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      petName: json['petName'] ?? '',
      species: json['species'] ?? '',
      sex: json['sex'] ?? '',
    );
  }
}

class OwnerModel {
  String ownerName;
  String phone;

  OwnerModel({required this.ownerName, required this.phone});

  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      ownerName: json['ownerName'] ?? '-',
      phone: json['phone'] ?? '-',
    );
  }
}
