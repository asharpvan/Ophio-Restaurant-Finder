//
//  RestaurantDetailsViewController.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "RestaurantDetailsViewController.h"
#import "RestaurantDetailsModel.h"
#import "AddReviewViewController.h"
#import "SqliteManager.h"
#import "PSCorneredButton.h"


@interface RestaurantDetailsViewController () {

    UILabel *lbl_Address; //label for Restaurant Address
    UILabel *lbl_Contact; //label for Restaurant contact number
    UILabel *lbl_Web; //label for Restaurant Website URL
    UILabel *lbl_Distance; //label to reflect distance between User and and Restaurant
    UILabel *lbl_Reviews; //label to show Restaurant Review
    UILabel *lbl_Visited; //label to show how many Times the User has visited the Restaurant
    PSCorneredButton *btn_Visited; // button to increase visit count
    PSCorneredButton *btn_Review; // button to write review
    PSCorneredButton *btn_Block; // button to block the restaurant from appearing in assisted search
    RestaurantDetailsModel *currentRestaurant; // instace of currently shown restaurant
    UIScrollView *scrollView;
}

@end

@implementation RestaurantDetailsViewController
-(instancetype) initWithRestaurant:(RestaurantDetailsModel *) restaurantPassed {
    
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self setTitle:restaurantPassed.name];
        
        scrollView =[[UIScrollView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:scrollView];
        
        currentRestaurant = restaurantPassed;

        lbl_Address = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 120)];
        [lbl_Address setTextAlignment:NSTextAlignmentCenter];
        [lbl_Address setText:[NSString stringWithFormat:@"Address : %@",restaurantPassed.mailAddress]];
        [lbl_Address setNumberOfLines:0];
        [scrollView addSubview:lbl_Address];
        
        lbl_Contact = [[UILabel alloc]initWithFrame:CGRectMake(0, lbl_Address.frame.origin.y + lbl_Address.frame.size.height, self.view.frame.size.width, 30)];
        [lbl_Contact setTextAlignment:NSTextAlignmentCenter];
        [lbl_Contact setText:[NSString stringWithFormat:@"Contact Number : %@",restaurantPassed.phoneNumber]];
        [lbl_Contact setNumberOfLines:0];
        [scrollView addSubview:lbl_Contact];

        lbl_Web = [[UILabel alloc]initWithFrame:CGRectMake(0, lbl_Contact.frame.origin.y + lbl_Contact.frame.size.height, self.view.frame.size.width, 44)];
        [lbl_Web setTextAlignment:NSTextAlignmentCenter];
        [lbl_Web setText:[NSString stringWithFormat:@"Website : %@",restaurantPassed.urlAddress]];
        [lbl_Web setNumberOfLines:0];
        [scrollView addSubview:lbl_Web];

        lbl_Distance = [[UILabel alloc]initWithFrame:CGRectMake(0, lbl_Web.frame.origin.y + lbl_Web.frame.size.height, self.view.frame.size.width, 44)];
        [lbl_Distance setTextAlignment:NSTextAlignmentCenter];
        [lbl_Distance setText:[NSString stringWithFormat:@"Distance From You : %0.2f kms",[restaurantPassed.howFar floatValue]]];
        [lbl_Distance setNumberOfLines:0];
        [scrollView addSubview:lbl_Distance];
        
        lbl_Visited = [[UILabel alloc]initWithFrame:CGRectMake(0, lbl_Distance.frame.origin.y + lbl_Distance.frame.size.height, self.view.frame.size.width, 44)];
        [lbl_Visited setTextAlignment:NSTextAlignmentCenter];
        [lbl_Visited setText:[NSString stringWithFormat:@"Times Visited : %lu",[[restaurantPassed visitCount] integerValue]]];
        [lbl_Visited setNumberOfLines:0];
        [scrollView addSubview:lbl_Visited];
        
        btn_Visited = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
        [btn_Visited setFrame:CGRectMake(10, lbl_Visited.frame.origin.y + lbl_Visited.frame.size.height, self.view.frame.size.width-20, 44)];
        [btn_Visited setTitle:@"I've been here!!" forState:UIControlStateNormal];
        [btn_Visited addTarget:self action:@selector(increaseVisitCount) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn_Visited];
        
        lbl_Reviews = [[UILabel alloc]initWithFrame:CGRectMake(0, btn_Visited.frame.origin.y + btn_Visited.frame.size.height+large_padding, self.view.frame.size.width, 44)];
        [lbl_Reviews setTextAlignment:NSTextAlignmentLeft];
        
        [lbl_Reviews setNumberOfLines:0];
        [scrollView addSubview:lbl_Reviews];
        
        btn_Review = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
        [btn_Review setFrame:CGRectMake(0, btn_Visited.frame.origin.y + btn_Visited.frame.size.height+large_padding, self.view.frame.size.width/3, 44)];
        [btn_Review setTitle:@"Add Review" forState:UIControlStateNormal];
        [btn_Review addTarget:self action:@selector(addReviewPressed) forControlEvents:UIControlEventTouchUpInside];
        [btn_Review setCenter:CGPointMake(self.view.frame.size.width-(CGRectGetWidth(btn_Review.frame)/2+10), lbl_Reviews.center.y)];
        [scrollView addSubview:btn_Review];
        
        btn_Block = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
        [btn_Block setFrame:CGRectMake(10, lbl_Reviews.frame.origin.y + lbl_Reviews.frame.size.height+large_padding, self.view.frame.size.width-20, 44)];
        NSLog(@"restaurantSelected.isBlocked : %d",restaurantPassed.isBlocked);
        if(restaurantPassed.isBlocked)
            [btn_Block setTitle:@"Unblock this restaurant" forState:UIControlStateNormal];
        else
            [btn_Block setTitle:@"Block this restaurant" forState:UIControlStateNormal];
        [btn_Block addTarget:self action:@selector(thumbsDownPressed) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn_Block];
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated {
    if([[currentRestaurant reviewsRecieved] count]>0)
        [self setupReviewLabels:[currentRestaurant reviewsRecieved]];
    [lbl_Reviews setText:[NSString stringWithFormat:@"Reviews (%lu)",[currentRestaurant.reviewsRecieved count]]];
    [super viewWillAppear:animated];
}
-(void)increaseVisitCount {
    //check if  the restaurant already exists in local db
    BOOL isExistingRestaurant =[currentRestaurant doesRestaurantExists];
    if(!isExistingRestaurant) {
        //if not then create the restaurant
        [currentRestaurant createNewRestaurant];
    }
    //fetch the restaurant ID for further use
    NSInteger restID = [currentRestaurant getRestaurantID];
    //get Current visit count
    NSInteger currentCounter =[currentRestaurant getTotalVisitsForRestaurant:restID];
    //increase the current visit by one
    currentCounter += 1;
    //update the value in the local db
    BOOL success = [currentRestaurant increaseVisitCountForRestaurantId:restID to:currentCounter];
    if(success) {
        //update the visit counter of instance of currently shown restaurant
        [currentRestaurant setVisitCount:[NSNumber numberWithInteger:currentCounter]];
        [lbl_Visited setText:[NSString stringWithFormat:@"Times Visited: %lu",[[currentRestaurant visitCount] integerValue]]];
    }
}

-(void)setupReviewLabels :(NSArray *)reviews {
    //enumerate through all the reviews nd create label as needed
    [reviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        @autoreleasepool {
            //for every review create a label
            UILabel *review = [[UILabel alloc] initWithFrame:CGRectMake(0, lbl_Reviews.frame.origin.y + lbl_Reviews.frame.size.height + idx*(small_padding+control_height), self.view.frame.size.width, control_height)];
            [review setBackgroundColor:[UIColor whiteColor]];
            [review setText:[reviews objectAtIndex:idx]];
            [scrollView addSubview:review];
            if(idx==[reviews count]-1) {
                //as soon as the last review is reached
                //rearrange the block button to always appear below the list of reviews
                [btn_Block setCenter:CGPointMake(btn_Block.center.x, review.center.y+review.frame.size.height/2+large_padding*3)];
                // increase scrollview size to always show block button
                [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, btn_Block.frame.origin.y+btn_Block.frame.size.height +large_padding)];
            }
        }
    }];
}

-(void) addReviewPressed {
    //present add review view
    AddReviewViewController *addVC = [[AddReviewViewController alloc]initWithForRestaurant:currentRestaurant];
    [self presentViewController:addVC animated:YES completion:^{ }];
}

-(void)thumbsDownPressed {
     //check if  the restaurant already exists in local db
    BOOL isExistingRestaurant =[currentRestaurant doesRestaurantExists];
    if(!isExistingRestaurant) {
        //if not then create the restaurant
        [currentRestaurant createNewRestaurant];
    }
    //fetch the restaurant ID for further use
    NSInteger restID = [currentRestaurant getRestaurantID];
    //check the block status of restaurant in question
    BOOL currentBlockedValue = [currentRestaurant isBlocked];
    // update the blocked status of restaurant in question
    BOOL success = [currentRestaurant changeBlockStatusForRestaurnatId:restID to:!currentBlockedValue];
    if(success){
        //update the block button title accordingly
        if(!currentBlockedValue) {
            [btn_Block setTitle:@"Unblock this restaurant" forState:UIControlStateNormal];
        }
        else {
            [btn_Block setTitle:@"Block this restaurant" forState:UIControlStateNormal];
        }
        //update the blog flag of instance of currently shown restaurant
        [currentRestaurant setIsBlocked:!currentBlockedValue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   [self setAutomaticallyAdjustsScrollViewInsets:FALSE];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
