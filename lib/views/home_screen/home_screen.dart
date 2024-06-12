import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/consts/lists.dart';
import 'package:emart_app/controllers/home_controller.dart';
import 'package:emart_app/services/firestore_services.dart';
import 'package:emart_app/views/category_screen/item_details.dart';
import 'package:emart_app/views/home_screen/search_screen.dart';
import 'package:emart_app/widgets_common/home_buttons.dart';
import 'package:emart_app/widgets_common/loading_indicator.dart';
import 'package:get/get.dart';

import 'components/featured_button.dart';

class HomeScreen extends StatelessWidget {
   const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var contoller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 60,
              color: lightGrey,
              child: TextFormField(
                controller: contoller.searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search).onTap(() {
                    if(contoller.searchController.text.isNotEmptyAndNotNull){
                      Get.to(()=>  SearchScreen(title: contoller.searchController.text,));
                    }
                  }),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchanything,
                  hintStyle: TextStyle(color: textfieldGrey),
                ),
              ),
            ),
            10.heightBox,
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    //swipers brands
                    VxSwiper.builder(
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: slidersList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            slidersList[index],
                            fit: BoxFit.fill,
                          ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 08)).make();
                        }),

                    10.heightBox,
                    //deals buttons
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: List.generate(
                    //       2,
                    //       (index) => homeButtons(
                    //             height: context.screenHeight * 0.15,
                    //             width: context.screenWidth / 2.5,
                    //             icon: index == 0 ? icTodaysDeal : icFlashDeal,
                    //             title: index == 0 ? todayDeal : flashsale,
                    //           )),
                    // ),

                    // //2nd swipers
                    // 10.heightBox,
                    // VxSwiper.builder(
                    //     aspectRatio: 16 / 9,
                    //     autoPlay: true,
                    //     height: 150,
                    //     enlargeCenterPage: true,
                    //     itemCount: secondSliderList.length,
                    //     itemBuilder: (context, index) {
                    //       return Image.asset(
                    //         secondSliderList[index],
                    //         fit: BoxFit.fill,
                    //       ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 08)).make();
                    //     }),

                    //category buttons
                    10.heightBox,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: List.generate(
                    //       3,
                    //       (index) => homeButtons(
                    //             height: context.screenHeight * 0.15,
                    //             width: context.screenWidth / 3.5,
                    //             icon: index == 0
                    //                 ? icTopCategories
                    //                 : index == 1
                    //                     ? icBrands
                    //                     : icTopSeller,
                    //             title: index == 0
                    //                 ? topCategories
                    //                 : index == 1
                    //                     ? brand
                    //                     : topSellers,
                    //           )),
                    // ),

                    //featured categories
                    20.heightBox,
                    Align(alignment: Alignment.centerLeft, child: featuredCategories.text.color(darkFontGrey).size(18).fontFamily(semibold).make()),
                    20.heightBox,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            3,
                            (index) => Column(
                                  children: [
                                    featuredButton(icon: featuredImages1[index], title: featuredTitles1[index]),
                                    10.heightBox,
                                    featuredButton(icon: featuredImages2[index], title: featuredTitles2[index]),
                                  ],
                                )).toList(),
                      ),
                    ),

                    //featured Product
                    20.heightBox,
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: const BoxDecoration(color: redColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white.fontFamily(bold).size(18).make(),
                          10.heightBox,
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                              future: FirestoreServices.getFeaturedProducts(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(child: loadingIndicator());
                                } else if (snapshot.data!.docs.isEmpty) {
                                  return "NO featured products".text.white.makeCentered();
                                } else {
                                  var featuredData = snapshot.data!.docs;

                                  return Row(
                                    children: List.generate(
                                      featuredData.length,
                                      (index) => Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            featuredData[index]['p_imgs'][0],
                                            width: 130,
                                            height: 130,
                                            fit: BoxFit.cover,
                                          ),
                                          10.heightBox,
                                          "${featuredData[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                          10.heightBox,
                                          "${featuredData[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(16).make(),
                                        ],
                                      ).box.margin(const EdgeInsets.symmetric(horizontal: 4)).white.roundedSM.padding(const EdgeInsets.all(8)).make().onTap(() {
                                        Get.to(() => ItemDetails(
                                          title: "${featuredData[index]['p_name']}",
                                          data: featuredData[index],
                                        ));
                                      }),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    //third swiper
                    20.heightBox,
                    VxSwiper.builder(
                        autoPlayCurve: Curves.elasticIn,
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: slidersList.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            slidersList[index],
                            fit: BoxFit.fill,
                          ).box.rounded.clip(Clip.antiAlias).margin(const EdgeInsets.symmetric(horizontal: 08)).make();
                        }),

                    //all products section
                    20.heightBox,
                    StreamBuilder(
                      stream: FirestoreServices.allproducts(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return loadingIndicator();
                        } else {
                          var allproductsdata = snapshot.data!.docs;
                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: allproductsdata.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, mainAxisExtent: 310),
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    allproductsdata[index]['p_imgs'][0],
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover, //pela cover htu
                                  ),
                                  const Spacer(),
                                  10.heightBox,
                                  "${allproductsdata[index]['p_name']}".text.fontFamily(semibold).color(darkFontGrey).make(),
                                  10.heightBox,
                                  "${allproductsdata[index]['p_price']}".numCurrency.text.color(redColor).fontFamily(bold).size(16).make(),
                                ],
                              )
                                  .box
                                  .margin(const EdgeInsets.symmetric(horizontal: 4))
                                  .white
                                  .roundedSM
                                  .padding(const EdgeInsets.all(12))
                                  .make()
                                  .onTap(() {
                                Get.to(() => ItemDetails(
                                      title: "${allproductsdata[index]['p_name']}",
                                      data: allproductsdata[index],
                                    ));
                              });
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
