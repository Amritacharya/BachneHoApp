import 'package:Bechneho/account_bloc/account_bloc_bloc.dart';
import 'package:Bechneho/account_bloc/index.dart';
import 'package:Bechneho/advertisement/advertisement_bloc.dart';
import 'package:Bechneho/advertisement/index.dart';
import 'package:Bechneho/model/product.dart';
import 'package:Bechneho/ui/other_profile.dart';
import 'package:Bechneho/utils/utils.dart';
import 'package:Bechneho/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page_home.dart';
import '../page_profile.dart';

class AdvertisementReviewPage extends StatefulWidget {
  final Advertisement product;
  final AdvertisementBloc advertisementBloc;
  AdvertisementReviewPage({this.product, this.advertisementBloc});
  @override
  _AdvertisementReviewPageState createState() =>
      _AdvertisementReviewPageState();
}

class _AdvertisementReviewPageState extends State<AdvertisementReviewPage>
    with TickerProviderStateMixin {
  AdvertisementBloc get _advertisementBloc => widget.advertisementBloc;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvertisementBloc, AdvertisementState>(builder: (
      BuildContext context,
      AdvertisementState state,
    ) {
      if (state is CreateFailure) {
        _onWidgetDidBuild(() {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('An Error Occurred!'),
                content: Text("${state.error}"),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        });
      }
      if (state is CreateAdFinished) {
        return HomePage();
      }
      return Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: true,
          body: _buildProductDetailsPage(context, state));
    });
  }

  _buildProductDetailsPage(BuildContext context, AdvertisementState state) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnnotatedRegion(
        value: SystemUiOverlayStyle(
            statusBarColor: backgroundColor,
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: backgroundColor),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                upperPart(),
                Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          FloatingActionButton.extended(
                            onPressed: () => Navigator.of(context).pop(),
                            label: Text('Discard'),
                            icon: Icon(Icons.close),
                            backgroundColor: Colors.red,
                          ),
                          FloatingActionButton.extended(
                            onPressed: state is! InAdvertisementState
                                ? _onCreateButtonPresseed
                                : null,
                            label: Text('Post'),
                            icon: Icon(Icons.file_upload),
                            backgroundColor: Colors.green,
                          ),
                        ])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget upperPart() {
    var size = Screen(MediaQuery.of(context).size);
    Size screenSize = MediaQuery.of(context).size;

    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: UpperClipper(),
          child: Container(
            height: size.getWidthPx(200),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorCurve, colorCurveSecondary],
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: size.getWidthPx(36)),
              child: Column(
                children: <Widget>[
                  titleWidget(),
                  SizedBox(height: size.getWidthPx(10)),
                ],
              ),
            ),
            SizedBox(height: size.getWidthPx(20)),
            Card(
              margin: const EdgeInsets.all(4.0),
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildProductImagesWidgets(),
                  _buildProductTitleWidget(),
                  SizedBox(height: 12.0),
                  _buildPriceWidgets(),
                  SizedBox(height: 12.0),
                  _buildDivider(screenSize),
                  SizedBox(height: 12.0),
                  _buildDivider(screenSize),
                  SizedBox(height: 12.0),
                  _buildSizeChartWidgets(),
                  SizedBox(height: 12.0),
                  _buildDetailsAndMaterialWidgets(),
                  SizedBox(height: 12.0)
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  _buildDivider(Size screenSize) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey[600],
          width: screenSize.width,
          height: 0.25,
        ),
      ],
    );
  }

  _buildProductImagesWidgets() {
    TabController imagesController = TabController(length: 10, vsync: this);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 250.0,
        child: Center(
          child: DefaultTabController(
            length: 10,
            child: Stack(
              children: <Widget>[
                TabBarView(
                  controller: imagesController,
                  children: <Widget>[
                    Image.file(
                      widget.product.image1,
                      fit: BoxFit.contain,
                    ),
                    widget.product.image2 == null
                        ? Image.file(
                            widget.product.image1,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            widget.product.image2,
                            fit: BoxFit.contain,
                          ),
                    widget.product.image3 == null
                        ? Image.file(
                            widget.product.image1,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            widget.product.image3,
                            fit: BoxFit.contain,
                          ),
                    widget.product.image4 == null
                        ? Image.file(
                            widget.product.image1,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            widget.product.image4,
                            fit: BoxFit.contain,
                          ),
                    widget.product.image5 == null
                        ? Image.file(
                            widget.product.image1,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            widget.product.image5,
                            fit: BoxFit.contain,
                          ),
                    widget.product.image6 == null
                        ? Image.file(
                            widget.product.image1,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            widget.product.image6,
                            fit: BoxFit.contain,
                          ),
                    widget.product.image7 == null
                        ? Image.file(
                            widget.product.image1,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            widget.product.image7,
                            fit: BoxFit.contain,
                          ),
                    widget.product.image8 == null
                        ? Image.file(
                            widget.product.image1,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            widget.product.image8,
                            fit: BoxFit.contain,
                          ),
                    widget.product.image9 == null
                        ? Image.file(
                            widget.product.image1,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            widget.product.image9,
                            fit: BoxFit.contain,
                          ),
                    widget.product.image10 == null
                        ? Image.file(
                            widget.product.image1,
                            fit: BoxFit.contain,
                          )
                        : Image.file(
                            widget.product.image10,
                            fit: BoxFit.contain,
                          ),
                  ],
                ),
                Container(
                  alignment: FractionalOffset(0.5, 0.95),
                  child: TabPageSelector(
                    controller: imagesController,
                    selectedColor: Colors.grey,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildProductTitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Center(
        child: Text(
          //name,
          "${widget.product.ad_title}",
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
      ),
    );
  }

  _buildPriceWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Rs. ${widget.product.price}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Exo2",
                color: Colors.red),
          ),
        ],
      ),
    );
  }

  _buildSizeChartWidgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.straighten,
                color: Colors.grey[600],
              ),
              SizedBox(
                width: 12.0,
              ),
              Text(
                "Product Availability",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Text(
            "${widget.product.ad_validity}",
            style: TextStyle(
              color: Colors.blue[400],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildDetailsAndMaterialWidgets() {
    TabController tabController = new TabController(length: 2, vsync: this);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: <Widget>[
              Tab(
                child: Text(
                  " PRODUCT DETAILS",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "TERMS & CONDITIONS",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
            height: 150,
            child: TabBarView(
              controller: tabController,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Category: ${widget.product.subcategory}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                    Text(
                      "${widget.product.description}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                    Text(
                      "Condition: ${widget.product.condition}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                    Text(
                      "Used for:${widget.product.used_for}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Negotiable: ${widget.product.negotiable}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                    Text(
                      "Home Delivery: ${widget.product.home_delivery}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                    Text(
                      "Delivery Areas: ${widget.product.delivery_areas}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                    Text(
                      "Delivery Charge: ${widget.product.delivery_charges}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                    Text(
                      "Warranty type: ${widget.product.warranty_type}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                    Text(
                      "Warranty Period: ${widget.product.warranty_period}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    ),
                    Text(
                      "Warranty Includes: ${widget.product.warranty_includes}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Exo2"),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text titleWidget() {
    return Text("${widget.product.ad_title}",
        style: TextStyle(
            fontFamily: 'Exo2',
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
            color: Colors.white));
  }

  _onCreateButtonPresseed() {
    print(widget.product.ad_validity + " hello");
    _advertisementBloc.add(ButtonPressed(
        image1: widget.product.image1,
        image2: widget.product.image2,
        image3: widget.product.image3,
        image4: widget.product.image4,
        image5: widget.product.image5,
        image6: widget.product.image6,
        image7: widget.product.image7,
        image8: widget.product.image8,
        image9: widget.product.image9,
        image10: widget.product.image10,
        subcategory: widget.product.subcategory,
        ad_title: widget.product.ad_title,
        description: widget.product.description,
        ad_validity: widget.product.ad_validity,
        price: widget.product.price,
        negotiable: widget.product.negotiable,
        condition: widget.product.condition,
        used_for: widget.product.used_for,
        home_delivery: widget.product.home_delivery,
        delivery_areas: widget.product.delivery_areas,
        delivery_charges: widget.product.delivery_charges,
        warranty_type: widget.product.warranty_type,
        warranty_period: widget.product.warranty_period,
        warranty_includes: widget.product.warranty_includes,
        zone: widget.product.zone,
        district: widget.product.district));
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}
