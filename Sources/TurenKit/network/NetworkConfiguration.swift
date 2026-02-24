//
//  NetworkConfiguration.swift
//  TurenKit
//
//  Created by YueTing Weng on 2026/2/24.
//

/// 网络配置结构体
/// 用于存储网络请求的基础配置信息，包括域名和CDN地址
public struct NetworkConfiguration {

    /// API服务器域名地址
    public let domainUrl: String

    /// CDN服务器地址，用于静态资源访问
    public let cdnUrl: String
}
