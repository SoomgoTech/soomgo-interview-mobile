//
//  API.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 20/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import Foundation
import Alamofire

class API {
    
    private static let baseUrl = "https://api.nytimes.com/svc/search/v2/articlesearch.json"
    
    static func search(query: String, page: Int) {
        if mainStore.state.isLoading || query.isEmpty || page > 200 {
            return
        }
        
        mainStore.dispatch(page <= 1 ? LoadingAction() : LoadmoreAction())
        Alamofire.request(baseUrl,
                          method: .get,
                          parameters: ["q": query,
                                       "page": page,
                                       "headline": "main",
                                       "sort": "newest",
                                       "api-key": "0z8EPBWWtYs5G6JNWbSPru5cMtsSIL3k"],
                          encoding: URLEncoding.default,
                          headers: nil)
            .responseData { (response) in
                if let data = response.data {
                    do {
                        let res = try JSONDecoder().decode(ResponseRoot.self, from: data)
                        mainStore.dispatch(ArticleLoadedAction(articles: res.response.docs, page: page))
                    } catch {
                        mainStore.dispatch(FailLoadAction(error: error))
                    }
                }
        }
    }
    
}
