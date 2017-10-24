//
//  ProfileViewController.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/23.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

class ProfileViewController: UITableViewController {
    lazy var menuItems = []
    private let disposeBag = DisposeBag()

    var navController:UINavigationController? {
        return drawerViewController?.centerViewController as? UINavigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        AppStyle.shared.themeUpdateVariable.asObservable().subscribe(onNext:{update in
//            self.updateTheme()
            if update {
//                self.
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)

        tableView.delegate = nil
        tableView.dataSource = nil

        Account.shared.user.asObservable().bind(to: h)
    }

}
