import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';

class ProductMange with ChangeNotifier {
  List<Bill> _bills = [];
  List<String> _items = [];
  List<TextEditingController> _qntytyControllers = [];
  List<TextEditingController> _priceControllers = [];
  List<TextEditingController> _percentControllers = [];
  List<TextEditingController> _descrptionControllers = [];
  List<bool> _initialValues = [];

  double total = 0;
  double balance = 0;
  double advance = 0;
  var selectedDate;
  var io = true;

  List<Bill> get bills {
    return [..._bills];
  }

  List<String> get items {
    return [..._items];
  }

  List<TextEditingController> get qntytyControllers {
    return [..._qntytyControllers];
  }

  List<TextEditingController> get priceControllers {
    return [..._priceControllers];
  }

  List<TextEditingController> get percentControllers {
    return [..._percentControllers];
  }

  List<TextEditingController> get descrptionControllers {
    return [..._descrptionControllers];
  }

  List<bool> get initialValues {
    return [..._initialValues];
  }

  void changevalue(int i, bool value) {
    _initialValues[i] = value;
    notifyListeners();
  }

  void onClear() {
    _items = [];
    _initialValues = [];
    _qntytyControllers = [];
    _priceControllers = [];
    _percentControllers = [];
    _descrptionControllers = [];
    total = 0;
    balance = 0;
    advance = 0;
    selectedDate = null;
    notifyListeners();
  }

  void onAddedNewItem(
    String itemName,
    BuildContext context,
    TextEditingController titleController,
  ) {
    _items.add(itemName);

    FocusScope.of(context).unfocus();
    titleController.clear();

    _priceControllers.add(TextEditingController());
    _qntytyControllers.add(TextEditingController());
    _percentControllers.add(TextEditingController());
    _descrptionControllers.add(TextEditingController());
    _initialValues.add(false);

    notifyListeners();
  }

  void calculateIncludeGst(BuildContext context) {
    total = 0.0;

    for (var i = 0; i < _items.length; i++) {
      if (double.tryParse(_priceControllers[i].text) == null &&
          priceControllers[i].text.isNotEmpty)
      // double.tryParse(_percentControllers[i].text) == null ||
      {
        return;
      }
      if (double.tryParse(_qntytyControllers[i].text) == null &&
          _qntytyControllers[i].text.isNotEmpty) {
        return;
      }
      if (double.tryParse(_percentControllers[i].text) == null &&
          initialValues[i] == true &&
          _percentControllers[i].text.isNotEmpty) {
        return;
      }
      var pri = (double.tryParse(_priceControllers[i].text));
      var per = (double.tryParse(_percentControllers[i].text));
      var qnt = (double.tryParse(_qntytyControllers[i].text));
      if (initialValues[i] == false || _percentControllers[i].text.isEmpty) {
        per = 0;
        _percentControllers[i].text = '0';
      }
      if (_percentControllers[i].text.isEmpty) {
        per = 0;
      }
      if (priceControllers[i].text.isEmpty) {
        pri = 0;
      }
      if (qntytyControllers[i].text.isEmpty) {
        qnt = 0;
      }

      total = total + qnt! * (pri! + (pri * (per! / 100)));
    }
    balance = total - advance;
    // FocusScope.of(context).unfocus();
    notifyListeners();
  }

  Future<void> addProducs(
      {required String name,
      required String adress,
      required String receivedby,
      required String mobile,
      required List<Product> products,
      required double total,
      required DateTime deliverydate,
      required String paymentMethode}) async {
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      final status = 'notyetfinished';

      final delivery =
          DateTime(deliverydate.year, deliverydate.month, deliverydate.day);
      final data = await FirebaseFirestore.instance.collection('bills').add({
        'name': name.toString(),
        'address': adress.toString(),
        'mobileNUmber': int.parse(mobile),
        'total': double.parse(total.toStringAsFixed(2)),
        'advance': double.parse(advance.toStringAsFixed(2)),
        'receivedby': receivedby.toString(),
        'fetchby': Timestamp.now(),
        'receiveddate': date.toString(),
        'finisheddate': status,
        'balnce': double.parse(balance.toStringAsFixed(2)),
        'paymentMethode': paymentMethode.toString(),
        'delivaryDate': deliverydate.toIso8601String(),
        'isFinished': false,
        'finishedfetch': Timestamp.fromDate(DateTime(2020)),
        'devliveryfetch': Timestamp.fromDate(delivery),
      });

      for (var prod in products) {
        await FirebaseFirestore.instance
            .collection('bills/${data.id}/products')
            .add({
          'itemName': prod.itemName,
          'specifications': prod.specifications,
          'quantity': prod.quantity,
          'price': prod.price,
          'gst': prod.gst,
          'isFinished': prod.isFinished,
          'fetchBy': Timestamp.now(),
        });
      }
      _bills.add(Bill(
        id: data.id,
        name: name,
        address: adress,
        receivedby: receivedby,
        mobileNUmber: mobile,
        products: products,
        advance: advance,
        balnce: balance,
        delivaryDate: deliverydate,
        paymentMethode: paymentMethode,
        total: total,
      ));

      onClear();
    } on SocketException catch (_) {
      throw SocketException('eroor');
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> updateData(
    String id,
    String recivedBy,
    String methode,
    String payingAmountText,
    double totalPaid,
    double total,
  ) async {
    var payingAmount = double.tryParse(payingAmountText);
    if (payingAmount == null) {
      payingAmount = 0;
    }

    final paided = totalPaid + payingAmount;
    final balance = total - paided;
    await FirebaseFirestore.instance.collection('bills').doc(id).update({
      'receivedby': recivedBy,
      'paymentMethode': methode,
      'balnce': balance,
      'advance': paided,
    });

    notifyListeners();
    print(recivedBy);
    print(methode);
  }

  Future<void> updateFinishStatus(
      {String? mainId, String? subId, bool? status}) async {
    final mstatus = 'notyetfinished';
    try {
      await FirebaseFirestore.instance
          .collection('bills')
          .doc(mainId)
          .collection('products')
          .doc(subId)
          .update({'isFinished': status});

      FirebaseFirestore.instance.collection('bills').doc(mainId).update({
        'isFinished': false,
        'finisheddate': mstatus,
        'finishedfetch': Timestamp.fromDate(DateTime(2020)),
      });

      notifyListeners();
    } catch (eroor) {
      print(eroor.toString());

      await FirebaseFirestore.instance
          .collection('bills')
          .doc(mainId)
          .collection('products')
          .doc(subId)
          .update({'isFinished': false});
      notifyListeners();
      throw Error();
    }
  }
}
