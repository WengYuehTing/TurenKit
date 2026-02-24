//
//  RequestLoggerPlugin.swift
//  TurenKit
//
//  Created by YueTing Weng on 2026/2/24.
//

import Foundation
import Moya
import OSLog

public final class RequestLoggerPlugin: PluginType {
    // MARK: - Constants

    public init() {}

    private enum Constants {
        static let maxLogLength = 1000
        static let truncationSuffix = "... (truncated)"
        static let unknownMethod = "UNKNOWN"
        static let unknownURL = "UNKNOWN URL"
        static let binaryDataPrefix = "<Binary data, size: "
        static let binaryDataSuffix = " bytes>"
    }

    // MARK: - Plugin Methods

    /// 在发送请求前调用，用于打印请求信息
    public func willSend(_ request: RequestType, target _: TargetType) {
        guard let request = request.request else {
            Logger.network.warning("Request is nil")
            return
        }

        let method = request.httpMethod ?? Constants.unknownMethod
        let url = request.url?.absoluteString ?? Constants.unknownURL
        let parametersString = buildParametersString(from: request)

        // 打印请求信息
        if !parametersString.isEmpty {
            let logMessage = "[\(method)] \(url) with parameters:\n\(parametersString)"
            Logger.network.info("\(self.truncateIfNeeded(logMessage))")
        } else {
            Logger.network.info("[\(method)] \(url)")
        }
    }

    /// 在收到响应后调用，用于打印响应信息
    public func didReceive(_ result: Result<Response, MoyaError>, target _: TargetType) {
        switch result {
        case let .success(response):
            let statusCode = response.statusCode
            let url = response.request?.url?.absoluteString ?? Constants.unknownURL
            let responseString = buildResponseString(from: response)

            // 打印响应信息
            if !responseString.isEmpty {
                let logMessage = "[\(statusCode)] \(url) finished with response:\n\(responseString)"
                Logger.network.info("\(self.truncateIfNeeded(logMessage))")
            } else {
                Logger.network.info("[\(statusCode)] \(url) finished")
            }

        case let .failure(error):
            let url = error.response?.request?.url?.absoluteString ?? Constants.unknownURL
            let logMessage = "[ERROR] \(url) failed: \(error.localizedDescription)"
            Logger.network.error("\(self.truncateIfNeeded(logMessage))")
        }
    }

    // MARK: - Private Methods

    /// 构建请求参数字符串
    private func buildParametersString(from request: URLRequest) -> String {
        var parameters: [String] = []

        // 处理请求体参数
        if let bodyString = extractBodyString(from: request.httpBody) {
            parameters.append(bodyString)
        }

        // 处理URL查询参数
        if let queryString = extractQueryString(from: request.url) {
            parameters.append(queryString)
        }

        return parameters.joined(separator: "\n")
    }

    /// 提取请求体字符串
    private func extractBodyString(from body: Data?) -> String? {
        guard let body = body else { return nil }

        if let bodyString = String(data: body, encoding: .utf8) {
            if let jsonData = bodyString.data(using: .utf8),
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                return prettyPrint(jsonObject)
            } else {
                // 如果不是JSON，直接使用原始字符串
                return bodyString
            }
        } else {
            return Constants.binaryDataPrefix + "\(body.count)" + Constants.binaryDataSuffix
        }
    }

    /// 提取URL查询参数字符串
    private func extractQueryString(from url: URL?) -> String? {
        guard let url = url,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              !queryItems.isEmpty
        else {
            return nil
        }

        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value ?? "") })
        return prettyPrint(queryDict)
    }

    /// 构建响应字符串
    private func buildResponseString(from response: Response) -> String {
        guard let responseData = try? response.mapString() else { return "" }

        if let jsonData = responseData.data(using: .utf8),
           let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
            return prettyPrint(jsonObject)
        } else {
            return responseData
        }
    }

    /// 美化打印字典数据
    private func prettyPrint(_ dictionary: [String: Any]) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted]),
              let string = String(data: data, encoding: .utf8)
        else {
            return String(describing: dictionary)
        }
        return string
    }

    /// 如果字符串过长则截断
    private func truncateIfNeeded(_ string: String) -> String {
        if string.count <= Constants.maxLogLength {
            return string
        }

        let truncatedLength = Constants.maxLogLength - Constants.truncationSuffix.count
        let truncatedString = String(string.prefix(truncatedLength))
        return truncatedString + Constants.truncationSuffix
    }
}
