//
//  JsonExecutorAdapter.h
//  Studio Mobile
//
//  Created by Developer on 3/26/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//
#import "JsonExecutorProtocol.h"

@interface JsonExecutorAdapter : NSObject

- (id)initWithTagret:(id)target;

- (void)startExecutor:(id<JsonExecutorProtocol>)executor successAction:(SEL)action errorAction:(SEL)action;
- (void)cancelAll;
@end
