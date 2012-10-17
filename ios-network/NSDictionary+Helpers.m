//
//  NSDictionary+Helpers.m
//  Studio Mobile
//
//  Created by Sergey Martynov on 24.02.12.
//  Copyright (c) 2012 StudioMobile. All rights reserved.
//

#import "NSDictionary+Helpers.h"

@implementation NSDictionary (Helpers)

- (id)objectAtIndex:(NSUInteger)index
{
    return [self objectForKey:[NSNumber numberWithUnsignedInteger:index]];
}

- (NSInteger)integerForKey:(id)key
{
    return [self integerForKey:key default:NSNotFound];
}

- (NSInteger)integerForKey:(id)key default:(NSInteger)def
{
    id obj = [self nonNullObjectForKey:key];
    return [obj respondsToSelector:@selector(integerValue)]? [obj integerValue] : def;
}

- (NSUInteger)unsignedIntegerForKey:(id)key
{
    return [self unsignedIntegerForKey:key default:NSNotFound];
}

- (NSUInteger)unsignedIntegerForKey:(id)key default:(NSUInteger)def
{
    id obj = [self nonNullObjectForKey:key];
    if (![obj respondsToSelector:@selector(integerValue)]) return def;
    return [obj respondsToSelector:@selector(unsignedIntegerValue)] ? [obj unsignedIntegerValue] : (NSUInteger) [obj integerValue];
}

- (BOOL)boolForKey:(id)key
{
    return [[self numberForKey:key] boolValue];
}

- (float)floatForKey:(id)key
{
    return [[self numberForKey:key] floatValue];
}

- (double)doubleForKey:(id)key
{
    return [[self numberForKey:key] doubleValue];
}

- (id)nonNullObjectForKey:(id)key
{
    id value = [self objectForKey:key];
    return [value isKindOfClass:[NSNull class]] ? nil : value;
}

- (NSDate*)dateForKey:(id)key formatter:(NSDateFormatter*)formatter
{
    id date = [self nonNullObjectForKey:key];
    return [date isKindOfClass:[NSDate class]] ? date : [formatter dateFromString:[date description]];
}

- (NSString*)stringForKey:(id)key
{
    id obj = [self nonNullObjectForKey:key];
    return [obj isKindOfClass:[NSString class]] ? obj : nil;
}

- (NSDictionary*)dictionaryForKey:(id)key
{
    id obj = [self nonNullObjectForKey:key];
    return [obj isKindOfClass:[NSDictionary class]] ? obj : nil;
}

- (NSArray*)arrayForKey:(id)key
{
    id obj = [self nonNullObjectForKey:key];
    return [obj isKindOfClass:[NSArray class]] ? obj : nil;
}

- (NSNumber*)numberForKey:(id)key
{
    id obj = [self nonNullObjectForKey:key];
    return [obj isKindOfClass:[NSNumber class]] ? obj : nil;
}

@end

@implementation NSMutableDictionary (Helpers)

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)obj
{
    [self setObject:obj forKey:[NSNumber numberWithUnsignedInteger:index]];
}

@end
