//
//  UIView+LeoMaskAnimation.h
//  LeoMaskAnimationKit
//
//  Created by huangwenchen on 15/12/26.
//  Copyright © 2015年 WenchenHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,LeoMaskAnimationOptions){
    LeoMaskAnimationOptionLiner,
    LeoMaskAnimationOptionEaseIn,
    LeoMaskAnimationOptionEaseOut,
    LeoMaskAnimationOptionEaseInOut,
    LeoMaskAnimationOptionDefault,
};
typedef NS_ENUM(NSInteger,LeoMaskAnimationDirections){
    LeoMaskAnimationDirectionLeftToRight,
    LeoMaskAnimationDirectionTopToBottom,
    LeoMaskAnimationDirectionRightToLeft,
    LeoMaskAnimationDirectionBottomToTop,
    LeoMaskAnimationDirectionLeftTopToRightBottom,
    LeoMaskAnimationDirectionLeftBottomToRightTop,
    LeoMaskAnimationDirectionRightTopToLeftBottom,
    LeoMaskAnimationDirectionRightBottomToLeftTop,
};

@interface UIView (LeoMaskAnimation)

-(void)leo_animateRectExpandDirection:(LeoMaskAnimationDirections)directions
                             duration:(NSTimeInterval)duration
                                delay:(NSTimeInterval)delay
                                alpha:(CGFloat)alpha
                              options:(LeoMaskAnimationOptions)options
                          compeletion:(void(^)(void))completion;

-(void)leo_animateMaskFromRect:(CGRect)fromRect
                    toRect:(CGRect)toRect
                  duration:(NSTimeInterval)duration
                     delay:(NSTimeInterval)delay
                         alpha:(CGFloat)alpha
                       options:(LeoMaskAnimationOptions)options
                   compeletion:(void(^)(void))completion;


-(void)leo_animateMaskFromPath:(UIBezierPath *)fromPath
                    toPath:(UIBezierPath *)toPath
                  duration:(NSTimeInterval)duration
                     delay:(NSTimeInterval)delay
                         alpha:(CGFloat)alpha
                       options:(LeoMaskAnimationOptions)options
                   compeletion:(void(^)(void))completion;


-(void)leo_animateCircleMaskWithduration:(NSTimeInterval)duration
                                   delay:(NSTimeInterval)delay
                               clockwise:(BOOL)clockwise
                                 options:(LeoMaskAnimationOptions)options
                             compeletion:(void(^)(void))completion;

-(void)leo_animateCircleExpandFromView:(UIView *)fromView
                      duration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                                 alpha:(CGFloat)alpha
                       options:(LeoMaskAnimationOptions)options
                           compeletion:(void(^)(void))completion;

-(void)leo_animateCircleExpandCenter:(CGPoint)center
                              radius:(CGFloat)radius
                            duration:(NSTimeInterval)duration
                               delay:(NSTimeInterval)delay
                               alpha:(CGFloat)alpha
                             options:(LeoMaskAnimationOptions)options
                         compeletion:(void (^)(void))completion;

-(void)leo_animateReverseCircleExpandToView:(UIView *)toView
                                     duration:(NSTimeInterval)duration
                                        delay:(NSTimeInterval)delay
                                        alpha:(CGFloat)alpha
                                      options:(LeoMaskAnimationOptions)options
                                   completion:(void (^)(void))completion;

-(void)leo_animateReverseCircleExpandCenter:(CGPoint)center
                              radius:(CGFloat)radius
                            duration:(NSTimeInterval)duration
                               delay:(NSTimeInterval)delay
                               alpha:(CGFloat)alpha
                             options:(LeoMaskAnimationOptions)options
                         compeletion:(void (^)(void))completion;

-(void)leo_animateReverseMaskFromPath:(UIBezierPath *)fromPath
                               toPath:(UIBezierPath *)toPath
                             duration:(NSTimeInterval)duration
                                delay:(NSTimeInterval)delay
                                alpha:(CGFloat)alpha
                              options:(LeoMaskAnimationOptions)options
                          compeletion:(void(^)(void))completion;

-(void)leo_removeMaskAnimations;
@end
