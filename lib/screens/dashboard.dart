import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:peace_residencia/constants/colors.dart';
import 'package:peace_residencia/screens/plans.dart';
import 'package:peace_residencia/screens/verify_details.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
          SizedBox(
            width: size.width,
            height: size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: 300,
                  ),
                  Text(
                    'Select an option',
                    style: GoogleFonts.cairo(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          alignment: Alignment.bottomCenter,
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 600),
                          reverseDuration: const Duration(milliseconds: 600),
                          type: PageTransitionType.rightToLeft,
                          child: const VerifyDetails(),
                        ),
                      );
                    },
                    child: Container(
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/verify.svg",
                              height: 60,
                            ),
                            Expanded(
                              child: Text(
                                'Verify File Details',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightBlueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          alignment: Alignment.bottomCenter,
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 600),
                          reverseDuration: const Duration(milliseconds: 600),
                          type: PageTransitionType.rightToLeft,
                          child: Plans(),
                        ),
                      );
                    },
                    child: Container(
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 25),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              "assets/icons/list.png",
                              height: 55,
                            ),
                            Expanded(
                              child: Text(
                                'E-Brochure',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.lightBlueColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
