//
//  ImageContentPackProvider.swift
//  MovieImages
//
//  Created by VI_Business on 28.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift

protocol ImageContentPackProvider {
    var collectionDisplayName: String {get}

    func loadPacksCollection() -> Observable<ImageContentPackCollection>
}

class MemesImageContentPackProvider: ImageContentPackProvider {
    let contentMetadataRequestServiceInteractor: ContentMetadataRequestServiceInteractor
    var collectionDisplayName: String {
        return "MemesTitle".localized
    }
    
    init(contentMetadataRequestServiceInteractor: ContentMetadataRequestServiceInteractor) {
        self.contentMetadataRequestServiceInteractor = contentMetadataRequestServiceInteractor
    }
    
    func loadPacksCollection() -> Observable<ImageContentPackCollection> {
        return contentMetadataRequestServiceInteractor.fetchMemesPackCollection()
    }
}
class GifsImageContentPackProvider: ImageContentPackProvider {
    let contentMetadataRequestServiceInteractor: ContentMetadataRequestServiceInteractor
    var collectionDisplayName: String {
        return "GifsTitle".localized
    }
    
    init(contentMetadataRequestServiceInteractor: ContentMetadataRequestServiceInteractor) {
        self.contentMetadataRequestServiceInteractor = contentMetadataRequestServiceInteractor
    }
    
    func loadPacksCollection() -> Observable<ImageContentPackCollection> {
        return contentMetadataRequestServiceInteractor.fetchGifsPackCollection()
    }
}
