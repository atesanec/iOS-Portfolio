//
//  ImageContentPacksNavigationRouter.swift
//  MovieImages
//
//  Created by VI_Business on 28.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import Swinject

class ImageContentPacksNavigationRouter: UINavigationController {
    let resolver: Resolver
    let contentProvider: ImageContentPackProvider
    
    init(contentProvider: ImageContentPackProvider, resolver: Resolver) {
        self.resolver = resolver
        self.contentProvider = contentProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentContentPackList() {
        let controller = resolver.resolve(ImageContentPackListViewController.self, arguments: contentProvider, self)!
        self.viewControllers = [controller]
    }
    
    func presentContentPackDetailScreen(_ pack: ImageContentPack, focusOnItemAtIndex: Int) {
        let controller = resolver.resolve(ImageContentPackDetailViewController.self, arguments: pack, focusOnItemAtIndex)!
        pushViewController(controller, animated: true)
    }
}
