//
//  PinInputViewController.swift
//  SolWallet
//
//  Created by Pavel Sokolov on 18/04/2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import UIKit
import RxSwift

enum PinInputViewControllerStyle {
    case walletUnlock
}

class PinInputViewController: UIViewController {
    
    /// Completion handler
    var pinInputAcceptedHandler: ((_ pin: String) -> Bool)!
    
    /// Controller keyboard
    private var controllerKeyboard: PinKeyboardViewController!
    /// Controller main
    private var controllerMain: PinInputMainViewController!
    
    /// Dispose bag
    private let disposeBag = DisposeBag()
    
    /// Pin create view model
    private let viewModel: PinInputViewModel
    
    /// Wallet create action manager
    private let walletCreateActionManager = WalletCreateActionManager()
    
    //MARK: - Life circle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(style: PinInputViewControllerStyle) {
        self.viewModel = PinInputViewModel(style: style)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInertface()
        setupObservers()
    }

    // MARK: - Private
    
    /// Setup inertface
    private func setupInertface() {
        self.view.backgroundColor = UIColor.duskBlue
        
        self.addKeyboadController()
        self.addMainView()
    }
    
    /// Setup observers
    private func setupObservers() {
        self.viewModel.pinInputCompletedSignal.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.pinInputCompletionSignalHandler()
        }).disposed(by: disposeBag)
    }
    
    /// Add keyboad controller
    private func addKeyboadController() {
        self.controllerKeyboard = PinKeyboardViewController()
        self.controllerKeyboard.view.translatesAutoresizingMaskIntoConstraints = false
        self.controllerKeyboard.symbolInputHandler.bind(to: self.viewModel.symbolInputHandler).disposed(by: disposeBag)
        self.controllerKeyboard.symbolDeleteHandler.bind(to: self.viewModel.symbolDeleteHandler).disposed(by: disposeBag)
        self.embed(childViewController: self.controllerKeyboard)
        self.controllerKeyboard.view.edge(anchorDirection: [.bottom, .left, .right])
        self.controllerKeyboard.view.height(multiplier: PinKeyboardViewController.multiplierControllerKeyboardController, view: view)
    }
    
    /// Add main view
    private func addMainView() {
        self.controllerMain = PinInputMainViewController(viewModel: self.viewModel)
        self.controllerMain.view.translatesAutoresizingMaskIntoConstraints = false
        self.embed(childViewController: self.controllerMain)
        self.controllerMain.view.edge(anchorDirection: [.left, .right])
        self.controllerMain.view.spaceNavigationBar(controller: self)
        self.controllerMain.view.bottom(view: self.controllerKeyboard.view)
    }
    
    /// Pin created handler
    private func pinInputCompletionSignalHandler() {
        let pincode = try! self.viewModel.inputPinValue.value()
        if !self.pinInputAcceptedHandler(pincode) {
            self.viewModel.reset()
            FlashPopupPresenter.flashErrorPopup()
        }
    }
}
