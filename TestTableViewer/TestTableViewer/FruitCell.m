//
//  FruitCell.m
//  TestTableViewer
//
//  Created by Alexander on 24.04.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "FruitCell.h"

@implementation FruitCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
