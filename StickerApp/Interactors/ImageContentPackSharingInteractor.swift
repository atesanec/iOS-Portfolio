//
//  ImageContentPackSharingInteraction.swift
//  MovieImages
//
//  Created by VI_Business on 28.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class ImageContentPackSharingInteractor {
    let cachedBinaryDownloaderDataInteractor: CachedBinaryDownloaderDataInteractor
    let router: RootTabRouter
    
    init(cachedBinaryDownloaderDataInteractor: CachedBinaryDownloaderDataInteractor, router: RootTabRouter) {
        self.cachedBinaryDownloaderDataInteractor = cachedBinaryDownloaderDataInteractor
        self.router = router
    }
    
    func doUiShareImageContentPackItem(_ item: ImageContentPackItem) -> Disposable {
        SVProgressHUD.show()
        
        return cachedBinaryDownloaderDataInteractor.downloadBinaryDataForPaths([item.imageDownloadPath], progressObserver: nil)
            .subscribe(onNext: { [weak self] (pair) in
                SVProgressHUD.dismiss()
                
                let filePath = pair.first!.value
                let data = NSData(contentsOf: filePath)!
                let controller = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                controller.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
                    if let error = activityError {
                        AppAlertMessagePresenter.presentAlert(title: error.localizedDescription, text: nil)
                        return
                    }
                }
                
                self!.router.present(controller, animated: true, completion: nil)
                
            }, onError: { (error) in
                SVProgressHUD.dismiss()
                AppAlertMessagePresenter.presentAlert(title: error.localizedDescription, text: nil)
            })
    }
}
