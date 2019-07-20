//
//  FirstViewController.swift
//  soomgo-interview-mobile
//
//  Created by Thomas Jeong on 19/07/2019.
//  Copyright © 2019 Thomas Jeong. All rights reserved.
//

import UIKit
import ReSwift
import MBProgressHUD
import SafariServices

class SearchViewController: UIViewController, StoreSubscriber {
    typealias StoreSubscriberStateType = MainState

    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var queryString = ""
    private var page = 1
    private var articles: [Article] = []
    private var isFailedSearching = false
    
    private var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.sizeToFit()
        
        mainStore.subscribe(self)
    }
    
    func newState(state: StoreSubscriberStateType) {
        state.isLoading ? showLoadingProress() : hideLoadingProgress()
        state.isLoadmore ? showLoadmoreIndicator() : hideLoadmoreIndicator()
        
        if !state.isLoading && !state.isLoadmore {
            page = state.page
            articles.append(contentsOf: state.articles)
            tableView.reloadData()
            searchController.isActive = false
            
            if (state.errorMessage != nil) {
                print(state.errorMessage!)
                isFailedSearching = true
            }
        }
        
        if state.isRefreshed {
            tableView.reloadData()
        }
    }
    
    private func showLoadmoreIndicator() {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
        
        tableView.tableFooterView = spinner
    }
    
    private func hideLoadmoreIndicator() {
        if (tableView.tableFooterView is UIActivityIndicatorView) {
            tableView.tableFooterView = UIView()
        }
    }
    
    private func showLoadingProress() {
        if (hud != nil) {
            return
        }
        hud = MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    private func hideLoadingProgress() {
        if (hud == nil) {
            return
        }
        hud?.hide(animated: true)
        hud = nil
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row != articles.count - 1 || isFailedSearching) {
            return
        }
        
        actionStore.dispatch(ArticleSearchAction(query: queryString, page: page + 1))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        }
        
        let article = articles[indexPath.row]
        
        cell?.textLabel?.text = article.headline.main
        cell?.detailTextLabel?.text = article.formattedPubDate()
        cell?.accessoryView = bookmarkButton(article: article)
        cell?.accessoryView?.tag = indexPath.row
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = articles[indexPath.row]
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let safariViewController = SFSafariViewController(url: URL(string: article.webUrl)!, configuration: config)
        present(safariViewController, animated: true, completion: nil)
    }
    
    private func bookmarkButton(article: Article) -> UIButton {
        let button = UIButton(type: .system)
        let image = UIImage(imageLiteralResourceName: "star")
        button.setImage(image, for: .normal)
        button.tintColor = article.isBookmarked() ? UIColor.red : UIColor.gray
        button.sizeToFit()
        
        button.removeTarget(self, action: #selector(bookmarkButtonClicked(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(bookmarkButtonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func bookmarkButtonClicked(_ button: UIButton) {
        let article = articles[button.tag]
        actionStore.dispatch(ToggleBookmarkAction(article: article))
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text ?? ""
        if (query.isEmpty) {
            return
        }
        
        queryString = query
        page = 1
        articles.removeAll()
        isFailedSearching = false
        
        actionStore.dispatch(ArticleSearchAction(query: queryString, page: page))
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchBar.resignFirstResponder()
    }
}

