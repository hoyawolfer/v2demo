//
//  TopicDetailsSection.swift
//  V2exDemo
//
//  Created by 黄亚武 on 28/10/2017.
//  Copyright © 2017 Zaixuan. All rights reserved.
//

import Foundation
import RxDataSources

enum SectionType {
    case more, data
}

struct TopicDetailsSection {
    var type:SectionType
    var comments:[Comment]
    
    init(type:SectionType, comments:[Comment]) {
        self.type = type
        self.comments = comments
    }
}

extension TopicDetailsSection:AnimatableSectionModelType {
    typealias Identity = SectionType
    typealias Item = Comment
    init(original:TopicDetailsSection, items:[Item]) {
        self = original
        self.comments = items
    }
    
    var identity:SectionType {
        return type
    }
    
    var items:[Comment] {
        return comments
    }
}

extension Comment:IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity:String {
        return number
    }
    
    static func == (lhs:Comment, rhs:Comment) -> Bool {
        return lhs.number == rhs.number
    }
}

extension TopicDetailsSection:Equatable {
    static func == (lhs:TopicDetailsSection, rhs:TopicDetailsSection) -> Bool {
        return lhs.type == rhs.type && lhs.items == rhs.items
    }
}










































