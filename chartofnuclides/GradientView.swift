//
//  GradientView.swift
//  GradientLoadingBar
//
//  Created by Felix Mau on 10.12.16.
//  Copyright © 2016 Felix Mau. All rights reserved.
//

import Foundation
import UIKit

class GradientView : UIView, CAAnimationDelegate {
    private let config = (
        fadeInAnimationKey: "GradientView--fade-in",
        fadeOutAnimationKey: "GradientView--fade-out",
        progressAnimationKey: "GradientView--progress"
    )
    
    private var gradientLayer : CAGradientLayer!
    private var gradientLayer2 : CAGradientLayer!
    
    private var durations : Durations
    
    required init?(coder aDecoder: NSCoder) {
        durations = Durations()
        super.init(coder: aDecoder)
        print("ADecoder init is called")
    }
    
    func initalizeLayers(with frame: CGRect) {
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = CGRect(x: 0, y: frame.height - 85, width: 3 * frame.size.width, height: frame.size.height)
        
        self.gradientLayer2 = CAGradientLayer()
        self.gradientLayer2.frame = CGRect(x: 0, y: frame.height - 85, width: 3 * frame.size.width, height: frame.size.height)
        
        self.gradientLayer.anchorPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer.position = CGPoint(x: -2 * frame.size.width, y: frame.height - 85)
        
        self.gradientLayer2.anchorPoint = CGPoint(x: 0, y: 0)
        self.gradientLayer2.position = CGPoint(x: -4.4 * frame.size.width, y: frame.height - 85)
        
        self.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0);
        self.gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0);
        
        self.gradientLayer2.startPoint = CGPoint(x: 0.0, y: 0.0);
        self.gradientLayer2.endPoint = CGPoint(x: 1.0, y: 0.0);
        
        // Colors from http://www.cssscript.com/ios-style-gradient-progress-bar-with-pure-css-css3/
        let gradientColors = [
            UIColor(hexString:"#30DF96").cgColor,
            UIColor(hexString:"#FFFFFF").cgColor
        ]
        
        // Append reversed gradient to simulate infinte animation
        self.gradientLayer.colors = gradientColors + gradientColors.reversed() + gradientColors;
        self.gradientLayer2.colors = self.gradientLayer.colors
        //self.gradientLayer2.colors = gradientColors.reversed() + gradientColors + gradientColors.reversed();
        self.gradientLayer2.colors = [gradientColors[0], gradientColors[0], gradientColors[1] , gradientColors[1], gradientColors[0], gradientColors[0]]
        self.gradientLayer.colors = self.gradientLayer2.colors
        
        // Add layer to view
        
        self.layer.insertSublayer(gradientLayer2, at: 0)
        self.layer.insertSublayer(gradientLayer, at: 0)

    }
    
    override func awakeFromNib() {
        print("Awake from nib called")
        super.awakeFromNib()
        self.initalizeLayers(with: self.frame)
        show()
        
    }
    
    // MARK: Progress animations (automatically triggered via delegates)
    
    func animationDidStart(_ anim: CAAnimation) {
        if (anim == self.gradientLayer.animation(forKey: config.fadeInAnimationKey)) {
            // Start progress animation
            startAnimating()
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if (anim == self.gradientLayer.animation(forKey: config.fadeOutAnimationKey)) {
            // Stop progress animation
            self.gradientLayer.removeAnimation(forKey: self.config.progressAnimationKey)
        }
    }
    
    // MARK: Fade-In / Out
    
    func toggleGradientLayerVisibility(duration: TimeInterval, from: CGFloat, to: CGFloat, key: String) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.delegate = self
        
        animation.duration = duration
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = "forwards"
        animation.isRemovedOnCompletion = false
        
        self.gradientLayer.add(animation, forKey: key)
    }
    
    func show() {
        self.gradientLayer.removeAnimation(forKey: config.fadeOutAnimationKey)
        self.toggleGradientLayerVisibility(
            duration: durations.fadeIn,
            from: 0.0,
            to: 1.0,
            key: config.fadeInAnimationKey
        )
    }
    
    func hide() {
        self.gradientLayer.removeAnimation(forKey: config.fadeInAnimationKey)
        self.toggleGradientLayerVisibility(
            duration: durations.fadeOut,
            from: 1.0,
            to: 0.0,
            key: config.fadeOutAnimationKey
        )
    }
    
    func startAnimating() {
        // Start progress animation
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: -2 * self.frame.size.width, y: 0)
        animation.toValue = CGPoint(x: 1.0 * self.frame.size.width, y: 0)
        animation.duration = 2.5
        animation.delegate = self
        //animation.repeatCount = Float.infinity
        
        let move = CABasicAnimation(keyPath: "position")
        move.fromValue = CGPoint(x: 1.0 * self.frame.size.width, y: 0)
        move.toValue = CGPoint(x: 1.0 * self.frame.size.width, y: 0)
        move.duration = 2.5
        move.beginTime = CACurrentMediaTime() + 2.0
        move.delegate = self
        
        let group = CAAnimationGroup()
        group.animations = [animation, move]
        group.repeatCount = Float.infinity
        group.duration = 2.5
        group.delegate = self
        
        self.gradientLayer.add(group, forKey: config.progressAnimationKey)
        
        //self.gradientLayer.add(animation, forKey: config.progressAnimationKey)
   
        // Start progress animation
        let animation2 = CABasicAnimation(keyPath: "position")
        animation2.fromValue = CGPoint(x: -4.4 * self.frame.size.width, y: 0)
        animation2.toValue = CGPoint(x: -2.0*self.frame.width, y: 0)
        animation2.duration = 2.5
        animation2.repeatCount = Float.infinity
        
        let move2 = CABasicAnimation(keyPath: "position")
        move2.fromValue = CGPoint(x: -2.0*self.frame.width, y: 0)
        move2.toValue = CGPoint(x: -2.0*self.frame.width, y: 0)
        move2.duration = 0.6
        move2.beginTime = CACurrentMediaTime() + 0.6
        
        let group2 = CAAnimationGroup()
        group2.animations = [animation2, move2]
        group2.repeatCount = Float.infinity
        group2.duration = 2.5
        
        self.gradientLayer2.add(group2, forKey: config.progressAnimationKey)
    }

}
