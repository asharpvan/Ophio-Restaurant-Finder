//
//  ViewController.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "FirstViewController.h"
#import "RestaurantDetailsModel.h"
#import "AllRestaurantsViewController.h"
#import "AssistViewController.h"
#import "PSCorneredButton.h"



@interface FirstViewController () {
    CurrentLocationFinder *fetchedUserLocation; // location manager
    PSBlinkingMultiColoredLabel *lbl_Blinking; //label to show restaurant names
    UILabel *lbl_Header; //label to indicate restaurant fetch
    UILabel *lbl_Or; //label that shows "OR"
    NSMutableArray *arrOfRestaurants;// holder for complete restaurant list
    PSCorneredButton *btn_All; //button to view all restaurant
    PSCorneredButton *btn_Assist; //button to seek help
    UIActivityIndicatorView *spinner; //show on going process
}

@end

@implementation FirstViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self setTitle:@"Ophio"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(!arrOfRestaurants){
        arrOfRestaurants = [NSMutableArray new];
    }
    else
        [arrOfRestaurants removeAllObjects];

    lbl_Header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    [lbl_Header setTextAlignment:NSTextAlignmentCenter];
    [lbl_Header setText:@"Please Wait. Info Fetched From 1 Restaurant"];
    [lbl_Header setNumberOfLines:0];
    [lbl_Header setAlpha:0.0f];
    [self.view addSubview:lbl_Header];
    
    
    lbl_Or = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
    [lbl_Or setTextAlignment:NSTextAlignmentCenter];
    [lbl_Or setText:@"OR"];
    [lbl_Or setNumberOfLines:0];
    [lbl_Or setAlpha:0.0f];
    [lbl_Or setCenter:self.view.center];
    [self.view addSubview:lbl_Or];
    
    btn_All = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
    [btn_All setFrame:CGRectMake(0, 0, self.view.frame.size.width-20, control_height)];
    [btn_All setTitle:@"View All Options" forState:UIControlStateNormal];
    [btn_All addTarget:self action:@selector(viewAllPressed) forControlEvents:UIControlEventTouchUpInside];
    [btn_All setCenter:CGPointMake(lbl_Or.center.x, lbl_Or.center.y-lbl_Or.frame.size.height/2 - btn_All.frame.size.height/2)];
    [btn_All setAlpha:0.0f];
    [self. view addSubview:btn_All];

    btn_Assist = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
    [btn_Assist setFrame:CGRectMake(0, 0, self.view.frame.size.width-20, control_height)];
    [btn_Assist setTitle:@"Need assistance in finding a place to eat" forState:UIControlStateNormal];
    [btn_Assist addTarget:self action:@selector(allowUsPressed) forControlEvents:UIControlEventTouchUpInside];
    [btn_Assist setCenter:CGPointMake(lbl_Or.center.x, lbl_Or.center.y+lbl_Or.frame.size.height/2 + btn_All.frame.size.height/2)];
    [btn_Assist setAlpha:0.0f];
    [self. view addSubview:btn_Assist];
    
    lbl_Blinking = [[PSBlinkingMultiColoredLabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0f)];
    [lbl_Blinking setBlinkDelegate:self];
    [lbl_Blinking setAlpha:0.0f];
    [self.view addSubview:lbl_Blinking];
    
    [lbl_Blinking setCenter:self.view.center];
    [lbl_Header setCenter:CGPointMake(self.view.center.x, lbl_Blinking.center.y-lbl_Blinking.frame.size.height/2 - lbl_Header.frame.size.height/2)];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(self.view.center.x,self.view.center.y)];
    [spinner setHidesWhenStopped:YES];
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
    //initialize the geocoder to fetch us current location
    if(!fetchedUserLocation) {
        fetchedUserLocation = [[CurrentLocationFinder alloc]init];
        [fetchedUserLocation setDelegate:self];
    }
    //start the process of fetching the current location
    [fetchedUserLocation startUpdates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Local Methods
-(void) viewAllPressed {
    //show the complete list view
    NSLog(@"List of Restaurants : %@",arrOfRestaurants);
    AllRestaurantsViewController *listView = [[AllRestaurantsViewController alloc]initWithRestaurant:arrOfRestaurants];
     [self.navigationController pushViewController:listView animated:YES];
}

-(void) allowUsPressed {
    //show assisted view
    AssistViewController *allowUsView = [[AssistViewController alloc]initWithRestaurant:arrOfRestaurants];
    [self.navigationController pushViewController:allowUsView animated:YES];

}

#pragma mark Current Location Finder Delegate Methods

-(void)currentCoordinates:(CLLocation *)location {
    //we have the current location
    RestaurantFinder *restaurantFinder = [[RestaurantFinder alloc]init];
    [restaurantFinder setRestaurantDelegate:self];
    //start the process of finding restaurant new the recieved location
    [restaurantFinder findRestaurantNear:location];
}

-(void) failedToFindCurrentCoordinates:(NSError *)error {
    //failed to find location
    NSLog(@"error: %@",error);
}

#pragma mark Restaurant Finder Delegate Methods

-(void) didFindRestaurants:(NSArray *)restaurantsList {
    // stop spinner
    [spinner stopAnimating];
    //check if the list is pre populated
    if([arrOfRestaurants count] > 0){
        //if so empty it
        [arrOfRestaurants removeAllObjects];
    }
    //update the restaurant list
    [arrOfRestaurants addObjectsFromArray:restaurantsList];
    //check if we have any restaurants at all
    if([arrOfRestaurants count] == 0) {
        //if no restaurants found then show the alert view controller
        if ([UIAlertController class])
        {
            // use UIAlertController  for iOS 8
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"Sorry No Resataurants Found!!"
                                       message:@"Must be the Internet"
                                       preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okayButton = [UIAlertAction actionWithTitle:@"Okay"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {
                                                                   
                                                               }];
            [alert addAction:okayButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            // use UIAlertView for iOS 7
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry No Resataurants Found!!"
                                                                message:@"Must be the Internet"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Okay", nil];
            [alertView show];
        }
   }
    else {
        //if we have the restaurant list
        //display the label showing: number of restaurants
        [lbl_Header setAlpha:1.0];
        __block NSMutableArray *nameList = [NSMutableArray new];
        //enumerate through the list and add the restaurant names to another array
        [arrOfRestaurants enumerateObjectsUsingBlock:^(RestaurantDetailsModel* obj, NSUInteger idx, BOOL *stop) {
            [nameList addObject:obj.name];
            if([nameList count]==[arrOfRestaurants count]){
                //once the end of restaurant list is reached
                [lbl_Blinking setAlpha:1.0f];
                //pass the array of names to blinking label
                [lbl_Blinking animateWithWords:[nameList copy] updatingLabel:lbl_Header];
            }
        }];
    }
}

-(void)didFailToFindRestaurant:(NSError *)error {
    NSLog(@"error: %@",error);
}

#pragma mark Animated Label Delegate Methods

-(void) LabelDidFinishBlinking {
    
    //remove blinking label and header label
   [lbl_Blinking removeFromSuperview];
    lbl_Blinking = nil;
    [lbl_Header removeFromSuperview];
    lbl_Header = nil;
    //animate the fade in of button and or label
    [UIView transitionWithView:lbl_Header duration:2.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //show other buttons and "OR"
        [btn_All setAlpha:1.0];
        [lbl_Or setAlpha:1.0];
        [btn_Assist setAlpha:1.0];
    } completion:^(BOOL finished) {    }];
}
@end
