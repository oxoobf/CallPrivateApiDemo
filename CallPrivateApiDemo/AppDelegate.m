//
//  AppDelegate.m
//  CallPrivateApiDemo
//
//  Created by Henray Luo on 2016/12/11.
//  Copyright © 2016年 Henray Luo. All rights reserved.
//

#import "AppDelegate.h"
#import "JPEngine.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [JPEngine startEngine];
    
//    [JPEngine evaluateScript:@"\
//     var workSpace = require('LSApplicationWorkspace').defaultWorkspace();\
//     console.log(workSpace.allApplications());\
//     "];
    
    return YES;
}

@end
