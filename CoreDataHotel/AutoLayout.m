//
//  AutoLayout.m
//  CoreDataHotel
//
//  Created by Christina Lee on 4/24/17.
//  Copyright © 2017 Christina Lee. All rights reserved.
//

#import "AutoLayout.h"

@implementation AutoLayout

+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute
                               andMultiplier:(CGFloat)multiplier{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:superView
                                                                attribute:attribute
                                                                 multiplier:multiplier
                                                                   constant:0.0];
    
    constraint.active = YES;
    return constraint;
}

+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute{
    return [AutoLayout genericConstraintFrom:view toView:superView withAttribute:attribute andMultiplier:1.0];
}

+(NSArray *)constraintsWithVFLForViewDictionary:(NSDictionary *)viewDictionary
                           forMetricsDictionary:(NSDictionary *)metricsDictionary
                                    withOptions:(NSLayoutFormatOptions)options
                               withVisualFormat:(NSString *)visualFormat{
    NSArray *constraints = [[NSArray alloc]init];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:options
                                                          metrics:metricsDictionary
                                                            views:viewDictionary];
    [NSLayoutConstraint activateConstraints:constraints];
    return constraints.copy;
}

+(NSArray *)fullScreenConstraintsWithVFLForView:(UIView *)view{
    NSMutableArray *constraints = [[NSMutableArray alloc]init];
    NSDictionary *viewDictionary = @{@"view": view};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewDictionary];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewDictionary];
    
    [constraints addObjectsFromArray:horizontalConstraints];
    [constraints addObjectsFromArray:verticalConstraints];
    [NSLayoutConstraint activateConstraints:constraints];
    
    return constraints.copy;
}

+(NSLayoutConstraint *)equalHeightConstraintFrom:(UIView *)view
                                          toView:(UIView *)otherView
                                  withMultiplier:(CGFloat)multiplier{
    NSLayoutConstraint *heightConstraint = [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeHeight andMultiplier:multiplier];
    
    return heightConstraint;
}

+(NSLayoutConstraint *)leadingConstraintFrom:(UIView *)view
                                      toView:(UIView *)otherView{
    return [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeLeading];
    
}

+(NSLayoutConstraint *)trailingConstraintFrom:(UIView *)view
                                       toView:(UIView *)otherView{
    return [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeTrailing];
}

@end

