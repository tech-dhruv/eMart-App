import 'package:emart_app/consts/consts.dart';

class FirestoreServices {
  //get users data
  static getUser(uid) {
    return firestore.collection(usersCollection).where('id', isEqualTo: uid).snapshots();
  }

  //get products according to category
  static getProducts(category) {
    return firestore.collection(productsCollection).where('p_category', isEqualTo: category).snapshots();
  }

  //get product according subcategory
  static getSubCategoryProducts(title){
    return firestore.collection(productsCollection).where('p_subcategory', isEqualTo: title).snapshots();
  }

  //get cart
  static getCart(uid) {
    return firestore.collection(cartCollection).where('added_by', isEqualTo: uid).snapshots();
  }

  //delete cart document
  static deleteDocument(docId) {
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  //get all chat messages
  static getChatMessages(docId) {
    return firestore.collection(chatsCollection).doc(docId).collection(messagesCollection).orderBy('created_on', descending: false).snapshots();
  }

  //get all orders
  static getAllOrders() {
    return firestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).snapshots();
  }

  //get all wishlist
  static getWishlist() {
    return firestore.collection(productsCollection).where('p_wishlist', arrayContains: currentUser!.uid).snapshots();
  }

  //get all messages
  static getAllMessages() {
    return firestore.collection(chatsCollection).where('fromId', isEqualTo: currentUser!.uid).snapshots();
  }

  //get 3 No. count in profile
  static getCounts() async {
    var res = await Future.wait([
      firestore.collection(cartCollection).where('added_by', isEqualTo: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
      firestore.collection(productsCollection).where('p_wishlist', arrayContains: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
      firestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).get().then((value) {
        return value.docs.length;
      }),
    ]);
    return res;
  }

  //for homepage display all products
  static allproducts(){
    return firestore.collection(productsCollection).snapshots();
  }

  //get featured products method
  static getFeaturedProducts(){
    return firestore.collection(productsCollection).where('is_featured',isEqualTo: true).get();
  }

  static searchProduct(title) {
    return firestore.collection(productsCollection).get();
  }


}
