//
//  JsonExecutorProxy.h
//  Studio Mobile
//
//  Created by Developer on 3/27/12.
//  Copyright (c) 2012 Studio Mobile. All rights reserved.
//

#import "JsonExecutorProtocol.h"

@interface JsonExecutorProxy : NSObject <JsonExecutorProtocol>
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL onSuccess;
@property (nonatomic, assign) SEL onError;
@end
