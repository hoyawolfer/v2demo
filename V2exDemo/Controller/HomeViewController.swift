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
    fileprivate let dataSource = RxTableViewSectionedAnimatedDataSource<TopicListSection>()
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

        refreshControl = UIRefreshControl()
        refreshControl?.rx.controlEvent(UIControlEvents.valueChanged).flatMapLatest({[unowned viewModel]_ in
            viewModel.fetchTopics()
        }).share(replay: 1, scope: SubjectLifetimeScope.whileConnected)
            .subscribe(onNext: {isEmpty in
            }, onError: {error in
                print("error:",error)
            })
            .disposed(by: disposebag)
        viewModel.loadingActivityIndicator.asObservable().bind(to: refreshControl!.rx.isRefreshing).disposed(by: disposebag)

    }
}













