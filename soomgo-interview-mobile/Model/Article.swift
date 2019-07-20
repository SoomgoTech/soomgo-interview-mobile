//
//  Article.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 20/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import Foundation

struct Article: Decodable {
    let id: String
    let headline: Headline
    let snippet: String
    let webUrl: String
    let pubDate: String
    
    func isBookmarked() -> Bool {
        return BookmarksRepository.shared.firstIndex(self) != nil
    }
    
    func date() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: pubDate)!
    }
    
    func formattedPubDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: date())
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case headline
        case snippet
        case webUrl = "web_url"
        case pubDate = "pub_date"
    }
}

struct Headline: Decodable {
    let main: String
}

struct ResponseRoot: Decodable {
    let response: Response
}

struct Response: Decodable {
    let docs: [Article]
}
