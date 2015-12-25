//
//  AddLocation.swift
//  LocationLocker
//
//  Created by Jay Ravaliya on 12/23/15.
//  Copyright © 2015 JRav. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class AddLocation : UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    /* Location Coordinates */
    var latitude : CLLocationDegrees!
    var longitude : CLLocationDegrees!
    
    /* API Results */
    var api : API!
    var results : JSON!
    
    /* UI Elements */
    var alertController : UIAlertController!
    var tableView : UITableView!
    var searchController : UISearchController!
    var cancelBarButtonItem : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Location"
        
        results = []
        
        /* TableView */
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        /* Search Controller */
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Keyword"
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
        
        /* Cancel Button */
        cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "dismissAddLocationViewController:")
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
    }
    
    func dismissAddLocationViewController(sender : UIButton) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = self.results["results"][indexPath.row]["name"].stringValue
        cell.textLabel?.font = UIFont(name: "RobotoSlab-Regular", size: 20)
        
        cell.detailTextLabel?.text = self.results["results"][indexPath.row]["vicinity"].stringValue
        cell.detailTextLabel?.font = UIFont(name: "RobotoSlab-Light", size: 12)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.openAlertController(indexPath.row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results["results"].count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        api = API()
        api.checkIn(searchController.searchBar.text!, latitude: latitude, longitude: longitude) { (success, data) -> Void in
            
            if(success) {
                self.results = data
                self.tableView.reloadData()
            }
            else {
                // throw error
            }
            
        }
        
        searchController.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func addLocation(name : String, place_id : String, key : String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var arr = userDefaults.objectForKey(key)
        
        if(arr == nil) {
            arr = NSMutableArray()
        }
        else {
            arr = arr!.mutableCopy() as! NSMutableArray
        }
        
        arr!.addObject([name, place_id])
        userDefaults.setObject(arr, forKey: key)
        userDefaults.synchronize()
        print(NSUserDefaults.standardUserDefaults().objectForKey("locker"))
    }
    
    func openAlertController(row : Int) {
        /* Alert Controller */
        alertController = UIAlertController(title: "Add Location", message: "Add this location!", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        alertController.addAction(UIAlertAction(title: "Add to Locker", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.addLocation(self.results["results"][row]["name"].stringValue, place_id: self.results["results"][row]["place_id"].stringValue, key: "locker")
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Add to Wishlist", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            self.addLocation(self.results["results"][row]["name"].stringValue, place_id: self.results["results"][row]["place_id"].stringValue, key: "wishlist")
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            
        }))
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }

}
