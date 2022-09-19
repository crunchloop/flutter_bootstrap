import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'timeout.freezed.dart';

@freezed
class Timeout with _$Timeout {

  const Timeout._();

  const factory Timeout(Duration duration) = _Timeout;

  static const noTimeout = _Timeout(Duration.zero);

  @Assert('duration.inMilliseconds <= 65535')
  factory Timeout.timeMs(Duration duration) = TimeoutMs;

  List<int> toHex() => Uint8List.view(Uint16List.fromList([duration.inMilliseconds]).buffer);
}