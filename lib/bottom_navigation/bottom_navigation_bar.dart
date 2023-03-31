import 'package:app_workplace/cham_cong/cham_cong_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import '../custom_code/notification/local_notification_service.dart';
import '../thong_bao/thong_bao_cham_cong_widget.dart';
import '../tin_tuc/tin_tuc_widget.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int curentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
    LocalNoticationService.initialize(context);
    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {},
          ),
        );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNoticationService.showNotificationOnForeground(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      openNotify(message);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void openNotify(RemoteMessage message) {
    //String? value = message.data['url'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThongBaoChamCongWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        screens: screens(),
        items: navbarItems(),
        navBarStyle: NavBarStyle.style3,
      ),
    );
  }

  List<Widget> screens() {
    return [
      ChamCongWidget(),
      TinTucWidget(),
      Container(color: Colors.blue),
      Container(color: Colors.red)
    ];
  }

  List<PersistentBottomNavBarItem> navbarItems() {
    return [
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.access_alarm),
          title: "Chấm công",
          activeColorPrimary: Colors.red.shade500,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.article),
          title: "Tin tức",
          activeColorPrimary: Colors.red.shade500,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.notifications),
          title: "Thông báo",
          activeColorPrimary: Colors.red.shade500,
          inactiveColorPrimary: CupertinoColors.systemGrey),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: "Cài đặt",
          activeColorPrimary: Colors.red.shade500,
          inactiveColorPrimary: CupertinoColors.systemGrey)
    ];
  }
}


// class _NavigationBarWidgetState extends State<NavigationBarWidget> {
//   int curentIndex = 0;
//   late PageController pageController;

//   @override
//   void initState() {
//     super.initState();
//     pageController = new PageController();
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SizedBox.expand(
//         child: PageView(
//           controller: pageController,
//           onPageChanged: (index) {
//             setState(() {
//               curentIndex = index;
//             });
//           },
//           children: [
//             ChamCongWidget(),
//             TinTucWidget(),
//             Container(color: Colors.red),
//             Container(color: Colors.green)
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavyBar(
//         selectedIndex: curentIndex,
//         onItemSelected: (index) {
//           setState(() {
//             pageController.jumpToPage(index);
//           });
//         },
//         items: [
//           BottomNavyBarItem(
//               icon: Icon(Icons.access_alarm), title: Text("Chấm công")),
//           BottomNavyBarItem(
//               icon: Icon(Icons.newspaper), title: Text("Tin tức")),
//           BottomNavyBarItem(
//               icon: Icon(Icons.new_releases_rounded), title: Text("Cộng đồng")),
//           BottomNavyBarItem(icon: Icon(Icons.settings), title: Text("Cài đặt"))
//         ],
//       ),
//     );
//   }
// }
