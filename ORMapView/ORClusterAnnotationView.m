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

@interface MKAnnotationView (iOS7TintColor)
- (void)tintColorDidChange;
@end


@interface ORClusterAnnotationView ()

@property(nonatomic,strong) UIFont* font;

@end

@implementation ORClusterAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.font = [UIFont systemFontOfSize:12];
        
        self.opaque = NO;
        
        self.strokeWidth = 1;
        
        // Create a square that contains the text
        
        UIFont *font = self.font;
        NSDictionary *attributes = @{NSFontAttributeName: font};
        
        CGSize textSize = [[self _text] sizeWithAttributes: @{NSFontAttributeName: self.font}];
        NSUInteger maxValue = ceil(MAX(textSize.height, textSize.width));
        self.frame = CGRectMake(0, 0, maxValue + 2*TEXT_INSET, maxValue + 2*TEXT_INSET);
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // System tint color or black default
    UIColor* tintColor = nil;
    if([self respondsToSelector:@selector(tintColor)]) {
        tintColor = [self performSelector:@selector(tintColor)];
    }
    
    if(!tintColor) {
        tintColor = [UIColor blackColor];
    }

    
    
    // Oval
    CGRect ovalRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(1, 1, 1, 1));

    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    [[UIColor whiteColor] setFill];
    [ovalPath fill];
    [tintColor setStroke];
    ovalPath.lineWidth = self.strokeWidth;
    [ovalPath stroke];
    
    
    
    // Text
    [[UIColor blackColor] setFill];
    
    NSString* annotationsCount = [self _text];
    

    UIFont *font = self.font;
    NSDictionary *attributes = @{NSFontAttributeName: font};
    
    CGSize textSize = [annotationsCount sizeWithAttributes:attributes];
    CGFloat textY = (rect.size.height - textSize.height)/2.0;
    CGFloat textX = (rect.size.width - textSize.width)/2.0;
    
    CGRect textRect = CGRectMake(textX, textY, textSize.width, textSize.height);
    
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByTruncatingMiddle;
    textStyle.alignment = NSTextAlignmentCenter;
    
    
    [annotationsCount drawInRect:textRect withAttributes:@{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:textStyle}];
}


- (void)tintColorDidChange
{
    if([super respondsToSelector:@selector(tintColorDidChange)]) {
        [super tintColorDidChange];
    }
    [self setNeedsDisplay];
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
}

- (NSString*)_text
{
    ORClusterAnnotation* clusterAnnotation = (ORClusterAnnotation*)self.annotation;
    return [NSString stringWithFormat:@"%lu", (unsigned long)clusterAnnotation.count];
}


@end
