//
//  ZSDGuideViewController.m
//  ZSDGuideView
//
//  Created by 胡晓桥 on 14-8-7.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define screenHeight [UIScreen mainScreen].bounds.size.height

#import "ZSDGuideViewController.h"

@interface ZSDGuideViewController ()<UIScrollViewDelegate>

@end

@implementation ZSDGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 

- (CGRect)onScreenFrame
{
    return [UIScreen mainScreen].applicationFrame;
}

- (CGRect)offscreenFrame
{
    CGRect frame = [self onScreenFrame];
    switch ([UIApplication sharedApplication].statusBarOrientation)
    {
        case UIInterfaceOrientationPortrait:
            frame.origin.y = frame.size.height;
            break;
            case UIInterfaceOrientationPortraitUpsideDown:
            frame.origin.y = -frame.size.height;
            break;
            case UIInterfaceOrientationLandscapeLeft:
            frame.origin.x = frame.size.width;
            break;
            case UIInterfaceOrientationLandscapeRight:
            frame.origin.x = -frame.size.width;
            break;
    }
    return frame;
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }else
    {
        return [app keyWindow];
    }
}

- (void)showGuide
{
    if(!_animating && self.view.superview == nil)
    {
        [ZSDGuideViewController sharedGuide].view.frame = [self offscreenFrame];
        [[self mainWindow] addSubview:[ZSDGuideViewController sharedGuide].view];
        
        _animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(guideShown)];
        [UIView commitAnimations];
    }
}

- (void)guideShown
{
    _animating = NO;
}

- (void)hideGuide
{
    if(!_animating && self.view.superview != nil)
    {
        _animating = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(guideHidden)];
        [ZSDGuideViewController sharedGuide].view.frame = [self offscreenFrame];
        [UIView commitAnimations];
    }
}

- (void)guideHidden
{
    _animating = NO;
    [[ZSDGuideViewController sharedGuide].view removeFromSuperview];
}

#pragma mark -

+ (ZSDGuideViewController *)sharedGuide
{
    @synchronized(self)
    {
        static ZSDGuideViewController *sharedGuide = nil;
        if(sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}

+ (void)show
{
    [[ZSDGuideViewController sharedGuide].pageScroll setContentOffset:CGPointMake(0.f, 0.f)];
    [[ZSDGuideViewController sharedGuide] showGuide];
}

+ (void)hide
{
    [[ZSDGuideViewController sharedGuide] hideGuide];
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *imgNameArr = [NSMutableArray arrayWithCapacity:4];
    
    for (int i = 1; i <= 4; i ++)
    {
        if(iPhone5)
        {
            //640 * 1136 屏幕引导页
            [imgNameArr addObject:[NSString stringWithFormat:@"640_1136_guide_%d",i]];
        }else
        {
            // 640 * 960 屏幕引导页
            [imgNameArr addObject:[NSString stringWithFormat:@"640_960_guide_%d",i]];
        }
        //扩展：适配iPhone6 屏幕
    }
    
    _pageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, screenHeight)];
    _pageScroll.pagingEnabled = YES;
    _pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * imgNameArr.count, screenHeight);
    _pageScroll.showsHorizontalScrollIndicator = NO;
    _pageScroll.delegate = self;
    [self.view addSubview:_pageScroll];
    
    NSString *imgName;
    UIImageView *imageView;
    for (int i = 0; i < imgNameArr.count; i ++)
    {
        imgName = [imgNameArr objectAtIndex:i];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, screenHeight)];
        imageView.image = [UIImage imageNamed:imgName];
        [self.pageScroll addSubview:imageView];
    }
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(120,self.view.frame.size.height - 80,80, 40)];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    [self.view addSubview:_pageControl];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page;
    page = (int)scrollView.contentOffset.x / 320;
    _pageControl.currentPage = page;
    
}

@end
