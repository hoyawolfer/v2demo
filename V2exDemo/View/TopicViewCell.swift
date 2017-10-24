//
//  TopicViewCell.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/19.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class TopicViewCell: UITableViewCell {

    @IBOutlet var avatarView: UIImageView!

    @IBOutlet var nodeLabel: UILabel!

    @IBOutlet var ownerNameLabel: UILabel!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var timeLabel: UILabel!

    @IBOutlet var countLabel: UILabel!

    var linkTap:((TapLink) -> Void)?

    var topic:Topic? {
        willSet {
            if let model = newValue {
                avatarView.kf.setImage(with: URL(string:model.owner?.avatar(.large) ?? ""), placeholder:UIImage.init(named: "avatar_default"))
                nodeLabel.text = " " + (model.node?.name ?? "") + " "
                ownerNameLabel.text = model.owner?.name
                timeLabel.text = model.lastReplyTime
                countLabel.text = " \(model.replyCount) "
                countLabel.isHidden = model.replyCount == "0"

                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 3

                let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15), NSAttributedStringKey.foregroundColor:AppStyle.shared.theme.black102Color, NSAttributedStringKey.paragraphStyle:paragraphStyle]
                titleLabel.attributedText = NSAttributedString(string: model.title, attributes: attributes)
            }
        }
    }

    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        nodeLabel.clipsToBounds = true
        nodeLabel.layer.cornerRadius = 4.0
        countLabel.clipsToBounds = true
        countLabel.layer.cornerRadius = 9

        avatarView.isUserInteractionEnabled = true
        let avatarTap = UITapGestureRecognizer(target: self, action: #selector(userTapAction(_:)))
        avatarView.addGestureRecognizer(avatarTap)

        ownerNameLabel.isUserInteractionEnabled = true
        let nameTap = UITapGestureRecognizer(target: self, action: #selector(userTapAction(_:)))
        ownerNameLabel.addGestureRecognizer(nameTap)

        updateTheme()

        AppStyle.shared.themeUpdateVariable.asObservable().subscribe(onNext: {update in
            if update {
                self.updateTheme()
            }
        }).disposed(by: disposeBag)
    }

    @objc func userTapAction(_ sender:Any) {
        if let user = topic?.owner {
            linkTap?(TapLink.user(info: user))
        }
    }

    func updateTheme() {
        let selectedView = UIView()
        selectedView.backgroundColor = AppStyle.shared.theme.cellSelectedBackgroundColor
        self.selectedBackgroundView = selectedView

        self.backgroundColor = AppStyle.shared.theme.cellBackgroundColor
        ownerNameLabel.textColor = AppStyle.shared.theme.black102Color
        nodeLabel.backgroundColor = AppStyle.shared.theme.topicCellNodeBackgroundColor
        nodeLabel.textColor = AppStyle.shared.theme.black153Color
        timeLabel.textColor = AppStyle.shared.theme.black153Color
        countLabel.backgroundColor = AppStyle.shared.theme.topicReplyCountBackgroundColor
        countLabel.textColor = AppStyle.shared.theme.topicReplyCountTextColor

        if let data = topic {
            topic = data
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }











}
