//
//  MZMaskZoomTransitioningDelegate.h
//  MaskZoomTransition
//
//  Created by Steph Sharp on 16/12/2015.
//  Copyright © 2015 Stephanie Sharp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZMaskZoomTransitioningDelegate : NSObject <UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) UIView *smallView;
@property (nonatomic) BOOL dismissToZeroSize;

@end
