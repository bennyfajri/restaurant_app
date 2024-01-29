import 'dart:math';

import 'package:flutter/material.dart';

const String baseUrlImg = "https://restaurant-api.dicoding.dev/images/medium/";
const String pictureId = "pictureId";
const Color inactive = Color(0xFF9699A9);

String getRecommendationText() {
  var listText = [
    "Dapatkan promo menarik hari ini hanya di",
    "Wow, kamu belum tahu kan restoran",
    "Dapatkan menu favorit anda di restoran"
  ];
  return listText[Random().nextInt(listText.length)];
}
