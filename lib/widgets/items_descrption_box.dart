import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/product_manage.dart';

class ItemsDecrptionBox extends StatelessWidget {
  ItemsDecrptionBox(
      // this.items, [this.descrptionController]
      {required this.i,
      required this.title,
      required this.isEditable,
      this.lenght,
      this.exlist,
      this.mainId,
      this.subId,
      this.isFinished,
      this.gst,
      this.price,
      this.quantity,
      this.descrptionController,
      this.initialValue});

  final int i;
  final int? lenght;
  final List? exlist;
  final String? mainId;
  final String? subId;
  final String title;
  final String? initialValue;
  final String? quantity;
  final String? price;
  final String? gst;
  final TextEditingController? descrptionController;
  final bool isEditable;
  final bool? isFinished;

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;
    final manage = Provider.of<ProductMange>(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: isEditable
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: mHeight * .03,
                  child: Text('${int.parse(i.toString()) + 1}'),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: mHeight * .03,
                  width: mWidth * .44,
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (isEditable && lenght != 1)
              Row(
                children: const [Icon(Icons.swipe_outlined)],
              ),
            if (!isEditable && isFinished == false)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    manage.io = true;
                    await manage.updateFinishStatus(
                        mainId: mainId, subId: subId, status: true);

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: const Text(
                            'Updated Succesfully',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          action: SnackBarAction(
                              label: 'Undo',
                              textColor: Colors.black,
                              onPressed: () async {
                                manage.io = true;
                                await manage.updateFinishStatus(
                                    mainId: mainId,
                                    subId: subId,
                                    status: false);
                              }),
                          backgroundColor: Colors.amber),
                    );
                  },
                  child: const Text('Set as finished'),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      primary: Theme.of(context).toggleableActiveColor,
                      onPrimary: Colors.black),
                ),
              ),
            if (!isEditable && isFinished == true)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.done),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                            ' You can\'t undo this',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: Colors.amber),
                    );
                  },
                  label: const Text('Work finished'),
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 5),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      primary: Theme.of(context).toggleableActiveColor,
                      onPrimary: Colors.black),
                ),
              ),
          ],
        ),
        const Divider(
          thickness: 2,
        ),
        SizedBox(
          // color: Colors.red,
          height: isEditable ? mHeight * .255 : mHeight * .3,
          width: double.infinity,
          child: Column(
            children: [
              if (!isEditable)
                Row(
                  children: [
                    SizedBox(
                      width: mWidth * .16,
                      child: const Text('quantity'),
                    ),
                    const Text(':'),
                    const SizedBox(width: 10),
                    Text(quantity.toString())
                  ],
                ),
              if (!isEditable)
                Row(
                  children: [
                    SizedBox(
                      width: mWidth * .16,
                      child: const Text('price'),
                    ),
                    const Text(':'),
                    const SizedBox(width: 10),
                    Text(price.toString())
                  ],
                ),
              if (!isEditable)
                Row(
                  children: [
                    SizedBox(
                      width: mWidth * .16,
                      child: const Text('Gst'),
                    ),
                    const Text(':'),
                    const SizedBox(width: 10),
                    Text(gst.toString() + '%')
                  ],
                ),
              TextFormField(
                controller: descrptionController ?? null,
                decoration: isEditable
                    ? InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelText: 'Write Descrption Here')
                    : null,
                maxLines: 7,
                initialValue: isEditable ? null : initialValue,
                enabled: isEditable,
              ),
            ],
          ),
        )
      ],
    );
  }
}
