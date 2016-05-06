//
//  DAOHelper.h
//  TestDemo
//
//  Created by camera360 on 16/5/6.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DAOHelper : NSObject

+ (instancetype)sharedHelper;
- (BOOL)addToCollect:(NSURL *)url;
- (BOOL)removeFromCollect:(NSURL *)url;
- (NSArray *)loadCollected;

@end
