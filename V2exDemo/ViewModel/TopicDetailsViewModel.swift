//
//  TopicDetailsViewModel.swift
//  V2exDemo
//
//  Created by 黄亚武 on 28/10/2017.
//  Copyright © 2017 Zaixuan. All rights reserved.
//

import RxSwift
import Moya
import Kanna

class TopicDetailsViewModel {
    
    let content = Variable<String>("")
    let countTime = Variable<String>("")
    let sections = Variable<[TopicDetailsSection]>([])
    let updateTopic = Variable<Topic?>(nil)
    let loadingActivityIndicator = ActivityIndicator()
    let loadMoreActivityIndicator = ActivityIndicator()
    
    var currentPage = 1
    private let disposeBag = DisposeBag()
    
    var topic:Topic
    var htmlContent:String?
    init(topic:Topic) {
        self.topic = topic
        
    }
    
    func insertNew(text:String, atName:String?) {
        var atString = ""
        var string = text
        if let atName = atName {
            string = text.replacingOccurrences(of: "@\(atName) ", with: "")
            atString = "@<a href=\"/member/\(atName)\">\(atName)</a> "
        }
        let content = "<div class=\"reply_content\">\(atString)\(string)</div>"
        
        let number = currentPage > 1 ? sections.value[1].comments.count : sections.value[0].comments.count
        let comment = Comment(id: "", content: content, time: "刚刚", thanks: "0", number: "\(number + 1)", user: Account.shared.user.value)
        
        if currentPage > 1 {
            sections.value[1].comments.append(comment)
        } else {
            sections.value[0].comments.append(comment)
        }
    }
    
    func fetchDetails(href:String) {
        API.provider.rx.request(.page).
    }
}






























