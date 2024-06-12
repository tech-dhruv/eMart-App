import 'package:emart_app/consts/consts.dart';
import 'package:emart_app/controllers/auth_controller.dart';
import 'package:emart_app/controllers/cart_controller.dart';
import 'package:emart_app/controllers/chats_controller.dart';
import 'package:emart_app/controllers/product_controller.dart';
import 'package:emart_app/controllers/profile_controller.dart';
import 'package:emart_app/views/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'controllers/home_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //I using getX so i have to change this material app into getmaterialapp
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      initialBinding: Bind(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
            //to set app bar icons color
            iconTheme: IconThemeData(
              color: darkFontGrey,
            ),
            backgroundColor: Colors.transparent),
        fontFamily: regular,
      ),
      home: const SplashScreen(),
    );
  }
}

class Bind implements Bindings{
  @override
  void dependencies() {
    injection();
  }
}

injection(){
  Get.put(HomeController(),permanent: true);
  Get.put(AuthController(),permanent: true);
  Get.put(ProfileController(),permanent: true);
  Get.put(ProductController(),permanent: true);
  Get.put(CartController(),permanent: true);
}