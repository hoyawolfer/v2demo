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

    }
}
