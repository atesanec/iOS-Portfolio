//
//  ContentMetadataRequestService.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift

class ContentMetadataRequestServiceInteractor {
    private static let baseURL = URL(string: "https://sticker-babai-ios.firebaseapp.com")!
    enum Path: String {
        case stickers = "stickers.json"
        case memes = "memes.json"
        case gifs = "gifs.json"
    }
    
    
    let networkRequestService: NetworkRequestService
    init(networkRequestService: NetworkRequestService) {
        self.networkRequestService = networkRequestService
    }
    
    func fetchStickerPackCollection() -> Observable<MovieStickerPackCollection> {
        return networkRequestService.requestItem(atURL: type(of: self).makeURL(path: .stickers)).do(onNext: { (collection) in
            collection.connectChildParentRelations()
        })
    }
    
    func fetchMemesPackCollection() -> Observable<ImageContentPackCollection> {
        return networkRequestService.requestItem(atURL: type(of: self).makeURL(path: .memes)).do(onNext: { (collection) in
            collection.sourceName = "memes"
            collection.connectChildParentRelations()
        })
    }
    
    func fetchGifsPackCollection() -> Observable<ImageContentPackCollection> {
        return networkRequestService.requestItem(atURL: type(of: self).makeURL(path: .gifs)).do(onNext: { (collection) in
            collection.sourceName = "gifs"
            collection.connectChildParentRelations()
        })
    }
    
    static func makeURL(path: Path) -> URL {
        return baseURL.appendingPathComponent(path.rawValue)
    }
}
