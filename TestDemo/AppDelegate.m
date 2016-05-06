//
//  AppDelegate.m
//  TestDemo
//
//  Created by camera360 on 16/5/3.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "MineOwnPhotoFirstController.h"
#import "DAOHelper.h"

static NSString * localSaveStr = @"localphoto";

@interface AppDelegate ()<UITabBarControllerDelegate>

@property(nonatomic, strong) ALAssetsLibrary * lib;

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
   
    MainViewController * mainVc = [MainViewController new];
    mainVc.selectedIndex = 0;
    mainVc.delegate = self;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = mainVc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return true;
   
}


#pragma mark -- Tabbar Delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController
{
    NSMutableArray * array = [[[DAOHelper sharedHelper] loadCollected] copy];
    UIViewController * mineVc = [viewController viewControllers][0];
    if ([mineVc isKindOfClass:[MineOwnPhotoFirstController class]])
    {
        _lib = [[ALAssetsLibrary alloc] init];
        __block NSMutableArray<ALAsset *> * group = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSURL * _Nonnull url, NSUInteger idx, BOOL * _Nonnull stop) {
            [_lib assetForURL:url resultBlock:^(ALAsset *asset)
            {
                [group addObject:asset];
                if ((array.count-1) == idx)
                {
                    ((MineOwnPhotoFirstController*)mineVc).assetArr = group;
                    ((MineOwnPhotoFirstController*)mineVc).fromSystem = true;
                }
            } failureBlock:^(NSError *error) {
                NSLog(@"图片查找失败");
            }];
            
        }];
        
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

//- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
//    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
//        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//        return YES;
//    } else {
//        return NO;
//    }
//}

@end
