# TweenAnimation
A drop-in replacement for CABasicAnimation that offers more flexible tweening.

## Usage
To see it in action, simply run the included iOS app -- it should work fine in the simulator or on a physical device.

To use in your own code, simply copy `TweenAnimation.swift` into your project. Once that's done, you can use `TweenAnimation` much like you would `CABasicAnimation` ([docs](https://developer.apple.com/documentation/quartzcore/cabasicanimation)):
```swift
let animation = TweenAnimation()
animation.keyPath = "translation.y"
animation.fromValue = 0.0
animation.toValue = 10.0
animation.duration = 1.0
(...)
```
...but instead of setting `timingFunction` to control the way your values are interpolated, you set `tweenFunction`. You can use a predefined tween / ease function like `sinEaseInOut`:
```swift
(...)
animation.tweenFunction = TweenAnimation.sinEaseInOut
myScnNode.addAnimation(animation, forKey: "myAnimation")
```
...or a custom tween function of your own devising:
```swift
(...)
animation.tweenFunction = {
    return $0 * ($0 + 0.02) * (50.0/51.0)
}
myScnNode.addAnimation(animation, forKey: "myAnimation")
```

If you provide a custom tween function, the input it receives will be a normalized time value (ie. from 0.0 to 1.0), and the output it provides (typically also from 0.0 to 1.0, but not necessarily) will be used, at the given time, as a multiplier for the difference between the initial and final values.

Internally, `TweenAnimation` uses the typealias `TweenFloat` for its floating-point calculations. You can rebind that typealias to `Double`, `Float` or `CGFloat` to reflect whichever native data type you'll be working with most in your code, to minimize the amount of explicit casting / type conversion necessary.

Note that while `CABasicAnimation` [doesn't actually require](https://developer.apple.com/documentation/quartzcore/cabasicanimation) you to set any `from`/`by`/`to` values, `TweenAnimation` will only work if at least two of `fromValue`, `byValue`, and `toValue` are set (if all three are set, `byValue` is ignored).

The demo project uses Xcode 9 and Swift 4, but the code will also work as-is with Swift 3; it doesn't use any Swift-4-specific syntax or language features.

## See Also
- [TFAnimation](https://github.com/luowenxing/TFAnimation/)
- [GreenSock Ease Visualizer](https://greensock.com/ease-visualizer)
