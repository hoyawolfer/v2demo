//
//  AppStyle.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/17.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import UIKit
import RxSwift

let nightOnKey = "theme.night.on"

struct CSSColorMark {
    static let background = "#background#"
    static let subtleBackground = "#subtle#"
    static let topicContent = "#topic_content#"
    static let replyContent = "#reply_content#"
    static let hyperlink = "#hyperlink#"
    static let codePre = "#codePre#"
    static let separator = "#separator#"
}

struct AppStyle {
    static var shared = AppStyle()
    let themeUpdateVariable = Variable<Bool>(false)
    var css:String = ""
    var theme:Theme = UserDefaults.standard.bool(forKey: nightOnKey) ? Theme.night : Theme.normal {
        didSet {
            UserDefaults.standard.set(theme == .night, forKey: nightOnKey)
            self.themeUpdateVariable.value = true
        }
    }

    private init() {
        if let stylePath = Bundle.main.path(forResource: "style", ofType: "css") {
            do {
                self.css = try String(contentsOfFile: stylePath, encoding: String.Encoding.utf8)
            } catch {

            }
        }
    }

    func setupBarStyle(_ navigationBar:UINavigationBar = UINavigationBar.appearance()) {
        navigationBar.isTranslucent = false
        navigationBar.tintColor = theme.tintColor
        navigationBar.barTintColor = theme.barTintColor
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:theme.navigationBarTitleColor, NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)]
//        navigationBar.backIndicatorImage =
//        navigationBar.backIndicatorTransitionMaskImage =
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font:UIFont.systemFont(ofSize: 16)], for: .normal)

    }


}










