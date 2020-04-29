//
//  StickerPacksNavigationRouter.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import Swinject

class StickerPacksNavigationRouter: UINavigationController {
    let resolver: Resolver
    init(resolver: Resolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentMoviePackList() {
        viewControllers = [resolver.resolve(MoviePackListViewController.self)!]
    }
    
    func presentStickerPackDetails(_ pack: MovieStickerPack) {
        let controller = resolver.resolve(MoviePackDetailViewController.self, argument: pack)!
        self.pushViewController(controller, animated: true)
    }
}
