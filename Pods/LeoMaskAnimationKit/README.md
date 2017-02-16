# LeoMaskAnimationKit

[![CI Status](http://img.shields.io/travis/leoMobileDeveloper/LeoMaskAnimationKit.svg?style=flat)](https://travis-ci.org/leoMobileDeveloper/LeoMaskAnimationKit)
[![Version](https://img.shields.io/cocoapods/v/LeoMaskAnimationKit.svg?style=flat)](http://cocoapods.org/pods/LeoMaskAnimationKit)
[![License](https://img.shields.io/cocoapods/l/LeoMaskAnimationKit.svg?style=flat)](http://cocoapods.org/pods/LeoMaskAnimationKit)
[![Platform](https://img.shields.io/cocoapods/p/LeoMaskAnimationKit.svg?style=flat)](http://cocoapods.org/pods/LeoMaskAnimationKit)

##Gif
 <img src="https://raw.github.com/LeoMobileDeveloper/LeoMaskAnimationKit/master/ScreenShots/gif1.gif" width="200" /><img src="https://raw.github.com/LeoMobileDeveloper/LeoMaskAnimationKit/master/ScreenShots/gif2.gif" width="200" /><img src="https://raw.github.com/LeoMobileDeveloper/LeoMaskAnimationKit/master/ScreenShots/gif3.gif" width="200" /><img src="https://raw.github.com/LeoMobileDeveloper/LeoMaskAnimationKit/master/ScreenShots/gif4.gif" width="200" />

##With the methods,you can easy create a tableview cell like this
<img src="https://raw.github.com/LeoMobileDeveloper/LeoMaskAnimationKit/master/ScreenShots/gif5.gif" width="200" />

## Requirements

- ARC

## Installation

LeoMaskAnimationKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LeoMaskAnimationKit"
```
## How to use

<font color="red" size="3">Should in same coordinate when using mask</font>

Circle view mask

```
-(void)leo_animateCircleMaskWithduration:(NSTimeInterval)duration
                                   delay:(NSTimeInterval)delay
                               clockwise:(BOOL)clockwise
                                 options:(LeoMaskAnimationOptions)options
                             compeletion:(void(^)(void))completion;
```
Mask a view from any direction


```
-(void)leo_animateRectExpandDirection:(LeoMaskAnimationDirections)directions
                             duration:(NSTimeInterval)duration
                                delay:(NSTimeInterval)delay
                              options:(LeoMaskAnimationOptions)options
                          compeletion:(void(^)(void))completion;
```

Mask between rects

```
-(void)leo_animateMaskFromRect:(CGRect)fromRect
                    toRect:(CGRect)toRect
                  duration:(NSTimeInterval)duration
                     delay:(NSTimeInterval)delay
                       options:(LeoMaskAnimationOptions)options
                   compeletion:(void(^)(void))completion;
```

Mask between path

```

-(void)leo_animateMaskFromPath:(UIBezierPath *)fromPath
                    toPath:(UIBezierPath *)toPath
                  duration:(NSTimeInterval)duration
                     delay:(NSTimeInterval)delay
                       options:(LeoMaskAnimationOptions)options
                   compeletion:(void(^)(void))completion;
```


## Author

leoMobileDeveloper, leomobiledeveloper@gmail.com

## License

LeoMaskAnimationKit is available under the MIT license. See the LICENSE file for more info.
