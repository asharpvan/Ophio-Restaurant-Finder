//
//  PSCorneredButton.m
//  Ophio Restaurant Finder
//
//  Created by Pranav Sah on 01/05/15.
//  Copyright (c) 2015 Pranav Sah. All rights reserved.
//

#import "PSCorneredButton.h"

@implementation PSCorneredButton


-(instancetype)initWithFrame:(CGRect)frame{
    if(self= [super initWithFrame:frame]) {
        //add corner to the uibutton
        [self.layer setBorderWidth:1.0f];
        [self.layer setCornerRadius:4.0f];
        [self.layer setBorderColor:[self.tintColor CGColor]];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
