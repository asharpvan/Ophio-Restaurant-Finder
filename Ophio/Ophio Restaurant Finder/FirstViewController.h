//
//  ViewController.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentLocationFinder.h"
#import "RestaurantFinder.h"
#import "PSBlinkingMultiColoredLabel.h"
@interface FirstViewController : UIViewController <CurrentLocationFinderDelegate,RestaurantFinderDelegate,BlinkingLabelDelegate>


@end

