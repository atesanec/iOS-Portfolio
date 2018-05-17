//
//  PinInputFieldView.swift
//  SolWallet
//
//  Created by Pavel Sokolov on 18/04/2018.
//  Copyright © 2018 CryptoAlpha. All rights reserved.
//

import UIKit

class PinInputFieldView: UIView {

    /// Space between pins
    private static let spaceBetweenPins: CGFloat = 12.0
    
    /// Pins
    private var pinsView = [UIImageView]()
    /// Stack view
    private var stackView: UIStackView!

    /// filled lenght
    var filledPinLength: Int = 0 {
        didSet {
            self.updatePins()
        }
    }
    
    /// Error state
    var isMarkedAsError: Bool = false {
        didSet {
            self.updatePins()
        }
    }
    
    /// Init
    ///
    /// - Parameter count: max lenght
    init(count: Int) {
        super.init(frame: .zero)
        for indexPin in 0..<count {
            let pin = UIImageView.init(image: PinInputFieldView.imageEmptyPinView)
            pin.tag = indexPin
            pinsView.append(pin)
        }
        self.stackView = UIStackView(arrangedSubviews: pinsView)
        self.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.edge(anchorDirection: [.left, .right, .bottom, .top])
        self.stackView.spacing = PinInputFieldView.spaceBetweenPins
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    
    /// Update pins state
    private func updatePins() {
        for imageView in pinsView {
            if imageView.tag < filledPinLength {
                imageView.image = self.isMarkedAsError ? PinInputFieldView.imageErrorPinView : PinInputFieldView.imageFullPinView
            } else {
                imageView.image = PinInputFieldView.imageEmptyPinView
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let itemSize = PinInputFieldView.imageEmptyPinView!.size
        return CGSize(width: itemSize.width*CGFloat(self.pinsView.count) + CGFloat(self.pinsView.count-1)*PinInputFieldView.spaceBetweenPins,
                      height: itemSize.height)
    }
    
}

