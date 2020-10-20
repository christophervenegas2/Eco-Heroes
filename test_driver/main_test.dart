// This is a basic Flutter Driver test for the application. A Flutter Driver
// test is an end-to-end test that "drives" your application from another
// process or even from another computer. If you are familiar with
// Selenium/WebDriver for web, Espresso for Android or UI Automation for iOS,
// this is simply Flutter's version of that.

import 'package:flutter_driver/flutter_driver.dart';
import 'package:screenshots/screenshots.dart';
import 'package:test/test.dart';

void main() {
  group('end-to-end test', () {
    FlutterDriver driver;
    final config = Config();

    setUpAll(() async {
      // Connect to a running Flutter application instance.
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    Future<void> takescreenshot(String name) async {
      await screenshot(driver, config, name);
      await Future.delayed(Duration(milliseconds: 500));
    }

    test('Login with user', () async {
      await driver.waitFor(find.byValueKey('login-mail'));
      await takescreenshot('00');

      await driver.tap(find.byValueKey('login-mail'));
      await driver.enterText('joe@doe.cl');
      await Future.delayed(Duration(milliseconds: 500));

      await driver.tap(find.byValueKey('login-password'));
      await driver.enterText('joedoe123');
      await Future.delayed(Duration(milliseconds: 500));

      takescreenshot('01');
      await driver.tap(find.byValueKey('login-button'));

      await driver.waitFor(find.byValueKey('tasks-bottombar'));
      await Future.delayed(Duration(milliseconds: 2000));
      await takescreenshot('02');

      await driver.tap(find.byValueKey('articles-bottombar'));
      await Future.delayed(Duration(milliseconds: 2000));
      await takescreenshot('03');

      await driver.tap(find.byValueKey('profile-bottombar'));
      await Future.delayed(Duration(milliseconds: 2000));
      await takescreenshot('04');
    });
  });
}
