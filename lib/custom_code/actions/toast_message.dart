// Automatic FlutterFlow imports
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

void toastMessage(
  BuildContext context,
  String type,
  String title,
  String content,
) {
  showToastWidget(
      Container(
        height: content.length > 40 ? 84 : 64,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 25.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: type == "Success"
              ? Colors.green[500]
              : type == "Error"
                  ? Colors.red[800]
                  : Colors.yellow[700],
        ),
        child: Row(
          children: [
            Icon(
              type == "Success"
                  ? Icons.check_circle
                  : type == "Error"
                      ? Icons.clear
                      : Icons.error_outline,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      wordSpacing: 0.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      context: context,
      isIgnoring: false,
      duration: Duration(seconds: 5),
      position: StyledToastPosition.top,
      alignment: Alignment.centerLeft);
}
