import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Card {
  final String frontSide;
  final String backSide;
  bool isFaceUp = false;

  Card(this.frontSide, this.backSide);
}

class GameProvider extends ChangeNotifier {
  final List<Card> cards = [];

  GameProvider() {
    // Initialize the list of cards
    for (int i = 0; i < 8; i++) {
      cards.add(Card("assets/card_front_$i.png", "assets/card_back.png"));
    }
  }

  void flipCard(int index) {
    // Flip the card at the given index
    cards[index].isFaceUp = !cards[index].isFaceUp;

    // Check if the game is won
    if (isGameWon()) {
      // Show a victory message
    }

    notifyListeners();
  }

  bool isGameWon() {
    // Check if all pairs have been matched
    return cards.where((card) => !card.isFaceUp).isEmpty;
  }
}

class CardMatchingGame extends StatelessWidget {
  const CardMatchingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: Consumer<GameProvider>(
        builder: (context, provider, child) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: provider.cards.length,
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Card(
                  backSide: Image.asset("assets/card_back.png"),
                  frontSide: Image.asset(provider.cards[index].frontSide),
                ),
                transform: Matrix4.rotationY(
                    provider.cards[index].isFaceUp ? math.pi : 0),
              );
            },
            onTap: (index) {
              provider.flipCard(index);
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CardMatchingGame(),
    );
  }
}