//
//  SDragView.swift
//  SDragView
//
//  Created by Admin on 9/20/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit

class SDragView: UIView {

    //  MARK: - Public properties
    public var viewCornerRadius:CGFloat = 8
    public var viewBackgroundColor:UIColor = UIColor.clear
    
    // MARK: - Private properties
    private var dragViewAnimatedTopMargin:CGFloat = 25.0 // View fully visible (upper spacing)
    private var viewDefaultHeight:CGFloat = 80.0// View height when appear
    private var gestureRecognizer = UIPanGestureRecognizer()
    private var dragViewDefaultTopMargin:CGFloat!
    private var viewLastYPosition = 0.0
    
    required init(dragViewAnimatedTopSpace:CGFloat, viewDefaultHeightConstant:CGFloat)
    {
        dragViewAnimatedTopMargin = dragViewAnimatedTopSpace
        viewDefaultHeight = viewDefaultHeightConstant
        
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - viewDefaultHeight
        
        super.init(frame: CGRect(x: 0, y:dragViewDefaultTopMargin , width: screenSize.width, height: screenSize.height))
        
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //.withAlphaComponent(0.20) //
  // self.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
       //s self.layer.cornerRadius = self.viewCornerRadius
        
        self.clipsToBounds = true
        
      /*  let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.bounds
        blurView.clipsToBounds = true
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      //  blurView.layer.cornerRadius = self.viewCornerRadius
        self.addSubview(blurView)
 */
        /*
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width+10, height: 50))
        button.backgroundColor = UIColor.red
        button.autoresizingMask = [.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin]
      //  button.layer.cornerRadius = 8
        button.setTitle("Touch Me", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.addSubview(button)
 */
        
        self.layoutIfNeeded()
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(gestureRecognizer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            var newTranslation = CGPoint()
            var oldTranslation = CGPoint()
            newTranslation = gestureRecognizer.translation(in: self.superview)
            
            print(newTranslation.y)
            if(!(newTranslation.y < 0 && self.frame.origin.y + newTranslation.y <= dragViewAnimatedTopMargin))
            {
                self.translatesAutoresizingMaskIntoConstraints = true
                self.center = CGPoint(x: self.center.x, y: self.center.y + newTranslation.y)
                
                if (newTranslation.y < 0)
                {
                    if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                    {
                        self.frame = CGRect(x: self.frame.origin.x , y:self.frame.origin.y , width: self.frame.size.width , height: self.frame.size.height)
                    }
                }
                else
                {
                    if("\(self.frame.size.width)" != "\((self.superview?.frame.size.width)! )")
                    {
                        self.frame = CGRect(x: self.frame.origin.x , y:self.frame.origin.y , width: self.frame.size.width , height: self.frame.size.height)
                    }
                }
                
                // self.layoutIfNeeded()
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.superview)
                oldTranslation.y = newTranslation.y
            }
            else
            {
                self.frame.origin.y = dragViewAnimatedTopMargin
                self.isUserInteractionEnabled = false
            }
        }
            
        else if (gestureRecognizer.state == .ended)
          {
            self.isUserInteractionEnabled = true
            let vel = gestureRecognizer.velocity(in: self.superview)
            
            let finalY: CGFloat = 50.0
            let curY: CGFloat = self.frame.origin.y
            let distance: CGFloat = curY - finalY
            
            let springVelocity: CGFloat = 1.0 * vel.y / distance
            
            if(springVelocity > 0 && self.frame.origin.y <= dragViewAnimatedTopMargin)
            {
                self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
            }
            else if (springVelocity > 0)
            {
                if (self.frame.origin.y < (self.superview?.frame.size.height)!/3 && springVelocity < 7)
                {
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        }
                        self.frame.origin.y = self.dragViewAnimatedTopMargin
                    }), completion: nil)
                }
                else
                {
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                        
                        if(self.frame.size.width != (self.superview?.frame.size.width)! )
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)! , height: self.frame.size.height)
                        }
                        
                        self.frame.origin.y = self.dragViewDefaultTopMargin
                    }), completion:  { (finished: Bool) in
                        
                    })
                }
            }
            else if (springVelocity == 0)// If Velocity zero remain at same position
            {
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = CGFloat(self.viewLastYPosition)
                    
                    if(self.frame.origin.y == self.dragViewDefaultTopMargin)
                    {
                        if("\(self.frame.size.width)" == "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: self.frame.size.width , height: self.frame.size.height)
                        }
                    }
                    else{
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        }
                    }
                    
                }), completion: nil)
            }
            else
            {
                if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                {
                    self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                }
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = self.dragViewAnimatedTopMargin
                }), completion: nil)
            }
            viewLastYPosition = Double(self.frame.origin.y)
            self.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    
    func buttonAction(sender: UIButton!) {
        
        if(self.frame.origin.y == dragViewAnimatedTopMargin)
        {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x: 10, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width - 20, height: self.frame.size.height)
                
            }), completion: nil)
            
        }
        else{
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: nil)
        }
    }

}
