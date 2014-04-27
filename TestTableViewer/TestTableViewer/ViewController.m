//
//  ViewController.m
//  TestTableViewer
//
//  Created by Alexander on 24.04.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "FruitCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *presentData;
    dispatch_queue_t downloadQueue;
}
@property (nonatomic, weak) IBOutlet UITableView *table;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    downloadQueue = dispatch_queue_create("afsasfsdf", 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)reloadData
{
    if(presentData)
        return;
    
    [[DataManager sharedInstance] asyncListOfFruits:^(NSArray *arr) {
        presentData = arr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.table reloadData];
        });
        NSLog(@"%@", presentData);
    }];
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return presentData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FruitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *dic = presentData[indexPath.row];
    cell.fruitLabel.text = dic[@"title"];
    
    DataManager *dataManager = [DataManager sharedInstance];
    [dataManager asyncGetImage:dic[@"thumb_img"] complection:^(UIImage *img) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", img);
            cell.fruitImgView.image = img;
        });
    }];
    
    return cell;
}

@end
