//
//  YYDispatchQueueManager.h
//  
//
//  Created by ibireme on 15/7/18.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

/// Get a serial queue from global queue pool with a specified qos.
extern dispatch_queue_t YPDispatchQueueGetForQOS(NSQualityOfService qos);
extern dispatch_queue_t YPDispatchQueueGetForUserInteractiveQOS(void);
extern dispatch_queue_t YPDispatchQueueGetForUserInitiatedQOS(void);
extern dispatch_queue_t YPDispatchQueueGetForUtilityQOS(void);
extern dispatch_queue_t YPDispatchQueueGetForBackgroundQOS(void);
extern dispatch_queue_t YPDispatchQueueGetForDefaultQOS(void);



