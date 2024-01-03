import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/apiservices/api_services.dart';
import 'package:news/consts/var.dart';
import 'package:news/inner_screens/search_screen.dart';
import 'package:news/models/news_model.dart';
import 'package:news/providers/news_provider.dart';
import 'package:news/services/utils.dart';
import 'package:news/widgets/drawer_widget.dart';
import 'package:news/widgets/empty_screen.dart';
import 'package:news/widgets/loading_widget.dart';
import 'package:news/widgets/tabs_widget.dart';
import 'package:news/widgets/toptrending_widget.dart';
import 'package:news/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../widgets/articles_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var newsType = NewsType.allNews;
  int currentPageIndex = 0;
  String sortBy = SortByEnum.publishedAt.name;

  @override
  void didChangeDependencies() {
    getNewsList();
    super.didChangeDependencies();
  }

  Future<List<NewsModel>> getNewsList() async {
    List<NewsModel> newsList = await ApiService.getNews();
    return newsList;
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    Size size = Utils(context).getScreenSize;
    final newsProvider = Provider.of<NewsProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'News App',
            style: GoogleFonts.lobster(
              textStyle: const TextStyle(fontSize: 20),
              letterSpacing: 0.6,
              color: color,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const SearchScreen(),
                        inheritTheme: true,
                        ctx: context),
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: color,
                ))
          ],
        ),
        drawer: const DrawerWidget(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  TabsWidget(
                    text: 'All news',
                    color: newsType == NewsType.allNews
                        ? Theme.of(context).cardColor
                        : Colors.transparent,
                    function: () {
                      if (newsType == NewsType.allNews) {
                        return;
                      }
                      setState(() {
                        newsType = NewsType.allNews;
                      });
                    },
                    fontSize: newsType == NewsType.allNews ? 22 : 14,
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  TabsWidget(
                    text: 'Top trending',
                    color: newsType == NewsType.topTrending
                        ? Theme.of(context).cardColor
                        : Colors.transparent,
                    function: () {
                      if (newsType == NewsType.topTrending) {
                        return;
                      }
                      setState(() {
                        newsType = NewsType.topTrending;
                      });
                    },
                    fontSize: newsType == NewsType.topTrending ? 22 : 14,
                  ),
                ],
              ),
              const VerticalSpacing(10),
              newsType == NewsType.topTrending
                  ? Container()
                  : SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          paginationButton(
                            text: 'Prev',
                            function: () {
                              if (currentPageIndex == 0) {
                                return;
                              }
                              setState(() {
                                currentPageIndex -= 1;
                              });
                            },
                          ),
                          Flexible(
                            flex: 2,
                            child: ListView.builder(
                                itemCount: 5,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: ((context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Material(
                                      color: currentPageIndex == index
                                          ? Colors.blue
                                          : Theme.of(context).cardColor,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            currentPageIndex = index;
                                          });
                                        },
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("${index + 1}"),
                                        )),
                                      ),
                                    ),
                                  );
                                })),
                          ),
                          paginationButton(
                            text: 'Next',
                            function: () {
                              if (currentPageIndex == 4) {
                                return;
                              }
                              setState(() {
                                currentPageIndex += 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
              const VerticalSpacing(10),
              newsType == NewsType.topTrending
                  ? Container()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        color: Theme.of(context).cardColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton(
                            value: sortBy,
                            items: dropDownItems,
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ),
              FutureBuilder<List<NewsModel>>(
                future: newsProvider.fetchAllNews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                        child: LoadingWidget(
                      newsType: newsType,
                    ));
                  } else if (snapshot.hasError) {
                    return Expanded(
                        child: EmptyNewsWidget(
                      text: 'An error Occurred ${snapshot.error}',
                      imagePath: 'assets/images/no_news.png',
                    ));
                  } else if (snapshot.data == null) {
                    return const Expanded(
                        child: EmptyNewsWidget(
                      text: 'No news found',
                      imagePath: 'assets/images/no_news.png',
                    ));
                  }
                  return newsType == NewsType.allNews
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return ChangeNotifierProvider.value(
                                value: snapshot.data![index],
                                child: const ArticlesWidget(),
                              );
                            },
                          ),
                        )
                      : SizedBox(
                          height: size.height * 0.6,
                          child: Swiper(
                            autoplayDelay: 8000,
                            autoplay: true,
                            itemWidth: size.width * 0.9,
                            layout: SwiperLayout.STACK,
                            viewportFraction: 0.9,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return TopTrendingWidget(
                                url: snapshot.data![index].url,
                              );
                            },
                          ),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropDownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: SortByEnum.relevancy.name,
        child: Text(SortByEnum.relevancy.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.publishedAt.name,
        child: Text(SortByEnum.publishedAt.name),
      ),
      DropdownMenuItem(
        value: SortByEnum.popularity.name,
        child: Text(SortByEnum.popularity.name),
      ),
    ];
    return menuItems;
  }

  Widget paginationButton({required Function function, required String text}) {
    return ElevatedButton(
      onPressed: () {
        function();
      },
      style: ElevatedButton.styleFrom(
          shape: const BeveledRectangleBorder(),
          backgroundColor: Colors.blue,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          )),
      child: Text(text),
    );
  }
}
