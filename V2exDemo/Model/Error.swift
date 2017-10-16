//
//  Error.swift
//  V2exDemo
//
//  Created by zaixuan on 2017/10/16.
//  Copyright © 2017年 Zaixuan. All rights reserved.
//

import Foundation
import Moya

enum NetError:Swift.Error {
    case message(text: String)
}

extension Swift.Error {
    var message:String {
        if self is NetError {
            switch (self as! NetError) {
            case let .message(text):
                return text
            }
        }
        else if self is MoyaError {
            return (self as! MoyaError).errorDescription ?? ""
        }
        return localizedDescription
    }
}
