//
//  HTMLParser.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/10.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation
import Kanna

struct HTMLParser {
    static let shared = HTMLParser()

    private init() {

    }

    func HomeModel(data:Data) -> [Topic] {

        let html = try? HTML(html: data, encoding: .utf8)
        let path = html?.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]")

        let unreadPath = path?.first?.xpath("./div[@class='cell'][1]/table/tr/td[1]/input")
        var unreadCount = "0"

        if let unreadChar = unreadPath?.first?["value"]?.characters.first {
            unreadCount = String(unreadChar)
        }

        let items = path?.first?.xpath("./div[@class='cell item']").flatMap({e -> Topic? in
            if let userSrc = e.xpath(".//td[1]/a/img").first?["src"],
                let nodeHref = e.xpath(".//td[3]/span[1]/a").first?["href"],
                let nodeName = e.xpath(".//td[3]/span[1]/a").first?.content,
                let userHref = e.xpath(".//td[3]/span[1]/strong/a").first?["href"],
                let username = e.xpath(".//td[3]/span[1]/strong/a").first?.content,
                let topicHref = e.xpath(".//td[3]/span[2]/a[1]").first?["href"],
                let topicTitle = e.xpath(".//td[3]/span[2]/a[1]").first?.content,
                let lastReplyTime = e.xpath(".//td[3]/span[3]").first?.content {

                var lastReplyerUser: User?
                if let lastReplyerHref = e.xpath(".//td[3]/span[3]/strong/a").first?["href"],
                    let lastReplyerName = e.xpath(".//td[3]/span[3]/strong/a").first?.content {
                    lastReplyerUser = User(name: lastReplyerName, href: lastReplyerHref, src: "")
                }

                let owner = User(name: username, href: userHref, src: userSrc)
                let node = Node(name: nodeName, href: nodeHref)
                let replyCount = e.xpath(".//td[4]/a").first?.content ?? "0"
                let topic = Topic(title: topicTitle, href: topicHref, owner: owner, node: node, lastReplyTime: lastReplyTime, lastReplyUser: lastReplyerUser, replyCount: replyCount)

                return topic
            }
            return nil
        })

        return items ?? []
    }


}

