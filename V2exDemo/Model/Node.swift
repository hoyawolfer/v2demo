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
    var herf:String = ""
    var isCurrent:Bool = false

    var icon:String = ""
    var comments:Int = 0

    init(name:String, herf:String, isCurrent:Bool, icon:String, comments:Int) {
        self.name = name
        self.herf = herf
        self.isCurrent = isCurrent
        self.icon = icon
        self.comments = comments
    }
}
