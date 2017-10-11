//
//  Node.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/9/30.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation

struct Node {
    var name:String = ""
    var href:String = ""
    var isCurrent:Bool = false

    var icon:String = ""
    var comments:Int = 0

    init(name:String, href:String, isCurrent:Bool = false, icon:String = "", comments:Int = 0) {
        self.name = name
        self.href = href
        self.isCurrent = isCurrent
        self.icon = icon
        self.comments = comments
    }
}
