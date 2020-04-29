//
//  RootTabRouter.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit
import Swinject

class RootTabRouter: UITabBarController {
    enum Tabs: Int {
        case gifs
        case memes
        case stickers
    }
    
    let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentRootTabScreen(fromWindow: UIWindow) {
        let packRouter = resolver.resolve(StickerPacksNavigationRouter.self)!
        packRouter.presentMoviePackList()
        packRouter.tabBarItem = UITabBarItem(title: "StickerPacksTitle".localized.uppercased(), image: UIImage(named: "sticker_tab_icon"), tag: Tabs.stickers.rawValue)
        
        let gifProvider = resolver.resolve(GifsImageContentPackProvider.self)!
        let gifsRouter = resolver.resolve(ImageContentPacksNavigationRouter.self, argument: gifProvider as ImageContentPackProvider)!
        gifsRouter.tabBarItem = UITabBarItem(title: gifProvider.collectionDisplayName.uppercased(), image: UIImage(named: "gif_tab_icon"), tag: Tabs.gifs.rawValue)
        gifsRouter.presentContentPackList()
        
        let memesProvider = resolver.resolve(MemesImageContentPackProvider.self)!
        let memesRouter = resolver.resolve(ImageContentPacksNavigationRouter.self, argument: memesProvider as ImageContentPackProvider)!
        memesRouter.tabBarItem = UITabBarItem(title: memesProvider.collectionDisplayName.uppercased(), image: UIImage(named: "meme_tab_icon"), tag: Tabs.memes.rawValue)
        memesRouter.presentContentPackList()
        
        setViewControllers([gifsRouter, memesRouter, packRouter], animated: false)        
        fromWindow.rootViewController = self
    }
}
