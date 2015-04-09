# 0.5.1

- When Virtual Nodes for Components are performing updates they
  doesn't call `Component.update()` anymore, they're only passing new
  `data` and `children`.
- If `Component.invalidate()` method is called when Scheduler is running
  tasks for the currentFrame, Component is registered to the `currentFrame`
  write task queue, otherwise to the `nextFrame`.
- Added new stream `onNextFrame` to the Scheduler.

# 0.5.0

- Fixed wrong sort order for `Scheduler` write tasks.
- Fixed bug with clearing wrong flag for nextTick tasks.
- Removed build step: `ComponentGenerator` and `source_gen`
  dependency.

# 0.4.0

- `createClassName` and `vClassName` auto-generated functions removed.
  Creating Components is now possible with simple `new ClassName()` and
  to create virtual nodes that represent components
  `vComponent($ClassName, ...)`. When metaclasses are implemented in
  Dart, build step will be completely removed, and it will be possible to
  create virtual nodes with `vComponent(ClassName, ...)`. And it will be
  quite easy to migrate existing codebase just by removing `$` prefix
  in all `vComponent` calls.
- `resetTransientSubscriptions`, `resetSubscriptions` renamed to
  `cancelTransientSubscriptions` and `cancelSubscriptions`.
- Added `type` property check when looking for similar virtual nodes.
