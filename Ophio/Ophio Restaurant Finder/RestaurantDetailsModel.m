//
//  RestaurantDataModel.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "RestaurantDetailsModel.h"

@implementation RestaurantDetailsModel
-(BOOL) doesRestaurantExists{
    self.sqliteManager =[[SqliteManager alloc]init];
    BOOL isRestaurantNew =[self.sqliteManager recordExistsForRestaurant:self.name];
    return  isRestaurantNew;
}
-(BOOL) createNewRestaurant{
    self.sqliteManager =[[SqliteManager alloc]init];
    [self.sqliteManager openDatabase];
    BOOL success =[self.sqliteManager createRestaurantWithName:self.name];
    [self.sqliteManager closeDatabase];
    return  success;
}
-(NSInteger) getRestaurantID{
    self.sqliteManager =[[SqliteManager alloc]init];
     [self.sqliteManager openDatabase];
    NSInteger idNumber = [self.sqliteManager fetchIDForRestaurant:self.name];
    [self.sqliteManager closeDatabase];
    return idNumber;
}
-(NSInteger) getTotalVisitsForRestaurant:(NSInteger)restaurantID{
    self.sqliteManager =[[SqliteManager alloc]init];
    [self.sqliteManager openDatabase];
    NSInteger visitsMade = [self.sqliteManager readNumberOfVisitForRestaurantId:restaurantID];
    [self.sqliteManager closeDatabase];
    return visitsMade;
}

-(BOOL) getBlockedStatusForRestaurantId:(NSInteger)restaurantID{
    self.sqliteManager =[[SqliteManager alloc]init];
    [self.sqliteManager openDatabase];
    BOOL isCurrentlyBlocked = [self.sqliteManager readCurrentBlockedStatusForRestaurantId:restaurantID];
    [self.sqliteManager closeDatabase];
    return isCurrentlyBlocked;
}

-(NSMutableArray *) getReviewsForRestaurantId:(NSInteger)restaurantID{
    self.sqliteManager =[[SqliteManager alloc]init];
    [self.sqliteManager openDatabase];
    
    NSMutableArray *reviews = [self.sqliteManager readAllReviewsForRestaurantId:restaurantID];
    [self.sqliteManager closeDatabase];
    return reviews;
    
}

-(BOOL) saveReview:(NSString *)review forRestaurantId:(NSInteger) restaurantID{
    self.sqliteManager =[[SqliteManager alloc]init];
    [self.sqliteManager openDatabase];
   
    BOOL success =[self.sqliteManager createReview:review forRestaurantId:restaurantID];
     [self.sqliteManager closeDatabase];
    return  success;
    
}
-(NSMutableArray *) getAllBlockedRestaurants{
    self.sqliteManager =[[SqliteManager alloc]init];
    [self.sqliteManager openDatabase];
    
    NSMutableArray *blockedAccounts = [self.sqliteManager readBlockedRestaurants];
    [self.sqliteManager closeDatabase];
    return blockedAccounts;
    
}
-(BOOL) increaseVisitCountForRestaurantId:(NSInteger) restaurantID to:(NSInteger)newCount{
    self.sqliteManager =[[SqliteManager alloc]init];
    [self.sqliteManager openDatabase];
   
    BOOL success =[self.sqliteManager updateNumberOfVisitsForRestaurantId:restaurantID to:newCount];
     [self.sqliteManager closeDatabase];
    return  success;
    
}
-(BOOL) changeBlockStatusForRestaurnatId:(NSInteger) restaurantID to:(BOOL)updatedTo{
    self.sqliteManager =[[SqliteManager alloc]init];
    [self.sqliteManager openDatabase];
    BOOL success =[self.sqliteManager updateBlockedStatusForRestaurantId:restaurantID to:updatedTo];
     [self.sqliteManager closeDatabase];
    return  success;
}
@end
