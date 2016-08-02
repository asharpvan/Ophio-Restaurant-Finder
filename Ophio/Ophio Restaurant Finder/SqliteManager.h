//
//  SqliteManager.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 01/05/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
//@class  RestaurantDataModel;
@interface SqliteManager : NSObject
@property(nonatomic,assign) sqlite3 *dbHandle;
@property(nonatomic,strong) NSString *dbName;
//method to initialize
- (id)init;
//method to open database
-(void) openDatabase;
//method to close database
-(void) closeDatabase;

-(NSMutableArray *) readBlockedRestaurants;
-(BOOL) updateBlockedStatusForRestaurantId:(NSInteger)restaurantID to:(BOOL)newMode;
-(BOOL) readCurrentBlockedStatusForRestaurantId:(NSInteger)restaurantID;

-(BOOL) recordExistsForRestaurant:(NSString *)restaurantName;
-(NSInteger) fetchIDForRestaurant:(NSString *)restaurantName;


-(NSInteger) readNumberOfVisitForRestaurantId:(NSInteger)restaurantID;
-(BOOL) updateNumberOfVisitsForRestaurantId:(NSInteger)restaurantID to:(NSInteger) newCount;
-(BOOL) createRestaurantWithName:(NSString *)restaurantName;

-(BOOL) reviewsExistsForRestaurantId:(NSInteger)restaurantID;
-(BOOL) createReview:(NSString *)reviewRecieved forRestaurantId:(NSInteger)restaurantID;
-(NSMutableArray *) readAllReviewsForRestaurantId:(NSInteger)restaurantID;
@end
