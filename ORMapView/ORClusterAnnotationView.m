//
//  ORClusterAnnotationView.m
//  ORMapView Example
//
//  Created by Philipp Schmid on 9/8/13.
//  Copyright (c) 2013 Philipp Schmid. All rights reserved.
//

#import "ORClusterAnnotationView.h"

#import "ORClusterAnnotation.h"

#define TEXT_INSET 8


@interface ORClusterAnnotationView ()

@property(nonatomic,strong) UIFont* font;

@end

@implementation ORClusterAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.font = [UIFont fontWithName: @"HelveticaNeue" size: 12];
        
        self.opaque = NO;
        
        
        // Create a square that contains the text
        CGSize textSize = [[self _text] sizeWithFont:self.font];
        NSUInteger maxValue = ceil(MAX(textSize.height, textSize.width));
        self.frame = CGRectMake(0, 0, maxValue + 2*TEXT_INSET, maxValue + 2*TEXT_INSET);
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGRect ovalRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(1, 1, 1, 1));

    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    [[UIColor whiteColor] setFill];
    [ovalPath fill];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[UIColor blackColor] setStroke];

    } else {
        [self.tintColor setStroke];
    }
    
    ovalPath.lineWidth = 1;
    [ovalPath stroke];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[UIColor blackColor] setFill];
        
    } else {
        [self.tintColor setFill];
    }
    
    NSString* annotationsCount = [self _text];
    
    CGSize textSize = [annotationsCount sizeWithFont:self.font];
    CGFloat textY = (rect.size.height - textSize.height)/2.0;
    CGFloat textX = (rect.size.width - textSize.width)/2.0;
    
    CGRect textRect = CGRectMake(textX, textY, textSize.width, textSize.height);
    [annotationsCount drawInRect: textRect withFont: [UIFont fontWithName: @"Helvetica" size: 12] lineBreakMode: NSLineBreakByTruncatingMiddle alignment: NSTextAlignmentCenter];
}


- (void)tintColorDidChange
{
    [super tintColorDidChange];
    [self setNeedsDisplay];
}

- (NSString*)_text
{
    ORClusterAnnotation* clusterAnnotation = (ORClusterAnnotation*)self.annotation;
    return [NSString stringWithFormat:@"%d", clusterAnnotation.count];
}


@end
