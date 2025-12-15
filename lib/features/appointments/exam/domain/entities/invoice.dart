import 'package:equatable/equatable.dart';

class Invoice extends Equatable {
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
  final List<ItemEntity> items;
  final List<PackageOfferEntity> packageOffers; // Added package offers
  final List<PaymentHistoryEntity> paymentHistories;
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

  const Invoice({
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
    required this.packageOffers, // Added package offers
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

  @override
  List<Object?> get props => [
    clinicName,
    clientPhone,
    visitId,
    visitDate,
    petName,
    species,
    issueDate,
    document,
    code,
    breed,
    sex,
    doB,
    ownerName,
    items,
    packageOffers, // Added to props
    paymentHistories,
    receiptTotal,
    totalAfterVatAndDiscount,
    discount,
    paid,
    debit,
    vat,
    invoiceCode,
    isNeedSaQrCode,
    isNeedPaymentHistory,
    isNeedItems,
  ];
}

class ItemEntity extends Equatable {
  final String itemName;
  final String price;
  final String quantity;
  final String total;

  const ItemEntity({
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.total,
  });

  @override
  List<Object?> get props => [itemName, price, quantity, total];
}

class PackageOfferItemEntity extends Equatable {
  final String itemName;
  final String price;
  final String quantity;
  final String total;

  const PackageOfferItemEntity({
    required this.itemName,
    required this.price,
    required this.quantity,
    required this.total,
  });

  @override
  List<Object?> get props => [itemName, price, quantity, total];
}

class PackageOfferEntity extends Equatable {
  final String packageName;
  final int packageQuantity;
  final List<PackageOfferItemEntity> packageItems;

  const PackageOfferEntity({
    required this.packageName,
    required this.packageQuantity,
    required this.packageItems,
  });

  @override
  List<Object?> get props => [packageName, packageQuantity, packageItems];
}

class PaymentHistoryEntity extends Equatable {
  final String paymentName;
  final String value;
  final String paymentDate;
  final String type;

  const PaymentHistoryEntity({
    required this.paymentName,
    required this.value,
    required this.paymentDate,
    required this.type,
  });

  @override
  List<Object?> get props => [paymentName, value, paymentDate, type];
}

class PetPrint extends Equatable {
  final String petName;
  final String species;
  final String sex;

  const PetPrint({
    required this.petName,
    required this.species,
    required this.sex,
  });

  @override
  List<Object?> get props => [petName, species, sex];
}

class OwnerPrint extends Equatable {
  final String ownerName;
  final String phone;

  const OwnerPrint({required this.ownerName, required this.phone});

  @override
  List<Object?> get props => [ownerName, phone];
}
