//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
import MBProgressHUD

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UIScrollViewDelegate {

    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 0, 00))
    
    var locationManager:CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved = false
    
    var lat = 37.785771
    var lon = -122.406165
    var isMoreDataLoading = false
    
    var loadingMoreView:InfiniteScrollActivityView?
    
    var searchText = "Thai"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 90
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        searchBar.delegate = self
        
        searchBar.placeholder = "Search..."
        self.navigationItem.titleView = searchBar
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        self.loadingMoreView = InfiniteScrollActivityView(frame: frame)
        self.loadingMoreView!.hidden = true
        tableView.addSubview(self.loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
//        isMoreDataLoading = true
        let _ = MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
//        loadData(false)
        

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }
    
    @IBAction func onTap(sender: AnyObject) {
        searchBar.endEditing(false)
    }
    
    func loadData(append: Bool) {
        var offset = 0
        if(append) {
            offset = businesses.count
        }
        self.isMoreDataLoading = true
        Business.searchWithTerm(searchText, offset: offset, lat: lat, lon: lon, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.isMoreDataLoading = false
            if append {
                self.businesses! += businesses
            }
            else {
                self.businesses = businesses
            }

            self.tableView.reloadData()
            MBProgressHUD.hideAllHUDsForView(self.tableView, animated: true)
        })
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            lat = coord.latitude
            lon = coord.longitude
            
            locationManager.stopUpdatingLocation()
            loadData(false)
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        loadData(false)
        locationManager.stopUpdatingLocation()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath : indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
//                self.businesses = businesses
//                self.tableView.reloadData()
//            })
//
//        }
//        else {
//            Business.searchWithTerm(searchText, completion: { (businesses: [Business]!, error: NSError!) -> Void in
//                self.businesses = businesses
//                self.tableView.reloadData()
//            })
//        }
//
//    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(false)
        if searchBar.text!.isEmpty {
            searchText = "Thai"
            
        }
        else {
            searchText = searchBar.text!
        }
        loadData(false)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if(!isMoreDataLoading){
            //            isMoreDataLoading = true
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                //                isMoreDataLoading = true
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                loadData(true)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
