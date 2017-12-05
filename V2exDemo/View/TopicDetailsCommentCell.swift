//
//  TopicDetailsCommentCell.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/11/22.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import UIKit
import Kingfisher
import Kanna


class ImageAttachment: NSTextAttachment {
    var src:String?
    var imageSize = CGSize(width: 100, height: 100)
    let maxHeight:CGFloat = 100.0
    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        if imageSize.height > maxHeight {
            let factor = maxHeight / imageSize.height
            return CGRect(origin: CGPoint.zero, size: CGSize(width: imageSize.width * factor, height: maxHeight))
        } else {
            return CGRect(origin: CGPoint.zero, size: imageSize)
        }
    }
}

class TopicDetailsCommentCell: UITableViewCell {
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lzFlagLabel: UILabel!

    var linkTap: ((TapLink) -> Void)?
    var comment: Comment? {
        didSet {
//            configure()
        }
    }

    var isLZ: Bool = false {
        willSet {
            lzFlagLabel.isHighlighted = !newValue
        }
    }

    private var cssText = "a:link, a:visited, a:active {" +
        "text-decoration: none;" +
        "word-break: break-all;" +
        "}" +
        ".reply_content {" +
        "font-size: 14px;" +
        "line-height: 1.6;" +
        "color: #reply_content#;" +
        "word-break: break-all;" +
        "word-wrap: break-word;" +
    "}"
    override func awakeFromNib() {
        super.awakeFromNib()

        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 4.0
        textView.textContainerInset = UIEdgeInsetsMake(0, 0, -18, 0)
        textView.linkTextAttributes = [NSAttributedStringKey.foregroundColor:AppStyle.shared.theme.hyperlinkColor];
        textView.delegate = self

        avatarView.isUserInteractionEnabled = true
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(userTapAction(_:)))
        avatarView.addGestureRecognizer(avatarTap)

        nameLabel.isUserInteractionEnabled = true
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(userTapAction(_:)))
        nameLabel.textColor = AppStyle.shared.theme.black64Color
        timeLabel.textColor = AppStyle.shared.theme.black153Color
        floorLabel.textColor = AppStyle.shared.theme.black153Color
        lzFlagLabel.textColor = AppStyle.shared.theme.black153Color
        cssText = cssText.replacingOccurrences(of: CSSColorMark.replyContent, with: AppStyle.shared.theme.webTopicTextColorHex)
    }

    func cellTapAction(_ sender: Any) {
        if let tableView = superview?.superview as? UITableView, let indexPath = tableView.indexPath(for: self) {
            tableView.delegate?.tableView(tableView, didSelectRowAt: indexPath)
        }
    }

    func userTapAction(_ sender: Any) {
        if let user = comment?.user {
            linkTap?(TapLink.user(info: user))
        }
    }

    func configure() {
        guard let model = comment else {
            return
        }

        avatarView.kf.setImage(with: URL(string:model.user?.avatar(.large) ?? ""), placeholder: #imageLiteral(resourceName: "avatar_default"))
        nameLabel.text = model.user?.name
        floorLabel.text = "#" + model.number
        timeLabel.text = model.time

        var content = model.content
        guard let html = try? HTML(html: content, encoding: .utf8) else {
            textView.text = content
            return
        }

        var imgsrcs: [(id: String, src: String)] = []
        let srcs = html.xpath("//img").flatMap({$0["src"]})
        let imgTags = matchImg


    }

    func matchImgTags(text: String) -> [String] {
        let pattern = "<img src=(.*?)>"
        let regx = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive, .dotMatchesLineSeparators])
        guard let results = regx?.matches(in: text, options: .reportProgress, range: text.nsRange) else {
            return []
        }
        return results.flatMap({result -> String? in
            if let range = result.range.range(for: text) {
                return text.substring(with: range)
            }
            return nil
        })
    }

}


extension TopicDetailsCommentCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        let link = URL.absoluteString
        if link.hasPrefix("https://") || link.hasPrefix("http://") {
            linkTap?(TapLink.web(url: URL))
        } else if link.hasPrefix("applewebdata://") && link.contains("/member/") {
            let href = URL.path
            let name = href.replacingOccurrences(of: "/member/", with: "")
            let user = User(name: name, href: href, src: "")
            linkTap?(TapLink.user(info: user))
        }
        return false
    }

    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        if textAttachment is ImageAttachment {
            let attachment = textAttachment as! ImageAttachment
            if let src = attachment.src, attachment.imageSize.width > 50 {
                linkTap?(TapLink.image(src: src))
            }
            return false
        }
        return true
    }

}













