import 'package:chats/widget/profile_picture/color.dart';
import 'package:chats/widget/profile_picture/input_text.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    required this.name,
    required this.fontsize,
    super.key,
    this.random = false,
    this.count,
    this.img,
  });

  final String name;
  final double fontsize;
  final bool random;
  final int? count;
  final String? img;

  @override
  Widget build(BuildContext context) {
    // check image is available or not.
    return img == null ? NoImage(name: name, count: count, fontsize: fontsize, random: random) : WithImage(img: img!);
  }
}

// if image available
class WithImage extends StatelessWidget {
  const WithImage({
    required this.img,
    super.key,
  });

  final String img;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(img),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// if no image
class NoImage extends StatelessWidget {
  const NoImage({
    required this.name,
    required this.count,
    required this.fontsize,
    required this.random,
    super.key,
  });

  final String name;
  final int? count;
  final double fontsize;
  final bool random;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: random == true
            ? randomColorWidget()
            : name == ''
                ? ColorName.colorDefault
                : fixedColorWidget(
                    InitialName.parseName(name, count),
                  ),
      ),
      child: name == ''
          ? const SizedBox()
          : Center(
              child: Text(
                InitialName.parseName(name, count).toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontsize,
                  letterSpacing: 1.4,
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
