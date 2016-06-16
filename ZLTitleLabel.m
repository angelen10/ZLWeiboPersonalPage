//
//  ZLTitleLabel.m
//  ZLNetEase
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 ANGELEN. All rights reserved.
//

#import "ZLTitleLabel.h"

@implementation ZLTitleLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    
    UIColor *normalColor = [UIColor whiteColor];
    UIColor *highlightedColor = [UIColor orangeColor];
    
    CGFloat normalColorR = 0;
    CGFloat normalColorG = 0;
    CGFloat normalColorB = 0;
    
    CGFloat highlightedColorR = 0;
    CGFloat highlightedColorG = 0;
    CGFloat highlightedColorB = 0;
    
    size_t numOfComponents = CGColorGetNumberOfComponents(normalColor.CGColor);
    if (numOfComponents == 4) {
        const CGFloat *componemts = CGColorGetComponents(normalColor.CGColor);
        normalColorR = componemts[0];
        normalColorG = componemts[1];
        normalColorB = componemts[2];
    }
    
    size_t numOfComponents2 = CGColorGetNumberOfComponents(highlightedColor.CGColor);
    if (numOfComponents2 == 4) {
        const CGFloat *componemts = CGColorGetComponents(highlightedColor.CGColor);
        highlightedColorR = componemts[0];
        highlightedColorG = componemts[1];
        highlightedColorB = componemts[2];
    }
    
    CGFloat deltaR = highlightedColorR - normalColorR;
    CGFloat deltaG = highlightedColorG - normalColorG;
    CGFloat deltaB = highlightedColorB - normalColorB;

    [self setTitleColor:[UIColor colorWithRed:normalColorR + deltaR * scale
                                       green:normalColorG + deltaG * scale
                                        blue:normalColorB + deltaB * scale
                                        alpha:1] forState:UIControlStateNormal];
}



@end
