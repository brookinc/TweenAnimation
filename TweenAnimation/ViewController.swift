//
//  ViewController.swift
//  https://github.com/brookinc/TweenAnimation/
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var point: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var label: UILabel!
    var animationIndex = 0
    
    @IBAction func nextButtonPressed(_ sender: AnyObject) {
        animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        background.layer.borderColor = UIColor.black.cgColor
        background.layer.borderWidth = 1.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
    
    private func animate() {
        let width = background.bounds.width - point.bounds.width
        let height = background.bounds.height - point.bounds.height
        
        // (for possible keyPath values, see: https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html
        // and https://developer.apple.com/library/content/documentation/WindowsViews/Conceptual/ViewPG_iPhoneOS/AnimatingViews/AnimatingViews.html)
        let animationX = CABasicAnimation(keyPath: "position.x")
        animationX.fromValue = 0.0
        animationX.toValue = width
        animationX.duration = 1.0
        animationX.isAdditive = true
        //animationX.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let animationY = TweenAnimation(keyPath: "position.y")
        animationY.fromValue = height
        animationY.byValue = -height
        animationY.duration = 1.0
        animationY.isAdditive = true  // calculate our values relative to the object's (local) coordinates
        switch animationIndex % 19 {
        case 0:
            animationY.tweenFunction = TweenAnimation.linearEase
            label.text = "linearEase"
        case 1:
            animationY.tweenFunction = TweenAnimation.quadEaseIn
            label.text = "quadEaseIn"
        case 2:
            animationY.tweenFunction = TweenAnimation.quadEaseOut
            label.text = "quadEaseOut"
        case 3:
            animationY.tweenFunction = TweenAnimation.quadEaseInOut
            label.text = "quadEaseInOut"
        case 4:
            animationY.tweenFunction = TweenAnimation.cubicEaseIn
            label.text = "cubicEaseIn"
        case 5:
            animationY.tweenFunction = TweenAnimation.cubicEaseOut
            label.text = "cubicEaseOut"
        case 6:
            animationY.tweenFunction = TweenAnimation.cubicEaseInOut
            label.text = "cubicEaseInOut"
        case 7:
            animationY.tweenFunction = TweenAnimation.quartEaseIn
            label.text = "quartEaseIn"
        case 8:
            animationY.tweenFunction = TweenAnimation.quartEaseOut
            label.text = "quartEaseOut"
        case 9:
            animationY.tweenFunction = TweenAnimation.quartEaseInOut
            label.text = "quartEaseInOut"
        case 10:
            animationY.tweenFunction = TweenAnimation.expoEaseIn
            label.text = "expoEaseIn"
        case 11:
            animationY.tweenFunction = TweenAnimation.expoEaseOut
            label.text = "expoEaseOut"
        case 12:
            animationY.tweenFunction = TweenAnimation.expoEaseInOut
            label.text = "expoEaseInOut"
        case 13:
            animationY.tweenFunction = TweenAnimation.bounceEaseIn
            label.text = "bounceEaseIn"
        case 14:
            animationY.tweenFunction = TweenAnimation.bounceEaseOut
            label.text = "bounceEaseOut"
        case 15:
            animationY.tweenFunction = TweenAnimation.sinEase(period: 2.0)
            label.text = "sinEase"
        case 16:
            animationY.tweenFunction = TweenAnimation.sinEaseIn
            label.text = "sinEaseIn"
        case 17:
            animationY.tweenFunction = TweenAnimation.sinEaseOut
            label.text = "sinEaseOut"
        case 18:
            animationY.tweenFunction = TweenAnimation.sinEaseInOut
            label.text = "sinEaseInOut"
        default:
            print("Missing tween function!")
            label.text = "Missing tween function!"
        }
        animationIndex += 1
        
        let group = CAAnimationGroup()
        group.animations = [animationX, animationY]
        group.duration = 1.0
        group.beginTime = 0.0
        //group.autoreverses = true
        group.repeatCount = .infinity
        
        point.layer.add(group, forKey: "tweenPointAnimation")
        
        // add a sin "pulse" animation on the button as well
        let buttonAnimation = TweenAnimation(keyPath: "transform.scale")
        buttonAnimation.fromValue = 1.0
        buttonAnimation.byValue = 0.1
        buttonAnimation.duration = 1.0
        buttonAnimation.tweenFunction = TweenAnimation.sinEase()
        buttonAnimation.repeatCount = .infinity
        
        nextButton.layer.add(buttonAnimation, forKey: "tweenButtonAnimation")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
