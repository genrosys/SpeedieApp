//
//  IntroVC.swift
//  Speedie
//
//  Created by Sierra on 2/1/18.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class IntroVC: UIViewController,UIScrollViewDelegate {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrMain: UIScrollView!
    let arrImages = ["img1", "img2", "img3","img4"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
        override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
   
    @IBAction func skipActBtn(_ sender: Any) {
         UserDefaults.standard.set(true, forKey: "launchedBefore")
        let phoneNoVCobjct = self.storyboard?.instantiateViewController(withIdentifier: "PhoneNoVCViewController") as! PhoneNoVCViewController
        phoneNoVCobjct.backVal = "1"
        self.navigationController?.pushViewController(phoneNoVCobjct, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        self.loadScrollView()
    }
    
    func loadScrollView() {
        let pageCount : CGFloat = CGFloat(arrImages.count)
        
        scrMain.backgroundColor = UIColor.clear
        scrMain.delegate = self
        scrMain.isPagingEnabled = true
        scrMain.contentSize = CGSize(width:scrMain.frame.size.width * pageCount,height: scrMain.frame.size.height)
        scrMain.showsHorizontalScrollIndicator = false
        
        pageControl.numberOfPages = Int(pageCount)
        pageControl.addTarget(self, action: #selector(self.pageChanged), for: .valueChanged)
        
        for i in 0..<Int(pageCount) {
            print(self.scrMain.frame.size.width)
            let image = UIImageView(frame: CGRect(x:self.scrMain.frame.size.width * CGFloat(i), y:0, width:self.scrMain.frame.size.width, height:self.view.frame.size.height))
            image.image = UIImage(named: arrImages[i])!
            image.contentMode = UIViewContentMode.scaleAspectFit
            self.scrMain.addSubview(image)
        }
    }
    
    
    //MARK: UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let viewWidth: CGFloat = scrollView.frame.size.width
        // content offset - tells by how much the scroll view has scrolled.
        let pageNumber = floor((scrollView.contentOffset.x - viewWidth / 50) / viewWidth) + 1
        pageControl.currentPage = Int(pageNumber)
    }
    
    
    //MARK: Page tap action
    @objc func pageChanged() {
        let pageNumber = pageControl.currentPage
        var frame = scrMain.frame
        frame.origin.x = frame.size.width * CGFloat(pageNumber)
        frame.origin.y = 0
        scrMain.scrollRectToVisible(frame, animated: true)
    }
   
}
