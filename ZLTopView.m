//
//  ZLTopView.m
//  ZLWeiboPersonalPage
//
//  Created by angelen on 16/6/16.
//  Copyright © 2016年 ANGELEN. All rights reserved.
//

#import "ZLTopView.h"

//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@implementation ZLTopView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // Create your views here
        [self customizeUI];
    }
    return self;
}

- (void)customizeUI {
    
    self.profilePhoto = [[UIView alloc] init];
    self.profilePhoto.backgroundColor = [UIColor blueColor];
    [self addSubview:self.profilePhoto];
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor greenColor];
    self.label.text = @"头像";
    [self addSubview:self.label];
    
    self.titleView = [[UIView alloc] init];
    self.titleView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.titleView];
    
    // 头像约束
    [self.profilePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(64 + 20);
        make.size.mas_equalTo(30);
    }];

    // 昵称约束
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(72);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    // titleView 约束
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(self);
        make.height.equalTo(40);
    }];
}

// tell UIKit that you are using AutoLayout
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    // remake/update constraints here, remember to open if use
//    [self.titleView remakeConstraints:^(MASConstraintMaker *make) {
//        
//    }];
    [super updateConstraints];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_canNotResponseTapTouchEvent) {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

@end
