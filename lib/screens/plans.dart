import 'package:flutter/material.dart';
import 'package:peace_residencia/constants/colors.dart';

class Plans extends StatefulWidget {
  Plans({Key? key}) : super(key: key);

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  List<String> images = [
    'assets/images/plan_1_front.png',
    'assets/images/plan_1_back.png',
    'assets/images/plan_2_front.png',
    'assets/images/plan_2_back.png'
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   leading: BackButton(color: AppColors.lightBlueColor),
      // ),
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(),
          ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: SizedBox(
                  width: size.width * 0.90,
                  // height: size.height * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 2,
                      shadowColor: AppColors.lightBlueColor,
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          )
        ],
      ),
    );
  }
}
