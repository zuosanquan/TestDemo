//
//  PhotoModel.h
//  TestDemo
//
//  Created by camera360 on 16/5/5.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AssetsLibrary/AssetsLibrary.h>

@interface PhotoModel : NSObject

@property(nonatomic, strong) ALAsset    * photo;
@property(nonatomic, assign) BOOL       isSelected;

@end
