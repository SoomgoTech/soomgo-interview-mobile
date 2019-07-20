//
//  Actions.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 20/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import ReSwift

struct LoadingAction: Action {}

struct LoadmoreAction: Action {}

struct ArticleLoadedAction: Action {
    let articles: [Article]
    let page: Int
}

struct FailLoadAction: Action {
    let error: Error
}

struct DataChangedAction: Action {}

struct BookmarkAction: Action {
    let bookmarks: [Bookmark]
}


struct ArticleSearchAction: Action {
    let query: String
    let page: Int
}

struct ToggleBookmarkAction: Action {
    let article: Article
}

struct DeleteBookmarkAction: Action {
    let bookmark: Bookmark
}

struct BookmarkLoadAction: Action {}
