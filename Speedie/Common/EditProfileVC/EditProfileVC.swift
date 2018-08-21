//
//  EditProfileVC.swift
//  Speedie
//
//  Created by MAC on 19/07/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit
import Photos
import Alamofire
import SDWebImage
class EditProfileVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet var profileImgOut: UIImageView!
    
    @IBOutlet var FnameLabOut: UILabel!
    
    @IBOutlet var LnameLabOut: UILabel!
    @IBOutlet var PnoTF: UILabel!
    @IBOutlet var emailLabOut: UILabel!
    
    var imagePicker = UIImagePickerController()
    var tempDict = NSDictionary()
    var userDetails = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImgOut.layer.cornerRadius = profileImgOut.frame.size.height/2
        profileImgOut.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        userDetails = Store().getUserCredentials()
        print("userDetails---------\(userDetails)")
      //  let usrlStr = userDetails.value(forKey: "custimageurl") as! String
      // let url = URL(string: usrlStr)
     //   profileImgOut.sd_setImage(with: url, placeholderImage: UIImage(named: "dummyProfileImg"))
        FnameLabOut.text = userDetails.value(forKey: "firstName") as? String
        LnameLabOut.text = userDetails.value(forKey: "lastname") as? String
        PnoTF.text = userDetails.value(forKey: "mobile") as? String
        emailLabOut.text = userDetails.value(forKey: "email") as? String


    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9144350886, green: 0.7273971438, blue: 0.08961100131, alpha: 1)
    }

    @IBAction func profileImgBtnAct(_ sender: Any) {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Camera", style: .default) { _ in
            print("Camera")
            self.openCamera()
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Gallery", style: .default)
        { _ in
            print("Gallery")
            self.checkPhotoLibraryPermission()
            self.openGallery()
        }
        
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Cancel", style: .destructive)
        { _ in
            print("Cancel")
            
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            // print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType =  UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            print("camera working")
        }
        else{
            print("Camera not available")
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            // print("Button capture")
            imagePicker.delegate = self
            imagePicker.sourceType =  UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            print("Gallery not available")
        }
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            print("HElooo")
            break
        //handle authorized status
        case .denied, .restricted :
            print("denied")
            break
        //handle denied status
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    print("1")
                    break
                // as above
                case .denied, .restricted:
                    print("2")
                    break
                // as above
                case .notDetermined:
                    print("3")
                    break
                    // won't happen but still
                }
            }
        }
    }
    //MARK:- imagePickerController Delegate
    func imagePickerController(_ picker: UIImagePickerController,    didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            profileImgOut.image = image
            // profileimgOut.contentMode = .scaleAspectFit
            self.dismiss(animated: true, completion: nil)
            print("test")
        }
        
    }
    @IBAction func FbaneBtnAct(_ sender: Any) {
        let EditingVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "EditingVC") as! EditingVC
       EditingVCobjct.viewValuePass = "openFname"
        self.present(EditingVCobjct, animated: true, completion: nil)
    }
    @IBAction func LnameBtnAct(_ sender: Any) {
        let EditingVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "EditingVC") as! EditingVC
        EditingVCobjct.viewValuePass = "openLname"
        self.present(EditingVCobjct, animated: true, completion: nil)
    }
    
    @IBAction func PnoBtnAct(_ sender: Any) {
        let EditingVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "EditingVC") as! EditingVC
        EditingVCobjct.viewValuePass = "openPhoneNo"

        self.present(EditingVCobjct, animated: true, completion: nil)
    }
    
    @IBAction func emailBtnAct(_ sender: Any) {
        let EditingVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "EditingVC") as! EditingVC
        EditingVCobjct.viewValuePass = "openEmail"

        self.present(EditingVCobjct, animated: true, completion: nil)
    }
    
    @IBAction func PsdBtnAct(_ sender: Any) {
        let EditingVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "EditingVC") as! EditingVC
        EditingVCobjct.viewValuePass = "openPassword"

        self.present(EditingVCobjct, animated: true, completion: nil)
    }
  
 
    
    
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    

}
