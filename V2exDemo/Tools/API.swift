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
    case online(value:Int)
    case topic(value:Int)
    case search(on:Bool)
}

enum ThankType {
    case topic(id:String)
    case reply(id:String)
}

enum FavoriteType {
    case topic(id:String, token:String)
    case node(id:String, once:String)
}

enum API {
    // once 凭证
    case once()
    // 登录
    case login(userNameKey:String, passwordKey:String, userName:String, password:String, once:String)
    //注销
    case logout(once:String)
    // Topics
    case topics(nodeHerf:String)
    //每日奖励
    case dailyRewards(once:String)
    //分页列表数据
    case pageList(href:String, page:Int)
    //评论回复
    case comment(topicHref: String, content: String, once: String)
    //感谢
    case thank(type:ThankType, once:String)
    //节点收藏
    case favorite(type:FavoriteType, isCancel:Bool)
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
        case let .pageList(href, _), let .comment(href, _, _):
            if href.contains("#") {
                return href.components(separatedBy: "#").first ?? ""
            }
            return href
        case let .thank(type, _)
            switch type {
            case let .topic(id):
                return "/thank/topic/\(id)"
            case let .reply(id):
                return "/thank/reply/\(id)"
            }
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
        case let .thank(_, token):
            return ["t":token]
        default:
            return nil
        }
    }

    /// The type of HTTP task to be performed.
    var task: Task {
        switch self {
        case let .login(userNameKey, passwordKey, userName, password, once):
            return .requestParameters(parameters: [userNameKey:userName,passwordKey:password,"once":once, "next":"/"], encoding: JSONEncoding.default)
        case let .topics(nodeHref):
            if nodeHref.isEmpty {
                return nil
            }
            let node = nodeHref.replacingOccurrences(of: "/?tab=", with: "")
            return ["tab":node]
        case let .pageList(_, page):
            return page == 0 ? nil : ["p":page]
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












