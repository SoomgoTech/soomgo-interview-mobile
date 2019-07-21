//
//  Bookmark.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 20/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import SwiftFFDB

struct Bookmark: FFObject {
    
    var primaryId: Int64?
    var articleId: String = ""
    var headline: String?
    var snippet: String?
    var webUrl: String?
    var pubDate: Date?
    var createdAt: Date?
    
    func formattedPubDate() -> String {
        return pubDate!.formattedString()
    }
    
    static func memoryPropertys() -> [String]? {
        return nil
    }
    
    static func customColumnsType() -> [String : String]? {
        return nil
    }
    
    static func customColumns() -> [String : String]? {
        return nil
    }
    
    static func autoincrementColumn() -> String? {
        return "primaryId"
    }
    
    static func primaryKeyColumn() -> String {
        return "primaryId"
    }
}
