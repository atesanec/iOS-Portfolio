//
//  MoviePackListItemCell.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift
import YYImage

class MoviePackListItemCell: UICollectionViewCell {
    struct Configuration {
        let imageObservable: Observable<YYImage?>
        let title: String
        let subtitle: String
        let plusTapObserver: AnyObserver<Void>
    }
    
    static var defaultHeight: CGFloat = 90
    private static let imageSize = CGSize(width: 60, height: 60)
    private static let plusIconSize = CGSize(width: 22, height: 22)
    private static let contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 30)
    private static let labelLeftOffsetX: CGFloat = 90
    private static let labelRightOffsetX: CGFloat = contentInset.right + plusIconSize.width
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let plusButton = UIButton(type: .custom)
    private let separatorView = OnePixelSeparatorView()
    private var disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(separatorView)
        
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        
        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleLabel.textColor = UIColor.subtitleTextColor
        
        plusButton.setImage(UIImage(named: "add_pack_icon"), for: .normal)
    }
    
    func configure(info: Configuration) {
        titleLabel.text = info.title
        subtitleLabel.text = info.subtitle
        plusButton.rx.tap.map {()}.bind(to: info.plusTapObserver).disposed(by: disposeBag)
        info.imageObservable.map {$0 as UIImage?}.bind(to: imageView.rx.image).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
        imageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = contentView.bounds
        let contentInset = type(of: self).contentInset
        
        imageView.frame = CGRect(origin: CGPoint(x: contentInset.left,
                                                 y: bounds.midY - type(of: self).imageSize.height * 0.5),
                                 size: type(of: self).imageSize)
        
        titleLabel.frame = CGRect(x: type(of: self).labelLeftOffsetX,
                                  y: contentInset.top,
                                  width: bounds.width - type(of: self).labelLeftOffsetX - type(of: self).labelRightOffsetX,
                                  height: titleLabel.font.lineHeight)
        subtitleLabel.frame = CGRect(x: titleLabel.frame.minX,
                                  y: bounds.height - contentInset.top - subtitleLabel.font.lineHeight,
                                  width: titleLabel.frame.width,
                                  height: subtitleLabel.font.lineHeight)
        
        plusButton.frame = CGRect(origin: CGPoint(x: bounds.width - type(of: self).plusIconSize.width - contentInset.right,
                                                  y: bounds.midY - type(of: self).plusIconSize.height * 0.5),
                                  size: type(of: self).plusIconSize)
        
        separatorView.placeIntoView(position: .bottom)
    }
}
