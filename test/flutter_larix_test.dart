import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_larix/flutter_larix.dart';

void main() {
  test('CAMERA_TYPE enum has expected values', () {
    expect(CAMERA_TYPE.values.length, 2);
    expect(CAMERA_TYPE.FRONT, isNotNull);
    expect(CAMERA_TYPE.BACK, isNotNull);
  });

  test('CAMERA_RESOLUTION enum has expected values', () {
    expect(CAMERA_RESOLUTION.values.length, 3);
    expect(CAMERA_RESOLUTION.SD, isNotNull);
    expect(CAMERA_RESOLUTION.HD, isNotNull);
    expect(CAMERA_RESOLUTION.FULLHD, isNotNull);
  });
}
