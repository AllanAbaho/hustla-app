import 'package:active_ecommerce_flutter/custom/app_bar.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
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
  JobSectors({Key key, this.title, this.is_finding_job}) : super(key: key);

  final String title;
  final bool is_finding_job;

  @override
  _JobSectorsState createState() => _JobSectorsState();
}

class _JobSectorsState extends State<JobSectors> {
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
            child: buildAppBar(context, widget.title),
            preferredSize: Size(
              DeviceInfo(context).width,
              60,
            )),
        body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: buildBody(context, widget.title, _categories)));
  }

  Widget buildDescription(String title) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
              color: AppColors.dashboardColor,
              fontSize: 25,
              height: 2,
              fontWeight: FontWeight.bold),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 8.0, bottom: 50, right: 8.0),
          child: Text(
            'Choose our list of customised categories and avail the services in each.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: MyTheme.font_grey,
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context, String title, List _categories) {
    return CustomScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          buildDescription(title),
          buildCategoryList(context, _categories),
          Container(
            height: 60,
          )
        ]))
      ],
    );
  }

  Widget buildCategoryList(BuildContext context, List travelCategories) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.74,
        crossAxisCount: 2,
      ),
      itemCount: travelCategories.length,
      padding: EdgeInsets.only(left: 18, right: 18, bottom: 30),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return buildCategoryItemCard(context, travelCategories, index);
      },
    );
  }

  Widget buildCategoryItemCard(
      BuildContext context, List travelCategories, int index) {
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
                      'Proceed',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            if (widget.is_finding_job) {
                              return FindJobs(
                                sector: travelCategories[index]['name'],
                                banner: travelCategories[index]['banner'],
                              );
                            } else {
                              return PostJob(
                                  sector: travelCategories[index]['name']);
                            }
                          },
                        ),
                      );
                    }),
              ),
            ),
            Spacer()
          ],
        ),
      ),
    );
  }

  getCategories() {
    var _list = [
      {
        "id": 9,
        "name": "Finance",
        "banner": "http://media.monsterindia.com/cmsimages/1562748131.jpg",
        "description":
            "Please select this option to Proceed about this sector.",
      },
      {
        "id": 10,
        "name": "Law / Compliance",
        "banner":
            "https://thumbor.forbes.com/thumbor/fit-in/900x510/https://www.forbes.com/advisor/wp-content/uploads/2022/10/Paralegal_vs._Lawyer.jpeg.jpg",
        "description":
            "Please select this option to Proceed about this sector.",
      },
      {
        "id": 11,
        "name": "IT / Telecoms",
        "banner":
            "https://cdn.ucberkeleybootcamp.com/wp-content/uploads/sites/106/2020/08/CDG_blog_post_image_01.jpg",
        "description":
            "Please select this option to Proceed about this sector.",
      },
      {
        "id": 12,
        "name": "Hospitality / Hotels",
        "banner": "https://www.unhcr.org/thumb1/4af8257c6.jpg",
        "description":
            "Please select this option to Proceed about this sector.",
      },
      {
        "id": 13,
        "name": "Manufacturing",
        "banner":
            "https://thumbs.dreamstime.com/b/black-male-african-american-workers-wear-sound-proof-headphones-yellow-helmet-working-iron-cutting-machine-factory-213418200.jpg",
        "description":
            "Please select this option to Proceed about this sector.",
      },
      {
        "id": 14,
        "name": "Health Care",
        "banner":
            "https://www.afro.who.int/sites/default/files/2017-08/WHO_DRC%2520005%5B1%5D.jpg",
        "description":
            "Please select this option to Proceed about this sector.",
      },
      {
        "id": 15,
        "name": "Education",
        "banner":
            "https://a-better-africa.com/show/the-complete-teacher/blog-image/teachers.jpeg",
        "description":
            "Please select this option to Proceed about this sector.",
      },
      {
        "id": 16,
        "name": "Engineering",
        "banner":
            "https://cceonlinenews.com/wp-content/uploads/2021/11/confidence-in-construction-industry.jpg",
        "description":
            "Please select this option to Proceed about this sector.",
      },
      {
        "id": 17,
        "name": "Tourism / Travel",
        "banner":
            "https://www.morawayadventures.com/images/Tanzania/Tarangire_119A.jpg",
        "description":
            "Please select this option to Proceed about this sector.",
      },
    ];
    setState(() {
      _categories = _list;
    });
  }
}
