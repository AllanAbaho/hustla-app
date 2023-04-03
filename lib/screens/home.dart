import 'dart:developer';

import 'package:active_ecommerce_flutter/custom/custom_shape.dart';
import 'package:active_ecommerce_flutter/custom/common_functions.dart';
import 'package:active_ecommerce_flutter/custom/device_info.dart';
import 'package:active_ecommerce_flutter/custom/resources.dart';
import 'package:active_ecommerce_flutter/custom/spacers.dart';
import 'package:active_ecommerce_flutter/custom/text.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/presenter/cart_counter.dart';
import 'package:active_ecommerce_flutter/repositories/cart_repository.dart';
import 'package:active_ecommerce_flutter/screens/become_seller.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:active_ecommerce_flutter/screens/finance.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/government.dart';
import 'package:active_ecommerce_flutter/screens/jobs.dart';
import 'package:active_ecommerce_flutter/screens/sacco.dart';
import 'package:active_ecommerce_flutter/screens/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/screens/top_selling_products.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/top_up.dart';
import 'package:active_ecommerce_flutter/screens/travel.dart';
import 'package:active_ecommerce_flutter/screens/web_page.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:active_ecommerce_flutter/repositories/sliders_repository.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:active_ecommerce_flutter/repositories/product_repository.dart';
import 'package:active_ecommerce_flutter/app_config.dart';

import 'package:active_ecommerce_flutter/ui_elements/product_card.dart';
import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:active_ecommerce_flutter/custom/box_decorations.dart';
import 'package:active_ecommerce_flutter/ui_elements/mini_product_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Home extends StatefulWidget {
  Home(
      {Key key,
      this.title,
      this.show_back_button = false,
      go_back = true,
      this.counter})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final CartCounter counter;

  final String title;
  bool show_back_button;
  bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _current_slider = 0;
  ScrollController _allProductScrollController;
  ScrollController _featuredCategoryScrollController;
  ScrollController _mainScrollController = ScrollController();

  AnimationController pirated_logo_controller;
  Animation pirated_logo_animation;

  var _carouselImageList = [];
  var _bannerOneImageList = [];
  var _bannerTwoImageList = [];
  var _featuredCategoryList = [];

  bool _isCategoryInitial = true;

  bool _isCarouselInitial = true;
  bool _isBannerOneInitial = true;
  bool _isBannerTwoInitial = true;

  var _featuredProductList = [];
  bool _isFeaturedProductInitial = true;
  int _totalFeaturedProductData = 0;
  int _featuredProductPage = 1;
  bool _showFeaturedLoadingContainer = false;

  var _allProductList = [];
  bool _isAllProductInitial = true;
  int _totalAllProductData = 0;
  int _allProductPage = 1;
  bool _showAllLoadingContainer = false;
  int _cartCount = 0;

  YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=MNk7vkPWRyA"),
    flags: YoutubePlayerFlags(
      useHybridComposition: false,
      autoPlay: false,
    ),
  );
  YoutubePlayerController _controller2 = YoutubePlayerController(
    initialVideoId: YoutubePlayer.convertUrlToId(
        "https://www.youtube.com/watch?v=BajOpEY6Gko"),
    flags: YoutubePlayerFlags(
      useHybridComposition: false,
      autoPlay: false,
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchAll();

    _mainScrollController.addListener(() {
      if (_mainScrollController.position.pixels ==
          _mainScrollController.position.maxScrollExtent) {
        setState(() {
          _allProductPage++;
        });
        _showAllLoadingContainer = true;
        fetchAllProducts();
      }
    });
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    _controller2.pause();
    super.deactivate();
  }

  getCartCount() async {
    var res = await CartRepository().getCartCount();
    widget.counter.controller.sink.add(res.count);
  }

  fetchAll() {
    getCartCount();

    fetchCarouselImages();
    fetchBannerOneImages();
    fetchBannerTwoImages();
  }

  fetchCarouselImages() async {
    var carouselResponse = await SlidersRepository().getSliders();
    carouselResponse.sliders.forEach((slider) {
      _carouselImageList.add(slider);
    });
    _isCarouselInitial = false;
  }

  fetchBannerOneImages() async {
    var bannerOneResponse = await SlidersRepository().getBannerOneImages();
    bannerOneResponse.sliders.forEach((slider) {
      _bannerOneImageList.add(slider.photo);
    });
    _isBannerOneInitial = false;
    setState(() {});
  }

  fetchBannerTwoImages() async {
    var bannerTwoResponse = await SlidersRepository().getBannerTwoImages();
    bannerTwoResponse.sliders.forEach((slider) {
      _bannerTwoImageList.add(slider.photo);
    });
    _isBannerTwoInitial = false;
    setState(() {});
  }

  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    _featuredCategoryList.addAll(categoryResponse.categories);
    _isCategoryInitial = false;
    setState(() {});
  }

  fetchFeaturedProducts() async {
    var productResponse = await ProductRepository().getFeaturedProducts(
      page: _featuredProductPage,
    );

    _featuredProductList.addAll(productResponse.products);
    _isFeaturedProductInitial = false;
    _totalFeaturedProductData = productResponse.meta.total;
    _showFeaturedLoadingContainer = false;
    setState(() {});
  }

  fetchAllProducts() async {
    var productResponse =
        await ProductRepository().getFilteredProducts(page: _allProductPage);

    _allProductList.addAll(productResponse.products);
    _isAllProductInitial = false;
    _totalAllProductData = productResponse.meta.total;
    _showAllLoadingContainer = false;
    setState(() {});
  }

  reset() {
    _carouselImageList.clear();
    _bannerOneImageList.clear();
    _bannerTwoImageList.clear();
    _featuredCategoryList.clear();

    _isCarouselInitial = true;
    _isBannerOneInitial = true;
    _isBannerTwoInitial = true;
    _isCategoryInitial = true;
    _cartCount = 0;

    setState(() {});

    resetFeaturedProductList();
    resetAllProductList();
  }

  Future<void> _onRefresh() async {
    access_token.load().whenComplete(() {
      AuthHelper().fetch_and_set();
    });

    reset();
    fetchAll();
  }

  resetFeaturedProductList() {
    _featuredProductList.clear();
    _isFeaturedProductInitial = true;
    _totalFeaturedProductData = 0;
    _featuredProductPage = 1;
    _showFeaturedLoadingContainer = false;
    setState(() {});
  }

  resetAllProductList() {
    _allProductList.clear();
    _isAllProductInitial = true;
    _totalAllProductData = 0;
    _allProductPage = 1;
    _showAllLoadingContainer = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: AppColors.dashboardColor,
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            color: AppColors.appBarColor,
            child: Image.asset(
              'assets/images/hustla_logo.png',
              height: 130,
            ),
          ),
        ),
        //drawer: MainDrawer(),
        body: Stack(
          children: [
            // RefreshIndicator(
            //   color: MyTheme.dark_font_grey,
            //   backgroundColor: Colors.white,
            //   onRefresh: _onRefresh,
            //   displacement: 0,
            //   child:
            CustomScrollView(
              controller: _mainScrollController,
              // physics: const BouncingScrollPhysics(
              //     parent: AlwaysScrollableScrollPhysics()),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 10, right: 10, bottom: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          color: MyTheme.white, width: 1),
                                      //shape: BoxShape.rectangle,
                                    ),
                                    child: ClipRRect(
                                        clipBehavior: Clip.hardEdge,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100.0)),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/placeholder.png',
                                          image: "${avatar_original.$}",
                                          fit: BoxFit.fill,
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        MediumText(
                                          'Full Name',
                                        ),
                                        SmallText(
                                          user_name.$,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 190.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MediumText(
                                  'Wallet ID',
                                ),
                                SmallText(
                                  account_number.$,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppColors.brandColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withOpacity(.2),
                              blurRadius: 20,
                              spreadRadius: 00.0,
                              offset: Offset(
                                  0.0, 10.0), // shadow direction: bottom right
                            )
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          // border: Border.all(
                          //     color: MyTheme.light_grey, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  MediumText(
                                    'Available Balance',
                                    color: Colors.white,
                                  ),
                                  VSpace.sm,
                                  MediumText(
                                    '${account_balance.$} (Ksh)',
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            // HSpace.lg,
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, right: 8),
                                  child: SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TopUp(title: 'Add Credit');
                                        }));
                                      },
                                      // ignore: sort_child_properties_last
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, right: 8.0),
                                        child: SmallText(
                                          'Add Credit',
                                          color: Colors.black,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // <-- Radius
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 12, bottom: 8, left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          MediumText(
                            'Hustla Categories',
                          ),
                          SmallText('View More >>>')
                        ],
                      ),
                    ),
                    hustlaCategories(context),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12, left: 10),
                                    child: Row(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        MediumText('Hustla News',
                                            color: Colors.black),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, left: 10),
                                    child: hustlerBlog(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 10),
                                    child: Row(
                                      // ignore: prefer_const_literals_to_create_immutables
                                      children: [
                                        MediumText(
                                          'Advertise with us',
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, bottom: 80),
                                    child: buildHomeCarouselSlider(context),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
            // ),
          ],
        ));
  }

  Widget hustlaCategories(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 0.11 * screenHeight,
      child: ListView(
        itemExtent: screenWidth / 6,
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BecomeSeller(
                  title: 'Become Seller',
                );
              }));
            },
            child: iconText('assets/images/marketplace.png', 'My Shop'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Finance(
                  title: 'Financial Services',
                );
              }));
            },
            child: iconText('assets/images/finance.png', 'Finance'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Jobs(
                  title: 'Job Services',
                );
              }));
            },
            child: iconText('assets/images/finance.png', 'Jobs'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Government(
                  title: 'Government Services',
                );
              }));
            },
            child: iconText('assets/images/marketplace.png', 'E-Gov'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Sacco(
                  title: 'Sacco Services',
                );
              }));
            },
            child: iconText('assets/images/sacco.png', 'Sacco'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Travel(
                  title: 'Travel Services',
                );
              }));
            },
            child: iconText('assets/images/cab.png', 'Travel'),
          ),
          GestureDetector(
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return Travel(
              //     title: 'Bills',
              //   );
              // }));
            },
            child: iconText('assets/images/cab.png', 'Bills'),
          ),
        ],
      ),
    );
  }

  Widget iconText(String image, String title) {
    return Column(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.brandColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              image,
              height: 50,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: SmallText(
            title,
          ),
        ),
      ],
    );
  }

  Widget hustlerBlog() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: YoutubePlayer(
                controller: _controller2,
                bottomActions: [],
              ),
            ),
          ),
          HSpace.md,
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Image.asset(
              'assets/images/ruto_news.png',
              fit: BoxFit.fill,
            ),
          ),
          HSpace.md,
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: YoutubePlayer(
                controller: _controller,
                bottomActions: [],
              ),
            ),
          ),
          HSpace.md,
        ],
      ),
    );
  }

  Widget buildHomeCarouselSlider(context) {
    if (_isCarouselInitial && _carouselImageList.length == 0) {
      return Padding(
          padding: const EdgeInsets.all(8),
          child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (_carouselImageList.length > 0) {
      return CarouselSlider(
        options: CarouselOptions(
            aspectRatio: 338 / 140,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            autoPlayAnimationDuration: Duration(milliseconds: 1000),
            autoPlayCurve: Curves.easeInExpo,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current_slider = index;
              });
            }),
        items: _carouselImageList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Stack(
                  children: <Widget>[
                    Container(
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: InkWell(
                              onTap: () {
                                if (i.link != null) {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    // return DepositPage('Deposit Money');
                                    return WebPage(url: i.link);
                                  }));
                                }
                              },
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/placeholder_rectangle.png',
                                image: i.photo,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ))),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: _carouselImageList.map((url) {
                    //       int index = _carouselImageList.indexOf(url);
                    //       return Container(
                    //         width: 7.0,
                    //         height: 7.0,
                    //         margin: EdgeInsets.symmetric(
                    //             vertical: 10.0, horizontal: 4.0),
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: _current_slider == index
                    //               ? MyTheme.white
                    //               : Color.fromRGBO(112, 112, 112, .3),
                    //         ),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      );
    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).home_screen_no_carousel_image_found,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  _launchURL(String link) async {
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $link';
    }
  }

  Widget buildHomeBannerOne(context) {
    if (_isBannerOneInitial && _bannerOneImageList.length == 0) {
      return Padding(
          padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 20),
          child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (_bannerOneImageList.length > 0) {
      return Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 270 / 120,
              viewportFraction: .75,
              initialPage: 0,
              padEnds: false,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current_slider = index;
                });
              }),
          items: _bannerOneImageList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 9.0, right: 9, top: 20.0, bottom: 20),
                  child: Container(
                      //color: Colors.amber,
                      width: double.infinity,
                      decoration: BoxDecorations.buildBoxDecoration_1(),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: i,
                            fit: BoxFit.cover,
                          ))),
                );
              },
            );
          }).toList(),
        ),
      );
    } else if (!_isBannerOneInitial && _bannerOneImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).home_screen_no_carousel_image_found,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  Widget buildHomeBannerTwo(context) {
    if (_isBannerTwoInitial && _bannerTwoImageList.length == 0) {
      return Padding(
          padding:
              const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 10),
          child: ShimmerHelper().buildBasicShimmer(height: 120));
    } else if (_bannerTwoImageList.length > 0) {
      return Padding(
        padding: app_language_rtl.$
            ? const EdgeInsets.only(right: 9.0)
            : const EdgeInsets.only(left: 9.0),
        child: CarouselSlider(
          options: CarouselOptions(
              aspectRatio: 270 / 120,
              viewportFraction: 0.7,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.easeInExpo,
              enlargeCenterPage: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current_slider = index;
                });
              }),
          items: _bannerTwoImageList.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 9.0, right: 9, top: 20.0, bottom: 10),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecorations.buildBoxDecoration_1(),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder_rectangle.png',
                            image: i,
                            fit: BoxFit.fill,
                          ))),
                );
              },
            );
          }).toList(),
        ),
      );
    } else if (!_isCarouselInitial && _carouselImageList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).home_screen_no_carousel_image_found,
            style: TextStyle(color: MyTheme.font_grey),
          )));
    } else {
      // should not be happening
      return Container(
        height: 100,
      );
    }
  }

  buildHomeSearchBox(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecorations.buildBoxDecoration_1(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context).home_screen_search,
              style: TextStyle(fontSize: 13.0, color: MyTheme.textfield_grey),
            ),
            Image.asset(
              'assets/search.png',
              height: 16,
              //color: MyTheme.dark_grey,
              color: MyTheme.dark_grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildProductLoadingContainer() {
    return Container(
      height: _showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(_totalAllProductData == _allProductList.length
            ? AppLocalizations.of(context).common_no_more_products
            : AppLocalizations.of(context).common_loading_more_products),
      ),
    );
  }

  @override
  void dispose() {
    pirated_logo_controller?.dispose();
    _mainScrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
