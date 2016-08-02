//
//  AllowUsViewController.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 01/05/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssistViewController : UIViewController <UIAlertViewDelegate>
-(instancetype) initWithRestaurant:(NSMutableArray *) restaurantList;
@end
