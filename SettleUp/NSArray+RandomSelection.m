//
//  NSArray+RandomSelection.m
//  SettleUp
//
//  Created by Connor Neville on 4/10/15.
//  Copyright (c) 2015 connorneville. All rights reserved.
//

#import "NSArray+RandomSelection.h"

@implementation NSArray (RandomSelection)

- (NSArray *)randomSelectionWithCount:(NSUInteger)count {
    if ([self count] < count) {
        return nil;
    } else if ([self count] == count) {
        return self;
    }
    
    NSMutableSet* selection = [[NSMutableSet alloc] init];
    
    while ([selection count] < count) {
        id randomObject = [self objectAtIndex: arc4random() % [self count]];
        if(randomObject != nil)
            [selection addObject:randomObject];
    }
    
    return [selection allObjects];
}

@end