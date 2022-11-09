import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void toastMessageCustom(
    BuildContext context, String type, String title, String content) {
  var snackBar = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 220),
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
        title: title,
        message: content,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: type == "Success"
            ? ContentType.success
            : type == "Error"
                ? ContentType.failure
                : ContentType.warning),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
