//
//  DBHelper.h
//  Demo2
//
//  Created by zsm on 14-9-9.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^GetFinishedBlock)(NSArray *dataList);
@interface DBHelper : NSObject
//管理数据库所有操作
//+(DBHelper *)shareInstance;
// 创建表
+ (BOOL)createTableWithSqlString:(NSString *)sql;

// 插入数据1
+ (BOOL)insertTableWithSqlString:(NSString *)sql params:(NSArray *)params;

// 插入数据2
+ (BOOL)insertTableWithSqlString:(NSString *)sql WithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

// 查询语句1
+ (void)getTabelWithSqlString:(NSString *)sql
                       params:(NSArray *)params
             DidFinishedBlock:(GetFinishedBlock)finishedblock;

// 查询语句2
+ (void)getTabelWithSqlString:(NSString *)sql
             DidFinishedBlock:(GetFinishedBlock)finishedblock
                  WithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

// 修改语句1
+ (BOOL)updateTableWithSqlString:(NSString *)sql params:(NSArray *)params;

// 修改语句2
+ (BOOL)updateTableWithSqlString:(NSString *)sql WithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

// 删除语句1
+ (BOOL)deleteTableWithSqlString:(NSString *)sql params:(NSArray *)params;

// 删除语句2
+ (BOOL)deleteTableWithSqlString:(NSString *)sql WithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;


@end
