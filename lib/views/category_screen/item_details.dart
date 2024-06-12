import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/lists.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:emart_app/views/cart_screen/cart_screen.dart';
import 'package:emart_app/views/chat_screen/chat_screen.dart';
import 'package:emart_app/widgets_common/our_button.dart';
import 'package:get/get.dart';

import '../../services/firestore_services.dart';
import '../../widgets_common/loading_indicator.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;

  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();

    return WillPopScope(
      onWillPop: () async {
        controller.resetValues();
        return true;
      },
      child: Scaffold(
        backgroundColor: lightGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              controller.resetValues();
              Get.back();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(const CartScreen());
                },
                icon: const Icon(
                  Icons.shopping_cart,
                )),
            // IconButton(
            //     onPressed: () {},
            //     icon: const Icon(
            //       Icons.share,
            //     )),
            Obx(
              () => IconButton(
                  onPressed: () {
                    if (controller.isFav.value) {
                      controller.removeFromWishlist(data.id, context);
                      controller.isFav(false);
                    } else {
                      controller.addToWishlist(data.id, context);
                      controller.isFav(true);
                    }
                  },
                  icon: Icon(
                    Icons.favorite_outlined,
                    color: controller.isFav.value ? redColor : darkFontGrey,
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  //swiper section
                  VxSwiper.builder(
                      autoPlay: true,
                      height: 350,
                      itemCount: data['p_imgs'].length,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.0,
                      itemBuilder: (context, index) {
                        return Image.network(
                          data["p_imgs"][index],
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      }),

                  10.heightBox,
                  //title and details section
                  title!.text.size(16).color(darkFontGrey).fontFamily(semibold).make(),
                  10.heightBox,
                  //rating
                  VxRating(
                    isSelectable: false,
                    value: double.parse(data['p_rating']),
                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    selectionColor: golden,
                    count: 5,
                    size: 25,
                    maxRating: 5,
                  ),

                  10.heightBox,
                  "${data['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(18).make(),

                  10.heightBox,

                  Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Seller".text.white.fontFamily(semibold).make(),
                          5.heightBox,
                          "${data['p_seller']}".text.fontFamily(semibold).color(darkFontGrey).size(16).make(),
                        ],
                      )),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.message_rounded,
                          color: darkFontGrey,
                        ),
                      ).onTap(() {
                        Get.to(
                          () => const ChatScreen(),
                          arguments: [data['p_seller'], data['vendor_id']],
                        );
                      })
                    ],
                  ).box.height(60).padding(const EdgeInsets.symmetric(horizontal: 16)).color(textfieldGrey).make(),

                  //color selection
                  20.heightBox,
                  Obx(
                    () => Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: "Color: ".text.color(textfieldGrey).make(),
                            ),
                            Obx(
                              () => Row(
                                children: List.generate(
                                  data['p_colors'].length,
                                  (index) => Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      VxBox()
                                          .size(40, 40)
                                          .roundedFull
                                          .color(Color(data['p_colors'][index]).withOpacity(1.0))
                                          .margin(const EdgeInsets.symmetric(horizontal: 4))
                                          .make()
                                          .onTap(() {
                                        controller.changeColorIndex(index);
                                      }),
                                      Visibility(
                                        visible: index == controller.colorIndex.value,
                                        child: const Icon(Icons.done, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ).box.padding(const EdgeInsets.all(8)).make(),

                        //quantity row
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: "Quantity: ".text.color(textfieldGrey).make(),
                            ),
                            Obx(
                              () => Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        controller.decreaseQuantity();
                                        controller.calculateTotalPrice(int.parse(data['p_price']));
                                      },
                                      icon: const Icon(Icons.remove)),
                                  controller.quantity.value.text.size(16).color(darkFontGrey).fontFamily(bold).make(),
                                  IconButton(
                                      onPressed: () {
                                        controller.increaseQuantity(int.parse(data['p_quantity']));
                                        controller.calculateTotalPrice(int.parse(data['p_price']));
                                      },
                                      icon: const Icon(Icons.add)),
                                  10.widthBox,
                                  "(${data['p_quantity']} available)".text.color(textfieldGrey).make(),
                                ],
                              ),
                            ),
                          ],
                        ).box.padding(const EdgeInsets.all(8)).make(),

                        //total row
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: "Total: ".text.color(textfieldGrey).make(),
                            ),
                            "${controller.totalPrice.value}".numCurrency.text.color(redColor).size(16).fontFamily(bold).make(),
                          ],
                        ).box.padding(const EdgeInsets.all(8)).make(),
                      ],
                    ).box.white.shadowSm.make(),
                  ),
                  //description section
                  10.heightBox,
                  "Description".text.color(darkFontGrey).fontFamily(semibold).make(),
                  10.heightBox,
                  "${data['p_desc']}".text.color(darkFontGrey).make(),

                  //buttons section
                  10.heightBox,
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: List.generate(
                        itemDetailButtonsList.length,
                        (index) => ListTile(
                              title: itemDetailButtonsList[index].text.fontFamily(semibold).color(darkFontGrey).make(),
                              trailing: const Icon(Icons.arrow_forward),
                            )),
                  ),
                  20.heightBox,

                  //products may like section
                  productsyoumaylike.text.fontFamily(bold).size(16).color(darkFontGrey).make(),
                  10.heightBox,

                  //i copied this widget from home screen featured products
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: StreamBuilder(
                        stream: FirestoreServices.allproducts(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return loadingIndicator();
                          } else {
                            var allproductsdata = snapshot.data!.docs;
                           return Row(
                              children: List.generate(
                                allproductsdata.length,
                                    (index) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.network(
                                      allproductsdata[index]['p_imgs'][0],
                                      width: 150,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                    10.heightBox,
                                    "${allproductsdata[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                    10.heightBox,
                                    "${allproductsdata[index]['p_price']}".text.color(redColor).fontFamily(bold).size(16).make(),
                                  ],
                                ).box.margin(const EdgeInsets.symmetric(horizontal: 4)).white.roundedSM.padding(const EdgeInsets.all(8)).make()..onTap(() {
                                      Get.to(() => ItemDetails(
                                        title: "${allproductsdata[index]['p_name']}",
                                        data: allproductsdata[index],
                                      ));
                                    }),
                              ),
                            );
                          }
                        }),
                  ),
                ]),
              ),
            )),
            //bottom add to  cart button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: redColor,
                onPress: () {
                  if (controller.quantity.value > 0) {
                    controller.addToCart(
                        color: data['p_colors'][controller.colorIndex.value],
                        context: context,
                        vendorID: data['vendor_id'],
                        img: data['p_imgs'][0],
                        qty: controller.quantity.value,
                        sellername: data['p_seller'],
                        title: data['p_name'],
                        tprice: controller.totalPrice.value);
                    VxToast.show(context, msg: "Added to cart");
                  } else {
                    VxToast.show(context, msg: "Minimum 1 product is requried");
                  }
                },
                textColor: whiteColor,
                title: "Add to cart",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
