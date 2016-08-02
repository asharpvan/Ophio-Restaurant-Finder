//
//  AddReviewViewController.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 01/05/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RestaurantDetailsModel;
@interface AddReviewViewController : UIViewController <UITextViewDelegate,UIAlertViewDelegate>
-(instancetype) initWithForRestaurant:(RestaurantDetailsModel *) restaurant;
@end
