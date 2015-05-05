@TestOn('browser')

import 'dart:async';
import 'package:test/test.dart';
import 'package:uix/uix.dart';

void main() {
  group('Clock', () {
    test('initial', () {
      final s = new Scheduler();
      expect(s.clock, equals(1));
    });

    test('next tick', () async {
      final s = new Scheduler();
      await s.zone.run(() async {
        await s.nextTick;
        expect((s.flags & Scheduler.tickRunningFlag), isNot(equals(0)));
        expect(s.clock, equals(1));
        await s.nextTick;
        expect(s.clock, equals(2));
      });
    });

    test('next frame', () async {
      final s = new Scheduler();
      await s.zone.run(() async {
        await s.nextFrame.write();
        expect((s.flags & Scheduler.frameRunningFlag), isNot(equals(0)));
        expect(s.clock, equals(1));
        await s.nextTick;
        expect(s.clock, equals(2));
      });
    });

    test('current frame', () async {
      final s = new Scheduler();
      await s.zone.run(() async {
        await s.nextFrame.write();
        expect((s.flags & Scheduler.frameRunningFlag), isNot(equals(0)));
        expect(s.clock, equals(1));
        await s.currentFrame.write();
        expect(s.clock, equals(1));
      });
    });
  });

  group('Next frame', () {
    group('tasks', () {
      test('write', () async {
        final s = new Scheduler();
        final futures = [];
        int result = 0;

        await s.zone.run(() async {
          futures.add(s.nextFrame.write(4).then((_) => result++));
          futures.add(s.nextFrame.write(2).then((_) => result++));

          await Future.wait(futures);
          expect(result, equals(2));
        });
      });

      test('read', () async {
        final s = new Scheduler();
        final futures = [];
        int result = 0;

        await s.zone.run(() async {
          futures.add(s.nextFrame.read().then((_) => result++));
          futures.add(s.nextFrame.read().then((_) => result++));

          await Future.wait(futures);
          expect(result, equals(2));
        });
      });

      test('after', () async {
        final s = new Scheduler();
        final futures = [];
        int result = 0;

        await s.zone.run(() async {
          futures.add(s.nextFrame.after().then((_) => result++));
          futures.add(s.nextFrame.after().then((_) => result++));

          await Future.wait(futures);
          expect(result, equals(2));
        });
      });

      test('read/write/after', () async {
        final s = new Scheduler();
        final futures = [];
        int result = 0;

        await s.zone.run(() async {
          futures.add(s.nextFrame.after().then((_) => result++));
          futures.add(s.nextFrame.read().then((_) => result++));
          futures.add(s.nextFrame.after().then((_) => result++));
          futures.add(s.nextFrame.write().then((_) => result++));
          futures.add(s.nextFrame.write().then((_) => result++));
          futures.add(s.nextFrame.read().then((_) => result++));

          await Future.wait(futures);
          expect(result, equals(6));
        });
      });
    });

    group('priorities', () {
      test('write', () async {
        final s = new Scheduler();
        final futures = [];
        final result = [];

        await s.zone.run(() async {
          futures.add(s.nextFrame.write(4).then((_) => result.add(4)));
          futures.add(s.nextFrame.write(2).then((_) => result.add(2)));
          futures.add(s.nextFrame.write().then((_) => result.add(100)));
          futures.add(s.nextFrame.write(3).then((_) => result.add(3)));
          futures.add(s.nextFrame.write(0).then((_) => result.add(0)));
          futures.add(s.nextFrame.write(1).then((_) => result.add(1)));

          await Future.wait(futures);
          expect(result, equals([0, 1, 2, 3, 4, 100]));
        });
      });

      test('write/read/after', () async {
        final s = new Scheduler();
        final futures = [];
        final result = [];

        await s.zone.run(() async {
          futures.add(s.nextFrame.after().then((_) => result.add(201)));
          futures.add(s.nextFrame.write(2).then((_) => result.add(2)));
          futures.add(s.nextFrame.write(3).then((_) => result.add(3)));
          futures.add(s.nextFrame.read().then((_) => result.add(101)));
          futures.add(s.nextFrame.after().then((_) => result.add(202)));
          futures.add(s.nextFrame.write(1).then((_) => result.add(1)));
          futures.add(s.nextFrame.read().then((_) => result.add(102)));

          await Future.wait(futures);
          expect(result, equals([1, 2, 3, 101, 102, 201, 202]));
        });
      });
    });
  });

  group('Current frame', () {
    group('tasks', () {
      test('write', () async {
        final s = new Scheduler();
        final futures = [];
        int result = 0;

        await s.zone.run(() async {
          await s.nextFrame.write();
          futures.add(s.currentFrame.write(4).then((_) => result++));
          futures.add(s.currentFrame.write(2).then((_) => result++));

          await Future.wait(futures);
          expect(result, equals(2));
        });
      });

      test('read', () async {
        final s = new Scheduler();
        final futures = [];
        int result = 0;

        await s.zone.run(() async {
          await s.nextFrame.write();
          futures.add(s.currentFrame.read().then((_) => result++));
          futures.add(s.currentFrame.read().then((_) => result++));

          await Future.wait(futures);
          expect(result, equals(2));
        });
      });
    });

    test('after', () async {
      final s = new Scheduler();
      final futures = [];
      int result = 0;

      await s.zone.run(() async {
        await s.nextFrame.write();
        futures.add(s.currentFrame.after().then((_) => result++));
        futures.add(s.currentFrame.after().then((_) => result++));

        await Future.wait(futures);
        expect(result, equals(2));
      });
    });

    test('priorities', () async {
      final s = new Scheduler();
      final futures = [];
      final result = [];

      await s.zone.run(() async {
        await s.nextFrame.read();
        futures.add(s.currentFrame.write(1).then((_) => result.add(4)));
        futures.add(s.currentFrame.after().then((_) => result.add(5)));
        futures.add(s.currentFrame.read().then((_) => result.add(1)));
        futures.add(s.currentFrame.write(0).then((_) => result.add(3)));
        futures.add(s.currentFrame.read().then((_) => result.add(2)));

        await Future.wait(futures);
        expect(result, equals([1, 2, 3, 4, 5]));
      });
    });
  });
}
