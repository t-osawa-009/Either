import Foundation
/// https://github.com/eMdOS/fswift/blob/main/Sources/Algebra/Algebraic/Either.swift

public enum Either<L, R> {
    case left(L)
    case right(R)
}

public extension Either {
    static func left(with left: L) -> Either<L, R> {
        return .left(left)
    }
    
    static func right(with right: R) -> Either<L, R> {
        return .right(right)
    }
    
    var left: L? {
        switch self {
        case .left(let l): return l
        case .right: return nil
        }
    }
    
    var right: R? {
        switch self {
        case .left: return nil
        case .right(let r): return r
        }
    }
    
    var isLeft: Bool {
        switch self {
        case .left:
            return true
        case .right:
            return false
        }
    }
    
    var isRight: Bool {
        !isLeft
    }
    
    func fold<Value>(_ onLeft: ((L) -> Value), _ onRight: (R) -> Value) -> Value {
        switch self {
        case let .left(a): return onLeft(a)
        case let .right(b): return onRight(b)
        }
    }
    
    func tryFold<Value>(_ onLeft: ((L) throws -> Value), _ onRight: (R) throws -> Value) rethrows -> Value {
        switch self {
        case let .left(a): return try onLeft(a)
        case let .right(b): return try onRight(b)
        }
    }
    
    func leftMap<Value>(_ transform: (L) -> Value) -> Either<Value, R> {
        switch self {
        case .left(let value):
            return .left(transform(value))
        case .right(let value):
            return .right(value)
        }
    }
    
    func rightMap<Value>(_ transform: (R) -> Value) -> Either<L, Value> {
        switch self {
        case .left(let value):
            return .left(value)
        case .right(let value):
            return .right(transform(value))
        }
    }
    
    func leftFlatMap<Value>(_ transform: (L) -> Either<Value, R> ) -> Either<Value, R> {
        switch self {
        case .left(let value):
            return transform(value)
        case .right(let value):
            return .right(value)
        }
    }
    
    func rightFlatMap<Value>(_ transform: (R) -> Either<L, Value>) -> Either<L, Value> {
        switch self {
        case .right(let value):
            return transform(value)
        case .left(let value):
            return .left(value)
        }
    }
}

extension Either: Decodable where L: Decodable, R: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            let l = try container.decode(L.self)
            self = .left(l)
        } catch {
            let r = try container.decode(R.self)
            self = .right(r)
        }
    }
}

extension Either: Encodable where L: Encodable, R: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .left(let a):
            try container.encode(a)
        case .right(let b):
            try container.encode(b)
        }
    }
}

extension Either: Equatable where L: Equatable, R: Equatable {
    public static func == (lhs: Either, rhs: Either) -> Bool {
        switch (lhs, rhs) {
        case (.left(let leftValue), .left(let rightValue)):
            return leftValue == rightValue
        case (.right(let leftValue), .right(let rightValue)):
            return leftValue == rightValue
        default:
            return false
        }
    }
}
