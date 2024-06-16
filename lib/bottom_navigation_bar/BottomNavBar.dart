import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const BottomBar({required this.currentIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    if(screen_width > 500){
      return Center(
        child: SizedBox(
          width: 500 - 150,
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIcon(Icons.home, 0),
                _buildIcon(Icons.menu_book_outlined, 1),
                _buildIcon(CupertinoIcons.search_circle_fill, 2),
                _buildIcon(Icons.favorite, 3),
                _buildIcon(Icons.person, 4),
              ],
            ),
          ),
        ),
      );

    }else{
      return Container(
        width: MediaQuery.of(context).size.width - 70,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIcon(Icons.home, 0),
            _buildIcon(Icons.menu_book_outlined, 1),
            _buildIcon(CupertinoIcons.search_circle_fill, 2),
            _buildIcon(Icons.favorite, 3),
            _buildIcon(Icons.person, 4),
          ],
        ),
      );

    }


  }

  Widget _buildIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Icon(
        icon,
        size: 25,
        color: currentIndex == index ? Colors.pinkAccent : Colors.grey,
      ),
    );
  }
}