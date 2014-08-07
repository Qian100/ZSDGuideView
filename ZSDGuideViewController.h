//
//  ZSDGuideViewController.h
//  ZSDGuideView
//
//  Created by 胡晓桥 on 14-8-7.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSDGuideViewController : UIViewController

@property (nonatomic, strong) UIScrollView *pageScroll;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) BOOL animating;

+ (ZSDGuideViewController *)sharedGuide;

+ (void)show;
+ (void)hide;

@end
