//
//  AssetSaveDataModel.swift
//  OpenArt
//
//  Created by Иван Дурмашев on 22.06.2022.
//

import Foundation

struct AssetSaveDataModel {
    var tokenID: String?
    var assetName: String?
    var assetImageData: Data?
    var assetDescription: String?
    var collectionName: String?
    var collectionImageData: Data?
}
