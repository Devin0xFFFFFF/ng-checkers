import "package:test/test.dart";
import 'dart:async';

void main() {

//  var server;
//  var url;

  setUp(() async {
//    server = await HttpServer.bind('localhost', 0);
//    url = Uri.parse("http://${server.address.host}:${server.port}");
  });

  group("sanity check examples", () {
    test("String.split() splits the string on the delimiter", () {
      var string = "foo,bar,baz";
      expect(string.split(","), equals(["foo", "bar", "baz"]));
    });

    test("String.trim() removes surrounding whitespace", () {
      var string = "  foo ";
      expect(string.trim(), equals("foo"));
    });

    test(".remainder() returns the remainder of division", () {
      expect(11.remainder(3), equals(2));
    });

    test(".toRadixString() returns a hex string", () {
      expect(11.toRadixString(16), equals("b"));
    });
  });

  group("matcher examples", () {
    test(".split() splits the string on the delimiter", () {
      expect("foo,bar,baz", allOf([
        contains("foo"),
        isNot(startsWith("bar")),
        endsWith("baz")
      ]));
    });
  });

  group("async examples", () {
    test("new Future.value() returns the value", () async {
      var value = await new Future.value(10);
      expect(value, equals(10));
    });

    test("new Future.value() returns the value", () {
      expect(new Future.value(10), completion(equals(10)));
    });

    test("new Future.error() throws the error", () {
      expect(new Future.error("oh no"), throwsA(equals("oh no")));
      expect(new Future.error(new StateError("bad state")), throwsStateError);
    });

    test("Stream.fromIterable() emits the values in the iterable", () {
      var stream = new Stream.fromIterable([1, 2, 3]);

      stream.listen(expectAsync((number) {
        expect(number, inInclusiveRange(1, 3));
      }, count: 3));
    });
  });

  tearDown(() async {
//    await server.close(force: true);
//    server = null;
//    url = null;
  });
}