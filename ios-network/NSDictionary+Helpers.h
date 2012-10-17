//
//  NSDictionary+Helpers.h
//  Studio Mobile
//
//  Created by Sergey Martynov on 24.02.12.
//  Copyright (c) 2012 StudioMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helpers)

- (id)objectAtIndex:(NSUInteger)index;

- (NSInteger)integerForKey:(id)key;

- (NSInteger)integerForKey:(id)key default:(NSInteger)def;

- (NSUInteger)unsignedIntegerForKey:(id)key;

- (NSUInteger)unsignedIntegerForKey:(id)key default:(NSUInteger)def;

- (BOOL)boolForKey:(id)key;

- (float)floatForKey:(id)key;

- (double)doubleForKey:(id)key;

- (id)nonNullObjectForKey:(id)key;

- (NSDate*)dateForKey:(id)key formatter:(NSDateFormatter*)formatter;

- (NSString*)stringForKey:(id)key;

- (NSDictionary*)dictionaryForKey:(id)key;

- (NSArray*)arrayForKey:(id)key;

- (NSNumber*)numberForKey:(id)key;

@end

@interface NSMutableDictionary (Helpers)

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)obj;

@end
