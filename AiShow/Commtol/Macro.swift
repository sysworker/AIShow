//
//  Macro.swift
//  AiShow
//
//  Created by joyo on 2025/4/17.
//

import Foundation
import UIKit

/// 屏幕宽高
let screenW = UIScreen.main.bounds.size.width
let screenH = UIScreen.main.bounds.size.height

/// 状态栏高度
let statusBarHeight: CGFloat = isX ? 44.0 : 20.0
/// 导航栏高度
let navigationBarHeight: CGFloat = 44.0
/// Tab栏高度
let tabbarHeight: CGFloat = isX ? 49.0 + 34.0 : 49.0
/// Tab栏安全底部间距
let tabbarSafeMargin: CGFloat = isX ? 34.0 : 0.0
/// 状态栏和导航栏总高度
let statusBarBottomHeight: CGFloat = isX ? 88.0 : 64.0


var isX: Bool {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
    }
    return false
}


@_exported import SnapKit
@_exported import RxSwift
@_exported import RxCocoa
@_exported import RxRelay
@_exported import RxGesture
@_exported import MJRefresh
@_exported import IQKeyboardManagerSwift
@_exported import Reusable
@_exported import Toast_Swift
@_exported import DZNEmptyDataSet
@_exported import UITextView_Placeholder
@_exported import PanModal
@_exported import MJRefresh
@_exported import SDWebImage
@_exported import SDCycleScrollView
@_exported import TZImagePickerController
@_exported import SVProgressHUD
@_exported import FSPagerView
