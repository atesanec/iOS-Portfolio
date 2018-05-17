//
//  PinCreateMainViewController.swift
//  SolWallet
//
//  Created by Андрей Катюшин on 03.04.2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import UIKit
import RxSwift

class PinCreateMainViewController: UIViewController {

    /// Label title
    private var labelTitle: UILabel!
    /// Label description
    private var labelDescription: UILabel!
    /// Label repeat pin
    private var labelRepeatPin: UILabel!
    /// Container input pin
    private var containerInputPins: UIStackView!
    /// Container validated pin
    private var containerValidatedPins: UIStackView!
    /// Top label title constraint
    private var topLabelTitleConstraint: NSLayoutConstraint!
    /// Top label decription constraint
    private var topLabelDecriptionConstraint: NSLayoutConstraint!
    /// Bottom label input pin constraint
    private var bottomContainerInputPinConstraint: NSLayoutConstraint!
    /// Bottom label repeat pin constraint
    private var bottomLabelRepeatPinConstraint: NSLayoutConstraint!
    /// Bottom container validated pin constraint
    private var bottomContainerValidatedPinConstraint: NSLayoutConstraint!
    
    /// Pin create view model
    private let viewModel: PinCreateViewModel
    /// Dispose bag
    private let disposeBag = DisposeBag()
    
    /// Space between pins
    private static let spaceBetweenPins: CGFloat = 12.0
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
    /// Bottom container input pin
    private static let bottomContainerInputPin: CGFloat = 30.0
    /// Bottom label repeat pin
    private static let bottomLabelRepeatPin: CGFloat = 16.0
    
    //MARK: - Life circle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: PinCreateViewModel) {
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

        topLabelTitleConstraint.constant = getValue(defaultValue: PinCreateMainViewController.topLabelTitle)
        topLabelDecriptionConstraint.constant = getValue(defaultValue: PinCreateMainViewController.topLabelDescription)
        bottomContainerInputPinConstraint.constant = getValue(defaultValue: PinCreateMainViewController.bottomContainerInputPin)
        bottomLabelRepeatPinConstraint.constant = getValue(defaultValue: PinCreateMainViewController.bottomLabelRepeatPin)

        labelTitle.font = UIFont.boldSystemFont(ofSize: getValue(defaultValue: PinCreateMainViewController.sizeFontLabelTitle))
        labelDescription.font = UIFont.systemFont(ofSize: getValue(defaultValue: PinCreateMainViewController.sizeFontLabelDescription))
        labelRepeatPin.font = UIFont.systemFont(ofSize: getValue(defaultValue: PinCreateMainViewController.sizeFontLabelRepeatPin))
    }

    //MARK: - Private
    
    /// Setup interface
    private func setupInterface() {
        labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.textColor = UIColor.white
        labelTitle.text = "pin_create_title".localized
        view.addSubview(labelTitle)
        topLabelTitleConstraint = labelTitle.top(constant: PinCreateMainViewController.topLabelTitle)
        labelTitle.left(constant: PinCreateMainViewController.leftLabelTitle)
        
        labelDescription = UILabel()
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.numberOfLines = 0
        labelDescription.textColor = UIColor.white
        labelDescription.text = "pin_create_description".localized
        view.addSubview(labelDescription)
        topLabelDecriptionConstraint = labelDescription.top(constant: PinCreateMainViewController.topLabelDescription, view: labelTitle)
        labelDescription.leftAnchorLeft(anchorView: labelTitle)
        labelDescription.centerX()

        let viewSpaceBottomPins = UIView()
        viewSpaceBottomPins.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewSpaceBottomPins)
        viewSpaceBottomPins.edge(anchorDirection: [.left, .bottom, .right])

        containerValidatedPins = createPins()
        view.addSubview(containerValidatedPins)
        containerValidatedPins.bottom(view:viewSpaceBottomPins)
        containerValidatedPins.centerX()

        labelRepeatPin = UILabel()
        labelRepeatPin.translatesAutoresizingMaskIntoConstraints = false
        labelRepeatPin.textColor = UIColor.white
        view.addSubview(labelRepeatPin)
        bottomLabelRepeatPinConstraint = labelRepeatPin.bottom(constant: PinCreateMainViewController.bottomLabelRepeatPin, view: containerValidatedPins)
        labelRepeatPin.centerX()

        containerInputPins = createPins()
        view.addSubview(containerInputPins)
        bottomContainerInputPinConstraint = containerInputPins.bottom(constant: PinCreateMainViewController.bottomContainerInputPin, view: labelRepeatPin)
        containerInputPins.centerX()

        let viewSpaceTopPins = UIView()
        viewSpaceTopPins.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewSpaceTopPins)
        viewSpaceTopPins.edge(anchorDirection: [.left, .right])
        viewSpaceTopPins.top(view: labelDescription)
        viewSpaceTopPins.bottom(view: containerInputPins)
        viewSpaceTopPins.height(view: viewSpaceBottomPins)
    }
    
    /// Image full pin view
    private static var imageFullPinView: UIImage? {
        return UIImage(named: "bulletOval")
    }
    
    /// Image error pin view
    private static var imageErrorPinView: UIImage? {
        return UIImage(named: "bulletOvalRed")
    }
    
    /// Image empty pin view
    private static var imageEmptyPinView: UIImage? {
        return UIImage(named: "bulletOvalOpacity")
    }
    
    /// Setup observers
    private func setupObservers() {
        let fullingPins = { (container: UIStackView, value: Int) in
            container.arrangedSubviews.forEach({ (view) in
                guard let imageView = view as? UIImageView else {
                    return
                }
                if view.tag < value {
                    imageView.image = PinCreateMainViewController.imageFullPinView
                } else {
                    imageView.image = PinCreateMainViewController.imageEmptyPinView
                }
            })
        }
        viewModel.inputPinValue.map{ $0.count }
            .subscribe(onNext: { [weak self] (value) in
                guard let strongSelf = self else {
                    return
                }
                fullingPins(strongSelf.containerInputPins, value)
                
                let hideValidatedPin = value < strongSelf.viewModel.pinLength
                strongSelf.labelRepeatPin.isHidden = hideValidatedPin
                strongSelf.containerValidatedPins.isHidden = hideValidatedPin
        }).disposed(by: disposeBag)
        
        viewModel.validatedPinValue.map{ $0.count }
            .subscribe(onNext: { [weak self] (value) in
                guard let strongSelf = self else {
                    return
                }
                if strongSelf.viewModel.isPinValidated == .noCorrect {
                    strongSelf.containerValidatedPins.arrangedSubviews.forEach({ (view) in
                        guard let imageView = view as? UIImageView else {
                            return
                        }
                        imageView.image = PinCreateMainViewController.imageErrorPinView
                    })
                    strongSelf.labelRepeatPin.text = "pin_create_code_mismatch".localized
                } else {
                    fullingPins(strongSelf.containerValidatedPins, value)
                    strongSelf.labelRepeatPin.text = "pin_create_repeat_code".localized
                }
            }).disposed(by: disposeBag)
    }
    
    /// Create pins
    ///   - container: container pins
    /// - Returns: array pins
    private func createPins() -> UIStackView {
        var pinsView = [UIImageView]()
        for indexPin in 0..<viewModel.pinLength {
            let pin = UIImageView.init(image: PinCreateMainViewController.imageEmptyPinView)
            pin.tag = indexPin
            pinsView.append(pin)
        }
        let stackView = UIStackView(arrangedSubviews: pinsView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = PinCreateMainViewController.spaceBetweenPins
        return stackView
    }

    /// Get value for layouts
    ///   - defaultValue: defaultValue
    /// - Returns: value
    private func getValue(defaultValue: CGFloat) -> CGFloat {
        let ratio = defaultValue/PinCreateMainViewController.defaultHeightScreenLayout
        return min(defaultValue, ratio*view.frame.size.height)
    }
    
}
