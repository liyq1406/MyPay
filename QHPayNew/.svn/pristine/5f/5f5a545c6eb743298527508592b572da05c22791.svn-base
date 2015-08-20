//
//  YRIputCell.m
//  YunRichMPCR
//
//  Created by YunRich on 15/3/31.
//  Copyright (c) 2015年 YunRich. All rights reserved.
//

#import "YRIputCell.h"

@implementation YRIputCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)setCellType:(InputCellType)cellType{
    _cellType = cellType;
    
    if (cellType == InputCellTypeTF) {
        UITextField * textField = [[UITextField alloc] init];
        textField.borderStyle = UITextBorderStyleLine;
        textField.font = [UIFont systemFontOfSize:15];
        textField.frame = CGRectMake(100, 4, 200, 36);
        [self.contentView addSubview:textField];
        _inputTF = textField;
    }else if (cellType == InputCellTypeButton){
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(100, 4, 200, 36);
        [button setTitle:@"弹出框" forState:UIControlStateNormal];
        [self.contentView addSubview:button];
        _popFieldBtn = button;
    }
}

@end
