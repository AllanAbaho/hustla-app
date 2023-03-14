import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/screens/to_bank.dart';
import 'package:active_ecommerce_flutter/screens/to_mobile.dart';
import 'package:active_ecommerce_flutter/screens/to_wallet.dart';
import 'package:active_ecommerce_flutter/screens/top_up.dart';
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

class Banks extends StatefulWidget {
  Banks(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.bottomAppbarIndex})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex bottomAppbarIndex;

  @override
  _BanksState createState() => _BanksState();
}

class _BanksState extends State<Banks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          buildCategoryList(),
          Container(
            height: widget.is_base_category ? 60 : 90,
          )
        ]))
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.accent_color,
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
        getAppBarTitle(),
        style: TextStyle(
            fontSize: 16, color: MyTheme.white, fontWeight: FontWeight.bold),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = 'Banks';

    return name;
  }

  getTravelCategories() {
    var travelCategories = [
      {
        "id": 9,
        "name": "KCB",
        "banner":
            "https://financialallianceforwomen.org/wp-content/uploads/2016/11/kcb-e1480436893425.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/3V1JdHwjCE6COPQmG6vlX6oTQ5YjGHPh5ad2MeF7.png",
        "number_of_children": 2,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/9",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/9"
        },
        "page": ToBank(),
      },
      {
        "id": 11,
        "name": "Equity Bank",
        "banner":
            "https://equitygroupholdings.com/ug/templates/equity/assets/img/equity-bank-logo.png",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/BteYp028L2ZRXr5eg84NwSx8HOKKRysrjVFKsDnW.png",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/11",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/11"
        },
        "page": ToBank(),
      },
      {
        "id": 16,
        "name": "ABSA",
        "banner":
            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/de/ABSA_Group_Limited_Logo.svg/1200px-ABSA_Group_Limited_Logo.svg.png",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
      {
        "id": 1,
        "name": "Standard Chartered Bank",
        "banner":
            "https://av.sc.com/corp-en/content/images/Lockup-MonoBlack-thumbnail-278x220.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
      {
        "id": 2,
        "name": "National Bank",
        "banner": "https://images.africanfinancials.com/ke-nbk-logo-min.png",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
      {
        "id": 3,
        "name": "Diamond Trust Bank",
        "banner": "https://images.africanfinancials.com/ke-dtk-logo-min.png",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
      {
        "id": 4,
        "name": "Stanbic Bank",
        "banner":
            "https://www.tenderyetu.com/wp-content/uploads/2022/01/STANBIC-BANK-KENYA-LIMITED-tender-2022.png",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
      {
        "id": 5,
        "name": "Commercial Bank of Africa",
        "banner":
            "https://res.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_170,w_170,f_auto,b_white,q_auto:eco,dpr_1/v1494424636/xgezxjd9ogjxwwrhozps.png",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
      {
        "id": 6,
        "name": "Bank of Africa",
        "banner":
            "https://fresherjobsuganda.com/wp-content/uploads/2022/02/Bank-of-Africa.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
      {
        "id": 7,
        "name": "Prime Bank",
        "banner":
            "https://www.businesslist.co.ke/img/ke/j/1656409333-25-prime-bank-ltd-head-office.png",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
      {
        "id": 8,
        "name": "Trans National Bank",
        "banner":
            "http://covered.co.ke/blog/wp-content/uploads/2017/02/welcomeP.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
      {
        "id": 10,
        "name": "I & M Bank",
        "banner":
            "https://res.cloudinary.com/crunchbase-production/image/upload/c_lpad,f_auto,q_auto:eco,dpr_1/v1465885047/jxgzemkhfpwn2f684fr5.png",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/w65DPieTu3ZUq6rMPnzExVwx8ZVRp5LQA0sGwaCN.jpg",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/16",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/16"
        },
        "page": ToBank(),
      },
    ];
    return travelCategories;
  }

  buildCategoryList() {
    var travelCategories = getTravelCategories();
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.7,
        crossAxisCount: 3,
      ),
      itemCount: travelCategories.length,
      padding: EdgeInsets.only(
          left: 18, right: 18, bottom: widget.is_base_category ? 30 : 30),
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
    print(itemWidth);

    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: InkWell(
        onTap: () {
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
        },
        child: Container(
          //padding: EdgeInsets.all(8),
          //color: Colors.amber,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxHeight: itemWidth - 28),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(6),
                      topLeft: Radius.circular(6)),
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
                height: 60,
                //color: Colors.amber,
                alignment: Alignment.center,
                width: DeviceInfo(context).width,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  travelCategories[index]['name'],
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 10,
                      height: 1.6,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
