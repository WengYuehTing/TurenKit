//
//  Broadcast.swift
//  DucDuc
//
//  Created by Yueting Weng on 2025/9/7.
//

import Foundation

/// Posts a notification with an optional userInfo dictionary.
/// - Parameters:
///   - name: The notification name.
///   - userInfo: Optional additional data for the notification.
public func broadcast (
    name: Notification.Name,
    object: Any? = nil,
    userInfo: [String: Any]? = nil
) {
    NotificationCenter.default.post(
        name: name,
        object: object,
        userInfo: userInfo
    )
}

/// Adds an observer for a specific notification.
/// - Parameters:
///   - observer: The object that acts as the observer.
///   - selector: The method to call when the notification is received.
///   - name: The notification name to observe.
public func observe (
    observer: Any,
    selector: Selector,
    name: Notification.Name
) {
    NotificationCenter.default.addObserver(
        observer,
        selector: selector,
        name: name,
        object: nil
    )
}
