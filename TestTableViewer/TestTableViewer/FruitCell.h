//
//  FruitCell.h
//  TestTableViewer
//
//  Created by Alexander on 24.04.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FruitCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *fruitImgView;
@property (nonatomic, weak) IBOutlet UILabel *fruitLabel;
@end
