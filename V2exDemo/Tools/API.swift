//
//  API.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/9/30.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation
import Moya

enum PrivicyType {

}

enum API {
    // once 凭证
    case once()
    // 登录
    case login(userNameKey:String, passwordKey:String, userName:String, password:String, once:String)
    // Topics
    case topics(nodeHerf:String)
}

extension API:TargetType {

    var headers: [String : String]? {
        switch self{
        case .once:
            let headers = ["Origin": "https://www.v2ex.com",
                           "Content-Type": "application/x-www-form-urlencoded"]
            return headers
        case .login(userNameKey: _, passwordKey: _, userName: _, password: _, once: _):
            let headers = ["Referer": "https://www.v2ex.com/signin",
                           "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 10_2_1 like Mac OS X) AppleWebKit/602.4.6 (KHTML, like Gecko) Version/10.0 Mobile/14D27 Safari/602.1"]
            return headers
        default:
            let headers = ["User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 10_2_1 like Mac OS X) AppleWebKit/602.4.6 (KHTML, like Gecko) Version/10.0 Mobile/14D27 Safari/602.1"]
            return headers
        }
    }

    /// The target's base `URL`.
    var baseURL: URL {
        return URL(string: "http://www.v2ex.com")!
    }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self {
        case .once():
            return "/signin"
        case .login(userNameKey: _, passwordKey: _, userName: _, password: _, once: _):
            return "signin"
        default:
            return ""
        }
    }

    /// The HTTP method used in the request.
    var method: Moya.Method {
        switch self {
        case .login(userNameKey: _, passwordKey: _, userName: _, password: _, once: _):
            return .post
        default:
            return .get
        }
    }

    /// Provides stub data for use in testing.
    var sampleData: Data {
        return Data()
    }

    var parameters: [String: Any]? {
        switch self {
        case let .login(userNameKey, passwordKey, userName, password, once):
            return [userNameKey:userName,passwordKey:password,"once":once, "next":"/"]
        case let .topics(nodeHerf):
            if nodeHerf.isEmpty {
                return nil
            }
            let node = nodeHerf.replacingOccurrences(of: "/?tab=", with: "")
            return ["tab":node]
        default:
            return nil
        }
    }

    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool {
        return true
    }

}

extension API {
    static let provider = MoyaProvider<API>()
}












