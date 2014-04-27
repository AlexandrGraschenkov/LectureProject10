//
//  DataManager.m
//  HW_TableImages
//
//  Created by Alexander on 19.04.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "DataManager.h"

#define ARC4RANDOM_MAX      0x100000000

@interface DataManager()
{
    dispatch_queue_t bgQueue;
}
@end


@implementation DataManager

+ (instancetype)sharedInstance
{
    static id _singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _singleton = [[self alloc] init];
    });
    return _singleton;
}

- (id)init
{
    self = [super init];
    if(self){
        bgQueue = dispatch_queue_create("fasfsd", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)asyncListOfFruits:(void(^)(NSArray* arr))complection
{
    float delay = 0.5 + 1.5 * ((double)arc4random() / ARC4RANDOM_MAX);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), bgQueue, ^
    {
        NSArray *result = @[@{@"title" : @"Абрикос круче чем кокос", @"thumb_img" : @"Apricot_tb.png"},
                            @{@"title" : @"", @"thumb_img" : @"Apple_tb.png"},
                            @{@"title" : @"Банана", @"thumb_img" : @"Banana_tb.png"},
                            @{@"title" : @"Ананас", @"thumb_img" : @"Ananas_tb.png"}];
//        result = [result arrayByAddingObjectsFromArray:result];
//        result = [result arrayByAddingObjectsFromArray:result];
        complection(result);
    });
}

- (void)asyncGetImage:(NSString*)imgName complection:(void(^)(UIImage* img))complection
{
    float delay = 0.5 + 1.5 * ((double)arc4random() / ARC4RANDOM_MAX);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), bgQueue, ^
    {
        __block UIImage *img = [UIImage imageNamed:imgName];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        [self image:img aspectFillRadius:25 complection:^(UIImage *aImg) {
            img = aImg;
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        complection(img);
    });
}

- (void)image:(UIImage*)img aspectFillRadius:(float)radius complection:(void(^)(UIImage*))complection
{
    dispatch_async(bgQueue, ^{
        CGSize targetSize = CGSizeMake(2 * radius, 2 * radius);
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0);
        CGRect rect = CGRectMake(0, 0, targetSize.width, targetSize.height);
        [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
        
        float scale = fmaxf(targetSize.width / img.size.width, targetSize.height / img.size.height);
        CGSize newSize = CGSizeMake(ceilf(img.size.width * scale), ceilf(img.size.height * scale));
        CGRect frame = CGRectMake(ceilf((targetSize.width - newSize.width) / 2.0),
                                  ceilf((targetSize.height - newSize.height) / 2.0),
                                  newSize.width,
                                  newSize.height);
        [img drawInRect:frame];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        complection(image);
    });
}
@end
