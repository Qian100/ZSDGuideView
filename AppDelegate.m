//
//  AppDelegate.m
//  ZSDGuideView
//
//  Created by 胡晓桥 on 14-8-7.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import "AppDelegate.h"

#import "ZSDGuideViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //增加标识，用于判断是否是第一次启动应用...
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunched"];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunched"])
    {
        [ZSDGuideViewController show];
    }
    
    return YES;
}
							

@end
