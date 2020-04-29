//
//  MoviePackListItemsSectionManager.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class MoviePackListItemsSectionManager: CollectionViewSectionManager {
    var collectionView: UICollectionView!
    var sectionIndex: Int = 0
    var dataObservable = BehaviorSubject<[Any]>(value: [Any]())
    
    let viewModel: MoviePackListViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: MoviePackListViewModel) {
        self.viewModel = viewModel
        
        viewModel.stickerPacks.map {$0 as [Any]}.bind(to: dataObservable).disposed(by: disposeBag)
    }
    
    func registerCells() {
        collectionView.register(MoviePackListItemCell.self, forCellWithReuseIdentifier: MoviePackListItemCell.defaultReuseId)
    }
    
    func configure(cell: UICollectionViewCell, atIndex: Int) {
        let item = try! dataObservable.value()[atIndex] as! MovieStickerPack
        
        let imageObservable = viewModel.imageDownloadInteractor.downloadImage(path: item.trayImageDownloadPath).asDriver(onErrorJustReturn: nil)
        let subtitle = "\(item.publisher) ᛫ " + String(format: "NStickers".localized, item.stickers.count)
        let tapObserver = AnyObserver<Void> { [weak self] _ in
            self!.exportStickerPack(atIndex: atIndex)
        }
        
        let config = MoviePackListItemCell.Configuration(imageObservable: imageObservable.asObservable(),
                                                         title: item.name,
                                                         subtitle: subtitle,
                                                         plusTapObserver: tapObserver)
        (cell as! MoviePackListItemCell).configure(info: config)
        
    }
    
    func cellId(atIndex: Int) -> String {
        return MoviePackListItemCell.defaultReuseId
    }
    
    func sizeForItem(atIndex: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: MoviePackListItemCell.defaultHeight)
    }
    
    func itemSelected(atIndex: Int) {
        let item = try! dataObservable.value()[atIndex] as! MovieStickerPack
        viewModel.router.presentStickerPackDetails(item)
    }
    
    private func exportStickerPack(atIndex: Int) {
        let item = try! dataObservable.value()[atIndex] as! MovieStickerPack
        viewModel.stickerPackSharingInteractor.doUiShareStickerPackToWhatsApp(item).disposed(by: disposeBag)
    }
}
