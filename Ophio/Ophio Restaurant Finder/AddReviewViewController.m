//
//  AddReviewViewController.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 01/05/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "AddReviewViewController.h"
#import "RestaurantDetailsModel.h"
#import "PSCorneredButton.h"


@interface AddReviewViewController () {
    RestaurantDetailsModel *restaurant_ToAddTo; //instance of restaurant passed
    UITextView *txtFld_Review; //comment field
    PSCorneredButton *btn_Submit; //button of review submission
    PSCorneredButton *btn_Cancel; //button for cancellation 
}

@end

@implementation AddReviewViewController
-(instancetype) initWithForRestaurant:(RestaurantDetailsModel *) restaurant {
    self = [super init];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
        restaurant_ToAddTo = restaurant;
        
        txtFld_Review =[[UITextView alloc]initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-20, 100)];
        [txtFld_Review setDelegate:self];
        [self.view addSubview:txtFld_Review];
        
        btn_Cancel = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
        [btn_Cancel setFrame:CGRectMake(10, txtFld_Review.frame.origin.y + txtFld_Review.frame.size.height+large_padding, self.view.frame.size.width/4, 44)];
        [btn_Cancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [btn_Cancel addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
        [self. view addSubview:btn_Cancel];

        btn_Submit = [PSCorneredButton buttonWithType:UIButtonTypeSystem];
        [btn_Submit setFrame:CGRectMake(self.view.frame.size.width - 10 - self.view.frame.size.width/4, txtFld_Review.frame.origin.y + txtFld_Review.frame.size.height+large_padding, self.view.frame.size.width/4, 44)];
        [btn_Submit setTitle:@"Send" forState:UIControlStateNormal];
        [btn_Submit addTarget:self action:@selector(submitPressed) forControlEvents:UIControlEventTouchUpInside];
        [self. view addSubview:btn_Submit];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [txtFld_Review becomeFirstResponder];
}
-(void)submitPressed {
    //check if the user has entered the the comment
    if([[txtFld_Review text] length]>0){
        //if the user has entered the text
        //check if the restaurant exists in the local db
        BOOL isExistingRestaurant =[restaurant_ToAddTo doesRestaurantExists];
        if(!isExistingRestaurant) {
            //if the restaurant doesnt already exists then create it
            [restaurant_ToAddTo createNewRestaurant];
        }
        //get the restaurant ID
        NSInteger restID = [restaurant_ToAddTo getRestaurantID];
        //save the review
        BOOL reviewSaved = [restaurant_ToAddTo saveReview:txtFld_Review.text forRestaurantId:restID];
        if(reviewSaved){
            //if saved update the the record n the instance
            [[restaurant_ToAddTo reviewsRecieved]removeAllObjects];
            //get Id of restaurant we want to update the reviews for
            NSInteger ID = [restaurant_ToAddTo getRestaurantID];
            //update review
            [restaurant_ToAddTo setReviewsRecieved:[restaurant_ToAddTo getReviewsForRestaurantId:ID]];
            //close the view
            [self cancelPressed];
        }
        else {
            //no
        }
    }
    else {
        //if no comment is found and user presses the submit button then show him the alert
        if ([UIAlertController class])
        {
            // use UIAlertController  for iOS 8
            UIAlertController *alert= [UIAlertController
                                       alertControllerWithTitle:@"Enter Review"
                                       message:@"review Field Found Empty"
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Enter Review"
                                                                message:@"review Field Found Empty"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Okay", nil];
            [alertView show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
}

-(void)cancelPressed {
    //close the view
    [self dismissViewControllerAnimated:self completion:^{
        
    }];
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
