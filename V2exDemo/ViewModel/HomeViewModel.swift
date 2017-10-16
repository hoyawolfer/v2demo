//
//  HomeViewModel.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/9/30.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class HomeViewModel {

    let sections = Variable<[TopicListSection]>([])
    let defaultNodes = Variable<[Node]>([])

    var nodesNavigation:[(name:String, content:String)] = []

    var nodeHerf:String = ""
    private let dispostBag = DisposeBag()

    func fetchTopics() -> Observable<Bool>{
        return API.provider.rxRequest(API.topics(nodeHerf: nodeHerf)).asObservable().flatMapLatest({ response -> Observable<Bool> in
            if self.defaultNodes.value.isEmpty {
                let nodes = HTMLParser.shared.homeNodes(html: response.data)
                self.defaultNodes.value = nodes
            }
            if self.nodesNavigation.isEmpty {
                let navigation = HTMLParser.shared.nodesNavigation(html: response.data)
                self.nodesNavigation = navigation
            }

            let topics = HTMLParser.shared.home

        }).share(replay: 1, scope: SubjectLifetimeScope.forever).observeOn(MainScheduler.instance)
    }
}
