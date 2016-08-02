//
//  AllowUsViewController.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 01/05/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "AssistViewController.h"
#import "RestaurantDetailsModel.h"
#import "AllRestaurantsViewController.h"
#import "PSCorneredButton.h"


@interface AssistViewController (){
    UILabel *lbl_Question; //label to show the question
    PSCorneredButton *btn_less1km; //button to show restaurants within 1 km distance
    PSCorneredButton *btn_More1km; //button to show restaurants more 1 km distance
    NSMutableArray *arr_CompleteList; //array to hold complete list of restaurants
    NSMutableArray *arr_AssistedList; //array to hold list of suggested restaurants
}

@end

@implementation AssistViewController
-(instancetype) initWithRestaurant:(NSMutableArray *) restaurantList{
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self setTitle:@"Assistive Help"];
        
        if(!arr_CompleteList)
            arr_CompleteList = [NSMutableArray new];
        [arr_CompleteList removeAllObjects];
        
        arr_CompleteList = restaurantList;
        
        lbl_Question = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
        [lbl_Question setTextAlignment:NSTextAlignmentCenter];
        [lbl_Question setText:@"How far should the Restaurant be?"];
        [lbl_Question setNumberOfLines:0];
        [lbl_Question setCenter: CGPointMake(self.view.center.x, self.view.center.y-(lbl_Question.frame.size.height/2+large_padding))];
        [self.view addSubview:lbl_Question];
       
        
        btn_less1km = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
        [btn_less1km setFrame:CGRectMake(large_padding, 0, (self.view.frame.size.width-4*large_padding)/2 , 44.0f)];
        [btn_less1km setTitle:@"Less than 1 Km" forState:UIControlStateNormal];
        [btn_less1km setTag:0];
        [btn_less1km addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn_less1km setCenter: CGPointMake(btn_less1km.center.x, self.view.center.y+(btn_less1km.frame.size.height/2+large_padding))];
        [self. view addSubview:btn_less1km];
        
        btn_More1km = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
        [btn_More1km setFrame:CGRectMake(self.view.center.x+large_padding/2, 0, (self.view.frame.size.width-4*large_padding)/2 , 44.0f)];
        [btn_More1km setTitle:@"More than 1 Kms" forState:UIControlStateNormal];
        [btn_More1km setTag:1];
        [btn_More1km addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btn_More1km setCenter: CGPointMake(btn_More1km.center.x, self.view.center.y+(btn_More1km.frame.size.height/2+large_padding))];
        [self. view addSubview:btn_More1km];
     }
    return self;
}


-(void)buttonPressed:(id)sender {
    //check whether suggestion array is pre-created
    if(!arr_AssistedList)
        //if not create it
        arr_AssistedList = [NSMutableArray new];
    else
        //if pre created then ensure that it is empty
        [arr_AssistedList removeAllObjects];
    //enumerate through the list of complete array list
    [arr_CompleteList enumerateObjectsUsingBlock:^(RestaurantDetailsModel *obj, NSUInteger idx, BOOL *stop) {
        //if less than 1km. Find all matching restaurants and add to suggestion
        if ([sender tag]==0 && [obj.howFar floatValue] <= 1) {
            [arr_AssistedList addObject:obj];
        }
        // if more than 1km. Find all matching restaurants and add to suggestion
        else if ([sender tag]==1 && [obj.howFar floatValue] > 1) {
            [arr_AssistedList addObject:obj];
        }
    }];
    
    //check whether we have any restaurants in the suggestion array
    if([arr_AssistedList count] ==0) {
        //if not
        if ([UIAlertController class])
        {
            // use UIAlertController  for iOS 8
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"No Restaurants Found"
                                       message:@"we couldn't find restaurants matching your search parameter"
                                       preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* viewAllButton = [UIAlertAction actionWithTitle:@"View all"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {
                                                                      AllRestaurantsViewController *listView = [[AllRestaurantsViewController alloc]initWithRestaurant:arr_CompleteList];
                                                                      [self.navigationController pushViewController:listView animated:YES];
                                                                        }];
            UIAlertAction* tryAgain = [UIAlertAction actionWithTitle:@"Try Again"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * action) {
                                                                  }];
            [alert addAction:tryAgain];
            [alert addAction:viewAllButton];
           
 [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            // use UIAlertView for iOS 7
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Restaurants Found"
                                                            message:@"we couldn't find restaurants matching your search parameter"
                                                            delegate:self
                                                            cancelButtonTitle:@"Try Again"
                                                            otherButtonTitles:@"View All", nil];
            [alertView show];
        }
    }
    else {
        //if restaurants are found in suggestions array
        RestaurantDetailsModel *model = [[RestaurantDetailsModel alloc]init];
        //check if we have any blocked restaurants
        NSMutableArray *banned = [model getAllBlockedRestaurants];
        //enumerate through the blocked restaurants
        [banned enumerateObjectsUsingBlock:^(NSString *obj1, NSUInteger idx1, BOOL *stop1) {
            //enumerate through the suggested restaurants
            [arr_AssistedList enumerateObjectsUsingBlock:^(RestaurantDetailsModel *obj2, NSUInteger idx2, BOOL *stop2) {
                //if any blocked restaurant is found to be on suggested array then remove that occurrance
                if ([obj1 isEqualToString:obj2.name]) {
                    [arr_AssistedList removeObjectAtIndex:idx2];
                }
            }];
        }];
        //present the list of restaurants
        AllRestaurantsViewController *listView = [[AllRestaurantsViewController alloc]initWithRestaurant:arr_AssistedList];
        [self.navigationController pushViewController:listView animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != 0){
        //view all pressed.. show complete list
        AllRestaurantsViewController *listView = [[AllRestaurantsViewController alloc]initWithRestaurant:arr_CompleteList];
        [self.navigationController pushViewController:listView animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
