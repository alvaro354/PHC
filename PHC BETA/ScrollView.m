//
//  ScrollView.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 12/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nextResponder touchesBegan:touches withEvent:event];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.dragging){
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
    else
        [super touchesEnded:touches withEvent:event];
}
@end