import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void managerHttpResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch(response.statusCode){
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.body)['message']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.body)['error']);
      break;
    case 201:
      onSuccess();
      break;
  }
}
void showSnackBar(BuildContext context, String title) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            title
        ),
      )
  );
}