public protocol DependencyKey {
    associatedtype Value
    static var value: Value { get set }
}

public protocol LazyDependencyKey {
    associatedtype Value
    static var value: Value? { get set }
}

extension LazyDependencyKey {
    static var lazyValue: Value {
        get {
            guard let value = value else {
                preconditionFailure("Value must be set before trying to access this property.")
            }
            return value
        }
        set {
            value = newValue
        }
    }
}

public class DependencyContainer {
    private static var current = DependencyContainer()

    public static subscript<T>(key: T.Type) -> T.Value where T: DependencyKey {
        get { key.value }
        set { key.value = newValue }
    }

    public static subscript<T>(key: T.Type) -> T.Value where T: LazyDependencyKey {
        get { key.lazyValue }
        set { key.lazyValue = newValue }
    }

    public static subscript<T>(_ keyPath: WritableKeyPath<DependencyContainer, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }

    public static func set<T>(_ initialValue: T.Value, for key: T.Type) -> DependencyContainer.Type where T: DependencyKey {
        key.value = initialValue
        return self
    }

    public static func set<T>(_ initialValue: T.Value, for key: T.Type) -> DependencyContainer.Type where T: LazyDependencyKey {
        key.value = initialValue
        return self
    }
}

@propertyWrapper
public struct Dependency<T> {
    private let keyPath: WritableKeyPath<DependencyContainer, T>

    public var wrappedValue: T {
        get { DependencyContainer[keyPath] }
        set { DependencyContainer[keyPath] = newValue }
    }

    public init(_ keyPath: WritableKeyPath<DependencyContainer, T>) {
        self.keyPath = keyPath
    }
}
