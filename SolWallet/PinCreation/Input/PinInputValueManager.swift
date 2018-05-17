//
//  PinInputValueManager.swift
//  SolWallet
//
//  Created by Pavel Sokolov on 18/04/2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import UIKit
import RxSwift

class PinInputValueManager {
    
    /// State pin
    enum StatePin {
        case noFilled
        case correct
    }
    
    /// Pin length
    private let pinLength: Int
    
    /// Dispose bag
    private let disposeBag = DisposeBag()
    
    /// Signal symbol input handler
    let symbolInputHandler = BehaviorSubject<String>(value: "")
    /// Signal symbol delete handler
    let symbolDeleteHandler = PublishSubject<Void>()
    /// Signal input pin value
    let inputPinValue = BehaviorSubject<String>(value: "")
    /// Signal pin validated signal
    let pinValidatedSignal = PublishSubject<Void>()
    
    /// Is pin validated
    var isPinValidated: StatePin {
        let inputPin = try! inputPinValue.value()
        if inputPin.count == pinLength {
            return .correct
        } else {
            return .noFilled
        }
    }
    
    //MARK: - Life circle
    
    /// Init
    ///
    /// - Parameter pinLength: lenght
    init(pinLength: Int) {
        self.pinLength = pinLength
        setupObservers()
    }
    
    /// Setup observers
    private func setupObservers() {
        symbolInputHandler.subscribe(onNext: { [weak self] (value) in
            guard let strongSelf = self else {
                return
            }
            
            let pinLength = strongSelf.pinLength
            let inputPin = try! strongSelf.inputPinValue.value()
            
            if inputPin.count < pinLength {
                let newValue = inputPin+value
                strongSelf.inputPinValue.onNext(newValue)
                if strongSelf.isPinValidated == .correct {
                    strongSelf.pinValidatedSignal.onNext(())
                }
            }
            
        }).disposed(by: disposeBag)
        
        symbolDeleteHandler.subscribe(onNext: { [weak self] (value) in
            guard let strongSelf = self else {
                return
            }
            
            let inputPin = try! strongSelf.inputPinValue.value()
            
            if inputPin.count == 0 {
                return
            }
            var mutableValue = inputPin
            mutableValue.removeLast()
            strongSelf.inputPinValue.onNext(mutableValue)
            
        }).disposed(by: disposeBag)
    }
    
    /// Reset pin to ""
    func reset() {
        self.inputPinValue.onNext("")
    }
}

