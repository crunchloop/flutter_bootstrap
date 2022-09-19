import 'package:freezed_annotation/freezed_annotation.dart';

import 'shape.dart';
import 'timeout.dart';

part 'atn_command.freezed.dart';
part 'atn_command.g.dart';

class TIDGenerator {
  static final Iterator<int> _sequenceNumbers = List<int>
      .generate(0xFF, (k) => (k + 1) % 0xFF).iterator;

  static int next() => (_sequenceNumbers..moveNext()).current;

  TIDGenerator._();
}

enum ControlCommand {
  stop(0x04), recalibrate(0x05), echo(0x08), enterDfu(0x09);

  const ControlCommand(this.code);

  final int code;
}

enum SoundConfiguration {
  noSound(0x00), onStart(0x01), onHit(0x02), onStartAndHit(0x03);

  const SoundConfiguration(this.code);

  final int code;

  int mix(List<SoundConfiguration> configurations) => configurations
      .map((c) => c.code)
      .reduce((value, element) => value | element);
}

enum FeatureFlags {
  timeoutReport(0x01);

  const FeatureFlags(this.code);

  final int code;
}

enum Led {
  off(0x00), on(0x01), flash(0x02);

  const Led(this.code);

  final int code;
}

enum Color {
  noColor(0x00),
  white(0x42),
  red(0x52),
  green(0x56),
  blue(0x41),
  yellow(0x59),
  cyan(0x43),
  magenta(0x4D);

  const Color(this.code);

  final int code;
}

enum Sensor {
  off(0x00),
  outdoor(0x01),
  touch(0x02),
  hoverMin(0x13),
  hoverMed(0x23),
  hoverMax(0x33);

  const Sensor(this.code);

  final int code;
}

@freezed
class AtnCommand with _$AtnCommand {
  const AtnCommand._();

  const factory AtnCommand.ack(int code) = Ack;
  const factory AtnCommand.command({
    required int code,
    required int transactionId,
    required List<int> values }) = Command;

  factory AtnCommand.control(ControlCommand command) => AtnCommand.command(
      code: 0xE0, transactionId: TIDGenerator.next(),
      values: [command.code]
  );
  factory AtnCommand.controlAck() => const AtnCommand.ack(0xE1);

  //Assert valid hex
  factory AtnCommand.setConfig({
    dimmerLevel = 0x0A, soundConfiguration = SoundConfiguration.noSound,
    featureFlags = FeatureFlags.timeoutReport
  }) => AtnCommand.command(
      code: 0xF0, transactionId: TIDGenerator.next(),
      values: [dimmerLevel.code, soundConfiguration.code, featureFlags.code]
  );
  factory AtnCommand.setConfigAck() => const AtnCommand.ack(0xF1);

  factory AtnCommand.train({
    required Led led, required Shape shape, required Color color,
    required Sensor sensor, required Timeout timeout
  }) => AtnCommand.command(
      code: 0xC0, transactionId: TIDGenerator.next(),
      values: [led.code, shape.code, color.code, sensor.code, ...timeout.toHex()]
  );
  factory AtnCommand.trainAck() => const AtnCommand.ack(0xC1);

  factory AtnCommand.fromJson(Map<String, dynamic> json) => _$AtnCommandFromJson(json);

  List<int> get data => when(
      ack: (code) => [code],
      command: (code, transactionId, values) => [code, transactionId, ...values],
  );

  int get transactionId => when(
    ack: (code) => -1,
    command: (code, transactionId, values) => transactionId,
  );
}