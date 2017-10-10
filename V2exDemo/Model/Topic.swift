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
    var herf:String = ""
    var src:String = ""

    init(name:String, herf:String, src:String) {
        self.name = name
        self.herf = herf
        self.src = src
    }
}


struct Topic {

    var title:String = ""
    var content:String = ""
    var herf:String = ""
    var ower:User?
    var node:Node?

    var lastReplyTime:String = ""
    var lastReplyUser:User?
    var replyCount:Stirng = "0"
    var creatTime:String = ""
    var token:String = ""
    var isFavorite:Bool = false
    var isThank:Bool = false

    init(title:String,
         content:String,
         herf:String,
         ower:User,
         node:Node,
         lastReplyTime:String,
         lastReplyUser:User,
         replyCount:Stirng,
         creatTime:String,
         token:String,
         isFavorite:Bool,
         isThank:Bool) {

        self.title = title
        self.content = content
        self.herf = herf
        self.ower = ower
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

















