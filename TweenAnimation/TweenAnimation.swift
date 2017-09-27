//
//  TweenAnimation.swift
//  https://github.com/brookinc/TweenAnimation/
//

import UIKit

// You can bind TweenFloat to Float, Double, or CGFloat according to your preferences
// (ie. whichever type you'll be passing in most commonly for your to/from/by values,
// to minimize the amount of explicit type conversion you'll have to do)
typealias TweenFloat = CGFloat

typealias TweenFunction = (TweenFloat) -> TweenFloat

class TweenAnimation: CAKeyframeAnimation {
    var fromValue: TweenFloat? {
        didSet {
            updateValues()
        }
    }

    var toValue: TweenFloat? {
        didSet {
            updateValues()
        }
    }
    
    var byValue: TweenFloat? {
        didSet {
            updateValues()
        }
    }
    
    var tweenFunction: TweenFunction? {
        didSet {
            updateValues()
            if tweenEndpoints == nil {
                print("Error: at least TWO of [fromValue, toValue, byValue] must be set for TweenAnimation to animate.")
            }
        }
    }
    
    private var tweenEndpoints: (TweenFloat, TweenFloat)? {
        // Unlike CABasicAnimation (https://developer.apple.com/documentation/quartzcore/cabasicanimation),
        // we require that TWO of [fromValue, toValue, byValue] are set
        if let from = fromValue, let to = toValue {
            return (from, to)
        } else if let from = fromValue, let by = byValue {
            return (from, from + by)
        } else if let to = toValue, let by = byValue {
            return (to - by, to)
        }
        return nil
    }
    
    private func updateValues() {
        let keyframesPerSecond = 60
        let numKeyframes = Int(Double(keyframesPerSecond) * duration)
        let keyframeDuration = TweenFloat(1.0 / Double(numKeyframes))
        var tweenValues = [TweenFloat]()
        tweenValues.reserveCapacity(numKeyframes)
        var tweenKeyTimes = [NSNumber]()
        tweenKeyTimes.reserveCapacity(numKeyframes)
        var time: TweenFloat = 0.0
        if let (from, to) = tweenEndpoints {
            if let tweenFunc = tweenFunction {
                for _ in 0 ..< numKeyframes {
                    let value = from + (to - from) * tweenFunc(time)
                    tweenValues.append(value)
                    tweenKeyTimes.append(NSNumber(value: Double(time)))
                    time += keyframeDuration
                }
                values = tweenValues
                keyTimes = tweenKeyTimes
            }
        }
    }

    static let linearEase: TweenFunction = {
        $0
    }
    
    static let quadEaseIn: TweenFunction = {
        pow($0, 2.0)
    }
    
    static let quadEaseOut: TweenFunction = {
        $0 * (2.0 - $0)
    }
    
    static let quadEaseInOut: TweenFunction = {
        if $0 < 0.5 {
            return 2.0 * $0 * $0
        } else {
            return -1.0 + (4.0 - 2.0 * $0) * $0
        }
    }
    
    static let cubicEaseIn: TweenFunction = {
        pow($0, 3.0)
    }
    
    static let cubicEaseOut: TweenFunction = {
        pow(($0 - 1.0), 3.0) + 1.0
    }
    
    static let cubicEaseInOut: TweenFunction = {
        if $0 < 0.5 {
            return 4.0 * pow($0, 3.0)
        } else {
            return ($0 - 1.0) * pow((2.0 * $0 - 2.0), 2.0) + 1.0
        }
    }
    
    static let quartEaseIn: TweenFunction = {
        pow($0, 4.0)
    }
    
    static let quartEaseOut: TweenFunction = {
        1.0 - pow(($0 - 1.0), 4.0)
    }
    
    static let quartEaseInOut: TweenFunction = {
        if $0 < 0.5 {
            return 8.0 * pow($0, 4.0)
        } else {
            return -1.0 / 2.0 * pow((2.0 * $0 - 2.0), 4.0) + 1.0
        }
    }
    
    static let expoEaseIn: TweenFunction = {
        return $0 == 0.0 ? 0.0 : pow(2.0, 10.0 * ($0 - 1.0))
    }
    
    static let expoEaseOut: TweenFunction = {
        return $0 == 1.0 ? 1.0 : 1.0 - pow(2.0, -10.0 * $0)
    }
    
    static let expoEaseInOut: TweenFunction = {
        if $0 == 0.0 {
            return 0.0
        }
        if $0 == 1.0 {
            return 1.0
        }
        if $0 < 0.5 {
            return 0.5 * pow(2.0, 10.0 * (2.0 * $0 - 1.0))
        } else {
            return 1.0 - 0.5 * pow(2.0, -10.0 * (2.0 * $0 - 1.0))
        }
    }
    
    static let bounceEaseIn: TweenFunction = {
        return 1.0 - bounceEaseOut(1.0 - $0)
    }
    
    static let bounceEaseOut: TweenFunction = {
        if $0 < 4.0 / 11.0 {
            return pow(11.0 / 4.0, 2.0) * pow($0, 2.0)
        }
        if $0 < 8.0 / 11.0 {
            return 3.0 / 4.0 + pow(11.0 / 4.0, 2.0) * pow($0 - 6.0 / 11.0, 2.0)
        }
        if $0 < 10.0 / 11.0 {
            return 15.0 / 16.0 + pow(11.0 / 4.0, 2.0) * pow($0 - 9.0 / 11.0, 2.0)
        }
        return 63.0 / 64.0 + pow(11.0 / 4.0, 2.0) * pow($0 - 21.0 / 22.0, 2.0)
    }
    
    /// Returns a sine-wave easing function.
    ///
    /// - parameters:
    ///     - period: the number of full cycles to include (ie. frequency) (default is 1.0)
    ///     - phaseShift: the proportion of a full cycle to shift the phase by (default is 0.0)
    ///     - amplitude: multiplier for the amplitude (default is 1.0)
    ///     - yOffset: the vertical offset to apply (default is 0.0)
    static func sinEase(period: TweenFloat = 1.0, phaseShift: TweenFloat = 0.0, amplitude: TweenFloat = 1.0, yOffset: TweenFloat = 0.0) -> TweenFunction {
        return {
            sin(TweenFloat($0) * TweenFloat.pi * 2.0 * period - phaseShift * TweenFloat.pi * 2.0) * amplitude + yOffset
        }
    }
    
    static let sinEaseIn = sinEase(period: 0.25, phaseShift: 0.25, yOffset: 1.0)
    static let sinEaseOut = sinEase(period: 0.25)
    static let sinEaseInOut = sinEase(period: 0.5, phaseShift: 0.25, amplitude: 0.5, yOffset: 0.5)
}
