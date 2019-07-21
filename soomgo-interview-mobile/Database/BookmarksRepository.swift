//
//  BookmarkRepository.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 20/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import SwiftFFDB

class BookmarksRepository {
    
    static let shared = BookmarksRepository()
    
    private var bookmarks: [Bookmark] = []
    
    func load() {
        Bookmark.registerTable()
        var bookmarks = Bookmark.select() as? [Bookmark] ?? []
        bookmarks.sort { (lhs, rhs) -> Bool in
            return lhs.createdAt!.compare(rhs.createdAt!) != ComparisonResult.orderedAscending
        }
        
        self.bookmarks = bookmarks
        bookmarkStore.dispatch(BookmarkAction(bookmarks: bookmarks))
        mainStore.dispatch(DataChangedAction())
    }
    
    func firstIndex(_ article: Article) -> Int? {
        return bookmarks.firstIndex(where: { (bookmark) -> Bool in
            return bookmark.articleId == article.id
        })
    }
    
    func toggleBookmark(article: Article) {
        if let index = firstIndex(article) {
            let item = bookmarks[index]
            let ret = item.delete()
            if (ret) {
                bookmarks.remove(at: index)
                bookmarkStore.dispatch(BookmarkAction(bookmarks: bookmarks))
                mainStore.dispatch(DataChangedAction())
            }
            return
        }
        
        var bookmark = Bookmark()
        bookmark.articleId = article.id
        bookmark.headline = article.headline.main
        bookmark.pubDate = article.pubDate.toDate()
        bookmark.snippet = article.snippet
        bookmark.webUrl = article.webUrl
        bookmark.createdAt = Date()
        
        let ret = bookmark.insert()
        if (ret) {
            bookmarks.insert(bookmark, at: 0)
            bookmarkStore.dispatch(BookmarkAction(bookmarks: bookmarks))
            mainStore.dispatch(DataChangedAction())
        }
    }
    
    func delete(bookmark: Bookmark) {
        if let index = bookmarks.firstIndex(where: { (value) -> Bool in
            return value.articleId == bookmark.articleId
        }) {
            if (bookmark.delete()) {
                bookmarks.remove(at: index)
                bookmarkStore.dispatch(BookmarkAction(bookmarks: bookmarks))
                mainStore.dispatch(DataChangedAction())
            }
        }
    }
}
