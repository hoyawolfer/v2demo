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
//    let loadingActivityIndicator = ActivityIndicator()

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

            let topics = HTMLParser.shared.homeTopics(html: response.data)
            self.sections.value = [TopicListSection(header:"home", topics:topics)]
            return Observable.just(topics.isEmpty)
        }).share(replay: 1, scope: SubjectLifetimeScope.forever).observeOn(MainScheduler.instance)
    }

    func removeTopic(for id:String) {
        if sections.value.isEmpty {
            return
        }
        if let index = sections.value[0].topics.index(where: {$0.id == id}) {
            sections.value[0].topics.remove(at: index)
        }
    }
}










