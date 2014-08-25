//
//  MailboxViewController.swift
//  mailbox_prototype
//
//  Created by Ryhan Hassan on 8/24/14.
//  Copyright (c) 2014 Ryhan Hassan. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet var everythingView: UIView!
    @IBOutlet weak var mailboxScrollView: UIScrollView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageImageView: UIImageView!
    
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!

    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    
    @IBOutlet weak var hamburgerButton: UIButton!
    
    
    @IBOutlet weak var Inbox: UIView!
    var originalX : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mailboxScrollView.contentSize = CGSize(width: 320, height: 1367)
        
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onCustomTap:")
        messageView.addGestureRecognizer(panGestureRecognizer)
        everythingView.addGestureRecognizer(tapGestureRecognizer)
        
        originalX = messageImageView.center.x
        
        rescheduleView.alpha = 0
        listView.alpha = 0
        
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        Inbox.addGestureRecognizer(edgeGesture)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func remapRange(x:CGFloat, Xmin:CGFloat, Xmax:CGFloat, Ymin:CGFloat, Ymax: CGFloat) -> CGFloat{
        
        var y:CGFloat!
        y = (x-Xmin)/(Xmax - Xmin)*(Ymax - Ymin)+Ymin
        
        var min = Ymin
        var max = Ymax
        if (min > max){
            min = Ymax
            max = Ymin
        }
        if (y < min){
            y = min
        }
        else if (y > max){
            y = max
        }
        return y
    }
    
    func onEdgePan(ScreenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        //var point = tapGestureRecognizer.locationInView(view)
        
        // User tapped at the point above. Do something with that if you want.

        
        println("Edge Pan")
    }
    
    func onCustomTap(tapGestureRecognizer: UITapGestureRecognizer) {
        var point = tapGestureRecognizer.locationInView(view)
        
        // User tapped at the point above. Do something with that if you want.
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
        
            self.rescheduleView.alpha = 0
            self.mailboxScrollView.alpha = 1
            self.listView.alpha = 0
            self.Inbox.center.x = 160
            
            }, completion: nil)
        
        println("Tapped at \(point)")
    }
    
    func onCustomPan(panGestureRecognizer: UIPanGestureRecognizer) {
        var point = panGestureRecognizer.locationInView(view)
        var velocity = panGestureRecognizer.velocityInView(view)
        var translation = panGestureRecognizer.translationInView(view)
        
        
        archiveIcon.center.x = remapRange(translation.x, Xmin: 60, Xmax: 260, Ymin: 25, Ymax: 225)
        deleteIcon.center.x = remapRange(translation.x, Xmin: 60, Xmax: 260, Ymin: 25, Ymax: 225)
        laterIcon.center.x = remapRange(translation.x, Xmin: -60, Xmax: -260, Ymin: 295, Ymax: 95)
        listIcon.center.x = remapRange(translation.x, Xmin: -60, Xmax: -260, Ymin: 295, Ymax: 95)
        
        if (translation.x < 200){
            archiveIcon.alpha = remapRange(translation.x, Xmin: 0, Xmax: 60, Ymin: 0, Ymax: 1)
        }else{
            archiveIcon.alpha = 0
        }
        deleteIcon.alpha = remapRange(translation.x, Xmin: 200, Xmax: 201, Ymin: 0, Ymax: 1)
       
        
        if (translation.x > -200){
            laterIcon.alpha = remapRange(translation.x, Xmin: 0, Xmax: -60, Ymin: 0, Ymax: 1)
        }else{
            laterIcon.alpha = 0
        }
        
        listIcon.alpha = remapRange(translation.x, Xmin: -200, Xmax: -201, Ymin: 0, Ymax: 1)
        
        
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            println("Gesture began at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            messageImageView.center.x = originalX + translation.x
            
            if (translation.x > 60 && translation.x < 200){
                messageView.backgroundColor = UIColor(red: 101/255, green: 216/255, blue: 97/255, alpha: 1)
            }
            else if (translation.x > 200){
                messageView.backgroundColor = UIColor(red: 236/255, green: 85/255, blue: 34/255, alpha: 1)
            }
            else if (translation.x < -60 && translation.x > -200){
                messageView.backgroundColor = UIColor(red: 254/255, green: 221/255, blue: 71/255, alpha: 1)
            }else if (translation.x <= -200){
                messageView.backgroundColor = UIColor(red: 215/255, green: 166/255, blue: 120/255, alpha: 1)
            }else{
                 messageView.backgroundColor = UIColor(red: 203/255, green: 203/255, blue: 203/255, alpha: 1)
            }
            
            println("Gesture changed at: \(point)")
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
                
                self.messageImageView.center.x = self.originalX
                
                if (translation.x < -60 && translation.x > -200){
                    self.rescheduleView.alpha = 1
                    self.mailboxScrollView.alpha = 0
                }
                if (translation.x <= -200){
                    self.listView.alpha = 1
                    self.mailboxScrollView.alpha = 0
                }

                
                }, completion: nil)
            
            println("Gesture ended at: \(point)")
            
            
        }
    }
    
    
    @IBAction func hamburgerDown(sender: AnyObject) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: nil, animations: {
            
            self.Inbox.center.x = 440
            
            }, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer!, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer!) -> Bool {
        return true
    }

}
