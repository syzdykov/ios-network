//
//  NSDictionary+Helpers.h
//  Studio Mobile
//
//  Created by Developer on 2/16/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helpers)

- (NSURL*)urlForKey:(id)key;

- (id)objectNotNullForKey:(id)key;

- (NSDate *)dateForKey:(id)key;

- (NSNumber *)boolForKey:(id)key;

- (NSNumber *)intForKey:(id)key;

- (NSNumber *)floatForKey:(id)key;

@end
