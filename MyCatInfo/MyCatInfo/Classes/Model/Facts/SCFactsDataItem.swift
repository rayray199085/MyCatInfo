//
//  SCFactsDataItem.swift
//  MyCatInfo
//
//  Created by Stephen Cao on 6/8/19.
//  Copyright © 2019 Stephen Cao. All rights reserved.
//

import Foundation

struct SCFactsDataItem: Codable {
    let id: String?
    let v: Int?
    let text: String?
    let updatedAt: String?
    let deleted: Bool?
    let source: String?
    let used: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case text
        case updatedAt
        case deleted
        case source
        case used
    }
}
struct SCFactsImageDataItem: Codable{
    let url: String?
    let width: Int?
    let height: Int?
}
