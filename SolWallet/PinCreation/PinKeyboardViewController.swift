//
//  PinKeyboardViewController.swift
//  SolWallet
//
//  Created by Андрей Катюшин on 04.04.2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PinKeyboardViewController: UIViewController {

    /// Multiplier controller keyboard controller
    static let multiplierControllerKeyboardController: CGFloat = 220.0/667.0
    
    
    /// Size font input buttons
    private static let sizeFontInputButtons: CGFloat = 28.0
    /// Spacing horizantal stack view
    private static let spacingHorizantalStackView: CGFloat = 6.0
    /// Spacing vertical stack view
    private static let spacingVerticalStackView: CGFloat = 7.0
    /// Edge insets stack view
    private static let edgeInsetsStackView = UIEdgeInsets(top: 12, left: 6, bottom: 3, right: 6)
    
    /// Dispose bag
    private let disposeBag = DisposeBag()
    
    /// Symbol input handler
    private(set) var symbolInputHandler = PublishSubject<String>()
    /// Symbol delete handler
    private(set) var symbolDeleteHandler = PublishSubject<Void>()
    
    //MARK: - Life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInterface()
    }
    
    //MARK: - Private
    
    /// Setup interface
    private func setupInterface() {
        
        var stackViews = [UIStackView]()
        let countRow = 4
        let countCol = 3
        for row in 0..<countRow {
            var buttons = [UIButton]()
            for col in 0..<countCol {
                let orderNumber = row*countCol+col
                let button = createButtonForGridView(orderNumber: orderNumber)
                buttons.append(button)
            }
            let stackView = UIStackView(arrangedSubviews: buttons)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.distribution = .fillEqually
            stackView.spacing = PinKeyboardViewController.spacingHorizantalStackView
            stackViews.append(stackView)
        }
        let stackGridView = UIStackView(arrangedSubviews: stackViews)
        stackGridView.translatesAutoresizingMaskIntoConstraints = false
        stackGridView.axis = .vertical
        stackGridView.distribution = .fillEqually
        stackGridView.spacing = PinKeyboardViewController.spacingVerticalStackView
        view.addSubview(stackGridView)
        stackGridView.edge(constant: PinKeyboardViewController.edgeInsetsStackView)
    }
    
    /// Create button for grid view
    ///   - orderNumber: orderNumber
    /// - Returns: button for grid view
    private func createButtonForGridView(orderNumber: Int) -> UIButton {
        
        let setNumberButton = { (button: UIButton, orderNumber: Int) in
            button.setTitle("\(orderNumber)", for: .normal)
            button.rx
                .tap
                .subscribe(onNext: { [weak self] _ in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.symbolInputHandler.onNext("\(orderNumber)")
                })
                .disposed(by: self.disposeBag)
        }
        
        let button = UIButton()
        switch orderNumber {
        case 9:
            button.alpha = 0
        case 11:
            button.setImage(UIImage(named: "icBackspaceKeyboardButton"), for: .normal)
            button.rx
                  .tap
                  .subscribe { [weak self] _ in
                      guard let strongSelf = self else {
                            return
                      }
                      strongSelf.symbolDeleteHandler.onNext(())
                  }
                  .disposed(by: disposeBag)
        case 10:
            setNumberButton(button, 0)
        default:
            setNumberButton(button, orderNumber%10+1)
        }
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: PinKeyboardViewController.sizeFontInputButtons)
        button.setBackgroundImage(UIImage(named: "highlightImageKeyboardButton"), for: .highlighted)
        return button
    }

}
