
//
//  AbbrevPhotoCell.m
//  TestDemo
//
//  Created by camera360 on 16/5/5.
//  Copyright © 2016年 camera360. All rights reserved.
//
#import <PureLayout/PureLayout.h>
#import "AbbrevPhotoCell.h"


@interface AbbrevPhotoCell()

@property(nonatomic, strong) UIImageView * selectedView;
@property(nonatomic, strong) UIImageView * photoView;

@end

@implementation AbbrevPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        采用自动布局
        _selectedView   = [[UIImageView alloc] init];
        _photoView      = [[UIImageView alloc] init];
        [_photoView addSubview:_selectedView];
        [self.contentView addSubview:_photoView];
//        _photoView的布局
        ALEdgeInsets photoEdge = ALEdgeInsetsMake(0,0,0,0);
        [_photoView autoPinEdgesToSuperviewEdgesWithInsets:photoEdge];
//        _选中标签的布局, 设置固定大小
        [_selectedView autoSetDimensionsToSize:CGSizeMake(20.0, 20.0)];
        [_selectedView autoCenterInSuperview];
        
    }
    return self;
}

- (void)setModel:(PhotoModel *)model
{
    _model = model;
    ALAsset * photo = model.photo;
    //获取缩略图
    UIImage * image = [UIImage imageWithCGImage:[photo thumbnail]];
    _photoView.image = image;
    _selectedView.image = [UIImage imageNamed:@"selected"];
    self.isSelected = model.isSelected;
}

- (void) setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    _selectedView.hidden = !_isSelected;
}

@end
