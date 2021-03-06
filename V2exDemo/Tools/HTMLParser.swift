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

    func homeTopics(html data:Data) -> [Topic] {
        guard let html = try? HTML(html: data, encoding: String.Encoding.utf8) else {
            return []
        }
        var path = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]")
        if Account.shared.isLoggedIn.value && Account.shared.isDailyRewards.value {
            path = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][2]")
        }
        let unreadPath = path.first?.xpath("./div[@class='cell'][1]/table/tr/td[1]/input")
        var unreadCount = "0"
        if let unreadChar = unreadPath?.first?["value"]?.characters.first {
            unreadCount = String(unreadChar)
        }
        if let count = Int(unreadCount) {
            Account.shared.unreadCount.value = count
        }
        let items = path.first?.xpath("./div[@class='cell item']").flatMap({e -> Topic? in
            if let userSrc = e.xpath(".//td[1]/a/img").first?["src"],
                let nodeHref = e.xpath(".//td[3]/span[1]/a").first?["href"],
                let nodeName = e.xpath(".//td[3]/span[1]/a").first?.content,
                let userHref = e.xpath(".//td[3]/span[1]/strong/a").first?["href"],
                let userName = e.xpath(".//td[3]/span[1]/strong/a").first?.content,
                let topicHref = e.xpath(".//td[3]/span[2]/a[1]").first?.content,
                let topicTitle = e.xpath(".//td[3]/span[2]/a[1]").first?.content,
                let lastReplyTime = e.xpath(".//td[3]/span[3]").first?.content {

                var lastReplyerUser:User?
                if let lastReplyerHref = e.xpath(".//td[3]/span[3]/strong/a").first?["href"],
                    let lastReplyerName = e.xpath(".//td[3]/span[3]/strong/a").first?.content {
                    lastReplyerUser = User(name: lastReplyerName, href: lastReplyerHref, src: "")
                }
                let owner = User(name: userName, href: userHref, src: userSrc)
                let node = Node(name: nodeName, href: nodeHref)
                let replyCount = e.xpath(".//td[4]/a").first?.content ?? "0"
                let topic = Topic(title: topicTitle, content: "", href: topicHref, owner: owner, node: node, lastReplyTime: lastReplyTime, lastReplyUser: lastReplyerUser, replyCount: replyCount)
                return topic
            }
            return nil
        })
        return items ?? []
    }

    func topicDetails(html data:Data) -> (topic:Topic, currentPage:Int, countTime:String, comments:[Comment])? {
        
        guard let html = try? HTML(html: data, encoding: String.Encoding.utf8) else {
            return nil
        }
        
        let tokenPath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='inner']/div[@class='fr']/a[@class='op'][1]")
        let token = tokenPath.first?["herf"]?.components(separatedBy: "?t=").last ?? ""
        let isFavorite = tokenPath.first?["herf"]?.contains("unfavorite") ?? false
        let thankPath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='inner']/div[@class='fr']/div[@id='topic_thank']")
        let isThank = thankPath.first?.content?.contains("感谢已发送") ?? false
        
        let creatTimePath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='header']/small[@class='gray']")
        let creatTimeString = creatTimePath.first?.content ?? ""
        let creatTime = creatTimeString.components(separatedBy: " at ").last ?? ""
        let contentPath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='cell']/div[@class='topic_content']")
        let subtlePath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='subtle']")
        let subtle = subtlePath.flatMap({$0.toHTML}).joined(separator: "")
        let content = (contentPath.first?.toHTML ?? "") + subtle
        let replyTimePath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][2]/div[@class='cell'][1]")
        let countTime = (replyTimePath.first?.content ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pagePath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][2]/div[starts-with(@class,'inner')]/*[contains(@class,'page_current')]")
        var currentPage = 1
        if let page = pagePath.first?.content {
            currentPage = Int(page) ?? 1
        }
        var owner:User?
        let headerPath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='header']")
        if let ownerHref = headerPath.first?.xpath("./div[@class='fr']/a").first?["href"],
            let ownerSrc = headerPath.first?.xpath("./div[@class='fr']/a/img").first?["href"],
            let ownerName = headerPath.first?.xpath("./small[@class='gray']/a").first?.content {
                owner = User(name: ownerName, href: ownerHref, src: ownerSrc)
        }
        
        var node:Node?
        if let nodeName = headerPath.first?.xpath("./a[2]").first?.content,
            let nodeHref = headerPath.first?.xpath("./a[2]").first?["href"]{
            node = Node(name: nodeName, href: nodeHref)
        }
        let title = headerPath.first?.xpath("./h1").first?.content ?? ""
        let replyContentPath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][2]/div[contains(@id,'r_')]")
        let comments = replyContentPath.flatMap({e -> Comment? in
            if let src = e.xpath("./table/tr/td[1]/img").first?["src"],
                let userHref = e.xpath("./table/tr/td[3]/strong/a").first?["href"],
                let userName = e.xpath("./table/tr/td[3]/strong/a").first?.content,
                let time = e.xpath("./table/tr/td[3]/span[1]").first?.content,
                let text = e.xpath("./table/tr/td[3]/div[@class='reply_content']").first?.toHTML {
                
                let thanks = e.xpath("./table/tr/td[3]/span[2]").first?.content ?? "0"
                let number = e.xpath("./table/tr/td[3]/div[@class='fr']/span[@class='no']").first?.content ?? "0"
                let user = User(name: userName, href: userHref, src: src)
                let replyId = e["id"]?.replacingOccurrences(of: "r_", with: "") ?? ""

                return Comment(id: replyId, content: text, time: time, thanks: thanks, number: number, user: user)
            }
            return nil
        })

        let topic = Topic(title: title, content: content, href: "", owner: owner, node: node, lastReplyTime: "", lastReplyUser: nil, replyCount: "", creatTime: creatTime, token: token, isFavorite: isFavorite, isThank: isThank)
        return (topic, currentPage, countTime, comments)
    }

    func homeNodes(html data:Data) -> [Node] {
        guard let html = try? HTML(html: data, encoding: String.Encoding.utf8) else {
            return []
        }

        var nodePath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='cell'][1]/a")
        let infoPath = html.xpath("//body/div[@id='Top']/div[@class='content']//table/tr/td[3]/a[1]")
        if let nameHref = infoPath.first?["href"], nameHref.hasPrefix("/member/") {
            if let title = html.xpath("//head/title").first?.content, title.contains("两步验证登录") {
                Account.shared.logout()
                return []
            }
            //已经登录
            let username = nameHref.replacingOccurrences(of: "/member/", with: "")
            let src = infoPath.first?.xpath("./img").first?["src"] ?? ""
            Account.shared.user.value = User(name: username, href: nameHref, src: src)
            Account.shared.isLoggedIn.value = true

            let dailyPath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='inner']/a")
            if let href = dailyPath.first?["href"], href == "/mission/daily" {
                //领取今日的登录奖励
                Account.shared.isDailyRewards.value = true
                nodePath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][2]/div[@class='cell'][2]/a")
            }else {
                Account.shared.isDailyRewards.value = false
                nodePath = html.xpath("//body/div[@id='Wrapper']/div[@class='content']/div[@class='box'][1]/div[@class='cell'][2]/a")
            }
        }

        let n = nodePath.flatMap({e -> Node? in
            if let href = e["href"], let name = e.content, let className = e.className {
                return Node(name: name, href: href, isCurrent: className.hasSuffix("current"))
            }
            return nil
        })
        return n
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

