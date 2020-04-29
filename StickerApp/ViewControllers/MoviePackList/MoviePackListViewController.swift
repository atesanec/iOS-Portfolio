//
//  MoviePackListViewController.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

/**
 *  List of movie packs
 */
class MoviePackListViewController: UIViewController {    
    private let viewModel: MoviePackListViewModel
    private var sectionManagerAggregate: CollectionViewSectionManagerAggregate!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var loadingOverlayView: BlurredOverlayView?
    
    init(contentMetadataRequestService: ContentMetadataRequestServiceInteractor,
         stickerPackSharingInteractor: StickerPackSharingInteractor,
         imageDownloadInteractor: ImageDownloadInteractor,
         router: StickerPacksNavigationRouter)
    {
        viewModel = MoviePackListViewModel(contentMetadataRequestService: contentMetadataRequestService,
                                           stickerPackSharingInteractor: stickerPackSharingInteractor,
                                           imageDownloadInteractor: imageDownloadInteractor,
                                           router: router)
        super.init(nibName: "MoviePackListViewController", bundle: nil)
        title = "StickerPacksTitle".localized
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        
        let listSection = MoviePackListItemsSectionManager(viewModel: viewModel)
        sectionManagerAggregate = CollectionViewSectionManagerAggregate(sectionManagers: [listSection], collectionView: collectionView)
        
        setupUiObservations()
        loadStickerPacks()
    }
    
    private func loadStickerPacks() {
        viewModel.isLoadingInProgress.onNext(true)
        viewModel.contentMetadataRequestService.fetchStickerPackCollection().subscribe(onNext: {[weak self] (collection) in
            self!.viewModel.isLoadingInProgress.onNext(false)
            self!.viewModel.stickerPacks.onNext(collection.stickerPacks)
            }, onError: { [weak self]  (error) in
                self!.viewModel.isLoadingInProgress.onNext(false)
                AppAlertMessagePresenter.presentAlert(title: error.localizedDescription, text: nil, actionTitle: nil,
                                                      alternativeAction: UIAlertAction(title: "Retry".localized, style: .default,
                                                                                       handler: { [weak self] _ in
                                                        self!.loadStickerPacks()
                                                      }))
        }).disposed(by: disposeBag)
    }
    
    private func setupUiObservations() {
        navigationItem.rightBarButtonItem!.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.loadStickerPacks()
        }).disposed(by: disposeBag)
        
        viewModel.isLoadingInProgress.subscribe(onNext: { [weak self] (loading) in
            guard let strongSelf = self else {
                return
            }
            
            if !loading {
                SVProgressHUD.dismiss()
                strongSelf.loadingOverlayView?.removeFromSuperview()
            } else {
                SVProgressHUD.show()
                strongSelf.loadingOverlayView = BlurredOverlayView.showInWindow(UIApplication.shared.keyWindow!)
            }
        }).disposed(by: disposeBag)
    }
}
