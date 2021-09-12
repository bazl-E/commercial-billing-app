import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/product_manage.dart';

class Entry extends StatefulWidget {
  Entry(
    this.formkey2,
  );
  final formkey2;

  @override
  _EntryState createState() => _EntryState();
}

class _EntryState extends State<Entry> {
  @override
  Widget build(BuildContext context) {
    final manage = Provider.of<ProductMange>(context);
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;

    return Form(
      key: widget.formkey2,
      child: SizedBox(
        height: manage.items.length * mHeight * .18,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: manage.items.length,
            itemBuilder: (ctx, i) {
              // _percentControllers[i].text = '0';
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      height: mHeight * .15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${i + 1} - '),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: mWidth * .22,
                            child: Text(
                              manage.items[i],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: mWidth * .16,
                            // height: 50,
                            child: TextFormField(
                                validator: (val) {
                                  if (int.tryParse(val!) == null ||
                                      val.isEmpty ||
                                      int.tryParse(val) == 0) {
                                    return 'Not valid';
                                  }
                                },
                                onChanged: (val) {
                                  manage.calculateIncludeGst(context);
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: const InputDecoration(
                                    labelText: 'quantity'),
                                controller: manage.qntytyControllers[i],
                                keyboardType: TextInputType.number,
                                onTap: () {
                                  if (manage.qntytyControllers[i].text == '0') {
                                    manage.qntytyControllers[i].clear();
                                  }
                                },
                                // onChanged: (val) {
                                //   manage.calculateIncludeGst(context);

                                // },
                                onEditingComplete: () {
                                  manage.calculateIncludeGst(context);
                                }),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: mWidth * .16,
                            child: TextFormField(
                                onChanged: (val) {
                                  manage.calculateIncludeGst(context);
                                },
                                onTap: () {
                                  if (manage.priceControllers[i].text == '0') {
                                    manage.priceControllers[i].clear();
                                  }
                                },
                                validator: (val) {
                                  if (double.tryParse(val!) == null ||
                                      val.isEmpty ||
                                      int.tryParse(val) == 0) {
                                    return 'Not valid';
                                  }
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration:
                                    const InputDecoration(labelText: 'price'),
                                controller: manage.priceControllers[i],
                                keyboardType: TextInputType.number,
                                onEditingComplete: () {
                                  manage.calculateIncludeGst(context);
                                }),
                          ),
                          Checkbox(
                              value: manage.initialValues[i],
                              onChanged: (value) {
                                manage.changevalue(i, value!);
                                manage.calculateIncludeGst(context);
                              }),
                          SizedBox(
                            width: mWidth * .13,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    onChanged: (val) {
                                      manage.calculateIncludeGst(context);
                                    },
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          double.tryParse(value) == null) {
                                        return 'Alert';
                                      }
                                      return null;
                                    },
                                    // autovalidateMode:
                                    //     AutovalidateMode.onUserInteraction,
                                    onTap: () {
                                      if (manage.percentControllers[i].text ==
                                          '0') {
                                        manage.percentControllers[i].clear();
                                      }
                                    },
                                    enabled: manage.initialValues[i] == true,
                                    controller: manage.percentControllers[i],
                                    onEditingComplete: () {
                                      manage.calculateIncludeGst(context);
                                    },
                                    decoration:
                                        const InputDecoration(labelText: 'GST'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const Text(
                                  '%',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider()
                ],
              );
            }),
      ),
    );
  }
}
