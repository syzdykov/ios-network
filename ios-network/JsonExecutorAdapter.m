//
//  JsonExecutorAdapter.m
//  Studio Mobile
//
//  Created by Developer on 3/26/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

#import "JsonExecutorAdapter.h"
#import "NSObject+Invocation.h"

@interface JsonExecutorHandler : NSObject
@property (nonatomic, assign) SEL successAction;
@property (nonatomic, assign) SEL errorAction;

- (id)initWithSuccessAction:(SEL)successAction ErrorAction:(SEL)errorAction;
@end

@interface JsonExecutorAdapter () <JsonExecutorDelegate>
@end

@implementation JsonExecutorAdapter {
    __unsafe_unretained id target;
    NSMutableArray *executors;
    NSMutableArray *handlers;
}

- (id)initWithTagret:(id)_target
{
    if (self = [super init]) {
        target = _target;
        executors = [NSMutableArray new];
        handlers = [NSMutableArray new];
    }
    return self;
}

- (void)startExecutor:(id<JsonExecutorProtocol>)executor successAction:(SEL)successAction errorAction:(SEL)errorAction
{
    [executors addObject:executor];
    [handlers addObject:[[JsonExecutorHandler alloc] initWithSuccessAction:successAction ErrorAction:errorAction]];
    executor.delegate = self;
    [executor start];
}

- (void)removeExecutor:(id<JsonExecutorProtocol>)executor
{
    NSUInteger idx = [executors indexOfObject:executor];
    if (idx != NSNotFound) {
        JsonExecutorHandler *handler = [handlers objectAtIndex:idx];
        [executors removeObject:executor];
        [handlers removeObject:handler];
    }   
}

- (void)cancelAll
{
    for (id<JsonExecutorProtocol> executor in executors) {
        [executor cancel];
    }
    
    [executors removeAllObjects];
    [handlers  removeAllObjects];
}

#pragma mark JsonExecutor delegate

- (void)jsonExecutor:(id)executor didFinishWithInfo:(id)info
{
    JsonExecutorHandler *handler = [handlers objectAtIndex:[executors indexOfObject:executor]];
    if (handler.successAction) {
        [target invokeSelector:handler.successAction withObject:info];
    }
    [self removeExecutor:executor];
}

- (void)jsonExecutor:(id)executor didFailWithError:(NSError *)error
{
    JsonExecutorHandler *handler = [handlers objectAtIndex:[executors indexOfObject:executor]];
    if (handler.errorAction) {
        [target invokeSelector:handler.errorAction withObject:[[error userInfo] objectForKey:NSLocalizedFailureReasonErrorKey] withObject:[NSNumber numberWithInt:error.code]];
    }
    [self removeExecutor:executor];
}
@end

@implementation JsonExecutorHandler
@synthesize successAction;
@synthesize errorAction;

- (id)initWithSuccessAction:(SEL)_successAction ErrorAction:(SEL)_errorAction
{
    if (self = [super init]) {
        successAction = _successAction;
        errorAction = _errorAction;
    }
    return self;
}
@end
