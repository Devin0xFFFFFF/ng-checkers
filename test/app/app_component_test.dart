@TestOn('browser')

import "package:test/test.dart";
import 'package:angular2_testing/angular2_testing.dart';
import 'package:angular2/angular2.dart';

import 'package:ng_checkers/app/app_component.dart';

@Injectable()
class TestService {
  String status = 'not ready';

  init() {
    this.status = 'ready';
  }
}

class MyToken {}

void main()
{
  initAngularTests();

  setUpProviders(() => [provide(MyToken, useValue: 'my string'), TestService]);

  ngTest('should allow a component using a templateUrl', (TestComponentBuilder tcb) async {
    var rootTC = await tcb
        .createAsync(AppComponent);

    //rootTC.detectChanges();

    expect(rootTC.debugElement.nativeElement.text, equals('My First Angular 2 App'));
  });
}