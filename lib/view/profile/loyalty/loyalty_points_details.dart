import 'package:aayu/controller/loyalty/loyalty_controller.dart';
import 'package:aayu/theme/theme.dart';
import 'package:aayu/view/profile/loyalty/widgets/pending_points.dart';
import 'package:aayu/view/profile/loyalty/widgets/point_transactions.dart';
import 'package:aayu/view/profile/loyalty/widgets/redeem_store.dart';
import 'package:aayu/view/profile/loyalty/widgets/user_coupons.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoyaltyPointsDetails extends StatefulWidget {
  const LoyaltyPointsDetails({Key? key}) : super(key: key);

  @override
  State<LoyaltyPointsDetails> createState() => _LoyaltyPointsDetailsState();
}

class _LoyaltyPointsDetailsState extends State<LoyaltyPointsDetails>
    with
        AutomaticKeepAliveClientMixin<LoyaltyPointsDetails>,
        TickerProviderStateMixin {
  LoyaltyController loyaltyController = Get.find();
  List<String> tabList = ["Earned", "Redeem", "Coupons"];
  TabController? tabController;
  int indexTab = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabList.length, vsync: this);
    Future.delayed(Duration.zero, () {
      loyaltyController.getUserPoints();
      loyaltyController.getPendingPointsList();
      loyaltyController.getRedeemStoreList();
      loyaltyController.getCouponList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.blackLabelColor,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Your Collection",
          style: TextStyle(
            fontSize: 25.sp,
            color: AppColors.blackLabelColor,
            fontFamily: "Baskerville",
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          InkWell(
            onTap: () {
             
            },
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.blackLabelColor,
            ),
          ),
          SizedBox(
            width: 18.w,
          ),
        ],
      ),
      body: DefaultTabController(
        length: tabList.length,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Image(
                  width: double.infinity,
                  image: AssetImage(Images.loyaltyBGImage),
                  fit: BoxFit.fitWidth,
                ),
                Image(
                  width: 178.w,
                  height: 178.h,
                  fit: BoxFit.contain,
                  image: const AssetImage(Images.pingCircleImage),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GetBuilder<LoyaltyController>(
                        builder: (userPointsController) {
                      return Text(
                        "${userPointsController.userPoints.value?.points?.vPoints ?? 0}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 50.sp,
                        ),
                      );
                    }),
                    Text(
                      "atoms",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondaryLabelColor,
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        foregroundColor: AppColors.secondaryLabelColor,
                      ),
                      onPressed: () {
                         Navigator.of(Get.context!).push(MaterialPageRoute(
                builder: (context) => const PointTransactions(),
              ));
                      },
                      child: Text(
                        "History",
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 26.h,
            ),
            Container(
              color: AppColors.whiteColor,
              width: double.infinity,
              child: TabBar(
                controller: tabController,
                isScrollable: true,
                indicatorPadding: EdgeInsets.zero,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.blackLabelColor,
                labelPadding:
                    EdgeInsets.symmetric(vertical: 18.h, horizontal: 40.w),
                labelStyle: TextStyle(
                  fontFamily: 'Baskerville',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.h,
                ),
                unselectedLabelColor: AppColors.secondaryLabelColor,
                indicator: ShapeDecoration(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(32),
                      topLeft: Radius.circular(32),
                    ),
                  ),
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
                onTap: (val) {
                  setState(() {
                    indexTab = val;
                  });
                },
                tabs: List.generate(tabList.length, (index) {
                  return Text(
                    tabList[index],
                    maxLines: 1,
                  );
                }),
              ),
            ),
            Flexible(
              child: Container(
                color: const Color(0xffFCAFAF).withOpacity(0.1),
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    PendingPoints(),
                    RedeemStore(),
                    UserCoupons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  changeToTab(String tabName) {
    tabController!.animateTo(tabList.indexOf(tabName));
  }

  @override
  bool get wantKeepAlive => true;
}
