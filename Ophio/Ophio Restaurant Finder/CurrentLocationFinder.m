//
//  CurrentLocationFinder.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "CurrentLocationFinder.h"
NSString *errorMessage;

BOOL didUpdate = NO;

@implementation CurrentLocationFinder
-(void)startUpdates {
    
    if (_locationManager == nil)
        _locationManager = [[CLLocationManager alloc] init];
    //set location manager delegate to itself
    [_locationManager setDelegate:self];
    // You have some options here, though higher accuracy takes longer to resolve.
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
    
    if( [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    //start location fetching
    [_locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error domain] == kCLErrorDomain) {
        
        NSLog(@"%@ : %ld",[error localizedDescription],[error code]);
        // We handle CoreLocation-related errors here
        switch ([error code]) {
                // "Don't Allow" on two successive app launches is the same as saying "never allow". The user
                // can reset this for all apps by going to Settings > General > Reset > Reset Location Warnings.
            case kCLErrorDenied:
                errorMessage=@"Authorization Related Issues.";
                break;
            case kCLErrorLocationUnknown:
                errorMessage=@"Location could not be determined";
                break;
            case kCLErrorNetwork:
                errorMessage=@"Network Related Issue";
                break;
            case kCLErrorGeocodeFoundNoResult:
                errorMessage=@"Could not Geocode location";
                break;
            default:
                errorMessage=@"God Knows!!";
                break;
        }
        NSLog(@"error message: %@ code: %ld",errorMessage,(long)[error code]);
        if([self.delegate respondsToSelector:@selector(failedToFindCurrentCoordinates:)]){
            [self.delegate failedToFindCurrentCoordinates:error];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //check if the location has already been updated
    if (didUpdate)
        return;
    //fetch the last returned location from locations array
    CLLocation* currentLocation = [locations lastObject];
    //check if location in question has horizontal accuracy of less than zero (possible when GPS returns old data)
    if (currentLocation.horizontalAccuracy < 0) {
        //if so return
        return;
    }
    //check if the interval between the last fetched and current fetched timestamp is greater than 3 (This discards old locations)
    if (abs([currentLocation.timestamp timeIntervalSinceNow])>3) {
        // if interval is greater than 3 return
        return;
    }
    //if horizontal accuracy is greater than 1420 then we do not have an accurate enough location -> discard whatever we have
    if (currentLocation.horizontalAccuracy > 1420) // was 70 earlier
        return;
    //update flag to yes
    didUpdate = YES;
    // Disable future updates to save power.
    [_locationManager stopUpdatingLocation];
    if([self.delegate respondsToSelector:@selector(currentCoordinates:)]){
        [self.delegate currentCoordinates:currentLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    // 0 - not determined - at the app start
    // 1, 2 - restricted / denied
//    NSLog(@"status: %d",status);
    CLAuthorizationStatus updatedStatus = kCLAuthorizationStatusAuthorized;
    if([manager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        updatedStatus = kCLAuthorizationStatusAuthorizedWhenInUse;
    if(status > 0 && status != updatedStatus){
        // if not_authorised
        NSLog(@"Please Enable Location Services");
    }
}
@end
