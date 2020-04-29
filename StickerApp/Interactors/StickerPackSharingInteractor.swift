//
//  StickerPackSharingInteractor.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class StickerPackSharingInteractor {
    let cachedBinaryDownloaderDataInteractor: CachedBinaryDownloaderDataInteractor
    let workQueue = DispatchQueue.init(label: "stickerPackSharingInteractor.queue")
    
    init(cachedBinaryDownloaderDataInteractor: CachedBinaryDownloaderDataInteractor) {
        self.cachedBinaryDownloaderDataInteractor = cachedBinaryDownloaderDataInteractor
    }
    
    func shareStickerPackToWhatsApp(_ pack: MovieStickerPack, progressObserver: AnyObserver<CGFloat>?) -> Observable<Bool> {
        var paths = pack.stickers.map {$0.imageDownloadPath}
        paths.append(pack.trayImageDownloadPath)
        return cachedBinaryDownloaderDataInteractor.downloadBinaryDataForPaths(paths, progressObserver: progressObserver)
            .flatMap({ [weak self] downloadedPaths -> Observable<Bool> in
                let strongSelf = self!
                return strongSelf.sendDownloadedStickerPackToWhatsApp(pack, imageFiles: downloadedPaths)
            })
    }
    
    func doUiShareStickerPackToWhatsApp(_ pack: MovieStickerPack) -> Disposable {
        SVProgressHUD.showProgress(0, status: "DownloadingStickers".localized)
        let overlay = BlurredOverlayView.showInWindow(UIApplication.shared.keyWindow!)
        overlay.backgroundColor = .clear
        
        let progressObserver = AnyObserver<CGFloat> { (event: Event<CGFloat>) in
            SVProgressHUD.showProgress(Float(event.element!), status: "DownloadingStickers".localized)
        }
        
        return shareStickerPackToWhatsApp(pack, progressObserver: progressObserver).observeOn(MainScheduler.instance).subscribe(onNext: { _ in
            SVProgressHUD.dismiss()
            overlay.removeFromSuperview()
        }, onError: { (error) in
            SVProgressHUD.dismiss()
            overlay.removeFromSuperview()
            AppAlertMessagePresenter.presentAlert(title: error.localizedDescription, text: nil)
        })
    }
    
    private func sendDownloadedStickerPackToWhatsApp(_ pack: MovieStickerPack, imageFiles: CachedBinaryDownloaderDataInteractor.DownloadRemoteToLocalPath)
        -> Observable<Bool>
    {
        return Observable.create({ [weak self] (observer) -> Disposable in
            self!.workQueue.async {
                let trayPath = imageFiles[pack.trayImageDownloadPath]!.path
                do {
                    let exportPack = try StickerPack(identifier: pack.identifier,
                                                     name: pack.name,
                                                     publisher: pack.publisher,
                                                     trayImageFileName: trayPath,
                                                     publisherWebsite: pack.publisherWebsite,
                                                     privacyPolicyWebsite: pack.privacyPolicyWebsite,
                                                     licenseAgreementWebsite: pack.licenseAgreementWebsite)
                    
                    for item in pack.stickers {
                        let imagePath = imageFiles[item.imageDownloadPath]!.path
                        try exportPack.addSticker(contentsOfFile: imagePath, emojis: item.emojis)
                    }
                    
                    exportPack.sendToWhatsApp(completionHandler: { (result) in
                        observer.onNext(result)
                        observer.onCompleted()
                    })
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        })
    }
}
