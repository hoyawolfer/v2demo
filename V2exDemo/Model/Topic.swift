//
//  Topic.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/10.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation

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

















