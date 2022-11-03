# DependencyContainer

Adds support for `@propertyWrapper` dependency injection:

```swift
@Dependency(\.loginService) var loginService
```

In order to achieve this you just have to add your own key to `DependencyContainer`:

```swift
public protocol LoginService: AnyObject {
    func login(_ request: LoginRequest) async throws -> LoginResponse
}

public struct LoginServiceDependencyKey: LazyDependencyKey {
    public static var value: LoginService?
}

extension DependencyContainer {
    public var loginService: LoginService {
        get { DependencyContainer[LoginServiceDependencyKey.self] }
        set { DependencyContainer[LoginServiceDependencyKey.self] = newValue }
    }
}
```

Then on app launch you just need to override the dependency like so:

```swift
func registerDependencies() {
    DependencyContainer[LoginServiceDependencyKey.self] = LoginApiService()
}
```

Inspired by: [Antoine van der Lee](https://www.avanderlee.com/swift/dependency-injection/) and [Point Free](https://github.com/pointfreeco/swift-composable-architecture/tree/main/Sources/Dependencies)
