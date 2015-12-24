//
//  AddLocation.swift
//  LocationLocker
//
//  Created by Jay Ravaliya on 12/23/15.
//  Copyright © 2015 JRav. All rights reserved.
//

import UIKit

class AddLocation : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var tableView : UITableView!
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Location"
        
        /* TableView */
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchController.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

}
