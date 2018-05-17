//
//  PinInputViewModel.swift
//  SolWallet
//
//  Created by Pavel Sokolov on 18/04/2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import UIKit
import RxSwift

class PinInputViewModel: NSObject {
    
    /// Style
    let style: PinInputViewControllerStyle

    /// Pin length
    var pinLength: Int {
        switch style {
        case .walletUnlock:
            return PinSettings.pinsCount
        }
    }

    /// Signal symbol input handler
    let symbolInputHandler = BehaviorSubject<String>(value: "")
    /// Signal symbol delete handler
    let symbolDeleteHandler = PublishSubject<Void>()
    /// Signal input pin value
    let inputPinValue = BehaviorSubject<String>(value: "")
    /// Signal pin input completed signal
    let pinInputCompletedSignal = PublishSubject<Void>()
    

    
    /// Dispose bag
    private let disposeBag = DisposeBag()
    /// Input manager
    private var pinInputManager: PinInputValueManager!

    
    /// Init
    ///
    /// - Parameter style: style
    init(style: PinInputViewControllerStyle) {
        self.style = style

        super.init()

        self.pinInputManager = PinInputValueManager(pinLength: self.pinLength)
        self.symbolInputHandler.bind(to: self.pinInputManager.symbolInputHandler).disposed(by: self.disposeBag)
        self.symbolDeleteHandler.bind(to: self.pinInputManager.symbolDeleteHandler).disposed(by: self.disposeBag)
        
        self.pinInputManager.inputPinValue.bind(to: self.inputPinValue).disposed(by: self.disposeBag)
        self.pinInputManager.pinValidatedSignal.bind(to: self.pinInputCompletedSignal).disposed(by: self.disposeBag)
    }
    
    /// Reset pin to ""
    func reset() {
        self.pinInputManager.reset()
    }
}
