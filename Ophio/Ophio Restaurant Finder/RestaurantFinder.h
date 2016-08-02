//
//  RestaurantFinder.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol RestaurantFinderDelegate <NSObject>
//method called when restaurants are found
-(void)didFindRestaurants:(NSArray *)restaurantsList;
//method called when restaurants are not found "Though I'm not using it." - Pranav
-(void)didFailToFindRestaurant:(NSError *)error;

@end

@interface RestaurantFinder : NSObject <MKMapViewDelegate>

@property(nonatomic , assign) id<RestaurantFinderDelegate> restaurantDelegate;
//method to start the process of finding the restaurant given location
-(void) findRestaurantNear: (CLLocation *)location;

@end
