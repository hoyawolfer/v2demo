//
//  ProfileMenuViewCell.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/25.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class ProfileMenuViewCell: UITableViewCell, ThemeUpdating {
    @IBOutlet weak var nameLab:UILabel!
    @IBOutlet weak var iconImg:UIImageView!
    @IBOutlet weak var unreadLab:UILabel!

    var unreadCount:Int = 0 {
        willSet {
            unreadLab.isHidden = newValue < 1
            unreadLab.text = "  \(newValue)  "
        }
    }

    override func awakeFromNib() {
         super.awakeFromNib()

        unreadLab.clipsToBounds = true
        unreadLab.layer.cornerRadius = 9
        unreadLab.isHidden = true
    }

    func updateTheme() {
        self.backgroundColor = AppStyle.shared.theme.tableBackgroundColor
        contentView.backgroundColor = AppStyle.shared.theme.tableBackgroundColor
        let selectedView = UIView()
        selectedView.backgroundColor = AppStyle.shared.theme.cellBackgroundColor
        self.selectedBackgroundView = selectedView

        nameLab.textColor = AppStyle.shared.theme.black64Color
    }

    func configure(image:UIImage, text:String) {
        iconImg.image = AppStyle.shared.theme == .night ? image.imageWithTintColor(#colorLiteral(red: 0.6078431373, green: 0.6862745098, blue: 0.8, alpha: 1)) : image
        nameLab.text = text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension Reactive where Base:ProfileMenuViewCell {
    var unread:Binder<Int> {
        return Binder.init(self.base, binding: {view, value in
            view.unreadCount = value
        })
    }
}











