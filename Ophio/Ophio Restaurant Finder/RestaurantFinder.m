//
//  RestaurantFinder.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "RestaurantFinder.h"
#import "RestaurantDetailsModel.h"

@implementation RestaurantFinder

-(void)findRestaurantNear: (CLLocation *)location {
    // initiate the search request
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = @"restaurant";
    CLLocationCoordinate2D userLocation = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (userLocation, 10000, 10000);
    request.region = region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
         @autoreleasepool {
              NSLog(@"error: %@",error);
         __block NSMutableArray *restList = [NSMutableArray arrayWithCapacity:[response.mapItems count]];
             //check if we have the response
        if([[response mapItems] count] > 0){
            //If we have the response then we enumerate through it and then map the data with our data model
            [response.mapItems enumerateObjectsUsingBlock:^(MKMapItem *item, NSUInteger idx, BOOL *stop) {
//                NSLog(@"item : %@",item.name);
                RestaurantDetailsModel *restaurantDetails = [[RestaurantDetailsModel alloc]init];
                [restaurantDetails setName:item.name];
                [restaurantDetails setLocation:item.placemark.location];
                [restaurantDetails setHowFar:[NSNumber numberWithDouble:[location distanceFromLocation:item.placemark.location]/1000]];
                //get Restaurant Id
                 NSInteger ID = [restaurantDetails getRestaurantID];
                //use the restaurant id to get block status
                [restaurantDetails setIsBlocked:[restaurantDetails getBlockedStatusForRestaurantId:ID]];
                //and to fetch reviews
                [restaurantDetails setReviewsRecieved:[restaurantDetails getReviewsForRestaurantId:ID]];
                [restaurantDetails setVisitCount:[NSNumber numberWithInteger:[restaurantDetails getTotalVisitsForRestaurant:ID]]];
                //fetch the address
                NSString *temp=@"";
                for(int i=0;i<[[item.placemark.addressDictionary valueForKey:@"FormattedAddressLines"] count];i++) {
                    temp=[temp stringByAppendingString:[[item.placemark.addressDictionary valueForKey:@"FormattedAddressLines"] objectAtIndex:i]];
                    temp=[temp stringByAppendingString:@",\n"];
                }
                temp = [temp substringToIndex:[temp length]-1];
                [restaurantDetails setMailAddress:temp];
                [restaurantDetails setPhoneNumber:item.phoneNumber];
                [restaurantDetails setUrlAddress:[item.url absoluteString]];
                
                [restList addObject:restaurantDetails];
                if([restList count]==[[response mapItems] count]) {
                    //when the end is reached call the delegate
                    if([self.restaurantDelegate respondsToSelector:@selector(didFindRestaurants:)]){
                        [self.restaurantDelegate didFindRestaurants:[restList copy]];
                    }
                }
            }];
        }
        else {
                //if no retaurant found then then call delegate
                if([self.restaurantDelegate respondsToSelector:@selector(didFindRestaurants:)]){
                    [self.restaurantDelegate didFindRestaurants:[restList copy]];
                }
            }
         }
    }];
}
@end
