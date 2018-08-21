//
//  AppDelegate.swift
//  Speedie
//
//  Created by MAC on 08/01/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import CoreLocation
import GoogleMaps
import GooglePlaces
import PubNub // <- Here is our PubNub module import.

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,PNObjectEventListener {

    var window: UIWindow?
    var client: PubNub!

      var locationManager: CLLocationManager!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        sleep(3)
        // Override point for customization after application launch.
        //    IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowTextFieldPlaceholder = false
        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysShow
        
        GMSServices.provideAPIKey("AIzaSyB5FUuLmbBkQpHXNnk7HxyoY-i_btuT_bs")
        GMSPlacesClient.provideAPIKey("AIzaSyB5FUuLmbBkQpHXNnk7HxyoY-i_btuT_bs")
        
        // Initialize and configure PubNub client instance
        let configuration = PNConfiguration(publishKey: "pub-c-58904805-9a59-412e-b05b-0b7eb441de86", subscribeKey: "sub-c-563f1070-04ba-11e8-91aa-36923a88c219")
        self.client = PubNub.clientWithConfiguration(configuration)
        self.client.addListener(self)
        // Subscribe to demo channel with presence observation
        self.client.subscribeToChannels(["navneet"], withPresence: true)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore
        {
            print("Not first launch.")
            
            if  UserDefaults.standard.bool(forKey: "keepLoginvalCustmer") == true {
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let HomeVCobjct = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
               // let HomeVCobjct = mainStoryboard.instantiateViewController(withIdentifier: "DeliveryDetailsVC") as! DeliveryDetailsVC
                let navigationController = UINavigationController(rootViewController: HomeVCobjct)
                navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
                window!.rootViewController = navigationController
                
            }else{
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "PhoneNavVC") as! PhoneNavVC
                window!.rootViewController = homeViewController
                
            }
        }
        else
        {
            print("First launch")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "IntroNavVC") as!
            IntroNavVC
            window!.rootViewController = homeViewController
        }
         determineMyCurrentLocation()
        return true
    }
    //MARK:- For location
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        let currentLat: String = String(userLocation.coordinate.latitude)
        let CurrentLong: String =  String(userLocation.coordinate.longitude)
        print("userCurrentLat:- \(currentLat) userCurrentlong:- \(CurrentLong)")
  //      UserDefaults.standard.set(userLocation.coordinate.latitude, forKey: "currentLatVal")
   //     UserDefaults.standard.set(userLocation.coordinate.longitude, forKey: "currentLongval")
        UserDefaults.standard.set(currentLat, forKey: "currentLatVal")
        UserDefaults.standard.set(CurrentLong, forKey: "currentLongval")
        UserDefaults.standard.synchronize()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
        let alert = UIAlertController(title:"Alert", message: error as? String, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        // show the alert
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    //MARK:- PUBNUB DELEGATES
    // Handle new message from one of channels on which client has been subscribed.
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.channel != message.data.subscription {
            
            // Message has been received on channel group stored in message.data.subscription.
            print("WORKING-----NOT")
        }
        else {
            print("WORKING-----")
            // Message has been received on channel stored in message.data.channel.
        }
        
        
        print("Received message: \(message.data.message) on channel \(message.data.channel) " +
            "at \(message.data.timetoken)")
     
        let bikerAry = message.data.message as! String
        print("bikerAry-----------\(bikerAry)")

        let jsonData = bikerAry.data(using: .utf8)
        var dic: [String : Any]?
        do {
            dic = try JSONSerialization.jsonObject(with: jsonData!, options: []) as? [String : Any]
             print("THE DICT IS====\(dic!)")
            bikerDataAry = dic! as NSDictionary
            if bikerDataAry.value(forKey: "driverStatus") as! String == "a"{
                if allBikerCordinates.count > 0{
                    var valueID:String = String()
                    valueID = "\(bikerDataAry.value(forKey: "biker_id")!)"
                    print("allBikerCordinates.count----------\(allBikerCordinates.count)")
                    for i in 0..<allBikerCordinates.count {
                        
                        let dict:NSDictionary = allBikerCordinates.object(at: i)as! NSDictionary
                        
                        if dict.value(forKey: "biker_id")as! String == valueID
                        {
                            
                            allBikerOldCordinates = allBikerCordinates
                            allBikerCordinates.replaceObject(at: i, with: dict)
                            
                            if allBikerCordinates.count > 20{
                                
                                allBikerCordinates.removeAllObjects()
                                
                            }
                            
                        }else{
                            allBikerCordinates.add(dic! as NSDictionary)
                            allBikerOldCordinates = allBikerCordinates
                            
                        }
                    }
                }
                else {
                    allBikerCordinates.add(dic! as NSDictionary)
                }
            }
            else{
                if allBikerCordinates.contains(dic! as NSDictionary){
                    allBikerCordinates.remove(dic! as NSDictionary)

                }
            }
            
        let datat:[String: String] = ["image": "fghjk"]
    // post a notification
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationForBikerdetails"), object: nil, userInfo: datat)
        }catch {
            print("error========\(error.localizedDescription)")
        }
   
    }
    // New presence event handling.
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        
        // Handle presence event event.data.presenceEvent (one of: join, leave, timeout, state-change).
        if event.data.channel != event.data.subscription {
            
            // Presence event has been received on channel group stored in event.data.subscription.
        }
        else {
            
            // Presence event has been received on channel stored in event.data.channel.
        }
        
        if event.data.presenceEvent != "state-change" {
            
            print("\(event.data.presence.uuid) \"\(event.data.presenceEvent)'ed\"\n" +
                "at: \(event.data.presence.timetoken) on \(event.data.channel) " +
                "(Occupancy: \(event.data.presence.occupancy))");
        }
        else {
            
            print("\(event.data.presence.uuid) changed state at: " +
                "\(event.data.presence.timetoken) on \(event.data.channel) to:\n" +
                "\(event.data.presence.state)");
        }
    }
    
    // Handle subscription status change.
    func client(_ client: PubNub, didReceive status: PNStatus) {
        
        if status.operation == .subscribeOperation {
            
            // Check whether received information about successful subscription or restore.
            if status.category == .PNConnectedCategory || status.category == .PNReconnectedCategory {
                
                let subscribeStatus: PNSubscribeStatus = status as! PNSubscribeStatus
                if subscribeStatus.category == .PNConnectedCategory {
                    
                    // This is expected for a subscribe, this means there is no error or issue whatsoever.
                    
                    // Select last object from list of channels and send message to it.
                    let targetChannel = client.channels().last!
                    client.publish("Hello from the PubNub Swift SDK", toChannel: targetChannel,
                                   compressed: false, withCompletion: { (publishStatus) -> Void in
                                    
                                    if !publishStatus.isError {
                                        
                                        // Message successfully published to specified channel.
                                    }
                                    else {
                                        
                                        /**
                                         Handle message publish error. Check 'category' property to find out
                                         possible reason because of which request did fail.
                                         Review 'errorData' property (which has PNErrorData data type) of status
                                         object to get additional information about issue.
                                         
                                         Request can be resent using: publishStatus.retry()
                                         */
                                    }
                    })
                }
                else {
                    
                    /**
                     This usually occurs if subscribe temporarily fails but reconnects. This means there was
                     an error but there is no longer any issue.
                     */
                }
            }
            else if status.category == .PNUnexpectedDisconnectCategory {
                
                /**
                 This is usually an issue with the internet connection, this is an error, handle
                 appropriately retry will be called automatically.
                 */
            }
                // Looks like some kind of issues happened while client tried to subscribe or disconnected from
                // network.
            else {
                
                let errorStatus: PNErrorStatus = status as! PNErrorStatus
                if errorStatus.category == .PNAccessDeniedCategory {
                    
                    /**
                     This means that PAM does allow this client to subscribe to this channel and channel group
                     configuration. This is another explicit error.
                     */
                }
                else {
                    
                    /**
                     More errors can be directly specified by creating explicit cases for other error categories
                     of `PNStatusCategory` such as: `PNDecryptionErrorCategory`,
                     `PNMalformedFilterExpressionCategory`, `PNMalformedResponseCategory`, `PNTimeoutCategory`
                     or `PNNetworkIssuesCategory`
                     */
                }
            }
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Speedie")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

