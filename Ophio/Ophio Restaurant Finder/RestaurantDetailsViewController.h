//
//  RestaurantDetailsViewController.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  RestaurantDetailsModel;
@interface RestaurantDetailsViewController : UIViewController

-(instancetype) initWithRestaurant:(RestaurantDetailsModel *) restaurantPassed;
@end
