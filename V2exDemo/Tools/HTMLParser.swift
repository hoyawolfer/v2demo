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
    //凭证
    func once(html data:Data) -> String? {
        guard let html = try? HTML(html: data, encoding: String.Encoding.utf8) else {
            return nil
        }

        if let onceElement = html.css("input").first(where: {$0["name"] == "once"}) {
            if let value = onceElement["value"] {
                return value
            }
        }
        return nil
    }
    //节点导航
    func nodesNavigation(html data:Data) -> [(name:String, content:String)] {
        guard let html = try? HTML(html: data, encoding: String.Encoding.utf8) else {
            return []
        }
        let path = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][last()]/div[position()>1]")
        let items = path.flatMap { e -> (name:String, content:String)? in
            if let name = e.xpath("./table/tr/td[1]/span").first?.content,
                let content = e.xpath("./table/tr/td[2]").first?.innerHTML {
                return (name, content)
            }
            return nil
        }
        return items
    }

    func topicDetails(html data:Data) -> (topic:Topic, currentPage:Int, countTime:String, comments:[Comment])? {

    }

    func homeNodes(html data:Data) -> [Node] {
        let html = try? HTML(html: data, encoding: .utf8)

        var nodePath = html?.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='cell'][1]/a")
        let infoPath = html?.xpath("//body/div[@id='Top']/div[@class='content']//table/tr/td[3]/a[1]")
        if let nameHref = infoPath.first?["href"], nameHref.hasPrefix("/member/") {
            if let title = html?.xpath("//head/title").first?.content, title.contains("两步验证登录") {
//                Account.shared.logout()
                return []
            }
            //已经登录
            let username = nameHref.replacingOccurrences(of: "/member/", with: "")
            let src = infoPath.first?.xpath("./img").first?["src"] ?? ""
//            Account.shared.user.value = User(name: username, href: nameHref, src: src)
//            Account.shared.isLoggedIn.value = true

            let dailyPath = html?.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='inner']/a")
            if let href = dailyPath.first?["href"], href == "/mission/daily" {
                //领取今日的登录奖励
                Account.shared.isDailyRewards.value = true
                nodePath = html?.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][2]/div[@class='cell'][2]/a")
            }else {
                Account.shared.isDailyRewards.value = false
                nodePath = html?.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='cell'][2]/a")
            }
        }

        let nodes = nodePath.flatMap({e -> Node? in
            if let href = e["href"], let name = e.content, let className = e.className {
                return Node(name: name, href: href, isCurrent: className.hasSuffix("current"))
            }
            return nil
        })
        return nodes

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

