//
//  MoviePackDetailViewController.swift
//  MovieImages
//
//  Created by VI_Business on 28.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoviePackDetailViewController: UIViewController {
    private let viewModel: MoviePackDetailViewModel
    private var sectionManagerAggregate: CollectionViewSectionManagerAggregate!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var shareButton: UIButton!
    
    init(stickerPack: MovieStickerPack,
         stickerPackSharingInteractor: StickerPackSharingInteractor,
         imageDownloadInteractor: ImageDownloadInteractor,
         router: StickerPacksNavigationRouter) {
        viewModel = MoviePackDetailViewModel(stickerPack: stickerPack,
                                             stickerPackSharingInteractor: stickerPackSharingInteractor,
                                             imageDownloadInteractor: imageDownloadInteractor,
                                             router: router)
        super.init(nibName: "MoviePackDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = viewModel.stickerPack.name
        
        shareButton.setTitle("AddToWhatsApp".localized, for: .normal)
        
        let listSection = MoviePackDetailStickerListSectionManager(viewModel: viewModel)
        sectionManagerAggregate = CollectionViewSectionManagerAggregate(sectionManagers: [listSection], collectionView: collectionView)
    
        setupUiObservations()
    }
    
    private func setupUiObservations() {
        shareButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.viewModel.stickerPackSharingInteractor.doUiShareStickerPackToWhatsApp(strongSelf.viewModel.stickerPack)
                .disposed(by: strongSelf.disposeBag)
        }).disposed(by: disposeBag)
    }
}
