import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

enum GameState {
  playing,
  gameOver,
}

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  Player() : super(position: Vector2.all(100), size: Vector2.all(50));
  GameState gameState = GameState.playing;
  final velocity = Vector2(0, 150);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      await Flame.images.load('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += velocity.y * dt;
  }

  @override
  void onCollisionStart(Set<Vector2> _, PositionComponent other) {
    super.onCollisionStart(_, other);
    gameState = GameState.gameOver;
    gameRef.pauseEngine();
  }

  void restart() {
    gameState = GameState.playing;
    position = Vector2.all(150); // Reset player position
    velocity.y = 100; // Reset player velocity
    // animationTime = 0; // Reset animation time
    // removeEffectsWithName('MoveByEffect'); // Remove any flying effects
    gameRef.resumeEngine();
  }

  void fly() {
    add(
      MoveByEffect(
        Vector2(0, -100),
        EffectController(
          duration: 0.2,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}
