import 'package:freezed_annotation/freezed_annotation.dart';

part 'shape.freezed.dart';

@freezed
class Shape with _$Shape {
  const factory Shape(int code) = _Shape;

  static const noShape = Shape(0x00);
  static const triangle = Shape(0x54);
  static const square = Shape(0x53);
  static const circle = Shape(0x4F);
  static const cross = Shape(0x4D);
  static const x = Shape(0x58);
  static const rightArrow = Shape(0x52);
  static const leftArrow = Shape(0x4C);
  static const upArrow = Shape(0x55);
  static const downArrow = Shape(0x57);
  static const rightArrowUp = Shape(0x48);
  static const leftArrowUp = Shape(0x46);
  static const rightArrowDown = Shape(0x47);
  static const leftArrowDown = Shape(0x4E);

  const factory Shape.number(int code) = Number;
  const factory Shape.letter(int code) = Letter;

  static List<Shape> shapes = [
    noShape, triangle, square, circle, cross, x,
    rightArrow, leftArrow, upArrow, downArrow,
    rightArrowUp, leftArrowUp, rightArrowDown,
    leftArrowDown,
    ...[for (int char = 0x61; char <= 0x7A; char++) char].map(Shape.letter),
    ...[for (int char = 0x30; char <= 0x39; char++) char].map(Shape.number)
  ];
}