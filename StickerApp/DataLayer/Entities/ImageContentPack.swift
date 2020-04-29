//
//  ImageContentPack.swift
//  MovieImages
//
//  Created by VI_Business on 28.04.19.
//  Copyright © 2019 coolcorp. All rights reserved.
//

import UIKit

class ImageContentPackCollection: Decodable {
    enum DecodingKeys: String, CodingKey {
        case current_version_code
        case gif_packs
    }
    
    let currentVersionCode: String
    let gifPacks: [ImageContentPack]
    
    var sourceName: String!
    
    func connectChildParentRelations() {
        gifPacks.forEach { item in
            item.packCollection = self
            item.connectPackAndItems()
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        currentVersionCode = try container.decode(String.self, forKey: .current_version_code)
        gifPacks = try container.decode([ImageContentPack].self, forKey: .gif_packs)
    }
}

class ImageContentPack: Decodable {
    enum DecodingKeys: String, CodingKey {
        case identifier
        case name
        case keywords
        case gifs
    }
    
    weak var packCollection: ImageContentPackCollection!
    let identifier: String
    let name: String
    let keywords: [String]
    let gifs: [ImageContentPackItem]
    
    func connectPackAndItems() {
        gifs.forEach {$0.pack = self}
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        keywords = try container.decode([String].self, forKey: .keywords)
        gifs = try container.decode([ImageContentPackItem].self, forKey: .gifs)
    }
}

class ImageContentPackItem: Decodable {
    enum DecodingKeys: String, CodingKey {
        case image_file
        case emojis
    }
    
    weak var pack: ImageContentPack!
    let imageFile: String
    let emojis: [String]
    
    var imageDownloadPath: String {
        return [pack.packCollection.sourceName, pack.identifier, imageFile].joined(separator: "/")
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        
        imageFile = try container.decode(String.self, forKey: .image_file)
        emojis = try container.decode([String].self, forKey: .emojis)
    }
}
