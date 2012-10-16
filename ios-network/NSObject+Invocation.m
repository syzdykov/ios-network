//
//  NSObject+Invocation.m
//  Studio Mobile
//
//  Created by Ekaterina Petrova on 8/3/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

#import "NSObject+Invocation.h"

@implementation NSObject (Invocation)

- (void)invokeSelector:(SEL)sel withObject:(id)obj1 withObject:(id)obj2
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"        
    [self performSelector:sel withObject:obj1 withObject:obj2];
#pragma clang diagnostic pop
}
     
- (void)invokeSelector:(SEL)sel withObject:(id)obj
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"        
    [self performSelector:sel withObject:obj];
#pragma clang diagnostic pop
}

- (id)invokeReturnedSelector:(SEL)sel withObject:(id)obj
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:sel withObject:obj];
#pragma clang diagnostic pop
}

- (id)invokeReturnedSelector:(SEL)sel withObject:(id)obj1 withObject:(id)obj2
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:sel withObject:obj1 withObject:obj2];
#pragma clang diagnostic pop
}

@end
