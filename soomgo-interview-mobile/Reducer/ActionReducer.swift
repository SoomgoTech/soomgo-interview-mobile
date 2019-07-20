//
//  MainReducer.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 20/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import ReSwift

func actionReducer(action: Action, state: ActionState?) -> ActionState {
    switch action {
    case _ as BookmarkLoadAction:
        BookmarksRepository.shared.load()
    
    case let action as ArticleSearchAction:
        API.search(query: action.query, page: action.page)
        
    case let action as ToggleBookmarkAction:
        BookmarksRepository.shared.toggleBookmark(article: action.article)
        
    case let action as DeleteBookmarkAction:
        BookmarksRepository.shared.delete(bookmark: action.bookmark)
        
    default:
        break
    }
    
    return ActionState()
}
