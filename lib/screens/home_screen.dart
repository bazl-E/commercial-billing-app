import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '/models/product.dart';
import '/models/product_manage.dart';

import '/widgets/billing/billing_button.dart';
import '/widgets/billing/delivery_time.dart';
import '/widgets/billing/entry_details.dart';
import '/widgets/drawer.dart';
import '/widgets/items_descrption_box.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];

  ProductMange? manageItems;
  double? passHeight;
  double? gheight;
  bool isLoading = false;
  bool isINit = true;

  String title = '';
  String? name;
  String? mob;
  String? address;
  String? recivedby;
  String? paymentMethode;
  DateTime? date;

  final scrollctrl = ScrollController();
  final _scaffoldKEy = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();

  final mobileNode = FocusNode();
  final addressNode = FocusNode();
  final receviedByNode = FocusNode();
  final nameofItemNode = FocusNode();
  final paymentMethodeNode = FocusNode();

  final titleController = TextEditingController();
  final nameController = TextEditingController();
  final mobController = TextEditingController();
  final recivedByController = TextEditingController();
  final addressController = TextEditingController();
  final advanceController = TextEditingController();
  final paymentController = TextEditingController();

  @override
  void initState() {
    manageItems = Provider.of<ProductMange>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    for (var i = 0; i < manageItems!.items.length; i++) {
      manageItems!.qntytyControllers[i].dispose();
      manageItems!.priceControllers[i].dispose();
      manageItems!.percentControllers[i].dispose();
      manageItems!.descrptionControllers[i].dispose();
    }
    titleController.dispose();
    nameController.dispose();
    mobController.dispose();
    addressController.dispose();
    advanceController.dispose();
    paymentController.dispose();
    // titleController.dispose();
    mobileNode.dispose();
    addressNode.dispose();
    receviedByNode.dispose();
    nameofItemNode.dispose();
    recivedByController.dispose();
    super.dispose();
  }

  void setDate(DateTime sdate) {
    date = sdate;
  }

  void onClear() {
    setState(() {
      titleController.clear();
      nameController.clear();
      mobController.clear();
      addressController.clear();
      advanceController.clear();
      paymentController.clear();
      recivedByController.clear();

      name = '';
      mob = '';
      address = '';
      paymentMethode = '';
      date = null;
    });
  }

  Future<void> onSave() async {
    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('pick a date for delivey!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    }

    final valid = formKey.currentState!.validate();
    final valid2 = formkey2.currentState!.validate();

    if (!valid2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Some product's price details remaining to fill!!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
      ));
    }

    if (!valid ||
        !valid2 ||
        manageItems!.items.isEmpty ||
        manageItems!.total == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Make sure You filled all fields!'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ));
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      formKey.currentState!.save();
      formkey2.currentState!.save();

      for (var i = 0; i < manageItems!.items.length; i++) {
        products.add(Product(
          itemName: manageItems!.items[i],
          price: double.parse(manageItems!.priceControllers[i].text),
          gst: double.parse(manageItems!.percentControllers[i].text),
          quantity: int.parse(manageItems!.qntytyControllers[i].text),
          specifications: manageItems!.descrptionControllers[i].text,
        ));
      }

      await Provider.of<ProductMange>(context, listen: false).addProducs(
        name: name!,
        adress: address!,
        receivedby: recivedby!,
        mobile: mob!,
        products: products,
        paymentMethode: paymentMethode!,
        total: manageItems!.total,
        deliverydate: date!,
      );

      manageItems!.onClear();
      titleController.clear();
      nameController.clear();
      mobController.clear();
      addressController.clear();
      advanceController.clear();
      paymentController.clear();
      recivedByController.clear();
      products = [];
      date = null;

      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Saved successfully',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.amber,
      ));
    } on SocketException catch (_) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                title: Text("Connection Error !"),
                content: Text("Please connect to the internet."),
              ));
    } catch (error) {
      setState(() {
        isLoading = false;
      });

      if (date != null) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Something Went Wrong'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                    'Check you filled all the quantity and price fields.Then Try again!'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final manage = Provider.of<ProductMange>(context);
    final mHeight = MediaQuery.of(context).size.height;
    final mWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKEy,
      appBar: AppBar(
          title: const Text('Create Order'),
          leading: IconButton(
              onPressed: () {
                final FocusScopeNode currentScope = FocusScope.of(context);
                if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                  FocusManager.instance.primaryFocus!.unfocus();
                }
                _scaffoldKEy.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu)),
          actions: [
            IconButton(
              onPressed: isLoading
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();
                      onClear();
                      manage.onClear();
                    },
              icon: const Icon(Icons.refresh),
            ),
          ]),
      drawer: const SideDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                // color: Colors.amber,
                padding: const EdgeInsets.only(
                  bottom: 5,
                  left: 10,
                  right: 10,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(mobileNode);
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: nameController,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Provide a name';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              name = val;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Name'),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            focusNode: mobileNode,
                            controller: mobController,
                            validator: (val) {
                              if (val!.isEmpty ||
                                  int.tryParse(val) == null ||
                                  val.length < 10 ||
                                  val.length > 10) {
                                return 'Provide 10 digits';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(addressNode);
                            },
                            onSaved: (val) {
                              mob = val;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                labelText: 'Mobile Number'),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            focusNode: addressNode,
                            controller: addressController,
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(receviedByNode);
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Provide a Adress';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              address = val;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration:
                                const InputDecoration(labelText: 'Address'),
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: recivedByController,
                            focusNode: receviedByNode,
                            onEditingComplete: () {
                              FocusScope.of(context)
                                  .requestFocus(nameofItemNode);
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'fill name';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              recivedby = val;
                            },
                            decoration:
                                const InputDecoration(labelText: 'Received by'),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  focusNode: nameofItemNode,
                                  onEditingComplete: title.trim().isEmpty
                                      ? null
                                      : () {
                                          manage.onAddedNewItem(
                                              titleController.text,
                                              context,
                                              titleController);
                                          title = '';
                                        },
                                  decoration: const InputDecoration(
                                      labelText: 'Name of item'),
                                  controller: titleController,
                                  onChanged: (val) {
                                    setState(() {
                                      title = val;
                                    });
                                  },
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Colors.teal.withAlpha(145)),
                                  onPressed: title.trim().isEmpty
                                      ? null
                                      : () {
                                          manage.onAddedNewItem(
                                              titleController.text,
                                              context,
                                              titleController);
                                          title = '';
                                        },
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.add,
                                        size: 19,
                                      ),
                                      SizedBox(width: 2),
                                      Text('Add item'),
                                    ],
                                  )),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              if (manage.items.isNotEmpty)
                                SizedBox(
                                  // color: Colors.amber,

                                  width: double.infinity,
                                  height: mHeight * .35,

                                  child: manage.items.isEmpty
                                      ? const Center(
                                          child: Text('Add products...'),
                                        )
                                      : Scrollbar(
                                          controller: scrollctrl,
                                          // isAlwaysShown: true,
                                          interactive: true,
                                          hoverThickness: 5,
                                          showTrackOnHover: true,
                                          child: PageView.builder(
                                              // allowImplicitScrolling: true,

                                              itemCount: manage.items.length,
                                              itemBuilder: (ctx, i) {
                                                return Card(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  elevation: 3,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: ItemsDecrptionBox(
                                                      i: i,
                                                      title: manage.items[i],
                                                      lenght:
                                                          manage.items.length,
                                                      isEditable: true,
                                                      descrptionController: manage
                                                          .descrptionControllers[i],
                                                      initialValue: null,
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                ),
                              if (manage.items.isEmpty && mHeight >= 700)
                                SizedBox(
                                  height: mHeight * .028,
                                ),
                              const SizedBox(height: 10),
                              // if (manage.items.isNotEmpty)
                              const Text(
                                'Price details',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (manage.items.isEmpty)
                                const SizedBox(
                                  height: 10,
                                ),
                              Entry(formkey2),
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  children: [
                                    BillingButton(
                                      child: manage.total == 0
                                          ? '0.0'
                                          : manage.total.toStringAsFixed(2),
                                      title: 'Total',
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(
                                          // color: Colors.amber,
                                          width: mWidth * .15,
                                          child: const Text(
                                            'Advance',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(width: mWidth * .03),
                                        const Text(":"),
                                        SizedBox(width: mWidth * .03),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          // color: Colors.amber,
                                          alignment: Alignment.center,
                                          width: mWidth * .35,
                                          height: mHeight * .07,
                                          child: Center(
                                            child: TextFormField(
                                              enabled: manage.total != 0,
                                              onEditingComplete: () {
                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        paymentMethodeNode);
                                              },
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: advanceController,
                                              // enabled: total != 0.0,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return null;
                                                }
                                                if (double.tryParse(val) ==
                                                    null) {
                                                  return 'Provide a valid value';
                                                }
                                                if (double.tryParse(val)! >
                                                    manage.total) {
                                                  return 'kepp an eye on total';
                                                }

                                                return null;
                                              },
                                              onSaved: (val) {
                                                if (double.tryParse(val!) ==
                                                        null ||
                                                    manage.total == null) {
                                                  return;
                                                }
                                                manage.advance =
                                                    double.parse(val);
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: const InputDecoration(
                                                hintText: 'Enter advance',
                                              ),
                                              onChanged: (value) {
                                                if (double.tryParse(value) ==
                                                    null) {
                                                  setState(() {
                                                    manage.advance = 0;
                                                    manage.balance =
                                                        manage.total;
                                                  });
                                                }
                                                if (double.tryParse(value) ==
                                                        null ||
                                                    manage.total == null ||
                                                    double.tryParse(value)! >
                                                        manage.total) {
                                                  return;
                                                }

                                                setState(() {
                                                  manage.advance =
                                                      double.parse(value);
                                                  manage.balance =
                                                      manage.total -
                                                          double.parse(value);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          // color: Colors.amber,
                                          padding: const EdgeInsets.all(4),
                                          alignment: Alignment.center,
                                          width: mWidth * .35,
                                          height: mHeight * .07,
                                          child: Center(
                                            child: TextFormField(
                                              focusNode: paymentMethodeNode,
                                              controller: paymentController,
                                              validator: (val) {
                                                if (val!.isEmpty) {
                                                  return 'Provide a  Method';
                                                }
                                                return null;
                                              },
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              onSaved: (val) {
                                                paymentMethode = val;
                                              },
                                              decoration: const InputDecoration(
                                                  hintText: 'Payment method'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    BillingButton(
                                        title: 'Balance',
                                        child:
                                            manage.balance.toStringAsFixed(2)),
                                    const SizedBox(height: 10),
                                    DeliveryTime(context, setDate),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                          //  Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: mHeight * .065,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.amber,
                                        onPrimary: Colors.black,
                                        elevation: 0,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      manage.balance =
                                          manage.total - manage.advance;

                                      manage.calculateIncludeGst(context);

                                      onSave();
                                    },
                                    icon: const Icon(Icons.save),
                                    label: const Text('Save'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
