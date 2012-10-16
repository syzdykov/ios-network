//
//  NSObject+Invocation.h
//  Studio Mobile
//
//  Created by Ekaterina Petrova on 8/3/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Invocation)

- (void)invokeSelector:(SEL)sel withObject:(id)object1 withObject:(id)object2;
- (void)invokeSelector:(SEL)sel withObject:(id)obj;

- (id)invokeReturnedSelector:(SEL)sel withObject:(id)obj1 withObject:(id)obj2;
- (id)invokeReturnedSelector:(SEL)sel withObject:(id)obj;

@end
