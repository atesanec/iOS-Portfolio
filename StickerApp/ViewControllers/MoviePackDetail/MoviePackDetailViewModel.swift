//
//  MoviePackDetailViewModel.swift
//  MovieImages
//
//  Created by VI_Business on 28.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit

class MoviePackDetailViewModel {
    let stickerPack: MovieStickerPack
    let stickerPackSharingInteractor: StickerPackSharingInteractor
    let imageDownloadInteractor: ImageDownloadInteractor
    let router: StickerPacksNavigationRouter
    
    init(stickerPack: MovieStickerPack,
         stickerPackSharingInteractor: StickerPackSharingInteractor,
         imageDownloadInteractor: ImageDownloadInteractor,
         router: StickerPacksNavigationRouter) {
        self.stickerPack = stickerPack
        self.stickerPackSharingInteractor = stickerPackSharingInteractor
        self.imageDownloadInteractor = imageDownloadInteractor
        self.router = router
    }
}
