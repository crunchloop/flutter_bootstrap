import 'package:freezed_annotation/freezed_annotation.dart';

import 'step.dart';

part 'train.freezed.dart';
part 'train.g.dart';

@freezed
class Train with _$Train {

  const factory Train(List<Step> steps) = _Train;

  factory Train.fromJson(Map<String, dynamic> json) => _$TrainFromJson(json);
}