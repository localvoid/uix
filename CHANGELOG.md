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
