import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/useful_elements.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_flutter/repositories/job_repository.dart';
import 'package:active_ecommerce_flutter/screens/apply_job.dart';
import 'package:active_ecommerce_flutter/screens/job_sectors.dart';
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

import '../data_model/job_response.dart';

class JobDescription extends StatefulWidget {
  JobDescription(
      {Key key,
      this.parent_category_id = 0,
      this.parent_category_name = "",
      this.is_base_category = false,
      this.is_top_category = false,
      this.bottomAppbarIndex,
      this.banner,
      this.sector,
      this.job})
      : super(key: key);

  final int parent_category_id;
  final String parent_category_name;
  final bool is_base_category;
  final bool is_top_category;
  final BottomAppbarIndex bottomAppbarIndex;
  final String banner;
  final String sector;
  final Job job;

  @override
  _JobDescriptionState createState() => _JobDescriptionState();
}

class _JobDescriptionState extends State<JobDescription> {
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
    String name = 'Job: ${widget.job.name}';
    return name;
  }

  buildCategoryList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.54,
        crossAxisCount: 1,
      ),
      itemCount: 1,
      padding: EdgeInsets.only(left: 18, right: 18, bottom: 30),
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return buildCategoryItemCard(widget.job, index);
      },
    );
  }

  Widget buildCategoryItemCard(Job job, index) {
    var itemWidth = ((DeviceInfo(context).width - 36));

    return Container(
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Position: ${job.name}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sector: ${job.category}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text(
              'Duration: ${job.duration}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text(
              'Location: ${job.location}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text(
              'Type: ${job.type}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text(
              'Deadline: ${job.deadline}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text(
              'Status: ${job.status}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Description',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyTheme.font_grey,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                job.description,
                style: TextStyle(
                    color: MyTheme.font_grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w100),
              ),
            ),
          ),
          Visibility(
            visible: job.status == 'Open' ? true : false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 45,
                child: FlatButton(
                    minWidth: MediaQuery.of(context).size.width,
                    disabledColor: MyTheme.grey_153,
                    //height: 50,
                    color: MyTheme.accent_color,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6.0))),
                    child: Text(
                      'Apply',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ApplyJob(job: job);
                          },
                        ),
                      );
                    }),
              ),
            ),
          ),
        ],
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
