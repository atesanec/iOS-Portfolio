//
//  PinCreateViewModel.swift
//  SolWallet
//
//  Created by Андрей Катюшин on 03.04.2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import RxSwift

class PinCreateViewModel {
    
    /// Dispose bag
    private let disposeBag = DisposeBag()
    
    /// Pin create input manager
    private var pinCreateInputManager: PinCreateInputManager!
    
    /// Style
    let style: PinCreateViewControllerStyle
    
    /// Pin length
    var pinLength: Int {
        switch style {
        case .walletCreate: fallthrough
        case .walletRestore:
            return PinSettings.pinsCount
        }
    }

    /// Signal symbol input handler
    let symbolInputHandler = BehaviorSubject<String>(value: "")
    /// Signal symbol delete handler
    let symbolDeleteHandler = PublishSubject<Void>()
    /// Signal input pin value
    let inputPinValue = BehaviorSubject<String>(value: "")
    /// Signal validated pin value
    let validatedPinValue = BehaviorSubject<String>(value: "")
    /// Signal pin validated signal
    let pinValidatedSignal = PublishSubject<Void>()
    
    /// Is pin validated
    var isPinValidated: PinCreateInputManager.StatePin {
        return pinCreateInputManager.isPinValidated
    }
    
    //MARK: - Life circle
    
    init(style: PinCreateViewControllerStyle) {
        self.style = style
        self.pinCreateInputManager = PinCreateInputManager(pinLength: pinLength)
        self.symbolInputHandler.bind(to: pinCreateInputManager.symbolInputHandler).disposed(by: disposeBag)
        self.symbolDeleteHandler.bind(to: pinCreateInputManager.symbolDeleteHandler).disposed(by: disposeBag)
        
        pinCreateInputManager.inputPinValue.bind(to: self.inputPinValue).disposed(by: disposeBag)
        pinCreateInputManager.validatedPinValue.bind(to: self.validatedPinValue).disposed(by: disposeBag)
        pinCreateInputManager.pinValidatedSignal.bind(to: self.pinValidatedSignal).disposed(by: disposeBag)
    }
}
