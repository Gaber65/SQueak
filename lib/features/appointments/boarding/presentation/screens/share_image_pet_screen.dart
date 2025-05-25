import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../../generated/l10n.dart';
import '../../domain/entities/share_image_pet_model.dart';

class ImageCarouselWidget extends StatefulWidget {
  const ImageCarouselWidget({super.key});
  @override
  _ImageCarouselWidgetState createState() => _ImageCarouselWidgetState();
}

class _ImageCarouselWidgetState extends State<ImageCarouselWidget> {
  String activeImage = ShareImagePetModel.dummyShareImagePetModels[0].image;

  @override
  void initState() {
    super.initState();
    // Set initial active image
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).ShareImagesPet),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: Image.network(
                  activeImage,
                  key: ValueKey<String>(activeImage),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 300,
              enlargeCenterPage: true,
              autoPlay: false,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
              onPageChanged: (index, reason) {
                setState(() {
                  activeImage =
                      ShareImagePetModel.dummyShareImagePetModels[index].image;
                });
              },
            ),
            items: ShareImagePetModel.dummyShareImagePetModels.map((pet) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    activeImage = pet.image;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.2 - 20,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(pet.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        pet.petName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        pet.description,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
