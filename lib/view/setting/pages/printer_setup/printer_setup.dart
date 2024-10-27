import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/colors.dart';

class PrinterSetup extends StatefulWidget {
  const PrinterSetup({super.key});

  @override
  State<PrinterSetup> createState() => _PrinterSetupState();
}

class _PrinterSetupState extends State<PrinterSetup> {
  List<BluetoothDevice> _devices = [];
  final BlueThermalPrinter _printer = BlueThermalPrinter.instance;
  bool _connect = false;

  void _connectBluetooth() {
    BluetoothEnable.enableBluetooth.then((result) {
      if (result == "true") {
        _devices.clear();
        _getDevices();
      } else if (result == "false") {
        Navigator.of(context).pop();
      }
    });
  }

  void _getDevices() async {
    _devices = await _printer.getBondedDevices();
    setState(() {});
  }

  void _connectCheck() async {
    _connect = (await _printer.isConnected)!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getDevices();
    _connectCheck();
    _connectBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    var myDynamicAspectRatio = 1.w / 0.5.h;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: myDynamicAspectRatio,
        mainAxisSpacing: 6.w,
        crossAxisSpacing: 6.h,
        crossAxisCount: 4,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: _devices.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            width: 360.w,
            height: 75.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_devices[index].name ?? "",
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(_devices[index].address ?? "",
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if ((await _printer.isConnected)! == true) {
                      _printer.disconnect().then((value) {
                        setState(() {
                          _connect = false;
                        });
                      });
                    } else {
                      _printer.connect(_devices[index]).then((value) {
                        setState(() {
                          _connect = true;
                        });
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.w),
                    child: Container(
                      height: 30.h,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(
                            width: 1,
                            color: _connect == false
                                ? Colors.green
                                : SonomaneColor.primary),
                      ),
                      child: Text(
                        _connect == false ? "Connect" : "Disconnect",
                        style: TextStyle(
                          color: _connect == false
                              ? Colors.green
                              : SonomaneColor.primary,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
