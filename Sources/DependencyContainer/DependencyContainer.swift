public protocol DependencyKey {
    associatedtype Value
    static var currentValue: Value { get set }
}

public protocol LazyDependencyKey {
    associatedtype Value
    static var currentValue: Value? { get set }
}

extension LazyDependencyKey {
    static var value: Value {
        get {
            guard let currentValue = currentValue else {
                preconditionFailure("Value must be set before trying to access this property.")
            }
            return currentValue
        }
        set {
            currentValue = newValue
        }
    }
}

public class DependencyContainer {
    private static var current = DependencyContainer()

    public static subscript<T>(key: T.Type) -> T.Value where T: DependencyKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }

    public static subscript<T>(key: T.Type) -> T.Value where T: LazyDependencyKey {
        get { key.value }
        set { key.value = newValue }
    }

    public static subscript<T>(_ keyPath: WritableKeyPath<DependencyContainer, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
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
