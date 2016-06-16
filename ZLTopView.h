//
//  ZLTopView.h
//  ZLWeiboPersonalPage
//
//  Created by angelen on 16/6/16.
//  Copyright © 2016年 ANGELEN. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  头像 view + 指示器 view
 */
@interface ZLTopView : UIView

/**
 *  头像
 */
@property (nonatomic, strong) UIView *profilePhoto;

/**
 *  标题 view
 */
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) BOOL canNotResponseTapTouchEvent;

@end
