//
//  ViewController.swift
//  LocationLocker
//
//  Created by Jay Ravaliya on 12/23/15.
//  Copyright © 2015 JRav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    /* UI Elements */
    var tableView : UITableView!
    var segmentedControl : UISegmentedControl!
    var addElementBarButtonItem : UIBarButtonItem!
    
    /* Variables */
    var locationLocker : AnyObject!
    var locationWishlist : AnyObject!
    var currentData : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Locker vs Wishlist SegmentedControl */
        segmentedControl = UISegmentedControl(items: ["Locker","Wishlist"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.frame = CGRect(x: Standard.screenWidth / 2 - 75, y: (self.navigationController?.navigationBar.frame.size.height)!/2 - 14, width: 150, height: 28)
        segmentedControl.addTarget(self, action: "segmentedControlSelection:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationController?.navigationBar.addSubview(segmentedControl)
        
        /* Add Element Bar Button Item */
        addElementBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addElement:")
        self.navigationItem.rightBarButtonItem = addElementBarButtonItem
        
        /* Get all locations */
        self.returnLocations()
        self.currentData = self.locationLocker as! NSArray
        if(currentData.count == 0) {
            currentData = ["No locations yet - add something!"]
        }
        
        /* TableView */
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell.textLabel?.text = String(currentData[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }

    func addElement(sender : UIButton) {
        let addLocationVC : AddLocation = AddLocation()
        let addLocationNavigationVC : UINavigationController = UINavigationController(rootViewController: addLocationVC)
        self.presentViewController(addLocationNavigationVC, animated: true) { () -> Void in
            
        }
    }
    
    func returnLocations() {
        self.locationLocker = NSUserDefaults.standardUserDefaults().objectForKey("locker")
        self.locationWishlist = NSUserDefaults.standardUserDefaults().objectForKey("wishlist")
        
        if self.locationLocker == nil {
            self.locationLocker = []
            NSUserDefaults.standardUserDefaults().setObject([], forKey: "locker")
        }
        
        if self.locationWishlist == nil {
            self.locationWishlist = []
            NSUserDefaults.standardUserDefaults().setObject([], forKey: "wishlist")
        }
        
    }
    
    func segmentedControlSelection(segment : UISegmentedControl) {
        if(segment.selectedSegmentIndex == 0) {
            currentData = self.locationLocker as! NSArray
        }
        else {
            currentData = self.locationWishlist as! NSArray
        }
        if(currentData.count == 0) {
            currentData = ["No locations yet - add something!"]
        }
        self.tableView.reloadData()
    }
}

