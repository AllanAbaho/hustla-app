import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/screens/find_jobs.dart';
import 'package:active_ecommerce_flutter/screens/jobs.dart';
import 'package:active_ecommerce_flutter/screens/post_job.dart';
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

class JobSectors extends StatefulWidget {
  JobSectors(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.is_finding_job = true,
      this.bottomAppbarIndex})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final bool is_finding_job;
  final BottomAppbarIndex bottomAppbarIndex;

  @override
  _JobSectorsState createState() => _JobSectorsState();
}

class _JobSectorsState extends State<JobSectors> {
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
    String name = 'Job Sectors';

    return name;
  }

  getTravelCategories() {
    var travelCategories = [
      {
        "id": 9,
        "name": "Finance & Accounting",
        "banner": "http://media.monsterindia.com/cmsimages/1562748131.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/3V1JdHwjCE6COPQmG6vlX6oTQ5YjGHPh5ad2MeF7.png",
        "number_of_children": 2,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/9",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/9"
        }
      },
      {
        "id": 10,
        "name": "Law & Compliance",
        "banner":
            "https://thumbor.forbes.com/thumbor/fit-in/900x510/https://www.forbes.com/advisor/wp-content/uploads/2022/10/Paralegal_vs._Lawyer.jpeg.jpg",
        "icon":
            "https://cdn.ucberkeleybootcamp.com/wp-content/uploads/sites/106/2020/08/CDG_blog_post_image_01.jpg",
        "number_of_children": 2,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/9",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/9"
        }
      },
      {
        "id": 11,
        "name": "IT & Telecoms",
        "banner":
            "https://cdn.ucberkeleybootcamp.com/wp-content/uploads/sites/106/2020/08/CDG_blog_post_image_01.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/BteYp028L2ZRXr5eg84NwSx8HOKKRysrjVFKsDnW.png",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/11",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/11"
        },
      },
      {
        "id": 12,
        "name": "Hospitality & Hotels",
        "banner": "https://www.unhcr.org/thumb1/4af8257c6.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/BteYp028L2ZRXr5eg84NwSx8HOKKRysrjVFKsDnW.png",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/11",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/11"
        },
      },
      {
        "id": 13,
        "name": "Manufacturing & Warehousing",
        "banner":
            "https://thumbs.dreamstime.com/b/black-male-african-american-workers-wear-sound-proof-headphones-yellow-helmet-working-iron-cutting-machine-factory-213418200.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/BteYp028L2ZRXr5eg84NwSx8HOKKRysrjVFKsDnW.png",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/11",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/11"
        },
      },
      {
        "id": 14,
        "name": "Health Care",
        "banner":
            "https://www.afro.who.int/sites/default/files/2017-08/WHO_DRC%2520005%5B1%5D.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/BteYp028L2ZRXr5eg84NwSx8HOKKRysrjVFKsDnW.png",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/11",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/11"
        },
      },
      {
        "id": 15,
        "name": "Education",
        "banner":
            "https://a-better-africa.com/show/the-complete-teacher/blog-image/teachers.jpeg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/BteYp028L2ZRXr5eg84NwSx8HOKKRysrjVFKsDnW.png",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/11",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/11"
        },
      },
      {
        "id": 16,
        "name": "Engineering",
        "banner":
            "https://cceonlinenews.com/wp-content/uploads/2021/11/confidence-in-construction-industry.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/BteYp028L2ZRXr5eg84NwSx8HOKKRysrjVFKsDnW.png",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/11",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/11"
        },
      },
      {
        "id": 17,
        "name": "Tourism & Travel",
        "banner":
            "https://www.morawayadventures.com/images/Tanzania/Tarangire_119A.jpg",
        "icon":
            "http://hustlermarkets.com/public/uploads/all/BteYp028L2ZRXr5eg84NwSx8HOKKRysrjVFKsDnW.png",
        "number_of_children": 0,
        "links": {
          "products": "http://hustlermarkets.com/api/v2/products/category/11",
          "sub_categories": "http://hustlermarkets.com/api/v2/sub-categories/11"
        },
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return widget.is_finding_job ? FindJobs() : PostJob();
              },
            ),
          );
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

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      height: widget.is_base_category ? 0 : 80,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 32),
                height: 40,
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.accent_color,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    AppLocalizations.of(context)
                            .category_list_screen_all_products_of +
                        " " +
                        widget.parent_category_name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoryProducts(
                        category_id: widget.parent_category_id,
                        category_name: widget.parent_category_name,
                      );
                    }));
                  },
                ),
              ),
            )
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