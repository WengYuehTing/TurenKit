//
//  AccessTokenPlugin.swift
//  TurenKit
//
//  Created by YueTing Weng on 2026/2/24.
//

import Foundation
import HandyJSON
import Moya
import OSLog

public final class AccessTokenPlugin: PluginType {

    public init() {}

    public func didReceive(_ result: Result<Response, MoyaError>, target _: TargetType) {
        switch result {
        case let .success(response):
            guard response.statusCode == 200 else { return }
            let businessCode = response.extractBusinessCode()
            if businessCode == 401 {
                NotificationCenter.default.post(
                    name: .TurenKit_AccessTokenDidExpire,
                    object: nil
                )
            }
        case let .failure(error):
            Logger.network.error("AccessTokenPlugin failed with error: \(error.localizedDescription)")
        }
    }
}
