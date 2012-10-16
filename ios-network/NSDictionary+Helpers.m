//
//  NSDictionary+Helpers.m
//  Studio Mobile
//
//  Created by Developer on 2/16/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

#import "NSDictionary+Helpers.h"

@implementation NSDictionary (Helpers)

- (NSURL*)urlForKey:(id)key
{
    NSString *str = [self objectForKey:key];
    if (![str isKindOfClass:[NSString class]] || [str isEqualToString:@""]) return nil;
    return [NSURL URLWithString:str];
}

- (id)objectNotNullForKey:(id)key
{
    id obj = [self objectForKey:key];
    return [obj isKindOfClass:[NSNull class]] ? nil : obj;
}

- (NSDate *)dateForKey:(id)key {
    NSString *str = [self objectForKey:key];
    if (![str isKindOfClass:[NSString class]]) return nil;

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    return [dateFormatter dateFromString:[self objectForKey:key]];
}

- (NSNumber *)boolForKey:(id)key {
    NSString *str = [self objectForKey:key];
    if (![str isKindOfClass:[NSString class]]) return nil;
    
    return [NSNumber numberWithInt:[str boolValue]];
}

- (NSNumber *)intForKey:(id)key {
    NSString *str = [self objectForKey:key];
    if (![str isKindOfClass:[NSString class]]) return nil;
    
    return [NSNumber numberWithInt:[str intValue]];
}

- (NSNumber *)floatForKey:(id)key {
    NSString *str = [self objectForKey:key];
    if (![str isKindOfClass:[NSString class]]) return nil;
    
    return [NSNumber numberWithInt:[str floatValue]];
}

@end
