//
//  PSAnimatedLabel.h
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BlinkingLabelDelegate <NSObject>
-(void) LabelDidFinishBlinking;
@end

@interface PSBlinkingMultiColoredLabel : UILabel
@property(nonatomic, retain) NSArray *arrOfNames; // array to hold the names to be shown
@property(nonatomic, assign) id<BlinkingLabelDelegate> blinkDelegate;
- (void)animateWithWords:(NSArray *)words updatingLabel:(UILabel *)label; 
@end
