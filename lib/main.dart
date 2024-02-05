import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/consts/colors.dart';
import 'package:weather_app/consts/images.dart';

import 'consts/strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: "poppins",
      ),
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      home: const WeatherApp(),
    );
  }
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});
  @override
  Widget build(BuildContext context) {
    var date = DateFormat("yMMMMd").format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: "$date".text.gray700.make(),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.light_mode,
                color: Vx.gray600,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_vert,
                color: Vx.gray600,
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "TANDOALLAHYAR".text.fontFamily("poppins_bold").size(32).make(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/weather/01d.png",
                    width: 80,
                    height: 80,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "37$degree",
                        style: TextStyle(
                          color: Vx.gray700,
                          fontSize: 64,
                          fontFamily: "poppins",
                        )),
                  ])),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Sunny",
                        style: TextStyle(
                          color: Vx.gray700,
                          letterSpacing: 3,
                          fontSize: 14,
                          fontFamily: "poppins_light",
                        )),
                  ])),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                      onPressed: null,
                      icon: Icon(
                        Icons.expand_less_rounded,
                        color: Vx.gray400,
                      ),
                      label: "41$degree".text.make()),
                  TextButton.icon(
                      onPressed: null,
                      icon: Icon(
                        Icons.expand_more_rounded,
                        color: Vx.gray400,
                      ),
                      label: "26$degree".text.make()),
                ],
              ),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(3, (index) {
                  var iconsList = [clouds, humidity, windspeed];
                  var values = ["70%", "40%", "3.5 km/h"];
                  return Column(
                    children: [
                      Image.asset(
                        iconsList[index],
                        width: 60,
                        height: 60,
                      )
                          .box
                          .gray200
                          .padding(const EdgeInsets.all(8))
                          .roundedSM
                          .make(),
                      10.heightBox,
                      values[index].text.gray400.make(),
                    ],
                  );
                }),
              ),
              10.heightBox,
              const Divider(),
              10.heightBox,
              SizedBox(
                height: 150,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          "${index + 1} AM".text.gray200.make(),
                          Image.asset(
                            "assets/weather/09n.png",
                            width: 80,
                          ),
                          "38$degree".text.white.make(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              10.heightBox,
              const Divider(),
              10.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Next 7 Days".text.semiBold.size(16).make(),
                  TextButton(onPressed: () {}, child: "View All".text.make()),
                ],
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 7,
                  itemBuilder: (BuildContext context, int index) {
                    var day = DateFormat("EEEE")
                        .format(DateTime.now().add(Duration(days: index + 1)));
                    return Card(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: day.text.semiBold.make()),
                            Expanded(
                              child: TextButton.icon(
                                  onPressed: null,
                                  icon: Image.asset(
                                    "assets/weather/50n.png",
                                    width: 40,
                                  ),
                                  label: "26$degree".text.gray800.make()),
                            ),
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: "38$degree /",
                                  style: TextStyle(
                                      color: Vx.gray800,
                                      fontFamily: "poppins",
                                      fontSize: 16),
                                ),
                                TextSpan(
                                  text: "26$degree ",
                                  style: TextStyle(
                                      color: Vx.gray600,
                                      fontFamily: "poppins",
                                      fontSize: 16),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    );
                  })
            ],
          )),
        ),
      ),
    );
  }
}
