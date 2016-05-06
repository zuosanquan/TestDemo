//
//  MainViewController.m
//  TestDemo
//
//  Created by camera360 on 16/5/4.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import "MainViewController.h"
#import "MineOwnPhotoFirstController.h"
#import "SystemPhotosFirstController.h"
#import "UIImage+Utils.h"




@interface MainViewController ()

@property(nonatomic, strong) NSArray<NSString *> * subControllerName;
@property(nonatomic, strong) NSArray<NSString *> * subName;
@property(nonatomic, strong) NSArray<NSString *> * images;
@property(nonatomic, strong) NSArray<NSString *> * selectedImages;
@property(nonatomic, strong) NSMutableArray<UIViewController *> * controllers;

@end

@implementation MainViewController

#pragma Mark -- 懒加载

/*初始化控制器名称*/
-(NSArray<NSString *> *)subControllerName
{
    if (!_subControllerName) {
//        初始化SubControlller的名称
        _subControllerName = @[@"MineOwnPhotoFirstController", @"SystemPhotosFirstController"];
    }
    return _subControllerName;
}
/** 初始化tabbar的名称 **/
-(NSArray<NSString *> *)subName
{
    if (!_subName)
    {
        _subName = @[@"我的", @"系统"];
    }
    return _subName;
}

/** 初始tabbar的图标 **/
-(NSArray<NSString *> *)images
{
    if (!_images)
        _images = @[@"mine", @"system"];
    return _images;
}

/** 初始化tabbar的选中图标 **/
-(NSArray<NSString *> *)selectedImages
{
    if (!_selectedImages) {
        _selectedImages = @[@"mine_filled", @"system_filled"];
    }
    return _selectedImages;
}

-(NSMutableArray<UIViewController *> *)controllers
{
    if (!_controllers) {
        _controllers = @[].mutableCopy;
    }
    return _controllers;
}

#pragma Mark -- 初始化SubController的名称， 之后通过名称得到class， 循环创建控制器


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialData];
    // Do any additional setup after loading the view.
}

- (void)initialData
{
    //判断是否所有的准备工作是否完成
    if ((self.subControllerName.count & self.subName.count & self.images.count & self.selectedImages.count) != self.subControllerName.count) {
        @throw [NSException exceptionWithName:@"tabbar各项配置不一致" reason:@"tabbar各项配置不一致" userInfo:nil];
    }
    
    [self.subControllerName enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController * vc = [[NSClassFromString(obj) alloc] init];
        vc.title = self.subName[idx];
        vc.tabBarItem.image = [UIImage originalImageNamed:self.images[idx]];
        vc.tabBarItem.selectedImage = [UIImage originalImageNamed:self.selectedImages[idx]];
        vc.view.backgroundColor = [UIColor whiteColor];
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.controllers addObject:nav];
    }];
    self.viewControllers = [self.controllers copy];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
