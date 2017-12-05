//
//  TopicDetailsViewController.swift
//  V2exDemo
//
//  Created by 黄亚武 on 28/10/2017.
//  Copyright © 2017 Zaixuan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
//import SKPhotoBrowser
import PKHUD
import MonkeyKing

extension UIViewController {
    static var segueId: String {
        return String(describing: self)
    }
}


@objc protocol TopicDetailsViewControllerDelegate:class {
    @objc optional func topicDetailsViewController(viewcontroller:TopicDetailsViewController,
                                                   ignorTopic topicId:String?)
    @objc optional func topicDetailsViewController(viewcontroller:TopicDetailsViewController,
                                                   unfavorite topicId:String?)
}

class TopicDetailsViewController: UITableViewController {
    var viewModel:TopicDetailsViewModel?
    weak var delegate:TopicDetailsViewControllerDelegate?

    fileprivate lazy var dataSource = RxTableViewSectionedAnimatedDataSource<TopicDetailsSection>()
    fileprivate let disposeBag = DisposeBag()

//    fileprivate lazy var inputbar:I
    fileprivate var lastSelectIndexPath:IndexPath?
    fileprivate var canCancelFirstResponder = true

    class func show(from navigationController:UINavigationController, topic:Topic, delegate:TopicDetailsViewControllerDelegate? = nil) {
        let controller = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: TopicDetailsViewController.segueId) as! TopicDetailsViewController
        controller.delegate = delegate
        controller.viewModel = TopicDetailsViewModel(topic:topic)
        navigationController.pushViewController(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.backgroundColor = AppStyle.shared.theme.tableBackgroundColor
        tableView.separatorColor = AppStyle.shared.theme.separatorColor
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        tableView.dataSource = nil

        guard let viewModel = viewModel else { return }

        headerView.topic = viewModel.topic
        headerView.linkTap = { [weak self] type in
//            self.link
        }
        header
    }

    func linkTapAction(type: TapLink) {
        guard let nav = navigationController else { return }
        switch type {
//        case let .user(info):
//            Timeli
        case let .image(src):
            AppSetting.openPhotoBrowser(from: nav, src: src)
        case let .web(info):
            AppSetting.openWebBrowser(from: nav, URL: url)
//        case let .node(info):
//            NodeTop
        default:

        }
    }
}

































