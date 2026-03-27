import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_larix/flutter_larix.dart';
import 'package:flutter_larix/src/flutter_larix_controller_options.dart';

void main() {
  group('FlutterLarixControllerOptions', () {
    test('toJson with BACK camera returns cameraId 0', () {
      final options = FlutterLarixControllerOptions(
        id: 1,
        listener: () {},
        cameraType: CAMERA_TYPE.BACK,
        cameraResolution: CAMERA_RESOLUTION.HD,
        url: 'rtmp://example.com/live/stream',
      );

      final json = options.toJson();

      expect(json['cameraId'], 0);
      expect(json['cameraResolution'], 'HD');
      expect(json['url'], 'rtmp://example.com/live/stream');
    });

    test('toJson with FRONT camera returns cameraId 1', () {
      final options = FlutterLarixControllerOptions(
        id: 1,
        listener: () {},
        cameraType: CAMERA_TYPE.FRONT,
        cameraResolution: CAMERA_RESOLUTION.FULLHD,
        url: 'rtmp://example.com/live/stream',
      );

      final json = options.toJson();

      expect(json['cameraId'], 1);
      expect(json['cameraResolution'], 'FULLHD');
    });

    test('toJson with SD resolution', () {
      final options = FlutterLarixControllerOptions(
        id: 1,
        listener: () {},
        cameraType: CAMERA_TYPE.BACK,
        cameraResolution: CAMERA_RESOLUTION.SD,
        url: 'rtmp://example.com/live/stream',
      );

      final json = options.toJson();

      expect(json['cameraResolution'], 'SD');
    });

    test('toJson does not include id or listener', () {
      final options = FlutterLarixControllerOptions(
        id: 42,
        listener: () {},
        cameraType: CAMERA_TYPE.BACK,
        cameraResolution: CAMERA_RESOLUTION.HD,
        url: 'rtmp://example.com/live/stream',
      );

      final json = options.toJson();

      expect(json.containsKey('id'), false);
      expect(json.containsKey('listener'), false);
      expect(json.length, 3);
    });
  });
}
