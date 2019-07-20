//
//  AppState.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 20/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import ReSwift

struct MainState: StateType {
    var isLoading: Bool = false
    var isLoadmore: Bool = false
    var isRefreshed: Bool = false
    var page: Int = 0
    var articles: [Article] = []
    var errorMessage: String?
}

struct BookmarkState: StateType {
    var bookmarks: [Bookmark] = []
}

struct ActionState: StateType {
    
}
