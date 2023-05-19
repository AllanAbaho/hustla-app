import 'package:hustla/custom/box_decorations.dart';
import 'package:hustla/custom/device_info.dart';
import 'package:hustla/custom/resources.dart';
import 'package:hustla/custom/spacers.dart';
import 'package:hustla/custom/text.dart';
import 'package:hustla/helpers/shared_value_helper.dart';
import 'package:hustla/my_theme.dart';
import 'package:flutter/material.dart';

Widget buildDescription(String title,
    {String description =
        'Choose our list of customised categories and avail the services in each.'}) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(
            color: AppColors.dashboardColor,
            fontSize: 25,
            height: 2,
            fontWeight: FontWeight.w300),
      ),
      Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 8.0, bottom: 20, right: 8.0),
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: MyTheme.font_grey,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w300),
        ),
      ),
    ],
  );
}

Widget buildBody(BuildContext context, String title, List _categories,
    {extraWidget}) {
  return CustomScrollView(
    physics: AlwaysScrollableScrollPhysics(),
    slivers: [
      SliverList(
          delegate: SliverChildListDelegate([
        buildDescription(title),
        extraWidget ?? Container(),
        buildCategoryList(context, _categories),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8.0),
            child: Text(
              travelCategories[index]['name'],
              // textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  color: AppColors.dashboardColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w300),
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
                  fontWeight: FontWeight.w300),
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
                        fontWeight: FontWeight.w300),
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

Widget buildAccountWidget() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.dashboardColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: MyTheme.light_grey, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                MediumText(
                  'ABC EMPOWERMENT SACCO LIMITED',
                  color: Colors.white,
                ),
                VSpace.sm,
                MediumText(
                  '${account_balance.$} (Ksh)',
                  color: MyTheme.accent_color,
                ),
              ],
            ),
          ),
          // HSpace.lg,
        ],
      ),
    ),
  );
}
