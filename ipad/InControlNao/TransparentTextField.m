//
//  TransparentTextField.m
//  InControlNao
//
//  Created by Steffen Kolb on 19.01.13.
//  Copyright (c) 2013 hdmstuttgart.de. All rights reserved.
//

#import "TransparentTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation TransparentTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIImage *textFieldBackground = [[UIImage imageNamed:@"UITTSBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [textFieldBackground drawInRect:[self bounds]];
    
    // adds a shadow to the text... but also to the background and everything else -.-
//    self.layer.shadowOpacity = 0.75;
//    self.layer.shadowRadius = 0.0;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + 15, bounds.origin.y, bounds.size.width - 20, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect inset = CGRectMake(bounds.origin.x + 15, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
    return inset;
}

- (void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor colorWithHue:0 saturation:0 brightness:0.75 alpha:1] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
}

@end
