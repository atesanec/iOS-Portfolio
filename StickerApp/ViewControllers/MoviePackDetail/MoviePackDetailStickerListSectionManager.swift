//
//  AlbumsListPhotosSectionManager.swift
//  MovieImages
//
//  Created by VI_Business on 20/12/2018.
//  Copyright © 2018 coolcorp. All rights reserved.
//

import UIKit
import RxSwift

class MoviePackDetailStickerListSectionManager: CollectionViewSectionManager {
    var collectionView: UICollectionView!
    var sectionIndex = 0
    var dataObservable: BehaviorSubject<[Any]>
    
    private static let cellsPerRow = 3
    private let viewModel: MoviePackDetailViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MoviePackDetailViewModel) {
        self.viewModel = viewModel
        
        dataObservable = BehaviorSubject<[Any]>(value: viewModel.stickerPack.stickers)
    }
    
    func registerCells() {
        collectionView.register(RoundedImageCell.self, forCellWithReuseIdentifier: RoundedImageCell.defaultReuseId)
    }
    
    func configure(cell: UICollectionViewCell, atIndex: Int) {
        let albumCell = cell as! RoundedImageCell
        let item = try! dataObservable.value()[atIndex] as! MovieSticker
        let imageObservable = viewModel.imageDownloadInteractor.downloadImage(path: item.imageDownloadPath).asDriver(onErrorJustReturn: nil)
        
        let config = RoundedImageCell.Configuration(imageObservable: imageObservable.asObservable())
        albumCell.configure(info: config)
    }
    
    func cellId(atIndex: Int) -> String {
        return RoundedImageCell.defaultReuseId
    }
    
    func sizeForItem(atIndex: Int) -> CGSize {
        let gap = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let cellCount = type(of: self).cellsPerRow
        let cellWidth = floor((collectionView.bounds.width - gap * CGFloat(cellCount + 1)) / CGFloat(cellCount))
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func itemSelected(atIndex: Int) {
    }
}
