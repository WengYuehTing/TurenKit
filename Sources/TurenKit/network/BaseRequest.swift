//
//  BaseRequest.swift
//  TurenKit
//
//  Created by YueTing Weng on 2026/2/24.
//

import HandyJSON
import Foundation

/// 网络请求协议
/// 定义了网络请求对象的基本接口，继承自 HandyJSON 以支持 JSON 序列化
public protocol BaseRequest: HandyJSON {
    /// 将请求对象转换为 JSON 字典
    /// - Returns: 包含请求参数的 JSON 字典
    func asJson() -> [String: Any]
}

/// Request 协议扩展，提供默认的 JSON 转换实现
public extension BaseRequest {
    /// 将请求对象转换为 JSON 字典的默认实现
    /// 使用 HandyJSON 进行序列化，然后转换为标准字典格式
    /// - Returns: 包含请求参数的 JSON 字典，转换失败时返回空字典
    func asJson() -> [String: Any] {
        guard let jsonString = self.toJSONString(),
              let data = jsonString.data(using: .utf8),
              let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return [:]
        }
        return dict
    }
}
