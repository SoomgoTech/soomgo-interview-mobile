//
//  BookmarkReducer.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 20/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import ReSwift

func bookmarkReducer(action: Action, state: BookmarkState?) -> BookmarkState {
    var state = state ?? BookmarkState()
    
    switch action {
    case _ as BookmarkLoadAction:
        BookmarksRepository.shared.load()
        
    case let action as BookmarkAction:
        state.bookmarks = action.bookmarks
        
    default:
        break
    }
    
    return state
}
