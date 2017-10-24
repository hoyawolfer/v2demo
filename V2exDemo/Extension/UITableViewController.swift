//
//  UITableViewController.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/23.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import UIKit

protocol ThemeUpdating {
    func updateTheme()
}

extension UITableViewController:ThemeUpdating {
    func updateTheme() {
        switch tableView.style {
        case .plain:
            tableView.backgroundColor = AppStyle.shared.theme.tableBackgroundColor
        case .grouped:
            tableView.backgroundColor = AppStyle.shared.theme.tableBackgroundColor
        }
        tableView.separatorColor = AppStyle.shared.theme.separatorColor
    }

    func showLoginlert(isPopBack:Bool = false) {
        let alert = UIAlertController(title: "需要您登录v2ex", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: {_ in
            if isPopBack {
                self.navigationController?.popViewController(animated: true)
            }
        }))

        alert.addAction(UIAlertAction(title: "登录", style: .default, handler: {_ in
            self.drawerViewController?.performSegue(withIdentifier: "drawer", sender: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}









