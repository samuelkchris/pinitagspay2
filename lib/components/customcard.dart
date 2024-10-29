import 'package:flutter/material.dart';
import 'package:flutter_custom_cards/flutter_custom_cards.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:flutter_svg/svg.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    List<GridItem> items = [
      GridItem(name: 'Bills', icon: 'assets/svg/bill-list-svgrepo-com.svg'),
      GridItem(
          name: 'Merchant', icon: 'assets/svg/merchant-shop-svgrepo-com.svg'),
      GridItem(name: 'Send Money', icon: 'assets/svg/send-svgrepo-com.svgs'),
      GridItem(name: 'Schedule', icon: 'assets/svg/schedule-svgrepo-com.svg'),
      GridItem(name: 'Bank Transfer', icon: 'assets/svg/bank-svgrepo-com.svg'),
      GridItem(name: 'Data bundles', icon: 'assets/svg/wifi-svgrepo-com.svg'),
      GridItem(
          name: 'Airtime',
          icon: 'assets/svg/call-chat-rounded-svgrepo-com.svg'),
      GridItem(name: 'My balances', icon: 'assets/svg/wallet-svgrepo-com.svgs'),
      GridItem(name: 'Tag', icon: 'assets/svg/tag-price-svgrepo-com.svg'),
    ];

    return IgnorePointer(
        ignoring: false,
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(items.length, (index) {
            return GestureDetector(
              onTap: () {
                showBottomSheetModal(context, items[index].name);
              },
              child: Custom3DCard(
                elevation: 4,
                child: SizedBox(
                  height: size.height * 0.04,
                  width: size.width * 0.05,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          items[index].icon,
                          height: 30,
                          width: 30,
                        ),
                        Text(
                          items[index].name,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ));
  }
}

class GridItem {
  final String name;
  final String icon;

  GridItem({required this.name, required this.icon});
}

void showBottomSheetModal(BuildContext context, String itemName) async {
  final Size size = MediaQuery.sizeOf(context);

  switch (itemName) {
    case 'Tag':
      ValueNotifier<bool> isScanning = ValueNotifier(true);
      ValueNotifier<Map<String, dynamic>> tagInfo = ValueNotifier({});

      FlutterNfcKit.poll().then((NFCTag tag) async {
        isScanning.value = false;
        print("tagInfo: ${tagInfo.value}");
      }).catchError((error) {
        isScanning.value = false;
        tagInfo.value = {'error': error};
        print("Error: $error");
      });

      // Define payment options
      List<String> paymentOptions = ['Mobile Money', 'Cash', 'Card'];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: size.height * 0.5,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ValueListenableBuilder(
              valueListenable: isScanning,
              builder: (context, isScanning, child) {
                return isScanning
                    ? const Center(
                        child: Text('Scanning...'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          child: Column(
                            children: [
                              ValueListenableBuilder(
                                valueListenable: tagInfo,
                                builder: (context, tagInfo, child) {
                                  return Text(
                                      'Tag ID: ${tagInfo['tagId']}, Data: ${tagInfo['data']}');
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Amount',
                                ),
                              ),
                              DropdownButton<String>(
                                items: paymentOptions.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (_) {},
                                hint: const Text('Select Payment Option'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Handle confirm button press
                                },
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        ),
                      );
              },
            ),
          );
        },
      );
      break;

    default:
      print('No bottom sheet defined for this item.');
  }
}
