import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/page_description.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/dummy_data/single_product.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/screens/send_money.dart';
import 'package:active_ecommerce_flutter/screens/top_up.dart';
import 'package:active_ecommerce_flutter/screens/withraw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Finance extends StatefulWidget {
  Finance(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.bottomAppbarIndex,
      this.title})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final String title;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex bottomAppbarIndex;

  @override
  _FinanceState createState() => _FinanceState();
}

class _FinanceState extends State<Finance> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List _categories = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: buildAppBar(context),
            preferredSize: Size(
              DeviceInfo(context).width,
              60,
            )),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: buildBody(),
        ));
  }

  Widget buildBody() {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          buildDescription(widget.title),
          buildCategoryList(_categories),
          Container(
            height: widget.is_base_category ? 60 : 90,
          )
        ]))
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.dashboardColor,
      //centerTitle: true,
      leading: widget.is_base_category
          ? Builder(
              builder: (context) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                child: UsefulElements.backToMain(context,
                    go_back: false, color: "white"),
              ),
            )
          : Builder(
              builder: (context) => IconButton(
                icon: Icon(CupertinoIcons.arrow_left, color: MyTheme.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      title: Text(
        widget.title,
        style: TextStyle(
            fontSize: 16, color: MyTheme.white, fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  getCategories() {
    var _list = [
      {
        "id": 0,
        "name": "Send Money",
        "banner":
            "https://www.dignited.com/wp-content/uploads/2018/12/Mobile-Money-Transfer-And-Mobile-Money-Transfer-Service-1200x800-1024x683.jpg",
        "description": "Send via mobile money, your wallet, or bank transfer.",
        "page": SendMoney(),
      },
      {
        "id": 1,
        "name": "Add Credit",
        "banner":
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMkJEivNrYTNeSi-vKI0aXoaQViWclE9Ewgw&usqp=CAU",
        "description": "Move money from your mobile money number to wallet.",
        "page": TopUp(),
      },
      {
        "id": 2,
        "name": "Withdaw Money",
        "banner":
            "https://www.nerdwallet.com/assets/blog/wp-content/uploads/2015/05/atm-eats-deposit-contact-financial-institution-immediately-story.jpg",
        "description":
            "Convert your wallet funds to cash at the nearest agent point.",
        "page": Withdraw(),
      },
    ];
    setState(() {
      _categories = _list;
    });
    ;
  }

  Widget buildCategoryList(List travelCategories) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 30,
        crossAxisSpacing: 30,
        childAspectRatio: 0.75,
        crossAxisCount: 2,
      ),
      itemCount: travelCategories.length,
      padding: EdgeInsets.only(
          left: 18, right: 18, bottom: widget.is_base_category ? 30 : 0),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return buildCategoryItemCard(travelCategories, index);
      },
    );
  }

  Widget buildCategoryItemCard(travelCategories, index) {
    var itemWidth = ((DeviceInfo(context).width - 36) / 3);
    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: itemWidth - 28),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(6), topLeft: Radius.circular(6)),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
                  image: travelCategories[index]['banner'],
                  fit: BoxFit.cover,
                  height: itemWidth,
                  width: DeviceInfo(context).width,
                ),
              ),
            ),
            Container(
              // alignment: Alignment.center,
              width: DeviceInfo(context).width,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8.0),
              child: Text(
                travelCategories[index]['name'],
                // textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    color: AppColors.dashboardColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: DeviceInfo(context).width,
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Text(
                travelCategories[index]['description'],
                // textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                    color: MyTheme.font_grey,
                    fontSize: 10,
                    height: 1.6,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
              child: Container(
                height: 30,
                child: FlatButton(
                    minWidth: MediaQuery.of(context).size.width * 0.5,
                    disabledColor: MyTheme.grey_153,
                    color: AppColors.dashboardColor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6.0))),
                    child: Text(
                      'Know More',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      if (travelCategories[index]['page'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return travelCategories[index]['page'];
                            },
                          ),
                        );
                      }
                    }),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }

  Widget buildShimmer() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1,
        crossAxisCount: 3,
      ),
      itemCount: 18,
      padding: EdgeInsets.only(
          left: 18, right: 18, bottom: widget.is_base_category ? 30 : 0),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecorations.buildBoxDecoration_1(),
          child: ShimmerHelper().buildBasicShimmer(),
        );
      },
    );
  }
}
