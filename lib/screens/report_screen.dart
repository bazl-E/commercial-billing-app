import 'package:bill_creator/widgets/orders/tile.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportScreen extends StatefulWidget {
  static const routeName = 'report-screen';
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream1;
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream2;

  bool isInit = true;

  // String? filterDate;
  String? inishowDate;
  String? finshowDate;
  DateTime initialDate = DateTime.now();
  Timestamp? inistamp;
  Timestamp? finstamp;

  @override
  void initState() {
    super.initState();
    inishowDate = null;
    finshowDate = null;
  }

  @override
  void didChangeDependencies() {
    if (isInit)
      stream2 = FirebaseFirestore.instance
          .collection('bills')
          .where('isFinished', isEqualTo: false)
          .orderBy('fetchby')
          .snapshots();

    super.didChangeDependencies();
    isInit = false;
  }

  Future<void> _showDatePicker() async {
    // final pickeddate = await showDatePicker(
    //   context: context,
    //   initialDate: initialDate,
    //   firstDate: DateTime(2020),
    //   lastDate: DateTime(2050),
    // );
    final pickeddate = await showDateRangePicker(
        context: context, firstDate: DateTime(2020), lastDate: DateTime(2050));
    if (pickeddate == null) {
      return;
    }
    final beginDate = pickeddate.start;
    final finalDate = pickeddate.end;
    print(beginDate);
    print(finalDate);

    inistamp = Timestamp.fromDate(beginDate);
    finstamp = Timestamp.fromDate(finalDate);
    // final date = DateFormat('yyyy-MM-dd').format(pickeddate);
    final date1 = DateFormat.yMd().format(pickeddate.start);
    final date2 = DateFormat.yMd().format(pickeddate.end);
    setState(() {
      // filterDate = date1;
      inishowDate = date1;
      finshowDate = date2;
      stream1 = FirebaseFirestore.instance
          .collection('bills')
          .where('devliveryfetch', isGreaterThanOrEqualTo: inistamp)
          .where('devliveryfetch', isLessThanOrEqualTo: finstamp)
          .where(
            'isFinished',
            isEqualTo: false,
          )
          .orderBy('devliveryfetch')
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        actions: [
          PopupMenuButton(
              padding: const EdgeInsets.all(0),
              onSelected: (val) {
                setState(() {
                  inishowDate = null;
                  finshowDate = null;
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
                      'Select date range',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      width: MediaQuery.of(context).size.width * .55,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 10),
                          Text(inishowDate == null
                              ? 'All orderes'
                              : "$inishowDate - $finshowDate"),
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
              stream: inishowDate == null ? stream2 : stream1,
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
                        'No due-dates on this range',
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
