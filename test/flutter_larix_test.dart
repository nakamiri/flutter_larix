import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_larix/flutter_larix.dart';

void main() {
  group('CAMERA_TYPE enum', () {
    test('has FRONT and BACK values', () {
      expect(CAMERA_TYPE.values.length, 2);
      expect(CAMERA_TYPE.FRONT, isNotNull);
      expect(CAMERA_TYPE.BACK, isNotNull);
    });

    test('name returns correct string', () {
      expect(CAMERA_TYPE.FRONT.name, 'FRONT');
      expect(CAMERA_TYPE.BACK.name, 'BACK');
    });
  });

  group('CAMERA_RESOLUTION enum', () {
    test('has SD, HD, and FULLHD values', () {
      expect(CAMERA_RESOLUTION.values.length, 3);
      expect(CAMERA_RESOLUTION.SD, isNotNull);
      expect(CAMERA_RESOLUTION.HD, isNotNull);
      expect(CAMERA_RESOLUTION.FULLHD, isNotNull);
    });

    test('name returns correct string', () {
      expect(CAMERA_RESOLUTION.SD.name, 'SD');
      expect(CAMERA_RESOLUTION.HD.name, 'HD');
      expect(CAMERA_RESOLUTION.FULLHD.name, 'FULLHD');
    });
  });

  group('STREAM_STATUS enum', () {
    test('has ON and OFF values', () {
      expect(STREAM_STATUS.values.length, 2);
      expect(STREAM_STATUS.ON, isNotNull);
      expect(STREAM_STATUS.OFF, isNotNull);
    });
  });
}
