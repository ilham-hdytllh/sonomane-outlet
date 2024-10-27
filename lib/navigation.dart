import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonomaneoutlet/common/behavior.dart';
import 'package:sonomaneoutlet/common/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sonomaneoutlet/view/customer_management/customer_management.dart';
import 'package:sonomaneoutlet/view/daily_checkin_management/daily_checkin_management.dart';
import 'package:sonomaneoutlet/view/employe_management/employe_management.dart';
import 'package:sonomaneoutlet/view/history_log_management/history_log_management.dart';
import 'package:sonomaneoutlet/view/inventory_management/inventory_management.dart';
import 'package:sonomaneoutlet/view/kitchen_management/kitchen_management.dart';
import 'package:sonomaneoutlet/view/loyalty_management/loyalty_management.dart';
import 'package:sonomaneoutlet/view/menu_management/menu_management.dart';
import 'package:sonomaneoutlet/view/order_management/order_management.dart';
import 'package:sonomaneoutlet/view/order_payment/order_payment_management.dart';
import 'package:sonomaneoutlet/view/pos_management/pos_management.dart';
import 'package:sonomaneoutlet/view/report_management/report_management.dart';
import 'package:sonomaneoutlet/view/table_management/table_management.dart';
import 'package:sonomaneoutlet/view/version_app_management/version_management.dart';
import 'package:sonomaneoutlet/view/voucher_management/voucher_management.dart';
import 'package:sonomaneoutlet/view/waiter_management/waiter_management.dart';

// ignore: must_be_immutable
class Navigation extends StatefulWidget {
  String user;
  Navigation({super.key, required this.user});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;
  bool extended = false;

  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Row(
          children: [
            ScrollConfiguration(
              behavior: NoGloww(),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                          width: 0.3.w,
                          color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                  duration: const Duration(microseconds: 300),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        labelType: NavigationRailLabelType.none,
                        selectedIconTheme:
                            IconThemeData(color: SonomaneColor.primary),
                        unselectedIconTheme: IconThemeData(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        selectedLabelTextStyle: TextStyle(
                            color: SonomaneColor.primary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                        unselectedLabelTextStyle: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        selectedIndex: _selectedIndex,
                        leading: GestureDetector(
                          onTap: () {
                            setState(() => extended = !extended);
                          },
                          child: extended == true
                              ? Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/logo_sonomane-removebg-preview.png',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'Son',
                                              style: GoogleFonts.nunito(
                                                color: SonomaneColor.primary,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'oom',
                                              style: GoogleFonts.nunito(
                                                color: Colors.amber,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'ane',
                                              style: GoogleFonts.nunito(
                                                color: SonomaneColor.primary,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Image.asset(
                                    'assets/images/logo_sonomane-removebg-preview.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                        ),
                        destinations: [
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer" ||
                              widget.user == "kasir" ||
                              widget.user == "leader")
                            NavigationRailDestination(
                              icon: const Icon(Icons.point_of_sale),
                              label: Text(
                                'POS',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer" ||
                              widget.user == "kasir" ||
                              widget.user == "leader")
                            NavigationRailDestination(
                              icon: const Icon(Icons.receipt_long_rounded),
                              label: Text(
                                'Order',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer" ||
                              widget.user == "kasir" ||
                              widget.user == "leader")
                            NavigationRailDestination(
                              icon: const Icon(Icons.payments_rounded),
                              label: Text(
                                'Transaction',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer" ||
                              widget.user == "kitchen")
                            NavigationRailDestination(
                              icon: const Icon(Icons.soup_kitchen_rounded),
                              label: Text(
                                'Kitchen',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer" ||
                              widget.user == "waiter")
                            NavigationRailDestination(
                              icon: const Icon(Icons.room_service_rounded),
                              label: Text(
                                'Waiter',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            NavigationRailDestination(
                              icon: const Icon(Icons.fastfood),
                              label: Text(
                                'Menu',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            NavigationRailDestination(
                              icon: const Icon(Icons.inventory),
                              label: Text(
                                'Inventory',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            NavigationRailDestination(
                              icon: const Icon(Icons.confirmation_number),
                              label: Text(
                                'Voucher',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            const NavigationRailDestination(
                              icon: Icon(Icons.card_membership),
                              label: Text(
                                'Loyalty',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            const NavigationRailDestination(
                              icon: Icon(Icons.wallet_giftcard),
                              label: Text(
                                'Daily Checkin',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            NavigationRailDestination(
                              icon: const Icon(Icons.table_restaurant_rounded),
                              label: Text(
                                'Table',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            NavigationRailDestination(
                              icon: const Icon(Icons.description_rounded),
                              label: Text(
                                'Report',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            NavigationRailDestination(
                              icon: const Icon(Icons.supervised_user_circle),
                              label: Text(
                                'Employe',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            NavigationRailDestination(
                              icon: const Icon(Icons.face),
                              label: Text(
                                'Customer',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin")
                            NavigationRailDestination(
                              icon: const Icon(Icons.settings_suggest_rounded),
                              label: Text(
                                'Version App',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                          if (widget.user == "superadmin" ||
                              widget.user == "manajer")
                            NavigationRailDestination(
                              icon: const Icon(Icons.history),
                              label: Text(
                                'History',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                        ],
                        extended: extended,
                        minExtendedWidth: 155.w,
                        minWidth: 60.w,
                        onDestinationSelected: (int index) {
                          setState(() {
                            _selectedIndex = index;
                            pageController.jumpToPage(index);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                children: [
                  if (widget.user == "superadmin") ...{
                    _buildOffstageNavigator(0),
                    _buildOffstageNavigator(1),
                    _buildOffstageNavigator(2),
                    _buildOffstageNavigator(3),
                    _buildOffstageNavigator(4),
                    _buildOffstageNavigator(5),
                    _buildOffstageNavigator(6),
                    _buildOffstageNavigator(7),
                    _buildOffstageNavigator(8),
                    _buildOffstageNavigator(9),
                    _buildOffstageNavigator(10),
                    _buildOffstageNavigator(11),
                    _buildOffstageNavigator(12),
                    _buildOffstageNavigator(13),
                    _buildOffstageNavigator(14),
                    _buildOffstageNavigator(15),
                    _buildOffstageNavigator(16),
                    _buildOffstageNavigator(17),
                  } else if (widget.user == "manajer") ...{
                    _buildOffstageNavigator(0),
                    _buildOffstageNavigator(1),
                    _buildOffstageNavigator(2),
                    _buildOffstageNavigator(3),
                    _buildOffstageNavigator(4),
                    _buildOffstageNavigator(5),
                    _buildOffstageNavigator(6),
                    _buildOffstageNavigator(7),
                    _buildOffstageNavigator(8),
                    _buildOffstageNavigator(9),
                    _buildOffstageNavigator(10),
                    _buildOffstageNavigator(11),
                    _buildOffstageNavigator(12),
                    _buildOffstageNavigator(13),
                    _buildOffstageNavigator(14),
                    _buildOffstageNavigator(15),
                    _buildOffstageNavigator(16),
                  } else if (widget.user == "kitchen") ...{
                    _buildOffstageNavigator(0),
                    _buildOffstageNavigator(1),
                  } else if (widget.user == "kasir") ...{
                    _buildOffstageNavigator(0),
                    _buildOffstageNavigator(1),
                    _buildOffstageNavigator(2),
                    _buildOffstageNavigator(3),
                    _buildOffstageNavigator(4),
                  } else if (widget.user == "waiter") ...{
                    _buildOffstageNavigator(0),
                    _buildOffstageNavigator(1),
                  }
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          if (widget.user == "superadmin") ...{
            const ScreenPosManagement(),
            const ScreenOrderPaymentManagement(),
            const ScreenOrderManagement(),
            const ScreenKitchenManagement(),
            const ScreenWaiterManagement(),
            const ScreenMenuManagement(),
            const ScreenInventoryManagement(),
            const ScreenVoucherManagement(),
            const LoyaltyManagement(),
            const DailyCheckinManagement(),
            const ScreenTableManagement(),
            const ScreenReportManagement(),
            const ScreenEmployeManagement(),
            const ScreenCustomerManagement(),
            const VersionManagement(),
            const ScreenHistoryLogManagement(),
          } else if (widget.user == "manajer") ...{
            const ScreenPosManagement(),
            const ScreenOrderPaymentManagement(),
            const ScreenOrderManagement(),
            const ScreenKitchenManagement(),
            const ScreenWaiterManagement(),
            const ScreenMenuManagement(),
            const ScreenInventoryManagement(),
            const ScreenVoucherManagement(),
            const LoyaltyManagement(),
            const DailyCheckinManagement(),
            const ScreenTableManagement(),
            const ScreenReportManagement(),
            const ScreenEmployeManagement(),
            const ScreenCustomerManagement(),
            const VersionManagement(),
            const ScreenHistoryLogManagement(),
          } else if (widget.user == "kitchen") ...{
            const ScreenKitchenManagement(),
            const ScreenHistoryLogManagement(),
          } else if (widget.user == "kasir") ...{
            const ScreenPosManagement(),
            const ScreenOrderPaymentManagement(),
            const ScreenOrderManagement(),
            const ScreenKitchenManagement(),
            const ScreenHistoryLogManagement(),
          } else if (widget.user == "waiter") ...{
            const ScreenWaiterManagement(),
            const ScreenHistoryLogManagement(),
          }
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name]!(context),
          );
        },
      ),
    );
  }
}
