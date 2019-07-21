//
//  Extensions.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 21/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import Foundation

extension Date {
    
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale.current
        
        return dateFormatter.date(from: self)!
    }
}
