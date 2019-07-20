//
//  SecondViewController.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 19/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import UIKit
import ReSwift
import SafariServices

class BookmarksViewController: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = BookmarkState

    @IBOutlet weak var tableView: UITableView!
    
    private var bookmarks: [Bookmark] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        
        bookmarkStore.subscribe(self)
    }
    
    func newState(state: StoreSubscriberStateType) {
        bookmarks = state.bookmarks
        tableView.reloadData()
    }
}

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let bookmark = bookmarks[indexPath.row]
        
        cell?.textLabel?.text = bookmark.headline
        cell?.detailTextLabel?.text = bookmark.formattedPubDate()
        cell?.accessoryView = bookmarkButton(bookmark: bookmark)
        cell?.accessoryView?.tag = indexPath.row
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let bookmark = bookmarks[indexPath.row]
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let safariViewController = SFSafariViewController(url: URL(string: bookmark.webUrl!)!, configuration: config)
        present(safariViewController, animated: true, completion: nil)
    }
    
    private func bookmarkButton(bookmark: Bookmark) -> UIButton {
        let button = UIButton(type: .system)
        let image = UIImage(imageLiteralResourceName: "star")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.red
        button.sizeToFit()
        
        button.removeTarget(self, action: #selector(bookmarkButtonClicked(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(bookmarkButtonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func bookmarkButtonClicked(_ button: UIButton) {
        let bookmark = bookmarks[button.tag]
        actionStore.dispatch(DeleteBookmarkAction(bookmark: bookmark))
    }
}
