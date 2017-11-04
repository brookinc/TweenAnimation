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
        
        let animationY = TweenAnimation(keyPath: "position.y")
        animationY.fromValue = height
        animationY.byValue = -height
        animationY.duration = 1.0
        animationY.isAdditive = true  // calculate our values relative to the object's (local) coordinates
        switch animationIndex % 32 {
        case 0:
            animationY.tweenFunction = TweenAnimation.linearEase
            label.text = "linearEase"
        case 1:
            animationY.tweenFunction = TweenAnimation.sinEase(period: 2.0)
            label.text = "sinEase"
        case 2:
            animationY.tweenFunction = TweenAnimation.sinEaseIn
            label.text = "sinEaseIn"
        case 3:
            animationY.tweenFunction = TweenAnimation.sinEaseOut
            label.text = "sinEaseOut"
        case 4:
            animationY.tweenFunction = TweenAnimation.sinEaseInOut
            label.text = "sinEaseInOut"
        case 5:
            animationY.tweenFunction = TweenAnimation.power2EaseIn
            label.text = "power2EaseIn"
        case 6:
            animationY.tweenFunction = TweenAnimation.power2EaseOut
            label.text = "power2EaseOut"
        case 7:
            animationY.tweenFunction = TweenAnimation.power2EaseInOut
            label.text = "power2EaseInOut"
        case 8:
            animationY.tweenFunction = TweenAnimation.power3EaseIn
            label.text = "power3EaseIn"
        case 9:
            animationY.tweenFunction = TweenAnimation.power3EaseOut
            label.text = "power3EaseOut"
        case 10:
            animationY.tweenFunction = TweenAnimation.power3EaseInOut
            label.text = "power3EaseInOut"
        case 11:
            animationY.tweenFunction = TweenAnimation.power4EaseIn
            label.text = "power4EaseIn"
        case 12:
            animationY.tweenFunction = TweenAnimation.power4EaseOut
            label.text = "power4EaseOut"
        case 13:
            animationY.tweenFunction = TweenAnimation.power4EaseInOut
            label.text = "power4EaseInOut"
        case 14:
            animationY.tweenFunction = TweenAnimation.power5EaseIn
            label.text = "power5EaseIn"
        case 15:
            animationY.tweenFunction = TweenAnimation.power5EaseOut
            label.text = "power5EaseOut"
        case 16:
            animationY.tweenFunction = TweenAnimation.power5EaseInOut
            label.text = "power5EaseInOut"
        case 17:
            animationY.tweenFunction = TweenAnimation.expoEaseIn
            label.text = "expoEaseIn"
        case 18:
            animationY.tweenFunction = TweenAnimation.expoEaseOut
            label.text = "expoEaseOut"
        case 19:
            animationY.tweenFunction = TweenAnimation.expoEaseInOut
            label.text = "expoEaseInOut"
        case 20:
            animationY.tweenFunction = TweenAnimation.circEaseIn
            label.text = "circEaseIn"
        case 21:
            animationY.tweenFunction = TweenAnimation.circEaseOut
            label.text = "circEaseOut"
        case 22:
            animationY.tweenFunction = TweenAnimation.circEaseInOut
            label.text = "circEaseInOut"
        case 23:
            animationY.tweenFunction = TweenAnimation.bounceEaseIn
            label.text = "bounceEaseIn"
        case 24:
            animationY.tweenFunction = TweenAnimation.bounceEaseOut
            label.text = "bounceEaseOut"
        case 25:
            animationY.tweenFunction = TweenAnimation.bounceEaseInOut
            label.text = "bounceEaseInOut"
        case 26:
            animationY.tweenFunction = TweenAnimation.backEaseIn
            label.text = "backEaseIn"
        case 27:
            animationY.tweenFunction = TweenAnimation.backEaseOut
            label.text = "backEaseOut"
        case 28:
            animationY.tweenFunction = TweenAnimation.backEaseInOut
            label.text = "backEaseInOut"
        case 29:
            animationY.tweenFunction = TweenAnimation.elasticEaseIn
            label.text = "elasticEaseIn"
        case 30:
            animationY.tweenFunction = TweenAnimation.elasticEaseOut
            label.text = "elasticEaseOut"
        case 31:
            animationY.tweenFunction = TweenAnimation.elasticEaseInOut
            label.text = "elasticEaseInOut"
        default:
            print("Missing tween function!")
            label.text = "Missing tween function! (\(animationIndex))"
        }
        
        let group = CAAnimationGroup()
        group.animations = [animationX, animationY]
        group.duration = 1.0
        group.beginTime = 0.0
        //group.autoreverses = true
        group.repeatCount = .infinity
        
        point.layer.add(group, forKey: "tweenPointAnimation")
        
        // demonstrate some different cycling animations on the "next" button as well
        let buttonAnimKey = "tweenButtonAnimation"
        switch animationIndex % 11 {
        case 0:
            let buttonAnimation = TweenAnimation(keyPath: "transform.scale")
            buttonAnimation.fromValue = 0.9
            buttonAnimation.toValue = 1.1
            buttonAnimation.duration = 1.0
            buttonAnimation.tweenFunction = TweenAnimation.sinEase()
            buttonAnimation.repeatCount = .infinity
            nextButton.layer.add(buttonAnimation, forKey: buttonAnimKey)
        case 1:
            nextButton.animatePulse(forKey: buttonAnimKey)
        case 2:
            nextButton.animatePulseUpward(forKey: buttonAnimKey)
        case 3:
            nextButton.animateSquashAndStretch(forKey: buttonAnimKey)
        case 4:
            nextButton.animateHop(forKey: buttonAnimKey, height: -20.0)
        case 5:
            nextButton.animateSquashHop(forKey: buttonAnimKey, height: -20.0)
        case 6:
            nextButton.animateBob(forKey: buttonAnimKey, bob: 2.0)
        case 7:
            nextButton.animateHonk(forKey: buttonAnimKey)
        // some alternate tweens possible with stock CoreAnimation code...
        case 8:
            let basicanim = CABasicAnimation(keyPath: "transform.scale")
            basicanim.fromValue = 0.9
            basicanim.toValue = 1.1
            basicanim.duration = 1.0
            basicanim.repeatCount = .infinity
            basicanim.autoreverses = true
            basicanim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            nextButton.layer.add(basicanim, forKey: buttonAnimKey)
        case 9:
            let basicanim = CABasicAnimation(keyPath: "transform.scale")
            basicanim.fromValue = 0.9
            basicanim.toValue = 1.1
            basicanim.duration = 1.0
            basicanim.repeatCount = .infinity
            basicanim.autoreverses = true
            basicanim.timingFunction = CAMediaTimingFunction(controlPoints: 0.375, 0.0, 0.625, 1.0)  // sin approximation
            nextButton.layer.add(basicanim, forKey: buttonAnimKey)
        case 10:
            let springanim = CASpringAnimation(keyPath: "transform.scale")
            springanim.fromValue = 0.9
            springanim.toValue = 1.1
            springanim.duration = 1.0
            springanim.repeatCount = .infinity
            springanim.initialVelocity = 0.5
            springanim.damping = 1.0
            nextButton.layer.add(springanim, forKey: buttonAnimKey)
        default:
            print("Missing button tween function! (\(animationIndex))")
        }
        
        animationIndex += 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
