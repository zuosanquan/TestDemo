//
//  DetailViewController.h
//  TestDemo
//
//  Created by camera360 on 16/5/3.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

