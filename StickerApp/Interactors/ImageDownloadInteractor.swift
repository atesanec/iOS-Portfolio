//
//  ImageDownloadInteractor.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift
import YYImage

class ImageDownloadInteractor: NSObject {
    let cachedBinaryDownloaderDataInteractor: CachedBinaryDownloaderDataInteractor
    
    init(cachedBinaryDownloaderDataInteractor: CachedBinaryDownloaderDataInteractor) {
        self.cachedBinaryDownloaderDataInteractor = cachedBinaryDownloaderDataInteractor
    }
    
    func downloadImage(path: String) -> Observable<YYImage?> {
        return cachedBinaryDownloaderDataInteractor.downloadBinaryDataForPaths([path], progressObserver: nil)
            .map({ result in
                return YYImage(contentsOfFile: result.values.first!.path)
            })
    }
}
