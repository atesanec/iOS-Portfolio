//
//  CachedBinaryDownloaderDataInteractor.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift

class CachedBinaryDownloaderDataInteractor {
    typealias DownloadRemoteToLocalPath = [String: URL]
    
    let binaryDownloaderService: BinaryDownloaderService
    private var cachePath: URL {
        return WhatsAppStickerFrameworkConfig.imageStoragePath
    }
    
    init(binaryDownloaderService: BinaryDownloaderService) {
        self.binaryDownloaderService = binaryDownloaderService
    }
    
    func downloadBinaryDataForPaths(_ paths: [String], progressObserver: AnyObserver<CGFloat>?) -> Observable<DownloadRemoteToLocalPath> {
        return binaryDownloaderService.getMetadataForPaths(paths).flatMap({ [weak self] (urlMetadata) -> Observable<DownloadRemoteToLocalPath> in
            let strongSelf = self!
            var downloadedFiles = DownloadRemoteToLocalPath()
            for (key, value) in urlMetadata {
                let meta = value
                let localPath = BinaryDownloaderService.localFileUrlForRemoteRelativePath(key, saveRootPath: strongSelf.cachePath)
                let localSize = try? FileManager.default.attributesOfItem(atPath: localPath.path)[FileAttributeKey.size] as! Int64
                
                if let localFileSize = localSize, meta.fileSize == localFileSize {
                    downloadedFiles[key] = localPath
                }
            }
            
            let pathsToDownload = Array<String>(Set<String>(paths).subtracting(downloadedFiles.keys))
            
            let downloadObservable = strongSelf.binaryDownloaderService.downloadBinaryDataForPaths(pathsToDownload,
                                                                                                   progressObserver: progressObserver,
                                                                                                   saveRootPath: strongSelf.cachePath)
            return Observable.merge(Observable.just(downloadedFiles), downloadObservable)
                .reduce(DownloadRemoteToLocalPath(), accumulator: { (acc, result) in
                    var mergedResult = acc
                    mergedResult.merge(result, uniquingKeysWith: { (source, dest) in
                        return dest
                    })
                    
                    return mergedResult
                })
        })
    }
}
