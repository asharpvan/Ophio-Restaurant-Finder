//
//  RestaurantDataModel.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SqliteManager.h"

//@class  CLLocation;

@interface RestaurantDetailsModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *urlAddress;
@property (nonatomic, strong) NSString *mailAddress;
@property (nonatomic, strong) NSNumber *howFar;
@property (nonatomic, strong) NSNumber *visitCount;
@property (nonatomic, strong) NSMutableArray *reviewsRecieved;
@property (nonatomic, assign) BOOL isBlocked;
@property (nonatomic) SqliteManager *sqliteManager;


-(BOOL) doesRestaurantExists;
-(BOOL) createNewRestaurant;
-(NSInteger) getRestaurantID;

-(NSInteger) getTotalVisitsForRestaurant:(NSInteger)restaurantID;
-(BOOL) getBlockedStatusForRestaurantId:(NSInteger)restaurantID;
-(NSMutableArray *) getReviewsForRestaurantId:(NSInteger)restaurantID; 
-(BOOL) saveReview:(NSString *)review forRestaurantId:(NSInteger) restaurantID;
-(NSMutableArray *) getAllBlockedRestaurants;

-(BOOL) increaseVisitCountForRestaurantId:(NSInteger) restaurantID to:(NSInteger)newCount;
-(BOOL) changeBlockStatusForRestaurnatId:(NSInteger) RestaurantID to:(BOOL)updatedTo;

@end
