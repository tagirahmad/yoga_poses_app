import 'dart:core';

import 'package:flutter/material.dart';
import 'package:teenytinyom/app/constants/app_colors.dart';
import 'package:teenytinyom/app/constants/dimensions.dart';
import 'package:teenytinyom/app/constants/paths.dart';
import 'package:teenytinyom/app/modules/home/home_menu_button.dart';
import 'package:teenytinyom/app/modules/main/main_view.dart';
import 'package:teenytinyom/app/services/url_launcher_service.dart';

import 'image_button.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.SIDE_INDENT),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 1,
              child: Image.asset(
                'assets/logo@2x~iphone.png',
                height: 150.0,
                filterQuality: FilterQuality.high,
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: HomeMenuButton(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainView.create(context),
                        ),
                      ),
                      buttonText: 'Create a Yoga Sequence',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.GREY,
                          ),
                    ),
                  ),
                  Flexible(
                    child: HomeMenuButton(
                      onTap: () =>
                          UrlLauncherService.launchURL(Paths.WEBSITE),
                      buttonText: 'Visit website',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.GREY,
                          ),
                    ),
                  ),
                  Flexible(
                    child: HomeMenuButton(
                      onTap: () => UrlLauncherService.launchURL(Uri(
                        scheme: 'mailto',
                        path: Paths.EMAIL,
                      ).toString()),
                      buttonText: 'Contact Us',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.GREY,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ImageButton(
                    onTap: () => UrlLauncherService.launchURL(Paths.BLOG),
                    path: 'assets/blog-icon.png',
                  ),
                  ImageButton(
                    onTap: () => UrlLauncherService.launchURL(Paths.FACEBOOK),
                    path: 'assets/FBlogo@2x~ipad.png',
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
