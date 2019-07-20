//
//  SearchReducer.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 20/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import ReSwift

func mainReducer(action: Action, state: MainState?) -> MainState {
    var state = state ?? MainState()
    
    state.isRefreshed = false
    state.isLoading = false
    state.isLoadmore = false
    state.errorMessage = nil
    
    switch action {
    case _ as LoadingAction:
        state.isLoading = true
        
    case _ as LoadmoreAction:
        state.isLoadmore = true
        
    case let action as FailLoadAction:
        state.errorMessage = action.error.localizedDescription
        
    case let action as ArticleLoadedAction:
        state.articles = action.articles
        state.page = action.page
        
    case _ as DataChangedAction:
        state.isRefreshed = true
        
    default:
        break
    }
    
    return state
}
