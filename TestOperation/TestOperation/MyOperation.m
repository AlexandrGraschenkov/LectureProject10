//
//  MyOperation.m
//  TestOperation
//
//  Created by Alexander on 17.04.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "MyOperation.h"

@implementation MyOperation
- (void)main
{
    for(int i = 0; i < 100; i++){
        [NSThread sleepForTimeInterval:1.0];
        if(self.isCancelled)
            return;
        NSLog(@"Val %d", i);
    }
}
@end
