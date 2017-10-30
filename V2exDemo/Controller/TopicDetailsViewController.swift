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
import SKPhotoBrowser
import PKHUD
import MonkeyKing

@objc protocol TopicDetailsViewControllerDelegate:class {
    @objc optional func topicDetailsViewController(viewcontroller:TopicDetailsViewController,
                                                   ignorTopic topicId:String?)
    @objc optional func topicDetailsViewController(viewcontroller:TopicDetailsViewController,
                                                   unfavorite topicId:String?)
}

class TopicDetailsViewController: UITableViewController {
    var viewModel:Topicde
}

































