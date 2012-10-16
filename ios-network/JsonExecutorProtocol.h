//
//  JsonExecutorProtocol.h
//  Studio Mobile
//
//  Created by Developer on 3/27/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

typedef id (^ParseBlock)(id);

@protocol JsonExecutorDelegate;

@protocol JsonExecutorProtocol <NSObject>
@property (nonatomic, assign) id<JsonExecutorDelegate> delegate;
@property (nonatomic, copy) ParseBlock parseBlock;

- (id)initWithRequest:(NSURLRequest*)req;
- (void)start;
- (void)cancel;
@end

@protocol JsonExecutorDelegate <NSObject>
- (void)jsonExecutor:(id)executor didFinishWithInfo:(id)info;
- (void)jsonExecutor:(id)executor didFailWithError:(NSError*)error;
@end
