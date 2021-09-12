import 'package:bill_creator/widgets/orders/tile.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'orders-screen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream1;
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream2;

  bool isInit = true;

  String? condition;
  String? filterDate;
  String? showDate;
  DateTime initialDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    showDate = null;
  }

  @override
  void didChangeDependencies() {
    if (isInit)
      condition = ModalRoute.of(context)!.settings.arguments as String;
    stream2 = condition == 'order'
        ? FirebaseFirestore.instance
            .collection('bills')
            .where('isFinished', isEqualTo: false)
            .orderBy('fetchby')
            .snapshots()
        : FirebaseFirestore.instance
            .collection('bills')
            .where('isFinished', isEqualTo: true)
            .orderBy('finishedfetch')
            .snapshots();

    super.didChangeDependencies();
    isInit = false;
  }

  Future<void> _showDatePicker() async {
    final pickeddate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (pickeddate == null) {
      return;
    }
    initialDate = pickeddate;
    final date = DateFormat('yyyy-MM-dd').format(pickeddate);
    final date2 = DateFormat.yMMMd().format(pickeddate);
    setState(() {
      filterDate = date;
      showDate = date2;
      stream1 = condition == 'order'
          ? FirebaseFirestore.instance
              .collection('bills')
              .where('receiveddate', isEqualTo: filterDate)
              .where(
                'isFinished',
                isEqualTo: false,
              )
              .orderBy('fetchby')
              .snapshots()
          : FirebaseFirestore.instance
              .collection('bills')
              .where('finisheddate', isEqualTo: filterDate)
              .where(
                'isFinished',
                isEqualTo: true,
              )
              .orderBy('finishedfetch')
              .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(condition == 'order' ? 'Orders' : 'Finished orders'),
        actions: [
          PopupMenuButton(
              padding: const EdgeInsets.all(0),
              onSelected: (val) {
                setState(() {
                  showDate = null;
                });
              },
              itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      child: Text('Show All orderes'),
                      value: 'a',
                    )
                  ])
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'Select Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      width: 200,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 10),
                          Text(showDate == null ? 'All orderes' : showDate!),
                          IconButton(
                            onPressed: _showDatePicker,
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.teal,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: showDate == null ? stream2 : stream1,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height -
                            MediaQuery.of(context).size.height * .3,
                        child: const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                }
                if (!snap.hasData) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * .3,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No Orders Yet',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 23),
                      ),
                    ),
                  );
                }

                if (snap.data!.docs.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).size.height * .3,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        condition == 'order'
                            ? 'No orders on this day'
                            : 'No oder finished on this day',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 23),
                      ),
                    ),
                  );
                }
                return Tile(snap);
              },
            )
          ],
        ),
      ),
    );
  }
}
