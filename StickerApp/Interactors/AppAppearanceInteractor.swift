//
//  AppAppearanceInteractor.swift
//  MovieImages
//
//  Created by VI_Business on 01.05.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit

class AppAppearanceInteractor {
    func applyAppearance() {
        let navBar =  UINavigationBar.appearance()
        navBar.barTintColor = .appGreenColor
        navBar.tintColor = .white
        navBar.titleTextAttributes = [.foregroundColor: UIColor.white,
                                      .font: UIFont.systemFont(ofSize: 26, weight: .bold)]
        
        UITabBar.appearance().tintColor = .appGreenColor
    }
}
