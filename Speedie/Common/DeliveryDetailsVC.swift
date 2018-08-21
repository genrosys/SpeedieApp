//
//  DeliveryDetailsVC.swift
//  Speedie
//
//  Created by MAC on 12/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire


class DeliveryDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var mapViewOut: GMSMapView!
    @IBOutlet weak var deatilView_out: UIView!
    
    let deliveryPicker = UIPickerView()
    let categoryPicker = UIPickerView()
    let weightPicker = UIPickerView()
    let sizePicker = UIPickerView()
    
    var DeliveryDataArr = ["Speedie", "Priority"]
    var categoryDataArr: [Dictionary<String, String>] = []
    var weightDataArr: [Dictionary<String, String>] = []
    var sizeDataArr: [Dictionary<String, String>] = []
    var TimePriceDataArr: [Dictionary<String, String>] = []
    
    var deliveryTF = UITextField()
    var CategoryTF = UITextField()
    var weightTF = UITextField()
    var sizeTF = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // dragView.viewBackgroundColor = UIColor.clear
        //dragView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        GetAllListData()
        
        deliveryPicker.delegate = self
        deliveryPicker.dataSource = self
        deliveryTF.inputView = deliveryPicker
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        CategoryTF.inputView = categoryPicker
        
        weightPicker.delegate = self
        weightPicker.dataSource = self
        weightTF.inputView = weightPicker
        
        sizePicker.delegate = self
        sizePicker.dataSource = self
        sizeTF.inputView = sizePicker

      }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        let  dragView = SDragView(dragViewAnimatedTopSpace:64, viewDefaultHeightConstant: (self.view.frame.size.height/2) + 100)

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: dragView.frame.size.width, height: dragView.frame.size.height + 100))
        scrollView.contentSize = dragView.bounds.size
        scrollView.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        scrollView.bringSubview(toFront: dragView)
        dragView.addSubview(scrollView)
        
        let image = UIImageView(frame: (CGRect(x: 10, y: 10, width: 300, height: 40)))
        image.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dragView.addSubview(image)
        
        // Delivery Type
        let deliveryType = UILabel(frame:(CGRect(x: 10, y: 60, width: 300, height: 25)))
        deliveryType.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        deliveryType.text = "Delivery Type"
        deliveryType.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(deliveryType)
        
        let deliveryView = UIView(frame:(CGRect(x: 10, y: 85, width: 300, height: 34)))
        deliveryView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        deliveryView.layer.shadowRadius = 3.0
        deliveryView.layer.shadowOpacity = 1.0
        deliveryView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        deliveryView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        scrollView.addSubview(deliveryView)

        deliveryTF = UITextField(frame:(CGRect(x: 10, y: 0, width: 230, height: 30)))
        deliveryTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        deliveryTF.attributedPlaceholder = NSAttributedString(string: "Select Delivery type",
                                                              attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        deliveryTF.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        deliveryTF.font = deliveryTF.font?.withSize(13.0)
        deliveryView.addSubview(deliveryTF)
        
        let deliDownBtn = UIButton(frame: CGRect(x: 270, y: 0, width: 30, height: 30))
        deliDownBtn.setImage(UIImage(), for: .normal)
        let btnImage = UIImage(named: "dropDown")
        deliDownBtn.setImage(btnImage, for: .normal)
        deliDownBtn.addTarget(self, action: #selector(DeliveryDetailsVC.DropDownBtnAction), for: .touchUpInside)
        deliveryView.addSubview(deliDownBtn)
        
        let delPrice = UILabel(frame:(CGRect(x: 20, y: 117, width: 150, height: 25)))
        delPrice.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        delPrice.text = "N55/1KM"
        delPrice.textAlignment = .left
        delPrice.font = UIFont.boldSystemFont(ofSize: 10.0)
        scrollView.addSubview(delPrice)
        
        let delTime = UILabel(frame:(CGRect(x: 155, y: 117, width: 150, height: 25)))
        delTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        delTime.text = "4 Hours Delivery Time"
        delTime.textAlignment = .right
        delTime.font = UIFont.boldSystemFont(ofSize: 10.0)
        scrollView.addSubview(delTime)
        
        // Category Type
        let CategoryType = UILabel(frame:(CGRect(x: 10, y: 140, width: 300, height: 25)))
        CategoryType.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        CategoryType.text = "Category"
        CategoryType.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(CategoryType)
        
        let CategoryView = UIView(frame:(CGRect(x: 10, y: 165, width: 300, height: 34)))
        CategoryView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        CategoryView.layer.shadowRadius = 3.0
        CategoryView.layer.shadowOpacity = 1.0
        CategoryView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        CategoryView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        scrollView.addSubview(CategoryView)
        
        CategoryTF = UITextField(frame:(CGRect(x: 10, y: 0, width: 250, height: 30)))
        CategoryTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        CategoryTF.attributedPlaceholder = NSAttributedString(string: "Choose Category",
                     attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        CategoryTF.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        CategoryTF.font = deliveryTF.font?.withSize(13.0)
        CategoryView.addSubview(CategoryTF)
        
        let cateDownBtn = UIButton(frame: CGRect(x: 270, y: 0, width: 30, height: 30))
        cateDownBtn.setImage(UIImage(), for: .normal)
        let btnImage1 = UIImage(named: "dropDown")
        cateDownBtn.setImage(btnImage1, for: .normal)
        cateDownBtn.addTarget(self, action: #selector(DeliveryDetailsVC.DropDownBtnAction), for: .touchUpInside)
        CategoryView.addSubview(cateDownBtn)
        
        // weight Type
        let weightType = UILabel(frame:(CGRect(x: 10, y: 205, width: 300, height: 25)))
        weightType.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        weightType.text = "Weight(In Kg)"
        weightType.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(weightType)
        
        let weightView = UIView(frame:(CGRect(x: 10, y: 230, width: 300, height: 34)))
        weightView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        weightView.layer.shadowRadius = 3.0
        weightView.layer.shadowOpacity = 1.0
        weightView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        weightView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        scrollView.addSubview(weightView)
        
        weightTF = UITextField(frame:(CGRect(x: 10, y: 0, width: 250, height: 30)))
        weightTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        weightTF.attributedPlaceholder = NSAttributedString(string: "Choose Weight(In Kg)",
                                                              attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        weightTF.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        weightTF.font = deliveryTF.font?.withSize(13.0)
        weightView.addSubview(weightTF)
        
        let wtDownBtn = UIButton(frame: CGRect(x: 270, y: 0, width: 30, height: 30))
        wtDownBtn.setImage(UIImage(), for: .normal)
        let btnImage2 = UIImage(named: "dropDown")
        wtDownBtn.setImage(btnImage2, for: .normal)
        wtDownBtn.addTarget(self, action: #selector(DeliveryDetailsVC.DropDownBtnAction), for: .touchUpInside)
        weightView.addSubview(wtDownBtn)
        
        // size Type
        let sizeType = UILabel(frame:(CGRect(x: 10, y: 270, width: 300, height: 25)))
        sizeType.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        sizeType.text = "Size (In C.M)"
        sizeType.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(sizeType)
        
        let sizeView = UIView(frame:(CGRect(x: 10, y: 295, width: 300, height: 34)))
        sizeView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sizeView.layer.shadowRadius = 3.0
        sizeView.layer.shadowOpacity = 1.0
        sizeView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        sizeView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        scrollView.addSubview(sizeView)
        
        sizeTF = UITextField(frame:(CGRect(x: 10, y: 0, width: 250, height: 30)))
        sizeTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        sizeTF.attributedPlaceholder = NSAttributedString(string: "Choose size(L*B*H)",
                                                          attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
        sizeTF.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        sizeTF.font = deliveryTF.font?.withSize(13.0)
        sizeView.addSubview(sizeTF)
        
        let sizeDownBtn = UIButton(frame: CGRect(x: 270, y: 0, width: 30, height: 30))
        sizeDownBtn.setImage(UIImage(), for: .normal)
        let btnImage3 = UIImage(named: "dropDown")
        sizeDownBtn.setImage(btnImage3, for: .normal)
        sizeDownBtn.addTarget(self, action: #selector(DeliveryDetailsVC.DropDownBtnAction), for: .touchUpInside)
        sizeView.addSubview(sizeDownBtn)
        
        // Description Type
        let descripTF = UITextField(frame:(CGRect(x: 10, y: 340, width: 300, height: 30)))
        descripTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        descripTF.attributedPlaceholder = NSAttributedString(string: "Parcel Description",
                                                              attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        descripTF.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        descripTF.font = deliveryTF.font?.withSize(13.0)
        descripTF.borderStyle = .none
        descripTF.layer.masksToBounds = false
        descripTF.layer.shadowColor = UIColor.gray.cgColor
        descripTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        descripTF.layer.shadowOpacity = 1.0
        descripTF.layer.shadowRadius = 0.0
        scrollView.addSubview(descripTF)
        
        // Add Photo Type
        let imagePhoto = "camera"
        let imagee = UIImage(named: imagePhoto)
        let imageVieww = UIImageView(image: imagee!)
        imageVieww.frame = CGRect(x: 125, y: 390, width: 25, height: 25)
        scrollView.addSubview(imageVieww)
        
        let imagee1 = UIImageView()
        imagee1.frame = CGRect(x: 180, y: 390, width: 30, height: 30)
        imagee1.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        scrollView.addSubview(imagee1)
        
        let imagee2 = UIImageView()
        imagee2.frame = CGRect(x: 230, y: 390, width: 30, height: 30)
        imagee2.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        scrollView.addSubview(imagee2)
        
        let PhotoType = UIButton(frame:(CGRect(x: 15, y: 390, width: 300, height: 25)))
        PhotoType.setTitle("Add Photos", for: .normal)
        PhotoType.setTitleColor(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), for: .normal)
        PhotoType.contentHorizontalAlignment = .left
        PhotoType.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(PhotoType)
        
        // Receiver details Type
        let ReceiverType = UILabel(frame:(CGRect(x: 10, y: 420, width: 300, height: 25)))
        ReceiverType.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        ReceiverType.text = "Receiver Details"
        ReceiverType.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(ReceiverType)
        
        let nameTF = UITextField(frame:(CGRect(x: 10, y: 445, width: 300, height: 30)))
        nameTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nameTF.attributedPlaceholder = NSAttributedString(string: "Name *",
                                                             attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        nameTF.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        nameTF.font = nameTF.font?.withSize(13.0)
        nameTF.borderStyle = .none
        nameTF.layer.masksToBounds = false
        nameTF.layer.shadowColor = UIColor.gray.cgColor
        nameTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        nameTF.layer.shadowOpacity = 1.0
        nameTF.layer.shadowRadius = 0.0
        scrollView.addSubview(nameTF)
        
        let PhoneNoTF = UITextField(frame:(CGRect(x: 10, y: 480, width: 300, height: 30)))
        PhoneNoTF.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        PhoneNoTF.attributedPlaceholder = NSAttributedString(string: "Phone Number *",
                                                          attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        PhoneNoTF.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        PhoneNoTF.font = PhoneNoTF.font?.withSize(13.0)
        PhoneNoTF.borderStyle = .none
        PhoneNoTF.layer.masksToBounds = false
        PhoneNoTF.layer.shadowColor = UIColor.gray.cgColor
        PhoneNoTF.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        PhoneNoTF.layer.shadowOpacity = 1.0
        PhoneNoTF.layer.shadowRadius = 0.0
        scrollView.addSubview(PhoneNoTF)
        
        let DoneBtn = UIButton(frame:(CGRect(x: 0, y: 520, width: 160, height: 25)))
        DoneBtn.setTitle("DONE", for: .normal)
        DoneBtn.setTitleColor(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), for: .normal)
        DoneBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        scrollView.addSubview(DoneBtn)

        let CancelBtn = UIButton(frame:(CGRect(x: 160, y: 520, width: 160, height: 25)))
        CancelBtn.setTitle("CANCEL", for: .normal)
        CancelBtn.setTitleColor(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), for: .normal)
        CancelBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        scrollView.addSubview(CancelBtn)
        
        self.view.addSubview(dragView)
    }
    
    func GetAllListData() {
       
        let HUD = MBProgressHUD.showAdded(to: self.view, animated: true);
        HUD.label.text = "Loading...";
        HUD.isUserInteractionEnabled = false;
        Alamofire.request("https://speedie.ng/Speedie?action", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                switch(response.result) {
                case .success(_):
                    if let responseData = response.result.value as? NSDictionary
                    {
                        print("data-----\(responseData)")
                        if responseData.object(forKey: "status")as! String == "0" {
                            self.alertMethod(Title: "Alert", Message: responseData.value(forKey: "error") as! String)
                        }else {
                            let jsonData: NSDictionary = responseData.value(forKey: "JSON") as! NSDictionary
                            
                            // Get Category Data
                            let categoryList: NSArray = jsonData.value(forKey: "categorylist") as! NSArray
                            for i in 0 ..< categoryList.count {
                                let CategoryData = categoryList[i] as! NSDictionary
                                
                                let categoryName = CategoryData.value(forKey: "category_name") as! String
                                self.categoryDataArr.append(["category_name": categoryName])
                            }
                           
                            // Get Weight Data
                            let weightList: NSArray = jsonData.value(forKey: "weightlist") as! NSArray
                            for i in 0 ..< weightList.count {
                                let weightData = weightList[i] as! NSDictionary
                                
                                let price = weightData.value(forKey: "price") as! String
                                let weight = weightData.value(forKey: "weight") as! String
                                
                                self.weightDataArr.append(["price": price, "weight": weight])
                            }
                            
                            // Get Size Data
                            let sizeList: NSArray = jsonData.value(forKey: "sizelist") as! NSArray
                            for i in 0 ..< sizeList.count {
                                let sizeData = sizeList[i] as! NSDictionary
                                
                                let length = sizeData.value(forKey: "length") as! String
                                let breadth = sizeData.value(forKey: "breadth") as! String
                                let height = sizeData.value(forKey: "height") as! String

                                self.sizeDataArr.append(["length": length, "breadth": breadth, "height": height])
                            }
                            
                            // Get Delivery Time and price
                            let TimePriceList: NSArray = jsonData.value(forKey: "urgenttype") as! NSArray
                            for i in 0 ..< TimePriceList.count {
                                let TimePriceData = TimePriceList[i] as! NSDictionary
                                
                                let basePrice = TimePriceData.value(forKey: "base_price") as! String
                                let unit = TimePriceData.value(forKey: "unit") as! String
                                let delTime = TimePriceData.value(forKey: "deliveryTime") as! String
                                
                                self.TimePriceDataArr.append(["base_price": basePrice, "unit": unit, "deliveryTime": delTime])
                            }
                            
                        }
                    }
                    
                case .failure(_):
                    self.alertMethod(Title: "Alert", Message: "Internet Connection Error..!")
                    print(response.result.error as Any)
                    break
                }
                HUD.isHidden = true
        }
    }
    
    // Get All Picker Data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == deliveryPicker {
            return DeliveryDataArr.count
        } else if pickerView == categoryPicker {
            return categoryDataArr.count
        } else if pickerView == weightPicker {
            return weightDataArr.count
        } else {
           return sizeDataArr.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
         if pickerView == deliveryPicker {
            deliveryTF.text = DeliveryDataArr[row]
         }else if pickerView == categoryPicker {
            CategoryTF.text = categoryDataArr[row]["category_name"]
         } else if pickerView == weightPicker {
            weightTF.text = weightDataArr[row]["\("price")\("weight")"]
         } else {
            sizeTF.text = sizeDataArr[row]["\("length")\("breadth")\("height")"]
        }
        self.view.endEditing(true)
    }
    //For commiting things TEST
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == deliveryPicker {
            return DeliveryDataArr[row]
        } else if pickerView == categoryPicker {
            return categoryDataArr[row]["category_name"]
        } else if pickerView == weightPicker {
            return weightDataArr[row]["\("price")\("weight")"]
        } else {
            return sizeDataArr[row]["\("length")\("breadth")\("height")"]
        }
    }
    
    @objc func DropDownBtnAction() {
        deliveryTF.becomeFirstResponder()
    }
    
    @IBAction func backBtnACt(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
