# Holonet

A monorepo.

## Layout

```
apps/
  ios/Astromech/   SwiftUI iOS app
packages/          Shared code
```

## Astromech (iOS)

Requires Xcode 26+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```sh
cd apps/ios/Astromech
xcodegen generate
open Astromech.xcodeproj
```

