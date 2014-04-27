//
//  ViewController.m
//  TestOperation
//
//  Created by Alexander on 17.04.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "MyOperation.h"

@interface ViewController ()
{
    NSOperationQueue *queue;
    MyOperation *oper;
}
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    oper = [MyOperation new];
    queue = [[NSOperationQueue alloc] init];
    [queue setSuspended:YES];
    [queue addOperation:oper];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
        __block int i = 0;
        dispatch_async(dispatch_get_global_queue(2, 0), ^{
            for(; i < 5; i++){
                dispatch_semaphore_signal(semaphore);
                [NSThread sleepForTimeInterval:0.5];
            }
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"%d", i);
    });
    
    self.imgView.image = [self image:[UIImage imageNamed:@"tkRmQPC.jpg"] aspectFillRadius:45];
}

- (IBAction)buttPressed:(id)sender
{
    [oper cancel];
}

- (UIImage*)image:(UIImage*)img aspectFillRadius:(float)radius
{
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
    
    return image;
}
@end
