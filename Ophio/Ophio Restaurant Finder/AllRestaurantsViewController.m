//
//  AllRestaurantsViewController.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 01/05/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "AllRestaurantsViewController.h"
#import "RestaurantDetailsModel.h"
#import "RestaurantDetailsViewController.h"
#import "PSCorneredButton.h"


@interface AllRestaurantsViewController (){
    NSMutableArray *arr_RestaurantList; //array to hold the list of restaurants passed
    UIScrollView *scrollView;
}

@end

@implementation AllRestaurantsViewController

-(instancetype) initWithRestaurant:(NSMutableArray *) restaurantList {
    self = [super init];
    if (self) {
        // Custom initialization
        scrollView =[[UIScrollView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:scrollView];
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self setTitle:@"List"];
        if(!arr_RestaurantList)
            arr_RestaurantList =[NSMutableArray new];
        else
            [arr_RestaurantList removeAllObjects];
        arr_RestaurantList = restaurantList;
        //create button for each restaurant
        [self setupButtons:restaurantList];
        
      
     }
    return self;
}

-(void)setupButtons:(NSArray *)array{
    //enumerate through the restaurant list
    [array enumerateObjectsUsingBlock:^(RestaurantDetailsModel *obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            //for list create a button
             PSCorneredButton*button = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
            [button setFrame:CGRectMake(10, 70 + idx*(small_padding+control_height), self.view.frame.size.width-20, control_height)];
            [button setTag:idx];
            [button setTitle:obj.name forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:button];
            if(idx==[array count]-1) {
                [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, button.frame.origin.y+button.frame.size.height +large_padding)];
            }
        }
    }];
}

-(void) buttonPressed: (id) sender {
    //present  restaurant details
    RestaurantDetailsViewController *detailsViewController = [[RestaurantDetailsViewController alloc]initWithRestaurant:(RestaurantDetailsModel *)[arr_RestaurantList objectAtIndex:[sender tag]]];
    [self.navigationController pushViewController:detailsViewController animated:YES];
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
