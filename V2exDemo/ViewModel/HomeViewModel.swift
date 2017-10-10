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

    func fetchTopics() -> Observable<Bool> {
        return API.provider.rxRequest(API.topics(nodeHerf: nodeHerf)).sub
    }
}
