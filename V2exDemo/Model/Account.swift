//
//  Account.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/16.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Kanna

struct Account {
    let isDailyRewards = Variable<Bool>(false)
    let unreadCount = Variable<Int>(0)

    let user = Variable<User?>(nil)
    let isLoggedIn = Variable<Bool>(false)

//    var privacy:
    private let disposeBag = DisposeBag()

    static var shared = Account()
    private init() {

    }

    mutating func logout() {
        isLoggedIn.value = false
        user.value = nil

        HTTPCookieStorage.shared.cookies?.forEach({ (cookie) in
            HTTPCookieStorage.shared.deleteCookie(cookie)
        })

        API.provider.rxRequest(API.once()).asObservable().flatMapLatest { response -> Observable<Response> in
            if let once = HTMLParser.shared.once(html: response.data) {
                return API.provider.rxRequest(API.logout(once: once)).asObservable()
            }else {
                return Observable.error(NetError.message(text: "获取once失败"))
            }
        }.share(replay: 1, scope: SubjectLifetimeScope.whileConnected).subscribe().disposed(by: disposeBag)
    }

    func redeemDailyRewards() -> Observable<Bool> {
        return API.provider.rxRequest(API.once()).asObservable().flatMapLatest({ response -> Observable<Bool> in
            if let once = HTMLParser.shared.once(html: response.data) {
                return API.provider.rxRequest(API.dailyRewards(once: once)).asObservable().flatMapLatest({ res  -> Observable<Bool> in
                    guard let html = try? HTML(html: res.data, encoding: String.Encoding.utf8) else {
                        return Observable.error(NetError.message(text: "请求获取失败"))
                    }
                    let path = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box']/div[@class='message']")
                    if let content = path.first?.content, content.contains("已成功领取") {
                        return Observable.just(true)
                    } else {
                        return Observable.error(NetError.message(text: "领取成功"))
                    }
                }).asObservable()
            } else {
                return Observable.error(NetError.message(text: "领取奖励失败"))
            }
        }).share(replay: 1, scope: SubjectLifetimeScope.whileConnected).asObservable()
    }


}



















