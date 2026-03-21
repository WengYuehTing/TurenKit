//
//  Logger.swift
//  TurenKit
//
//  Created by YueTing Weng on 2026/2/24.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    // MARK: - Business Domain Loggers

    /// Network 网络模块日志
    static let network = Logger(subsystem: subsystem, category: "TurenKit_Network_Module")
}
