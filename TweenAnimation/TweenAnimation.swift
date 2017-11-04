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
    
    // The standard smooth tweens, ordered from gentlest to strongest, are:
    // sin (sine)
    // power2 (quadratic, square)
    // power3 (cubic)
    // power4 (quartic)
    // power5 (quintic)
    // The expo (exponential) tween is initially slightly gentler than power4, but crosses it
    // around the x=0.3 mark, and then crosses power5 around the x=0.5 mark.
    // The circ (circular) tween is also similar, but not directly comparable to the others because
    // of its dfferent shape: it's initially between power2 and power3, but then
    // gets stronger, becoming (at its very tail end) even steeper than expo.
    // Graphs of the tweens can be compared at https://www.desmos.com/calculator/mjrsot0kyc
    // or https://greensock.com/ease-visualizer (note that GreenSock calls quadratic "power1", cubic "power2" etc.)
    
    /// Returns a sine-wave easing function.
    ///
    /// - parameters:
    ///     - period: the number of full cycles to include (ie. frequency) (default is 1.0)
    ///     - phaseShift: the proportion of a full cycle to shift the phase by (default is 0.0)
    ///     - amplitude: multiplier for the amplitude (default is 1.0)
    ///     - yOffset: the vertical offset to apply (default is 0.0)
    static func sinEase(period: TweenFloat = 1.0, phaseShift: TweenFloat = 0.0, amplitude: TweenFloat = 1.0, yOffset: TweenFloat = 0.0) -> TweenFunction {
        return {
            // y = sin(x * 2pi * period - 2pi * phaseShift) * amplitude + yOffset
            sin($0 * TweenFloat.pi * 2.0 * period - TweenFloat.pi * 2.0 * phaseShift) * amplitude + yOffset
        }
    }
    
    static let sinEaseIn = sinEase(period: 0.25, phaseShift: 0.25, yOffset: 1.0)  // y = sin(x * 2pi * 0.25 - 2pi * 0.25) + 1.0
    static let sinEaseOut = sinEase(period: 0.25)   // y = sin(x * 2pi * 0.25)
    static let sinEaseInOut = sinEase(period: 0.5, phaseShift: 0.25, amplitude: 0.5, yOffset: 0.5)  // y = sin(x * 2pi * 0.5 - 2pi * 0.25) * 0.5 + 0.5
    
    static let power2EaseIn: TweenFunction = {
        // y = x^2
        pow($0, 2.0)
    }
    
    static let power2EaseOut: TweenFunction = {
        // y = -(x-1)^2 + 1
        $0 * (2.0 - $0)
    }
    
    static let power2EaseInOut: TweenFunction = {
        if $0 < 0.5 {
            // y = 2^1 * x^2
            return 2.0 * $0 * $0
        } else {
            // y = -2^1 * (x-1)^2 + 1
            return -1.0 + (4.0 - 2.0 * $0) * $0
        }
    }
    
    static let power3EaseIn: TweenFunction = {
        // y = x^3
        pow($0, 3.0)
    }
    
    static let power3EaseOut: TweenFunction = {
        // y = (x-1)^3 + 1
        pow(($0 - 1.0), 3.0) + 1.0
    }
    
    static let power3EaseInOut: TweenFunction = {
        if $0 < 0.5 {
            // y = 2^2 * x^3
            return 4.0 * pow($0, 3.0)
        } else {
            // y = 2^2 * (x-1)^3 + 1
            return ($0 - 1.0) * pow((2.0 * $0 - 2.0), 2.0) + 1.0
        }
    }
    
    static let power4EaseIn: TweenFunction = {
        // y = x^4
        pow($0, 4.0)
    }
    
    static let power4EaseOut: TweenFunction = {
        // y = -(x-1)^4 + 1
        1.0 - pow(($0 - 1.0), 4.0)
    }
    
    static let power4EaseInOut: TweenFunction = {
        if $0 < 0.5 {
            // y = 2^3 * x^4
            return 8.0 * pow($0, 4.0)
        } else {
            // y = -2^3 * (x-1)^4 + 1
            return -0.5 * pow((2.0 * $0 - 2.0), 4.0) + 1.0
        }
    }
    
    static let power5EaseIn: TweenFunction = {
        // y = x^5
        pow($0, 5.0)
    }
    
    static let power5EaseOut: TweenFunction = {
        // y = (x-1)^5 + 1
        pow($0 - 1.0, 5.0) + 1.0
    }
    
    static let power5EaseInOut: TweenFunction = {
        if $0 < 0.5 {
            // y = 2^4 * x^5
            return 16.0 * pow($0, 5.0)
        } else {
            // y = 2^4 * (x-1)^5 + 1
            return 16.0 * pow($0 - 1.0, 5.0) + 1.0
        }
    }
    
    static let expoEaseIn: TweenFunction = {
        // y = 2^(10 * (x-1)) (except start point)
        return $0 == 0.0 ? 0.0 : pow(2.0, 10.0 * ($0 - 1.0))
    }
    
    static let expoEaseOut: TweenFunction = {
        // y = -2^(-10x) + 1 (except end point)
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
            // y = 2^-1 * 2^(10 * (2x-1))
            return 0.5 * pow(2.0, 10.0 * (2.0 * $0 - 1.0))
        } else {
            // y = -2^-1 * 2^(-10 * (2x-1)) + 1.0
            return -0.5 * pow(2.0, -10.0 * (2.0 * $0 - 1.0)) + 1.0
        }
    }
    
    static let circEaseIn: TweenFunction = {
        // y = -sqrt(1 - x^2) + 1
        -1.0 * sqrt(1.0 - pow($0, 2.0)) + 1.0
    }
    
    static let circEaseOut: TweenFunction = {
        // y = sqrt(1 - (x-1)^2)
        sqrt(1.0 - pow($0 - 1.0, 2.0))
    }
    
    static let circEaseInOut: TweenFunction = {
        if $0 < 0.5 {
            // y = -0.5 * sqrt(1 - 4x^2) + 0.5
            return -0.5 * sqrt(1.0 - 4.0 * pow($0, 2.0)) + 0.5
        } else {
            // y = 0.5 * sqrt(1 - 4(x-1)^2) + 0.5
            return 0.5 * sqrt(1.0 - 4.0 * pow($0 - 1.0, 2.0)) + 0.5
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
    
    static let bounceEaseInOut: TweenFunction = {
        if $0 < 0.5 {
            return 0.5 * bounceEaseIn($0 * 2.0)
        } else {
            return 0.5 * bounceEaseOut(($0 - 0.5) * 2.0) + 0.5
        }
    }
    
    static let backEaseIn: TweenFunction = {
        $0 * $0 * (2.701_58 * $0 - 1.701_58)
    }
    
    static let backEaseOut: TweenFunction = {
        1.0 - backEaseIn(1.0 - $0)
    }
    
    static let backEaseInOut: TweenFunction = {
        if $0 < 0.5 {
            return 0.5 * backEaseIn($0 * 2.0)
        } else {
            return 0.5 * backEaseOut(($0 - 0.5) * 2.0) + 0.5
        }
    }
    
    static let elasticEaseIn: TweenFunction = {
        // y = 2^(10(x-1)) * sin((x - 0.925) * 2pi * 10/3)
        //return pow(2.0, 10.0 * ($0 - 1.0)) * sin(($0 - 0.925) * 2.0 * TweenFloat.pi / 0.3)
        let wobble = TweenFloat(0.3)
        let powTerm = pow(2.0, 10.0 * ($0 - 1.0))
        let sinTerm = sin(($0 - (1.0 - wobble * 0.25)) * 2.0 * TweenFloat.pi / wobble)
        return powTerm * sinTerm
    }
    
    static let elasticEaseOut: TweenFunction = {
        1.0 - elasticEaseIn(1.0 - $0)
    }
    
    static let elasticEaseInOut: TweenFunction = {
        if $0 < 0.5 {
            return 0.5 * elasticEaseIn($0 * 2.0)
        } else {
            return 0.5 * elasticEaseOut(($0 - 0.5) * 2.0) + 0.5
        }
    }
}
