//
//  CurrentLocationFinder.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol CurrentLocationFinderDelegate <NSObject>
//method called when coordinates are found
-(void)currentCoordinates:(CLLocation *)location;
//method called when coordinates are not found
-(void)failedToFindCurrentCoordinates:(NSError *)error;

@end

@interface CurrentLocationFinder : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locationManager;

@property(nonatomic , assign) id<CurrentLocationFinderDelegate> delegate;

//method to start location fetch
-(void)startUpdates;

@end
