//
//  PSAnimatedLabel.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 30/04/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "PSBlinkingMultiColoredLabel.h"

@implementation PSBlinkingMultiColoredLabel{
    UILabel *lbl_TextToUpdate;//label that updates the counter
}
@synthesize arrOfNames = _arrOfNames;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTextAlignment:NSTextAlignmentCenter];
        [self setNumberOfLines:0];
        [self setFont:[UIFont fontWithName:@"STHeitiSC-Medium" size:25.0f]];
    }
    return self;
}

- (void)animateWithWords:(NSArray *)words updatingLabel:(UILabel *)label {

    if (self.arrOfNames) {
        self.arrOfNames = nil;
    }
    self.arrOfNames = [[NSArray alloc] initWithArray:words];
    self.text = [self.arrOfNames objectAtIndex:0];
    lbl_TextToUpdate = label;
    [NSThread detachNewThreadSelector:@selector(performBlinkOn:)
                             toTarget:self
                           withObject:self.arrOfNames];
}

- (void)performBlinkOn:(NSArray *)textArray {
    
    @autoreleasepool {
        
        for (uint i = 1; i < [textArray count]; i++) {
            sleep(1.0);
            
            [self performSelectorOnMainThread:@selector(blink:)
                                   withObject:[NSNumber numberWithInt:i]
                                waitUntilDone:YES];
            sleep(1.0);
        }
    }
}

- (void)blink:(NSNumber *)num {
    //animate the label
    [UIView animateWithDuration:1.0 / 2 animations:^{ self.alpha = 0.0;}
            completion:^(BOOL finished) {
            [UIView animateWithDuration:1.0 / 2
                    animations:^{
                        //show label
                        self.alpha = 1.0;
                        //update the blinking label text
                        self.text = [self.arrOfNames objectAtIndex:[num intValue]];
                        //update the header label text
                        [lbl_TextToUpdate setText:[NSString stringWithFormat:@"Please Wait. Info Fetched From %d Restaurants",[num intValue]+1]];
                        //get random color
                        CGFloat red = arc4random_uniform(255) / 255.0;
                        CGFloat green = arc4random_uniform(255) / 255.0;
                        CGFloat blue = arc4random_uniform(255) / 255.0;
                        UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
                        //update blinking label text color with random color
                        [self setTextColor:color];
                        }
                        completion:^(BOOL finished) {
                        //once complete hide the blinking label
                            //check if we have reached the end of animation
                        if ([num intValue] == [self.arrOfNames count]-1){
                            //if so
                            sleep(1.0);
                            [UIView animateWithDuration:1.0 / 2
                                            animations:^{
                                                //hide the last label
                                            self.alpha = 0.0;
                                            }
                                             completion:^(BOOL finished) {
                                                 //delegate it
                                            if([self.blinkDelegate respondsToSelector:@selector(LabelDidFinishBlinking)]){
                                                    [self removeFromSuperview];
                                                    [self.blinkDelegate LabelDidFinishBlinking];
                                    }
                            }];
                    }
            }];
    }];
}


@end
