

//
//  DAOHelper.m
//  TestDemo
//
//  Created by camera360 on 16/5/6.
//  Copyright © 2016年 camera360. All rights reserved.
//

#import "DAOHelper.h"
#import <FMDB/FMDB.h>

@interface DAOHelper()

@property(nonatomic, strong) FMDatabase * db;

@end

@implementation DAOHelper

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton" reason:@"singleton" userInfo:nil];
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        NSString * dbFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) firstObject];
        dbFilePath = [dbFilePath stringByAppendingPathComponent:@"collect.sqlite"];
        _db = [FMDatabase databaseWithPath:dbFilePath];
        if (_db && [_db open])
        {
            NSString * createSql = @"create table if not exists Collect"
            "("
            "url varchar(100) primary key"
            "thunbnail BLOB not null,"
            "fullImage BLOB not null"
            ")";
            if ([_db executeUpdate:createSql])
            {
                NSLog(@"表创建成功");
            }
            
        }
        else
            NSLog(@"数据库打开失败");
    }
    return self;
}

+ (instancetype)sharedHelper
{
    static dispatch_once_t onceToken;
    static DAOHelper * dbHelper = nil;
    dispatch_once(&onceToken, ^{
        if (!dbHelper)
        {
            dbHelper = [[self alloc] initPrivate];
        }
    });
    return dbHelper;
}

- (BOOL)addToCollect:(NSURL *)url
{
    BOOL success = false;
    if (_db && [_db open]) {
        NSString * urlStr = url.absoluteString;
        NSString * addSql = @"insert into Collect values (?)";
        success = [_db executeUpdate:addSql, urlStr];
    }
    return success;
}

- (NSArray *)loadCollected
{
    NSMutableArray<NSURL *> * array = @[].mutableCopy;
    if (_db && [_db open]) {
        NSString * querySql = @"select * from Collect";
        FMResultSet * rs = [_db executeQuery:querySql];
        while (rs.next)
        {
            NSURL * url = [NSURL URLWithString:[rs stringForColumn:@"url"]];
            [array addObject:url];
        }
        [rs close];
    }
    return array;
}

- (BOOL)removeFromCollect:(NSURL *)url
{
    BOOL success = false;
    if (_db && [_db open]) {
        NSString * urlStr = url.absoluteString;
        NSString * addSql = @"delete from Collect where url = ?";
        success = [_db executeUpdate:addSql, urlStr];
    }
    return success;
}

@end
