//
//  HomeViewController.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/17.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation
import Foundation
import Kanna
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController:UITableViewController {
    fileprivate lazy var viewModel = HomeViewModel()
    fileprivate let dataSource = RxTableViewSectionedAnimatedDataSource<TopicListSection>(configureCell: {(ds, table, indexPath, _) in
        let cell:TopicViewCell = table.dequeueReusableCell(withIdentifier: "TopicViewCell") as! TopicViewCell
        let item = ds[indexPath]
        cell.topic = item
        cell.linkTap = {type in
//            self.linkTapAction(type:type)
        }
        return cell
    })
    private let disposebag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)

        AppStyle.shared.themeUpdateVariable.asObservable().subscribe(onNext: {update in

        }).disposed(by: disposebag)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        tableView.delegate = nil
        tableView.dataSource = nil

        tableView.rx.setDelegate(self).disposed(by: disposebag)

        refreshControl = UIRefreshControl()
        refreshControl?.rx.controlEvent(UIControlEvents.valueChanged).flatMapLatest({[unowned viewModel]_ in
            viewModel.fetchTopics()
        }).share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
            .subscribe(onNext: {isEmpty in
            }, onError: {error in
                print("error:",error)
            })
            .disposed(by: disposebag)
//        viewModel.loadingActivityIndicator.asObservable().bind(to: refreshControl!.rx.isRefreshing).disposed(by: disposebag)
        viewModel.sections.asObservable().bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposebag)
        viewModel.defaultNodes.asObservable().subscribe(onNext:{[weak self] nodes in
            guard let `self` = self else { return }
            if let currentNode = nodes.filter({$0.isCurrent}).first {
                self.navigationItem.rightBarButtonItem?.title = currentNode.name
            } else {
                self.navigationItem.rightBarButtonItem?.title = nil
            }
        }).disposed(by: disposebag)

        refreshControl?.sendActions(for: .valueChanged)
        tableView.setContentOffset(CGPoint(x: 0, y: -60), animated: true)

    }

    @IBAction func leftBarItemAction(_ sender: UIBarButtonItem) {
        self.presentationController?.presentedViewController.dismiss(animated: true, completion: nil)
//        guard let drawerViewController =  else {
//            <#statements#>
//        }
    }

    func linkTapAction(type:TapLink) {
//        guard let nav = navigationController else {
//            return
//        }
//        switch type {
//        case let TapLink.user(info):
//
//        default:
//            <#code#>
//        }
    }


}

extension HomeViewController:UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        popoverPresentationController.backgroundColor = AppStyle.shared.theme.tableBackgroundColor
    }
}














