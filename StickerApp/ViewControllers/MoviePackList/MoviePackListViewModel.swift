//
//  MoviePackListViewModel.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift

class MoviePackListViewModel {
    let contentMetadataRequestService: ContentMetadataRequestServiceInteractor
    let stickerPackSharingInteractor: StickerPackSharingInteractor
    let imageDownloadInteractor: ImageDownloadInteractor
    let router: StickerPacksNavigationRouter
    
    let stickerPacks = BehaviorSubject<[MovieStickerPack]>(value: [MovieStickerPack]())
    let isLoadingInProgress = BehaviorSubject<Bool>(value: false)
    
    init(contentMetadataRequestService: ContentMetadataRequestServiceInteractor,
        stickerPackSharingInteractor: StickerPackSharingInteractor,
        imageDownloadInteractor: ImageDownloadInteractor,
        router: StickerPacksNavigationRouter) {
        self.contentMetadataRequestService = contentMetadataRequestService
        self.stickerPackSharingInteractor = stickerPackSharingInteractor
        self.imageDownloadInteractor = imageDownloadInteractor
        self.router = router
    }
}
