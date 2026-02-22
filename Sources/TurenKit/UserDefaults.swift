//
//  UserDefaults.swift
//  XFoundation
//
//  Created by Yueting Weng on 2025/9/3.
//

import Foundation

/// UserDefaults 属性包装器
/// 提供类型安全的 UserDefaults 访问
@propertyWrapper
public struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: Foundation.UserDefaults

    /// 初始化 UserDefaults 属性包装器
    /// - Parameters:
    ///   - key: UserDefaults 键名
    ///   - defaultValue: 默认值
    ///   - userDefaults: UserDefaults 实例，默认为 standard
    public init(
        _ key: String,
        defaultValue: T,
        userDefaults: Foundation.UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    /// 初始化支持 App Groups 的 UserDefaults 属性包装器
    /// - Parameters:
    ///   - key: UserDefaults 键名
    ///   - defaultValue: 默认值
    ///   - appGroupIdentifier: App Group 标识符
    public init(
        _ key: String,
        defaultValue: T,
        appGroupIdentifier: String
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = Foundation.UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }

    public var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key) as? T else {
                return defaultValue
            }
            return value
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }

    public var projectedValue: UserDefault<T> {
        return self
    }

    /// 删除存储的值
    public func remove() {
        userDefaults.removeObject(forKey: key)
    }

    /// 检查是否包含该键
    public var exists: Bool {
        return userDefaults.object(forKey: key) != nil
    }
}

// MARK: - Optional Support

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

// MARK: - Codable Support

/// 支持 Codable 的 UserDefaults 属性包装器
@propertyWrapper
public struct UserDefaultCodable<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: Foundation.UserDefaults

    /// 初始化支持 Codable 的 UserDefaults 属性包装器
    /// - Parameters:
    ///   - key: UserDefaults 键名
    ///   - defaultValue: 默认值
    ///   - userDefaults: UserDefaults 实例，默认为 standard
    public init(
        _ key: String,
        defaultValue: T,
        userDefaults: Foundation.UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    /// 初始化支持 App Groups 的 Codable UserDefaults 属性包装器
    /// - Parameters:
    ///   - key: UserDefaults 键名
    ///   - defaultValue: 默认值
    ///   - appGroupIdentifier: App Group 标识符
    public init(
        _ key: String,
        defaultValue: T,
        appGroupIdentifier: String
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = Foundation.UserDefaults(suiteName: appGroupIdentifier) ?? .standard
    }

    public var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key) else {
                return defaultValue
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                print("UserDefaultsCodable: Failed to decode value for key '\(key)': \(error)")
                return defaultValue
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                userDefaults.set(data, forKey: key)
            } catch {
                print("UserDefaultsCodable: Failed to encode value for key '\(key)': \(error)")
            }
        }
    }

    public var projectedValue: UserDefaultCodable<T> {
        return self
    }

    /// 删除存储的值
    public func remove() {
        userDefaults.removeObject(forKey: key)
    }

    /// 检查是否包含该键
    public var exists: Bool {
        return userDefaults.object(forKey: key) != nil
    }
}
