//
//  MyTableViewCell.m
//  HeartTouchTableViewDataSourceDemo
//
//  Created by 志强 on 16/1/18.
//  Copyright © 2016年 志强. All rights reserved.
//

#import "MyTableViewCell.h"

@interface MyTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation MyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    [self.contentView setBackgroundColor:nil];
    self.accessoryType = UITableViewCellAccessoryNone;
}

-(void)setModel:(MyTableViewCellModel *)model
{
    if (_model == model) {
        return;
    }
    _model = model;
    if ([model isKindOfClass:[NSString class]]) {
        _leftLabel.text = @"normal";
        [_button setTitle:(NSString*)model forState:UIControlStateNormal];
    } else {
        _leftLabel.text = model.title;
        [_button setTitle:model.actionName forState:UIControlStateNormal];
    }
    [_button setBackgroundColor:[UIColor orangeColor]];
}

-(CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, 100);
}

@end
