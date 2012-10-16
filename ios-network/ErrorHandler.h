//
//  ErrorHandler.h
//  Studio Mobile
//
//  Created by Developer on 3/27/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//
#import "JsonExecutorProtocol.h"
#import "ErrorHandlerProtocol.h"

@interface ErrorHandler : NSObject
- (id)initWithActiveCtrl:(UIViewController<ErrorHandlerProtocol>*)ctrl;
- (void)handleExecutor:(id<JsonExecutorProtocol>)exec error:(NSError *)error checkSessionOut:(BOOL)check;
- (void)handleExecutor:(id<JsonExecutorProtocol>)exec error:(NSError*)error;
@end

