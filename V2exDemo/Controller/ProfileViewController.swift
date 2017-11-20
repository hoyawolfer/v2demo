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

    @IBOutlet var headerView: ProfileHeaderView!

    var menuItems = [(#imageLiteral(resourceName: "slide_menu_topic"), "个人"),
                     (#imageLiteral(resourceName: "slide_menu_message"), "消息"),
                     (#imageLiteral(resourceName: "slide_menu_favorite"), "收藏"),
                     (#imageLiteral(resourceName: "slide_menu_setting"), "设置")]

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

        tableView.tableFooterView = UIView()

        Account.shared.user.asObservable().bind(onNext: {user in
            self.headerView.user = user
        }).disposed(by: disposeBag)
        Account.shared.isLoggedIn.asObservable().subscribe(onNext:{isLoggedIn in
            if !isLoggedIn {
                self.headerView.logout()
            }
        }).disposed(by: disposeBag)

        Observable.just(menuItems).bind(to: tableView.rx.items) { (tableView, row, item) in
            let cell: ProfileMenuViewCell = tableView.dequeueReusableCell(withIdentifier: "ProfileMenuViewCell") as! ProfileMenuViewCell
            cell.updateTheme()
            cell.configure(image: item.0, text: item.1)
            return cell
        }.disposed(by: disposeBag)

        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let `self` = self else { return }

            self.tableView.deselectRow(at: indexPath, animated: true)
            guard let nav = self.navController else {
                return
            }

            guard Account.shared.isLoggedIn.value else {
                self.showLoginView()
                return
            }

            switch indexPath.row {
            case 0:
                self.drawerViewController?.isOpenDrawer = false
            case 1:
                if Account.shared.unreadCount.value > 0 {
                    Account.shared.unreadCount.value = 0
                }
                self.drawerViewController?.isOpenDrawer = false
                nav.performSegue(withIdentifier: "", sender: nil)
            case 2:
                self.drawerViewController?.isOpenDrawer = false
                nav.performSegue(withIdentifier: "", sender: nil)
            default:
                break
            }
        }).disposed(by: disposeBag)

        if let cell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as? ProfileMenuViewCell {
            Account.shared.unreadCount.asObservable().bind(to: cell.rx.unread).disposed(by: disposeBag)
        }

        Account.shared.isDailyRewards.asObservable().flatMapLatest({ canRedeem -> Observable<Bool> in
            if canRedeem {
                return Account.shared.redeemDailyRewards()
            }
            return Observable.just(false)
        }).share(replay: 1, scope: SubjectLifetimeScope.whileConnected).subscribe(onNext:{success in
            if success {
                Account.shared.isDailyRewards.value = false
            }
        }).disposed(by: disposeBag)
        
        
        
    }

    @IBAction func loginButtonAction(_ sender: Any) {
        
        if let nav = navController, Account.shared.isLoggedIn.value {
            drawerViewController?.isOpenDrawer = false
            
        } else {
            showLoginView()
        }
    }
    
    func showLoginView() {
        drawerViewController?.performSegue(withIdentifier: "", sender: nil)
    }
}















