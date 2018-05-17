//
//  PinCreateViewController.swift
//  SolWallet
//
//  Created by Андрей Катюшин on 03.04.2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import UIKit
import RxSwift

enum PinCreateViewControllerStyle {
    case walletCreate
    case walletRestore
}

class PinCreateViewController: UIViewController {

    /// Controller keyboard
    private var controllerKeyboard: PinKeyboardViewController!
    /// Container view info panel
    private var viewInfoPanel: UIView!
    /// Controller main
    private var controllerMain: PinCreateMainViewController!
    
    /// Dispose bag
    private let disposeBag = DisposeBag()
    
    /// Pin create view model
    private let viewModel: PinCreateViewModel
    
    /// Pin created handler
    var pinCreatedHandler: ((_ pincode: String) -> Void)?
    
    //MARK: - Life circle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(style: PinCreateViewControllerStyle) {
        self.viewModel = PinCreateViewModel(style: style)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.changeStyle(style: .Transparent)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Private
    
    /// Setup inertface
    private func setupInterface() {
        view.backgroundColor = UIColor.duskBlue
        
        addKeyboadController()
        addInfoPanelView()
        addMainView()
    }
    
    /// Setup observers
    private func setupObservers() {
        viewModel.pinValidatedSignal.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.pinCreatedHandler?(try! strongSelf.viewModel.inputPinValue.value())
        }).disposed(by: disposeBag)
    }
    
    /// Add keyboad controller
    private func addKeyboadController() {
        controllerKeyboard = PinKeyboardViewController()
        controllerKeyboard.view.translatesAutoresizingMaskIntoConstraints = false
        controllerKeyboard.symbolInputHandler.bind(to: viewModel.symbolInputHandler).disposed(by: disposeBag)
        controllerKeyboard.symbolDeleteHandler.bind(to: viewModel.symbolDeleteHandler).disposed(by: disposeBag)
        embed(childViewController: controllerKeyboard)
        controllerKeyboard.view.edge(anchorDirection: [.bottom, .left, .right])
        controllerKeyboard.view.height(multiplier: PinKeyboardViewController.multiplierControllerKeyboardController, view: view)
    }
    
    /// Add info panel view
    private func addInfoPanelView() {
        viewInfoPanel = PinCreateInfoPanelView.create(style: .walletCreate)
        viewInfoPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewInfoPanel)
        viewInfoPanel.edge(anchorDirection: [.left, .right])
        viewInfoPanel.bottom(view: controllerKeyboard.view)
    }

    /// Add main view
    private func addMainView() {
        controllerMain = PinCreateMainViewController(viewModel: viewModel)
        controllerMain.view.translatesAutoresizingMaskIntoConstraints = false
        embed(childViewController: controllerMain)
        controllerMain.view.edge(anchorDirection: [.left, .right])
        controllerMain.view.spaceNavigationBar(controller: self)
        controllerMain.view.bottom(view: viewInfoPanel)
    }
}
