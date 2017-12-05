//
//  LoadMoreCommentCell.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/11/22.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import UIKit

class LoadMoreCommentCell: UITableViewCell {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView()
        selectedView.backgroundColor = AppStyle.shared.theme.cellSelectedBackgroundColor
        self.selectedBackgroundView = selectedView

        contentView.backgroundColor = AppStyle.shared.theme.cellBackgroundColor
        if AppStyle.shared.theme == .night {
            activityIndicatorView.activityIndicatorViewStyle = .white
            titleLabel.textColor = #colorLiteral(red: 0.1137254902, green: 0.631372549, blue: 0.9490196078, alpha: 1)
        }
    }
}
