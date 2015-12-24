//
//  ViewController.swift
//  LocationLocker
//
//  Created by Jay Ravaliya on 12/23/15.
//  Copyright © 2015 JRav. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    /* UI Elements */
    var tableView : UITableView!
    var segmentedControl : UISegmentedControl!
    var addElementBarButtonItem : UIBarButtonItem!
    var noLocationsLabel : UILabel!
    
    /* Variables */
    var locationLocker : AnyObject!
    var locationWishlist : AnyObject!
    var currentData : NSMutableArray!
    
    /* Location Manager */
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        /* Locker vs Wishlist SegmentedControl */
        segmentedControl = UISegmentedControl(items: ["Locker","Wishlist"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.frame = CGRect(x: Standard.screenWidth / 2 - 75, y: (self.navigationController?.navigationBar.frame.size.height)!/2 - 14, width: 150, height: 28)
        segmentedControl.addTarget(self, action: "segmentedControlSelection:", forControlEvents: UIControlEvents.ValueChanged)
        self.navigationController?.navigationBar.addSubview(segmentedControl)
        
        /* Add Element Bar Button Item */
        addElementBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addElement:")
        self.navigationItem.rightBarButtonItem = addElementBarButtonItem
        
        /* TableView */
        tableView = UITableView(frame: self.view.frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        /* Location */
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        /* No locations label */
        noLocationsLabel = UILabel(frame: CGRect(x: 0, y: Standard.screenHeight/2-20, width: Standard.screenWidth, height: 40))
        noLocationsLabel.text = "No locations yet - add some!"
        noLocationsLabel.textAlignment = NSTextAlignment.Center
        
        /* Get all locations */
        self.returnLocations()
        self.currentData = self.locationLocker as! NSMutableArray
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.returnLocations()
        self.tableView.reloadData()
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
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.deleteLocation(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    func addElement(sender : UIButton) {
        let addLocationVC : AddLocation = AddLocation()
        addLocationVC.latitude = locationManager.location?.coordinate.latitude
        addLocationVC.longitude = locationManager.location?.coordinate.longitude
        let addLocationNavigationVC : UINavigationController = UINavigationController(rootViewController: addLocationVC)
        self.presentViewController(addLocationNavigationVC, animated: true) { () -> Void in
            
        }
    }
    
    func returnLocations() {
        self.locationLocker = NSUserDefaults.standardUserDefaults().objectForKey("locker")
        self.locationWishlist = NSUserDefaults.standardUserDefaults().objectForKey("wishlist")
        
        if self.locationLocker == nil {
            self.locationLocker = NSMutableArray(array: [])
            NSUserDefaults.standardUserDefaults().setObject(self.locationLocker, forKey: "locker")
        }
        
        if self.locationWishlist == nil {
            self.locationWishlist = NSMutableArray(array: [])
            NSUserDefaults.standardUserDefaults().setObject(self.locationWishlist, forKey: "wishlist")
        }
        
        self.setCurrentData()
        
    }
    
    func segmentedControlSelection(segment : UISegmentedControl) {
        self.setCurrentData()
        self.tableView.reloadData()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // print(locations)
    }
    
    func setCurrentData() {
        if(segmentedControl.selectedSegmentIndex == 0) {
            currentData = self.locationLocker as! NSMutableArray
        }
        else {
            currentData = self.locationWishlist as! NSMutableArray
        }
        if(currentData.count == 0) {
            self.tableView.alpha = 0
            self.view.addSubview(noLocationsLabel)
        }
        else {
            self.tableView.alpha = 1
            noLocationsLabel.removeFromSuperview()
        }
    }
    
    func deleteLocation(row : Int) {
        
        let key : String!
        if segmentedControl.selectedSegmentIndex == 0 {
            key = "locker"
        }
        else {
            key = "wishlist"
        }
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var arr = userDefaults.objectForKey(key)?.mutableCopy() as! NSMutableArray
        
        arr.removeObjectAtIndex(row)
        
        if(arr.count == 0) {
            userDefaults.removeObjectForKey(key)
        }
        else {
            userDefaults.setObject(arr, forKey: key)
        }
        
        self.returnLocations()
        
    }
}

