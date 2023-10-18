import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RecipePage extends StatefulWidget {
  final String title;
  final String comment;
  final String user_image;
  final String name;
  final List<String>? imgURL;
  final List<String>? Ingredients;
  final List<String>? procedure;

  RecipePage(
      {required this.title,
      required this.imgURL,
      required this.comment,
      required this.name,
      required this.user_image,
      required this.Ingredients,
      required this.procedure});

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  int imgcount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Recipe Page',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      widget.user_image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  height: 0.5,
                  width: 1000,
                  color: Colors.grey,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  height: 0.5,
                  width: 1000,
                  color: Colors.grey,
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                if (widget.imgURL != null && widget.imgURL!.isNotEmpty)
                  CarouselSlider.builder(
                    itemCount: widget.imgURL!.length,
                    options: CarouselOptions(
                      autoPlay: true, //自動スクロール
                      height: 300,
                      //aspectRatio: 16 / 9,
                      viewportFraction: 1, //画像と画像の幅
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          Duration(milliseconds: 800), //スクロールの時間
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason) {
                        setState(() {
                          imgcount = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, realIndex) {
                      return Image.network(widget.imgURL![index]);
                    },
                  ),
                SizedBox(
                  height: 20,
                ),
                AnimatedSmoothIndicator(
                  activeIndex: imgcount,
                  count: widget.imgURL!.length,
                  effect: const JumpingDotEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "具材一覧",
              style: TextStyle(fontSize: 15),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.Ingredients!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.Ingredients![index]),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
