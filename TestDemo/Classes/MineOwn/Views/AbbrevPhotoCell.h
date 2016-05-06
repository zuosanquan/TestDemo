//
//  AbbrevPhotoCell.h
//  TestDemo
//
//  Created by camera360 on 16/5/5.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "PhotoModel.h"

@interface AbbrevPhotoCell : UICollectionViewCell

@property(nonatomic, assign) BOOL           isSelected;
@property(nonatomic, strong) PhotoModel     * model;

@end
