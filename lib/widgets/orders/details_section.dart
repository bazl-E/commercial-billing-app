import 'package:bill_creator/models/product_manage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../items_descrption_box.dart';

class DetailsSection extends StatefulWidget {
  const DetailsSection(this.id, this.element);

  final String id;
  final element;

  @override
  _DetailsSectionState createState() => _DetailsSectionState();
}

class _DetailsSectionState extends State<DetailsSection> {
  var stream2;
  ProductMange? prod;
  @override
  void initState() {
    stream2 = FirebaseFirestore.instance
        .collection('bills')
        .doc(widget.id)
        .collection('products')
        .orderBy('fetchBy')
        .snapshots();
    super.initState();
    prod = Provider.of<ProductMange>(context, listen: false);
  }

  void completedProject(String mainID) {
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    FirebaseFirestore.instance.collection('bills').doc(mainID).update({
      'isFinished': true,
      'finisheddate': date,
      'finishedfetch': Timestamp.now(),
    });
  }

  void show() {
    if (prod!.io) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Congratulations'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('All the works are finished. '),
              Text('This order will be moved in to finished orderes list.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ok'),
            )
          ],
        ),
      );
      prod!.io = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: stream2,
          builder: (ctx, subsnap) {
            if (subsnap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text(
                  'Loading......',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }
            final lenght = subsnap.data!.docs.length;
            final finishList = subsnap.data!.docs
                .where((element) => element['isFinished'] == true)
                .toList();
            final bool projStatus = widget.element['isFinished'];
            // var io = true;
            if (finishList.length == subsnap.data!.docs.length && !projStatus) {
              completedProject(widget.id);

              Future.delayed(Duration.zero, () async {
                show();
              });
            }

            return Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: lenght * (mHeight * .375),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lenght,
                  itemBuilder: (ctx, i) {
                    final productList = subsnap.data!.docs[i];
                    final exList = subsnap.data!.docs;
                    return ItemsDecrptionBox(
                      i: i,
                      mainId: widget.id,
                      exlist: exList,
                      subId: productList.id,
                      descrptionController: null,
                      initialValue: productList['specifications'].toString(),
                      isEditable: false,
                      isFinished: productList['isFinished'],
                      title: productList['itemName'].toString(),
                      gst: productList['gst']
                          .toString(), //for web gst:productList['gst']
                      price: productList['price']
                          .toString(), //for web pric:productList['price'],

                      quantity: productList['quantity'].toString(),
                    );
                  }),
            );
          }),
    );
  }
}
