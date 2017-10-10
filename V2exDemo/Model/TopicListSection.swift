//
//  TopicListSection.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/9/30.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation

struct TopicListSection {
    var header:String
    var topics:[Topic]

    init(header:String, topics:[Topic]) {
        self.header = header
        self.topics = topics
    }
    
}
