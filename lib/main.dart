import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/consts/colors.dart';
import 'package:weather_app/consts/images.dart';
import 'package:weather_app/controllers/main_controller.dart';
import 'package:weather_app/models/current_weather_model.dart';
import 'package:weather_app/models/hourly_weather_model.data.dart';
import 'package:weather_app/our_themes.dart';
import 'package:weather_app/services/api_services.dart';

import 'consts/strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: CustomThemes.lightTheme,
      darkTheme: CustomThemes.darkTheme,
      themeMode: ThemeMode.system,
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
    var theme = Theme.of(context);
    var controller = Get.put(MainController());
    print(controller.currentWeatherData);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: "$date".text.gray600.make(),
        backgroundColor: Colors.transparent,
        actions: [
          Obx(() => IconButton(
                onPressed: () {
                  controller.changeTheme();
                },
                icon: Icon(
                  controller.isDark.value ? Icons.light_mode : Icons.dark_mode,
                  color: theme.iconTheme.color,
                ),
              )),
        ],
      ),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: FutureBuilder(
              future: controller.currentWeatherData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text('No data available'),
                  );
                } else {
                  // Handle the case when data is available
                  CurrentWeatherData data = snapshot.data;
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "${data.name}"
                            .text
                            .fontFamily("poppins_bold")
                            .size(32)
                            .letterSpacing(3)
                            .color(theme.primaryColor)
                            .make(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/weather/${data.weather[0].icon}.png",
                              width: 80,
                              height: 80,
                            ),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "${data.main.temp}$degree",
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontSize: 64,
                                    fontFamily: "poppins",
                                  )),
                            ])),
                            RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "${data.weather[0].main}",
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    letterSpacing: 3,
                                    fontSize: 14,
                                    fontFamily: "poppins",
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
                                  color: theme.iconTheme.color,
                                ),
                                label: "${data.main.tempMax}$degree"
                                    .text
                                    .color(theme.iconTheme.color)
                                    .make()),
                            TextButton.icon(
                                onPressed: null,
                                icon: Icon(
                                  Icons.expand_more_rounded,
                                  color: theme.iconTheme.color,
                                ),
                                label: "${data.main.tempMin}$degree"
                                    .text
                                    .color(theme.iconTheme.color)
                                    .make()),
                          ],
                        ),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(3, (index) {
                            var iconsList = [clouds, humidity, windspeed];
                            var values = [
                              "${data.clouds.all}",
                              " ${data.main.humidity}",
                              " ${data.wind.speed}"
                            ];
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
                        FutureBuilder(
                            future: controller.hourlyWeatherData,
                            builder: (BuildContext context, AsyncSnapshot snapshot){
                              if(snapshot.hasData){
                                HourlyweatherData hourlyData = snapshot.data;

                                return SizedBox(
                                  height: 150,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: 12,
                                    itemBuilder: (BuildContext context, int index) {
                                      var time = DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(hourlyData.list![index].dt!.toInt() * 1000 ));
                                      return Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Column(
                                          children: [
                                            time.text.make(),
                                            Image.asset(
                                              "assets/weather/${hourlyData.list[index].weather[0].icon}.png",
                                              width: 80,
                                            ),
                                            "${hourlyData.list[index].main.temp}$degree".text.make(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator(),);
                            }
    ),
                        10.heightBox,
                        const Divider(),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Next 7 Days"
                                .text
                                .color(theme.primaryColor)
                                .semiBold
                                .size(16)
                                .make(),
                            TextButton(
                                onPressed: () {},
                                child: "View All".text.make()),
                          ],
                        ),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 7,
                            itemBuilder: (BuildContext context, int index) {
                              var day = DateFormat("EEEE").format(DateTime.now()
                                  .add(Duration(days: index + 1)));
                              return Card(
                                color: theme.cardColor,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: day.text
                                              .color(theme.primaryColor)
                                              .semiBold
                                              .make()),
                                      Expanded(
                                        child: TextButton.icon(
                                            onPressed: null,
                                            icon: Image.asset(
                                              "assets/weather/50n.png",
                                              width: 40,
                                            ),
                                            label: "26$degree"
                                                .text
                                                .color(theme.primaryColor)
                                                .make()),
                                      ),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: "38$degree /",
                                            style: TextStyle(
                                                color: theme.primaryColor,
                                                fontFamily: "poppins",
                                                fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: "26$degree ",
                                            style: TextStyle(
                                                color: theme.iconTheme.color,
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
                    ),
                  );
                }
              },
            )),
      ),
    );
  }
}
