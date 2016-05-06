//
//  MineOwnPhotoFirstController.h
//  TestDemo
//
//  Created by camera360 on 16/5/4.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AssetsLibrary/AssetsLibrary.h>

@interface MineOwnPhotoFirstController : UIViewController

@property(nonatomic, strong) ALAssetsGroup * group;
@property(nonatomic, strong) NSMutableArray<ALAsset *> * assetArr;
//因为这个控制用于展示图片详情，需要复用， 如果fromSystem = true， 代表图片数据来自系统相册
@property(nonatomic, assign) BOOL            fromSystem;

@end
