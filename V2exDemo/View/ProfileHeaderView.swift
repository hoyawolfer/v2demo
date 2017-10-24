//
//  ProfileHeaderView.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/23.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class ProfileHeaderView: UIView {

    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var nameLab:UILabel!

    var user:User? {
        willSet {
            if let model = newValue {
                avatarBtn.setTitle("", for: .normal)
                avatarBtn.kf.setBackgroundImage(with: URL(string:model.avatar(.large)), for: .normal)
                nameLab.text = model.name
                nameLab.isHidden = false
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        avatarBtn.clipsToBounds = true
        avatarBtn.layer.cornerRadius = 40
        nameLab.isHidden = true

        updateTheme()
    }

    func updateTheme() {
        backgroundColor = AppStyle.shared.theme.tableBackgroundColor
        nameLab.textColor = AppStyle.shared.theme.black64Color
        if AppStyle.shared.theme == .night {
            avatarBtn.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.2039215686, blue: 0.2784313725, alpha: 1)
        } else {
            avatarBtn.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        }
        avatarBtn.setTitleColor(AppStyle.shared.theme.black102Color, for: .normal)
    }

    func logout() {
        avatarBtn.setTitle("登录", for: .normal)
        avatarBtn.setBackgroundImage(nil, for: .normal)
        nameLab.isHidden = true
    }
}

extension Reactive where Base:ProfileHeaderView {
    var user:Binder {

    }
}











