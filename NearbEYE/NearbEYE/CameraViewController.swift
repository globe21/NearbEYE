//
//  ViewController.swift
//  NearbEYE
//
//  Created by Stephen Melinyshyn on 2015-10-24.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource  {

    let minimumHeadingChangeForRefresh = 60.0
    let minimumDistanceChangeForRefresh = 15.0
    var context : NSManagedObjectContext!
    var locationManager : CLLocationManager!
    var lastHeading : CLHeading!
    var lastLocation : CLLocation!
    var cameraOverlay : CameraOverlayView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if (status == CLAuthorizationStatus.Denied || status == CLAuthorizationStatus.NotDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
        
        if (cameraOverlay == nil) {
            let cameraView = UIImagePickerController()
            let screenSize = UIScreen.mainScreen().bounds.size
            cameraView.sourceType = UIImagePickerControllerSourceType.Camera
            cameraView.delegate = self
            cameraView.showsCameraControls = false
            cameraView.cameraViewTransform = CGAffineTransformTranslate(CGAffineTransformMakeScale(4.2/3.0, 4.2/3.0), 0, screenSize.height / 10.0)
            
            cameraOverlay = CameraOverlayView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height * 2), vc: self)
            cameraView.cameraOverlayView = cameraOverlay
            
            
            self.presentViewController(cameraView, animated: true, completion: nil)
        }
        
        
        
		// Do any additional setup after loading the view, typically from a nib.
	}
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func presentDetailViewControllerForAttraction(attraction: AnyObject?) {
        //TODO implement this
        stopHeadingAndLocation()
    }
    
    //#MARK: locationManager
    
    func startHeadingAndLocation() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
            lastHeading = locationManager.heading
            lastLocation = locationManager.location
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopHeadingAndLocation() {
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.stopUpdatingHeading()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print(status.rawValue)
        if (status == CLAuthorizationStatus.AuthorizedWhenInUse) {
            startHeadingAndLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if (lastHeading == nil) {
            lastHeading = newHeading
        }
        else if (fabs(newHeading.magneticHeading - lastHeading.magneticHeading) >= minimumHeadingChangeForRefresh) {
            lastHeading = newHeading
            cameraOverlay.refreshAttractions()
            print(lastHeading)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if (lastLocation == nil) {
            lastLocation = newLocation
        }
        else if (newLocation.distanceFromLocation(lastLocation) >= minimumDistanceChangeForRefresh) {
            lastLocation = newLocation
            cameraOverlay.refreshAttractions()
            print(lastLocation)
        }
    }
    
    //#MARK: tableView
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //TODO implement stephen's methods
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //TODO implement stephen's methods
        if let cell = tableView.dequeueReusableCellWithIdentifier("attraction") {
            cell.textLabel?.text = "Generic Attraction"
            cell.detailTextLabel?.text = "Prototype Content"
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "attraction")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        presentDetailViewControllerForAttraction(nil)
        //TODO segue to detail vc
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
        //TODO implement stephen's methods
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
    }

}

