//
//  Utilities.swift
//  TweenAnimation
//
//  Created by Brook Jones on 2017-11-03.
//  Copyright © 2017 Brook Jones. All rights reserved.
//

import UIKit

extension UIView {
    public func animatePulse(forKey: String, strength: Double = 0.05, duration: Double = 1.0, repeatCount: Double = .infinity) {
        let pulse = TweenAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.byValue = TweenFloat(strength)
        pulse.duration = duration
        pulse.tweenFunction = TweenAnimation.sinEase()
        pulse.repeatCount = Float(repeatCount)
        layer.add(pulse, forKey: forKey)
    }
    
    public func animatePulseUpward(forKey: String, strength: Double = 0.05, duration: Double = 1.0, repeatCount: Double = .infinity) {
        let scale = TweenAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.byValue = TweenFloat(strength)
        scale.duration = duration
        scale.tweenFunction = TweenAnimation.sinEase()
        
        let translate = TweenAnimation(keyPath: "position.y")
        translate.fromValue = TweenFloat(frame.midY)
        translate.byValue = TweenFloat(-1.0 * strength * Double(frame.height))
        translate.duration = duration
        translate.tweenFunction = TweenAnimation.sinEase()
        
        let pulse = CAAnimationGroup()
        pulse.animations = [scale, translate]
        pulse.duration = duration
        pulse.repeatCount = Float(repeatCount)
        layer.add(pulse, forKey: forKey)
    }
    
    public func animateSquashAndStretch(forKey: String, strength: Double = 0.1, duration: Double = 1.0, repeatCount: Double = .infinity) {
        let horizontal = TweenAnimation(keyPath: "transform.scale.x")
        horizontal.fromValue = 1.0
        horizontal.byValue = TweenFloat(strength)
        horizontal.duration = duration
        horizontal.tweenFunction = TweenAnimation.sinEase()
        
        let vertical = TweenAnimation(keyPath: "transform.scale.y")
        vertical.fromValue = 1.0
        vertical.byValue = -TweenFloat(strength)
        vertical.duration = duration
        vertical.tweenFunction = TweenAnimation.sinEase()
        
        let group = CAAnimationGroup()
        group.animations = [horizontal, vertical]
        group.duration = duration
        group.repeatCount = Float(repeatCount)
        layer.add(group, forKey: forKey)
    }
    
    public func animateHop(forKey: String, height: Double, pauseDuration: Double = 3.0, hopDuration: Double = 1.0, repeatCount: Double = .infinity) {
        let rise = TweenAnimation(keyPath: "position.y")
        rise.fromValue = 0.0
        rise.byValue = TweenFloat(height)
        rise.duration = 0.25 * hopDuration
        rise.isAdditive = true
        rise.tweenFunction = TweenAnimation.sinEaseOut
        rise.beginTime = pauseDuration
        
        let drop = TweenAnimation(keyPath: "position.y")
        drop.fromValue = TweenFloat(height)
        drop.toValue = 0.0
        drop.duration = 0.75 * hopDuration
        drop.isAdditive = true
        drop.tweenFunction = TweenAnimation.bounceEaseOut
        drop.beginTime = pauseDuration + 0.25 * hopDuration
        
        let group = CAAnimationGroup()
        group.animations = [rise, drop]
        group.duration = pauseDuration + hopDuration
        group.repeatCount = Float(repeatCount)
        layer.add(group, forKey: forKey)
    }
    
    public func animateSquashHop(forKey: String, height: Double, pauseDuration: Double = 3.0, hopDuration: Double = 1.0, repeatCount: Double = .infinity) {
        let squashDirection = (height < 0.0) ? 1.0 : -1.0
        let squashDuration = hopDuration * 0.75
        let squashPercentage = 0.3
        
        let squashPos = TweenAnimation(keyPath: "position.y")
        squashPos.fromValue = 0.0
        squashPos.byValue = TweenFloat(frame.height) * TweenFloat(squashDirection) * TweenFloat(squashPercentage)
        squashPos.duration = squashDuration
        squashPos.isAdditive = true
        squashPos.tweenFunction = TweenAnimation.sinEaseOut
        squashPos.beginTime = pauseDuration - squashDuration
        
        let squashScale = TweenAnimation(keyPath: "transform.scale.y")
        squashScale.fromValue = 1.0
        squashScale.toValue = TweenFloat(1.0 - squashPercentage)
        squashScale.duration = squashDuration
        squashScale.tweenFunction = TweenAnimation.sinEaseOut
        squashScale.beginTime = pauseDuration - squashDuration
        
        let stretchScale = TweenAnimation(keyPath: "transform.scale.y")
        stretchScale.fromValue = TweenFloat(1.0 - squashPercentage)
        stretchScale.toValue = 1.0
        stretchScale.duration = 0.25 * hopDuration
        stretchScale.tweenFunction = TweenAnimation.sinEaseOut
        stretchScale.beginTime = pauseDuration
        
        let rise = TweenAnimation(keyPath: "position.y")
        rise.fromValue = 0.0
        rise.byValue = TweenFloat(height)
        rise.duration = 0.25 * hopDuration
        rise.isAdditive = true
        rise.tweenFunction = TweenAnimation.sinEaseOut
        rise.beginTime = pauseDuration
        
        let drop = TweenAnimation(keyPath: "position.y")
        drop.fromValue = TweenFloat(height)
        drop.toValue = 0.0
        drop.duration = 0.75 * hopDuration
        drop.isAdditive = true
        drop.tweenFunction = TweenAnimation.bounceEaseOut
        drop.beginTime = pauseDuration + 0.25 * hopDuration
        
        let group = CAAnimationGroup()
        group.animations = [squashPos, squashScale, stretchScale, rise, drop]
        group.duration = pauseDuration + hopDuration
        group.repeatCount = Float(repeatCount)
        layer.add(group, forKey: forKey)
    }
    
    public func animateBob(forKey: String, bob: Double, duration: Double = 1.0, repeatCount: Double = .infinity) {
        let vertical = TweenAnimation(keyPath: "position.y")
        vertical.fromValue = 0.0
        vertical.byValue = TweenFloat(bob)
        vertical.duration = duration
        vertical.isAdditive = true
        vertical.tweenFunction = TweenAnimation.sinEase()
        vertical.repeatCount = Float(repeatCount)
        layer.add(vertical, forKey: forKey)
    }
    
    public func animateHonk(forKey: String, strength: Double = 1.0, rotation: Double = 0.1, duration: Double = 0.5, repeatCount: Double = 1.0) {
        let scale = TweenAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = TweenFloat(1.0 + strength)
        scale.duration = duration * 0.5
        scale.autoreverses = true
        scale.tweenFunction = TweenAnimation.sinEaseOut
        
        let rotate = TweenAnimation(keyPath: "transform.rotation")
        rotate.fromValue = 0.0
        rotate.toValue = TweenFloat(rotation) * TweenFloat.pi
        rotate.duration = duration * 0.5
        rotate.autoreverses = true
        rotate.tweenFunction = TweenAnimation.sinEaseOut
        
        let honk = CAAnimationGroup()
        honk.animations = [scale, rotate]
        honk.duration = duration * 2.0
        honk.repeatCount = Float(repeatCount)
        layer.add(honk, forKey: forKey)
    }
}
