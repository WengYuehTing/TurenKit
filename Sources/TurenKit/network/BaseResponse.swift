//
//  BaseResponse.swift
//  TurenKit
//
//  Created by YueTing Weng on 2026/2/24.
//

import HandyJSON

/// 网络响应协议
/// 定义了网络响应对象的基本接口，继承自 HandyJSON 以支持 JSON 反序列化
/// 使用关联类型 Output 来指定响应数据的实际类型
public protocol BaseResponse: HandyJSON {

    /// 响应数据的实际类型
    associatedtype Output

    /// 响应状态码
    /// 通常用于判断请求是否成功
    var code: Int { get }

    /// 响应消息
    /// 通常包含成功或失败的描述信息
    var message: String { get }

    /// 响应数据
    /// 包含实际的业务数据，类型由 Output 关联类型指定
    var data: Output { get }
}
