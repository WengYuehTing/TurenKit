//
//  Thread.swift
//  XFoundation
//
//  Created by Yueting Weng on 2025/9/3.
//

import Foundation

/// 线程安全的属性包装器
/// 使用 os_unfair_lock 提供线程安全访问
@propertyWrapper
public struct ThreadSafe<T> {
    private var value: T
    private var lock = os_unfair_lock()

    /// 初始化线程安全的属性包装器
    /// - Parameter wrappedValue: 初始值
    public init(wrappedValue: T) {
        value = wrappedValue
    }

    public var wrappedValue: T {
        mutating get {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            return value
        }
        set {
            os_unfair_lock_lock(&lock)
            defer { os_unfair_lock_unlock(&lock) }
            value = newValue
        }
    }
}
