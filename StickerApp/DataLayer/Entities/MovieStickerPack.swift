//
//  MovieStickerPack.swift
//  MovieImages
//
//  Created by VI_Business on 27.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit

class MovieStickerPackCollection: Decodable {
    enum DecodingKeys: String, CodingKey {
        case androidPlayStoreLink = "android_play_store_link"
        case iosAppStoreLink = "ios_app_store_link"
        case currentVersionCodeInPlayStore = "current_version_code_in_play_store"
        case stickerPacks = "sticker_packs"
    }
    
    let androidPlayStoreLink: String
    let iosAppStoreLink: String
    let currentVersionCodeInPlayStore: String
    let stickerPacks: [MovieStickerPack]
    
    func connectChildParentRelations() {
        stickerPacks.forEach { item in
            item.packCollection = self
            item.connectPackAndStickers()
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        androidPlayStoreLink = try container.decode(String.self, forKey: .androidPlayStoreLink)
        iosAppStoreLink = try container.decode(String.self, forKey: .iosAppStoreLink)
        currentVersionCodeInPlayStore = try container.decode(String.self, forKey: .currentVersionCodeInPlayStore)
        stickerPacks = try container.decode([MovieStickerPack].self, forKey: .stickerPacks)
    }
}

class MovieStickerPack: Decodable {
    enum DecodingKeys: String, CodingKey {
        case identifier
        case name
        case publisher
        case tray_image_file
        case publisher_website
        case privacy_policy_website
        case license_agreement_website
        case keywords
        case stickers
    }
    
    weak var packCollection: MovieStickerPackCollection!
    let identifier: String
    let name: String
    let publisher: String
    let trayImageFile: String
    let publisherWebsite: String?
    let privacyPolicyWebsite: String?
    let licenseAgreementWebsite: String?
    let keywords: [String]
    let stickers: [MovieSticker]
    
    func connectPackAndStickers() {
        stickers.forEach {$0.pack = self}
    }
    
    var trayImageDownloadPath: String {
        return ["stickers", identifier, trayImageFile].joined(separator: "/")
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        publisher = try container.decode(String.self, forKey: .publisher)
        trayImageFile = try container.decode(String.self, forKey: .tray_image_file)
        publisherWebsite = try container.decode(String?.self, forKey: .publisher_website)
        privacyPolicyWebsite = try container.decode(String?.self, forKey: .privacy_policy_website)
        licenseAgreementWebsite = try container.decode(String?.self, forKey: .license_agreement_website)
        keywords = try container.decode([String].self, forKey: .keywords)
        stickers = try container.decode([MovieSticker].self, forKey: .stickers)
    }
}

class MovieSticker: Decodable {
    enum DecodingKeys: String, CodingKey {
        case image_file
        case emojis
    }
    
    weak var pack: MovieStickerPack!
    let imageFile: String
    let emojis: [String]
    
    var imageDownloadPath: String {
        return ["stickers", pack.identifier, imageFile].joined(separator: "/")
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        imageFile = try container.decode(String.self, forKey: .image_file)
        emojis = try container.decode([String].self, forKey: .emojis)
    }
}
