//
//  AppDelegate.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) FirstViewController *viewController;
@end

