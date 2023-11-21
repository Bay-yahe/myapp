import 'package:bay_yahe_app/screens/activity/screens/activities.dart';
import 'package:flutter/material.dart';

class TabbarActivity extends StatefulWidget {
  const TabbarActivity({super.key});

  @override
  _TabbarActivityState createState() => _TabbarActivityState();
}

class _TabbarActivityState extends State<TabbarActivity>
    with SingleTickerProviderStateMixin {
  int tabIndex = 0;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  BoxDecoration setBgTab(int currentIndex) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: tabIndex == currentIndex
          ? const Color(0xFFF2F2F2)
          : Colors.transparent,
    );
  }

  TextStyle setColorText(int currentIndex) {
    return TextStyle(
      color: tabIndex == currentIndex ? Colors.green : Colors.black38,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15),
            width: 200,
            height: 36,
            child: TabBar(
              onTap: (index) {
                setState(() {
                  tabIndex = index;
                });
              },
              controller: _tabController,
              labelPadding: const EdgeInsets.symmetric(horizontal: 2),
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: setBgTab(0),
                    child: Center(
                      child: Text(
                        "Activities",
                        style: setColorText(0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Activities(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
