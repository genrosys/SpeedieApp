//
//  HomeVC.swift
//  Speedie
//
//  Created by Sierra on 2/2/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SkyFloatingLabelTextField
import Alamofire
class HomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,GMSMapViewDelegate,UITextFieldDelegate,GMSAutocompleteViewControllerDelegate {

    @IBOutlet var menuView: UIView!
    @IBOutlet var tableOut: UITableView!
    @IBOutlet var m_ProfileImg: UIImageView!
    @IBOutlet var M_UserNameLab: UILabel!
    
    @IBOutlet var shadowViewOut: UIView!
    @IBOutlet var menuBtnOut: UIButton!
    @IBOutlet var picUpLocTF: SkyFloatingLabelTextField!
    @IBOutlet var dropLocTF: SkyFloatingLabelTextField!
    
    @IBOutlet var PtickImg: UIImageView!
    @IBOutlet var DtickImg: UIImageView!
    
    @IBOutlet var mapViewOut: GMSMapView!
    
    @IBOutlet var bikerB_ViewOut: UIView!
    @IBOutlet var bottomConstraintsOut: NSLayoutConstraint!
    
    var toggleVal = Bool()
    var centerMapCoordinate:CLLocationCoordinate2D!
    //var marker:GMSMarker!
    var trackTF = Bool()
    
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!

    var menuItems = [
         ["name": "Home", "image": "homeImg"]
        , ["name": "History", "image": "historyImg"]
        , ["name": "Payment", "image": "creditCardImg"]
        , ["name": "Custom Delivery", "image": "callServiceImg"]
        , ["name": "Promotions", "image": "promotionImg"]
        , ["name": "Notifications", "image": "notificationImg"]
        , ["name": "About Us", "image": "aboutUSimg"]
        , ["name": "FAQ", "image": "faqImg"]
        , ["name": "Settings", "image": "settingImg"]
        
    ]
    var bikerLiveLocationsAry = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    ////     self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        m_ProfileImg.layer.cornerRadius = m_ProfileImg.frame.size.width/2
        m_ProfileImg.layer.borderWidth = 3
        m_ProfileImg.layer.borderColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        m_ProfileImg.clipsToBounds = true
        
        let userDetails = Store().getUserCredentials()
        print("userDetails========\(userDetails)")
     //   let usrlStr = userDetails.value(forKey: "custimageurl") as! String
       // let url = URL(string: usrlStr)
        //m_ProfileImg.sd_setImage(with: url, placeholderImage: UIImage(named: "dummyProfileImg"))
        M_UserNameLab.text = userDetails.value(forKey: "firstname") as? String
        mapViewOut.delegate = self
        mapViewOut.isMyLocationEnabled = true
        mapViewOut.mapType = .normal
        let fancy = GMSCameraPosition.camera(withLatitude: 30.709577,
                                             longitude: 76.688676,
                                             zoom: 12,
                                             bearing: 270,
                                             viewingAngle: 0)
        mapViewOut.camera = fancy

       
//     drawanimatedPathStoD()
   //     print("Driver Data ------------\(bikerDataAry)")
          NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinning(_:)), name: NSNotification.Name(rawValue: "notificationForBikerdetails"), object: nil)
      
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        

    }
    @objc func showSpinning(_ notification: NSNotification) {
        
        showBikerOnMap()
        //For animation of Bikes
        for i in 0..<allBikerOldCordinates.count{
            let marker = GMSMarker()
            let oldCoodinate: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(Double((allBikerOldCordinates[i] as AnyObject).value(forKey: "latitude") as! String)! ,Double((allBikerOldCordinates[i] as AnyObject).value(forKey: "longitude") as! String)!)
            let newCoodinate: CLLocationCoordinate2D? = CLLocationCoordinate2DMake(Double((allBikerCordinates[i] as AnyObject).value(forKey: "latitude") as! String)! ,Double((allBikerCordinates[i] as AnyObject).value(forKey: "longitude") as! String)!)
            marker.groundAnchor =  CGPoint(x: 0.5, y: 0.5)
            marker.rotation = CLLocationDegrees(getHeadingForDirection(fromCoordinate: oldCoodinate!, toCoordinate: newCoodinate!))
            //found bearing value by calculation when marker add
            marker.position = oldCoodinate!
            //this can be old position to make car movement to new position
            marker.map = mapViewOut
            //marker movement animation
            CATransaction.begin()
            CATransaction.setValue(Int(2.0), forKey: kCATransactionAnimationDuration)
            CATransaction.setCompletionBlock({() -> Void in
                //  self.marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                marker.rotation = CLLocationDegrees(self.getHeadingForDirection(fromCoordinate: oldCoodinate!, toCoordinate: newCoodinate!))
                //0.2//CDouble(bikerDataAry.value(forKey: "bearing"))
                //New bearing value from backend after car movement is done
            })
            marker.position = newCoodinate!
            //this can be new position after car moved from old position to new position with animation
            marker.map = mapViewOut
            //   marker.groundAnchor = CGPoint(x: CGFloat(0.5), y: CGFloat(0.5))
            marker.rotation = CLLocationDegrees(getHeadingForDirection(fromCoordinate: oldCoodinate!, toCoordinate: newCoodinate!))
            //found bearing value by calculation
            CATransaction.commit()
        }
  
        
        //
    }
    func showBikerOnMap(){
  //      mapViewOut.clear()
        var bounds = GMSCoordinateBounds()  //Max Zoom b/w all markers
 /*       print("bikerDataAry.count----------\(bikerDataAry.count)")
        let marker = GMSMarker()
        let lati = Double((bikerDataAry as AnyObject) .value(forKey: "latitude") as! String)
        let longi = Double((bikerDataAry as AnyObject) .value(forKey: "longitude") as! String)

        marker.position = CLLocationCoordinate2D(latitude: lati!, longitude: longi!
        )
        marker.icon = #imageLiteral(resourceName: "biker_marker")
        bounds = bounds.includingCoordinate(marker.position)  //Max Zoom b/w all markers
        marker.map = mapViewOut
*/
        for i in 0..<allBikerCordinates.count {
            let marker = GMSMarker()
            
            marker.position = CLLocationCoordinate2D(latitude: Double((allBikerCordinates [i] as AnyObject).value(forKey: "latitude") as! String )!, longitude: Double((allBikerCordinates[i] as AnyObject).value(forKey: "longitude") as! String)!)
            if (allBikerCordinates[i] as AnyObject).value(forKey: "driverStatus") as! String == "a"{
                 marker.icon = #imageLiteral(resourceName: "biker_marker")
            }else{
            marker.icon = nil
            }
          
         //   marker.iconView = customViewInfo
            bounds = bounds.includingCoordinate(marker.position)  //Max Zoom b/w all markers
            //  gmsMapViewOut .selectedMarker = marker
            
            marker.map = mapViewOut
        }
 
    }
    //MARK:- TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField){
        if textField.tag ==  100{
            tick_P()
            trackTF = false
            self.view.endEditing(true)
            
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.autocompleteFilter?.country = "IND"
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }else if textField.tag == 200{
           trackTF = true
            tick_D()
            self.view.endEditing(true)
            
            let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.autocompleteFilter?.country = "IND"
            autocompleteController.delegate = self
            present(autocompleteController, animated: true, completion: nil)
        }
        
    }
    //MARK:- GMS Map delegates
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if trackTF == false{
            let latitude = mapView.camera.target.latitude
            let longitude = mapView.camera.target.longitude
            centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
           // print("centerMapCoordinate----Pick-----\(centerMapCoordinate)")
            reverseGeocodeCoordinate(coordinate: centerMapCoordinate)
        }else if trackTF == true{
            let latitude = mapView.camera.target.latitude
            let longitude = mapView.camera.target.longitude
            centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
           // print("centerMapCoordinate-----Drop----\(centerMapCoordinate)")
            reverseGeocodeCoordinate(coordinate: centerMapCoordinate)
           
        }
        
    }
    //MARK:- Convert Lat-Long to Address
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let address = response?.firstResult() {
                let lines = address.lines!
                if self.trackTF == false{
                    self.picUpLocTF.text = lines.joined(separator: "\n")
                    self.tick_P()
                    
                }else if self.trackTF == true{
                    self.dropLocTF.text = lines.joined(separator: "\n")
                    self.tick_P()
                    self.bikerB_ViewOut.isHidden = false
                }
            }
        }
    }
    
    // MARK:- Here we draw animated route path from source to destination
    func drawanimatedPathStoD()
    {
        let originn = "\(30.709577),\(76.688676)"
        let destinationn = "\(30.733315),\(76.779418)"
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 30.733315, longitude: 76.779418)
        //marker.title = "Sydney"
        //   marker.snippet = "Australia"
        marker.map = mapViewOut
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originn)&destination=\(destinationn)&mode=driving"
        
        Alamofire.request(url, method: .post, parameters: nil,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success:
                //print("response==============\(response)")
                if let data = response.result.value as? NSDictionary
                {
                    // print(response.result.value as Any)
                    // print(data)
                    
                    let dict = data
                    //  print("dict-------------\(dict)")
                    self.drawRoute(routeDict: dict as! Dictionary<String, Any>)
                    
                }
                break
            case .failure(let error):
                
                print(error)
            }
        }
        
    }
    func drawRoute(routeDict: Dictionary<String, Any>) {
        let routesArray = routeDict ["routes"] as! NSArray
        if (routesArray.count > 0)
        {
            let routeDict = routesArray[0] as! Dictionary<String, Any>
            let routeOverviewPolyline = routeDict["overview_polyline"] as! Dictionary<String, Any>
            let points = routeOverviewPolyline["points"]
            self.path = GMSPath.init(fromEncodedPath: points as! String)!
            
            self.polyline.path = path
            self.polyline.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            self.polyline.strokeWidth = 3.0
            self.polyline.map = self.mapViewOut
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.008, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
        }
    }
    
    @objc func animatePolylinePath() {
        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.black
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapViewOut
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
        }
    }
    

    @IBAction func menuBtnAct(_ sender: Any) {
       menuMethod()
    }
    
    
    @IBAction func hideMenuBtnAct(_ sender: Any) {
        menuMethod()
    }
    
    func menuMethod(){
        if toggleVal == false{
            self.menuBtnOut.isHidden = true
            UIView.animate(withDuration: 0.4) {
                self.menuView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                self.view.bringSubview(toFront: self.menuView)
                
            }
            toggleVal = true
        }else{
            UIView.animate(withDuration: 0.4) {
                
                self.menuView.frame = CGRect(x: -380, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                
                
                
            }
            self.menuBtnOut.isHidden = false
            toggleVal = false
        }
    }
    
    @IBAction func viewPrifileBtnAct(_ sender: Any) {
        let EditProfileVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(EditProfileVCobjct, animated: true)
    }
    
    //MARK:- tableView datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return menuItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableOut.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuTable_Cell
        cell.imgOut.image = UIImage(named: ((menuItems [indexPath.row] as AnyObject).value(forKey: "image") as? String)!)!
        cell.nameLab.text = (menuItems[indexPath.row] as AnyObject).value(forKey: "name") as? String
        return cell
        
    }
    //MARK:- tableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
           menuMethod()
        }else if indexPath.row == 1{
            menuMethod()
            let HistoryMainVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "HistoryMainVC") as! HistoryMainVC
            self.navigationController?.pushViewController(HistoryMainVCobjct, animated: true)
            
        }else if indexPath.row == 2{
            menuMethod()
            let PaymentVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            self.navigationController?.pushViewController(PaymentVCobjct, animated: true)
        }else if indexPath.row == 3{
            menuMethod()
            let CustomDeliveryMainVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "CustomDeliveryMainVC") as! CustomDeliveryMainVC
            self.navigationController?.pushViewController(CustomDeliveryMainVCobjct, animated: true)
        }else if indexPath.row == 4{
            menuMethod()
            let PromotionsVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "PromotionsVC") as! PromotionsVC
            self.navigationController?.pushViewController(PromotionsVCobjct, animated: true)
        }else if indexPath.row == 5{
            menuMethod()
            print("Clicked----5")
        }else if indexPath.row == 6{
            menuMethod()
            let AboutUsVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsVC") as! AboutUsVC
            self.navigationController?.pushViewController(AboutUsVCobjct, animated: true)
        }else if indexPath.row == 7{
            menuMethod()
            let FaqVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "FaqVC") as! FaqVC
            self.navigationController?.pushViewController(FaqVCobjct, animated: true)
        }else if indexPath.row == 8{
            menuMethod()
            let AccountSettingVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "AccountSettingVC") as! AccountSettingVC
            self.navigationController?.pushViewController(AccountSettingVCobjct, animated: true)
        }
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0.1
    }
    //MARK:- ACTIONS
    func tick_P(){
        self.PtickImg.isHidden = false
        self.DtickImg.isHidden = true
    }
    func tick_D(){
        self.PtickImg.isHidden =  true
        self.DtickImg.isHidden = false
    }
    
    //Mark:- Google places AutoComplete
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
      //  print("Place address: \(place.formattedAddress)")
        let addressStr = String(format: "%@",place.formattedAddress!)
        print("addressStr========\(addressStr)")
       if self.trackTF == false{
            self.picUpLocTF.text = addressStr
            self.tick_P()
        }else if self.trackTF == true{
            self.dropLocTF.text = addressStr
            self.tick_D()
            self.bikerB_ViewOut.isHidden = false
        }
        
    //    print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    @IBAction func speedieNormalBtnAct(_ sender: Any) {
    //   self.alertMethod(Title: "Alert", Message: "Work InProgress")

        let DeliveryDetailsVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryDetailsVC") as! DeliveryDetailsVC
        self.navigationController?.pushViewController(DeliveryDetailsVCobjct, animated: true)
    }
    
    @IBAction func speediePriorityBtnAct(_ sender: Any) {
    //    self.alertMethod(Title: "Alert", Message: "Work InProgress")
        let DeliveryDetailsVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryDetailsVC") as! DeliveryDetailsVC
        self.navigationController?.pushViewController(DeliveryDetailsVCobjct, animated: true)
    }
    
    //s
    func getHeadingForDirection(fromCoordinate fromLoc: CLLocationCoordinate2D, toCoordinate toLoc: CLLocationCoordinate2D) -> Float {
        
        let fLat: Float = Float((fromLoc.latitude).degreesToRadians)
        let fLng: Float = Float((fromLoc.longitude).degreesToRadians)
        let tLat: Float = Float((toLoc.latitude).degreesToRadians)
        let tLng: Float = Float((toLoc.longitude).degreesToRadians)
        let degree: Float = (atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))).radiansToDegrees
        if degree >= 0 {
            return degree
        }
        else {
            return 360 + degree
        }
    }
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

