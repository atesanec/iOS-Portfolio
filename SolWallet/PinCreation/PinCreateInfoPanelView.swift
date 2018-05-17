//
//  PinCreateInfoPanelView.swift
//  SolWallet
//
//  Created by Андрей Катюшин on 03.04.2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import UIKit

class PinCreateInfoPanelView: UIView {
    
    /// Label info
    private var labelInfo: UILabel!
    
    /// Default height screen layout
    private static let defaultHeightScreenLayout: CGFloat = 667.0
    
    /// Size font label info
    private static let sizeFontLabelInfo: CGFloat = 15.0
    
    /// Left image view info
    private static let leftImageViewInfo: CGFloat = 12.0
    /// Top image view info
    private static let topImageViewInfo: CGFloat = 16.0
    /// Left label info
    private static let leftLabelInfo: CGFloat = 16.0
    /// Right label info
    private static let rightLabelInfo: CGFloat = 16.0
    /// Bottom label info
    private static let bottomLabelInfo: CGFloat = 12.0
    
    /// Content compression resistance priority image view info
    private static let contentCompressionResistancePriorityImageViewInfo: Float = 751
    
    //MARK: - Public
    
    /// Create style
    ///   - style: style
    /// - Returns: pin create info panel view
    class func create(style: PinCreateViewControllerStyle) -> PinCreateInfoPanelView {
        let view = PinCreateInfoPanelView()
        view.setupInterface()
        view.setInfo(style: style)
        return view
    }
    
    /// Set info style
    ///   - style: style
    private func setInfo(style: PinCreateViewControllerStyle) {
        switch style {
        case .walletCreate: fallthrough
        case .walletRestore:
            labelInfo.text = "pin_create_wallet_access_prompt".localized
        }
    }
    
    //MARK: - Private
    
    private func setupInterface() {
        backgroundColor = UIColor.dodgerBlue
        
        let imageViewInfo = UIImageView(image: UIImage(named: "icInfoWhite"))
        imageViewInfo.translatesAutoresizingMaskIntoConstraints = false
        imageViewInfo.setContentCompressionResistancePriority(.init(PinCreateInfoPanelView.contentCompressionResistancePriorityImageViewInfo),
                                                              for: .horizontal)
        addSubview(imageViewInfo)
        imageViewInfo.left(constant: PinCreateInfoPanelView.leftImageViewInfo)
        imageViewInfo.top(constant: PinCreateInfoPanelView.topImageViewInfo)
        
        labelInfo = UILabel()
        labelInfo.numberOfLines = 0
        labelInfo.translatesAutoresizingMaskIntoConstraints = false
        labelInfo.textColor = UIColor.white
        labelInfo.font = labelInfo.font.withSize(getValue(defaultValue: PinCreateInfoPanelView.sizeFontLabelInfo))
        addSubview(labelInfo)
        labelInfo.left(constant: PinCreateInfoPanelView.leftLabelInfo, view: imageViewInfo)
        labelInfo.right(constant: PinCreateInfoPanelView.rightLabelInfo)
        labelInfo.topAnchorTop(anchorView: imageViewInfo)
        labelInfo.bottom(constant: PinCreateInfoPanelView.bottomLabelInfo)
    }
    
    /// Get value for layout
    ///   - defaultValue: defaultValue
    /// - Returns: value
    private func getValue(defaultValue: CGFloat) -> CGFloat {
        let ratio = defaultValue/PinCreateInfoPanelView.defaultHeightScreenLayout
        return min(defaultValue, ratio*UIScreen.main.bounds.size.height)
    }
}
