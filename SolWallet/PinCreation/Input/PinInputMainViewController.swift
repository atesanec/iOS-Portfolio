//
//  PinInputMainViewController.swift
//  SolWallet
//
//  Created by Pavel Sokolov on 18/04/2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PinInputMainViewController: UIViewController {

    /// Label title
    private var labelTitle: UILabel!
    /// Label description
    private var labelDescription: UILabel!
    /// Container input pin
    private var containerInputPins: PinInputFieldView!
    /// Top label title constraint
    private var topLabelTitleConstraint: NSLayoutConstraint!
    /// Top label decription constraint
    private var topLabelDecriptionConstraint: NSLayoutConstraint!
    
    /// Pin create view model
    private let viewModel: PinInputViewModel
    /// Dispose bag
    private let disposeBag = DisposeBag()
    
    /// Default height screen layout
    private static let defaultHeightScreenLayout: CGFloat = 297.0
    /// Size font label title
    private static let sizeFontLabelTitle: CGFloat = 34.0
    /// Size font label description
    private static let sizeFontLabelDescription: CGFloat = 17.0
    /// Size font label repeat pin
    private static let sizeFontLabelRepeatPin: CGFloat = 17.0
    /// Top label title
    private static let topLabelTitle: CGFloat = 8.0
    /// Left label title
    private static let leftLabelTitle: CGFloat = 20.0
    /// Top label description
    private static let topLabelDescription: CGFloat = 12.0
    
    //MARK: - Life circle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Init
    ///
    /// - Parameter viewModel: view model
    init(viewModel: PinInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        setupObservers()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        topLabelTitleConstraint.constant = getValue(defaultValue: PinInputMainViewController.topLabelTitle)
        topLabelDecriptionConstraint.constant = getValue(defaultValue: PinInputMainViewController.topLabelDescription)
        
        labelTitle.font = UIFont.boldSystemFont(ofSize: getValue(defaultValue: PinInputMainViewController.sizeFontLabelTitle))
        labelDescription.font = UIFont.systemFont(ofSize: getValue(defaultValue: PinInputMainViewController.sizeFontLabelDescription))
    }
    
    //MARK: - Private
    
    /// Setup interface
    private func setupInterface() {
        self.labelTitle = UILabel()
        self.labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.labelTitle.textColor = UIColor.white
        self.labelTitle.text = "pin_input_wallet_unlock_title".localized
        self.view.addSubview(self.labelTitle)
        self.topLabelTitleConstraint = self.labelTitle.top(constant: PinInputMainViewController.topLabelTitle)
        self.labelTitle.left(constant: PinInputMainViewController.leftLabelTitle)
        
        self.labelDescription = UILabel()
        self.labelDescription.translatesAutoresizingMaskIntoConstraints = false
        self.labelDescription.numberOfLines = 0
        self.labelDescription.textColor = UIColor.white
        self.labelDescription.text = "pin_input_wallet_unlock_description".localized
        self.view.addSubview(self.labelDescription)
        self.topLabelDecriptionConstraint = self.labelDescription.top(constant: PinInputMainViewController.topLabelDescription, view: self.labelTitle)
        self.labelDescription.leftAnchorLeft(anchorView: labelTitle)
        self.labelDescription.centerX()
        
        let viewSpaceForPins = UIView()
        viewSpaceForPins.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewSpaceForPins)
        viewSpaceForPins.edge(anchorDirection: [.left, .right, .bottom])
        viewSpaceForPins.top(view: self.labelDescription)
        
        self.containerInputPins = PinInputFieldView(count: self.viewModel.pinLength)
        self.containerInputPins.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.containerInputPins)
        self.containerInputPins.centerX()
        self.containerInputPins.centerY(constant: 0, view: viewSpaceForPins)
    }
    
    /// Setup observers
    private func setupObservers() {
        viewModel.inputPinValue.map{ $0.count }
            .subscribe(onNext: { [weak self] (value) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.containerInputPins.filledPinLength = value
            }).disposed(by: disposeBag)
    }
    
    /// Get value for layouts
    ///   - defaultValue: defaultValue
    /// - Returns: value
    private func getValue(defaultValue: CGFloat) -> CGFloat {
        let ratio = defaultValue/PinInputMainViewController.defaultHeightScreenLayout
        return min(defaultValue, ratio*view.frame.size.height)
    }
    
}

