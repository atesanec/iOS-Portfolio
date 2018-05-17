//
//  PinCreateInputManager.swift
//  SolWallet
//
//  Created by Андрей Катюшин on 13.04.2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import RxSwift

class PinCreateInputManager {
    
    /// State pin
    enum StatePin {
        case noFilled
        case correct
        case noCorrect
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
    /// Signal validated pin value
    let validatedPinValue = BehaviorSubject<String>(value: "")
    /// Signal pin validated signal
    let pinValidatedSignal = PublishSubject<Void>()
    
    /// Is pin validated
    var isPinValidated: StatePin {
        let inputPin = try! inputPinValue.value()
        let validatedPin = try! validatedPinValue.value()
        if inputPin.count == pinLength, validatedPin.count == pinLength {
            if inputPin == validatedPin {
                return .correct
            } else {
                return .noCorrect
            }
        } else {
            return .noFilled
        }
    }
    
    //MARK: - Life circle
    
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
            let validatedPin = try! strongSelf.validatedPinValue.value()
            
            if inputPin.count == pinLength {
                if validatedPin.count < pinLength {
                    let newValue = validatedPin+value
                    strongSelf.validatedPinValue.onNext(newValue)
                }
            } else {
                let newValue = inputPin+value
                strongSelf.inputPinValue.onNext(newValue)
            }
            
        })
            .disposed(by: disposeBag)
        
        symbolDeleteHandler.subscribe(onNext: { [weak self] (value) in
            guard let strongSelf = self else {
                return
            }
            
            let inputPin = try! strongSelf.inputPinValue.value()
            let validatedPin = try! strongSelf.validatedPinValue.value()
            
            if validatedPin.count > 0 {
                var mutableValue = validatedPin
                mutableValue.removeLast()
                strongSelf.validatedPinValue.onNext(mutableValue)
            } else {
                if inputPin.count == 0 {
                    return
                }
                var mutableValue = inputPin
                mutableValue.removeLast()
                strongSelf.inputPinValue.onNext(mutableValue)
            }
            
        })
            .disposed(by: disposeBag)
        
        Observable.combineLatest([inputPinValue, validatedPinValue])
            .map { [weak self] (values) -> Bool in
                guard let strongSelf = self else {
                    return false
                }
                return strongSelf.isPinValidated == .correct
            }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.pinValidatedSignal.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
