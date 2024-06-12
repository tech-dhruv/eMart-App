import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_app/consts/consts.dart';
import 'package:intl/intl.dart' as intl;

Widget senderBubble(DocumentSnapshot data, double left, double right) {
  var t = data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);

  return Directionality(
    textDirection:  TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: data['uid'] == currentUser!.uid ? redColor : darkFontGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(left),
            bottomRight: Radius.circular(right),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ["${data['msg']}".text.align(data['uid'] == currentUser!.uid ? TextAlign.right : TextAlign.left).white.size(16).make(), 10.heightBox, time.text.color(whiteColor.withOpacity(0.5)).make()],
      ),
    ),
  );
}
