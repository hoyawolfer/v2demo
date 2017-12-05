//
//  AppSetting.swift
//  V2exDemo
//
//  Created by zaixuan on 04/12/2017.
//  Copyright © 2017 Zaixuan. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import SafariServices
import SKPhotoBrowser

struct AppSetting {
    static var isCameraEnable: Bool {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        return status != .restricted && status != .denied
    }

    static var isAlbumEnable: Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        return status != .restricted && status != .denied
    }

    static func openWebBrowser(from viewController: UIViewController, URL: URL) {
        let browser = SFSafariViewController(url: URL)
        viewController.present(browser, animated: true, completion: nil)
    }

    static func openPhotoBrowser(from viewController: UIViewController, src: String) {
        let photo = SKPhoto.photoWithImageURL(src)
        photo.shouldCachePhotoURLImage = true

        let browser = SKPhotoBrowser(photos: [photo])
        browser.initializePageIndex(0)
        viewController.present(browser, animated: true, completion: nil)
    }

}

