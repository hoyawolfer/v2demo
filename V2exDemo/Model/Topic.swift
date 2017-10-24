//
//  Topic.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/10.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation

enum TapLink {
    case user(info:User)
    case node(info:Node)
    case image(src:String)
    case web(url:URL)
}

struct User {
    var name:String = ""
    var href:String = ""
    var src:String = ""

    init(name:String, href:String, src:String) {
        self.name = name
        self.href = href
        self.src = src
    }
}

extension User {
    enum Avatar:String {
        case normal = "_normal.", mini = "_mini.", large = "_large."
    }

    var srcURLString:String {
        return "https:" + src
    }

    func avatar(_ type:Avatar) -> String {
        let arr = ["_normal.", "_mini.", "_large."]
        if let index = arr.index(where: {srcURLString.hasSuffix($0)}) {
            return srcURLString.replacingOccurrences(of: arr[index], with: type.rawValue)
        }
        return srcURLString
    }
}


struct Topic {

    var title:String = ""
    var content:String = ""
    var href:String = ""
    var owner:User?
    var node:Node?

    var lastReplyTime:String = ""
    var lastReplyUser:User?
    var replyCount:String = "0"
    var creatTime:String = ""
    var token:String = ""
    var isFavorite:Bool = false
    var isThank:Bool = false

    init(title: String = "", content: String = "", href: String = "", owner: User? = nil, node: Node? = nil, lastReplyTime: String = "", lastReplyUser: User? = nil, replyCount: String = "0", creatTime: String = "", token: String = "", isFavorite: Bool = false, isThank: Bool = false) {

        self.title = title
        self.content = content
        self.href = href
        self.owner = owner
        self.node = node
        self.lastReplyTime = lastReplyTime
        self.lastReplyUser = lastReplyUser
        self.replyCount = replyCount
        self.creatTime = creatTime
        self.token = token
        self.isFavorite = isFavorite
        self.isThank = isThank
    }

}

extension Topic {
    var id:String {
        if href.contains("#") {
            return href.components(separatedBy: "#").first?.replacingOccurrences(of: "/t/", with: "") ?? ""
        }
        return href.replacingOccurrences(of: "/t/", with: "")
    }
}
















