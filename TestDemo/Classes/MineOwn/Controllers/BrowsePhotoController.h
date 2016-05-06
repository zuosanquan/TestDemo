//
//  BrowsePhotoController.h
//  TestDemo
//
//  Created by camera360 on 16/5/5.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AssetsLibrary/AssetsLibrary.h>

@interface BrowsePhotoController : UIViewController

/** 接收过来的图片 **/
@property(nonatomic, assign) NSInteger                 currentIndex;
@property(nonatomic, strong) ALAssetsGroup             * group;
@property(nonatomic, strong) NSMutableArray<ALAsset *> * assetArr;

@end
