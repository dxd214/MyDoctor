//
//  DBHelper.m
//  Demo2
//
//  Created by zsm on 14-9-9.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "DBHelper.h"
#import <sqlite3.h>
@implementation DBHelper

#pragma mark - Create

//static DBHelper *instance = nil;
//+(DBHelper *)shareInstance
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[DBHelper alloc]init];
//    });
//    return instance;
//}
//
+ (BOOL)createTableWithSqlString:(NSString *)sql
{
    //1.创建一个数据库对象
    sqlite3 *sqlite = nil;
    
    //2.数据库的路径
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySqlite.db"];
    
    //3.打开数据库
    int result = sqlite3_open([path UTF8String], &sqlite);
    if (result != SQLITE_OK) {
        NSLog(@"数据库打开失败");
        return NO;
    }
    
    
    //4.执行创建表的SQL语句
    char *error = NULL;
    result = sqlite3_exec(sqlite, [sql UTF8String], NULL, NULL, &error);
    if (result != SQLITE_OK) {
        NSLog(@"创建表失败");
        //关闭数据库
        sqlite3_close(sqlite);
        return NO;
    }
    
    //6.关闭数据库
    sqlite3_close(sqlite);
    return YES;
}

#pragma mark - Insert

// 插入数据
+ (BOOL)insertTableWithSqlString:(NSString *)sql params:(NSArray *)params
{
    //1.打开数据库
    sqlite3 *mySqlite = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySqlite.db"];
    int result = sqlite3_open([path UTF8String], &mySqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }
    
    //2.编译sql语句
    //创建数据句柄
    sqlite3_stmt *stmt = nil;
    result = sqlite3_prepare_v2(mySqlite, [sql UTF8String], -1, &stmt, nil);
    if (result != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //3.填充编译好sql语句中的数据
//    sqlite3_bind_text(stmt, 1, "654321", -1, nil);
//    sqlite3_bind_text(stmt, 2, "王五", -1, nil);
//    sqlite3_bind_int(stmt, 3, 18);
    
    //便利参数
    for (int i = 0; i < params.count; i++) {
        //判断数据类型
        if ([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i + 1, [params[i] UTF8String], -1, nil);
        } else {
            sqlite3_bind_int(stmt, i + 1, [params[i] integerValue]);
        }
    }
    
    //4.执行sql语句
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"插入失败!");
        //关闭数据句柄
        sqlite3_finalize(stmt);
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //关闭数据句柄
    sqlite3_finalize(stmt);
    //关闭数据库
    sqlite3_close(mySqlite);
    
    return YES;
}

// 插入数据
+ (BOOL)insertTableWithSqlString:(NSString *)sql WithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    //1.打开数据库
    sqlite3 *mySqlite = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySqlite.db"];
    int result = sqlite3_open([path UTF8String], &mySqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }
    
    //2.编译sql语句
    //创建数据句柄
    sqlite3_stmt *stmt = nil;
    result = sqlite3_prepare_v2(mySqlite, [sql UTF8String], -1, &stmt, nil);
    if (result != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //3.填充编译好sql语句中的数据
    // 挨个的获取参数
    NSMutableArray *args = [NSMutableArray array];
    // 定义一个指向参数的列表指针
    va_list params;
    va_start(params, firstObj);
    if (firstObj) {
        //把第一个参数添加到数组里面
        [args addObject:firstObj];
        
        id arg;
        //va_list 指向下一个地址
        while ((arg = va_arg(params, id)))
        {
            if (arg) {
                [args addObject:arg];
            }
        }
        //置空
        va_end(params);
    }
    
    //便利参数
    for (int i = 0; i < args.count; i++) {
        //判断数据类型
        if ([args[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i + 1, [args[i] UTF8String], -1, nil);
        } else {
            sqlite3_bind_int(stmt, i + 1, [args[i] integerValue]);
        }
    }
    
    //4.执行sql语句
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"插入失败!");
        //关闭数据句柄
        sqlite3_finalize(stmt);
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //关闭数据句柄
    sqlite3_finalize(stmt);
    //关闭数据库
    sqlite3_close(mySqlite);
    
    
    return YES;
}

#pragma mark - Select

// 查询语句
+ (void)getTabelWithSqlString:(NSString *)sql
                       params:(NSArray *)params
             DidFinishedBlock:(GetFinishedBlock)finishedblock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            //1.打开数据库
            sqlite3 *mySqlite = nil;
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySqlite.db"];
            int result = sqlite3_open([path UTF8String], &mySqlite);
            if (result != SQLITE_OK) {
                NSLog(@"打开数据库失败!");
                return;
            }
            
            //2.编译sql语句
            //创建数据句柄
            sqlite3_stmt *stmt = nil;
            result = sqlite3_prepare_v2(mySqlite, [sql UTF8String], -1, &stmt, nil);
            if (result != SQLITE_OK) {
                NSLog(@"编译sql语句失败");
                //关闭数据库
                sqlite3_close(mySqlite);
                return;
            }
            
            //3.填充编译好sql语句中的数据
            //    sqlite3_bind_text(stmt, 1, "654321", -1, nil);
            //    sqlite3_bind_text(stmt, 2, "王五", -1, nil);
            //    sqlite3_bind_int(stmt, 3, 18);
            
            //便利参数
            for (int i = 0; i < params.count; i++) {
                //判断数据类型
                if ([params[i] isKindOfClass:[NSString class]]) {
                    sqlite3_bind_text(stmt, i + 1, [params[i] UTF8String], -1, nil);
                } else {
                    sqlite3_bind_int(stmt, i + 1, [params[i] integerValue]);
                }
            }
            
            //4.执行sql语句
            result = sqlite3_step(stmt);
            
            //创建一个可变的数组存放所有的数据
            NSMutableArray *dataList = [NSMutableArray array];
            while (result == SQLITE_ROW) {
                //创建一个可变的字典,存放所有的数据
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                //便利stmt里面的数据(一条数据里面的内容)
                //获取该数据有多少个字段
                int column_count = sqlite3_column_count(stmt);
                for (int j = 0; j < column_count;j++) {
                    //获取当前字段的名字
                    char *charName = (char *)sqlite3_column_name(stmt, j);
                    NSString *key = [NSString stringWithUTF8String:charName];
                    
                    //判断当前字段内容的类型
                    if (sqlite3_column_type(stmt, j) == SQLITE_TEXT) {
                        //获取当前字段里面的内容
                        char *charText = (char *)sqlite3_column_text(stmt, j);
                        NSString *value = [NSString stringWithUTF8String:charText];
                        
                        //把该字段信息的内容添加到可变字典里面
                        [dic setObject:value forKey:key];
                    } else {
                        //获取当前字段里面的内容
                        int value = sqlite3_column_int(stmt, j);
                        
                        //把该字段信息的内容添加到可变字典里面
                        [dic setObject:@(value) forKey:key];
                    }
                }
                //把字典添加的数组中
                [dataList addObject:dic];
                
                //让数据句柄游标移动到下一条数据
                result = sqlite3_step(stmt);
            }
            
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                finishedblock(dataList);
            });
            
            
            //关闭数据句柄
            sqlite3_finalize(stmt);
            //关闭数据库
            sqlite3_close(mySqlite);
        }
    });
    
}

// 查询语句2
+ (void)getTabelWithSqlString:(NSString *)sql
             DidFinishedBlock:(GetFinishedBlock)finishedblock
                  WithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    // 挨个的获取参数
    NSMutableArray *args = [NSMutableArray array];
    // 定义一个指向参数的列表指针
    va_list params;
    va_start(params, firstObj);
    
    if (firstObj) {
        //把第一个参数添加到数组里面
        [args addObject:firstObj];
        
        id arg;
        //va_list 指向下一个地址
        while ((arg = va_arg(params, id)))
        {
            if (arg) {
                [args addObject:arg];
            }
        }
        //置空
        va_end(params);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            //1.打开数据库
            sqlite3 *mySqlite = nil;
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySqlite.db"];
            int result = sqlite3_open([path UTF8String], &mySqlite);
            if (result != SQLITE_OK) {
                NSLog(@"打开数据库失败!");
                return;
            }
            
            //2.编译sql语句
            //创建数据句柄
            sqlite3_stmt *stmt = nil;
            result = sqlite3_prepare_v2(mySqlite, [sql UTF8String], -1, &stmt, nil);
            if (result != SQLITE_OK) {
                NSLog(@"编译sql语句失败");
                //关闭数据库
                sqlite3_close(mySqlite);
                return;
            }
            
            
            
            //便利参数
            for (int i = 0; i < args.count; i++) {
                //判断数据类型
                if ([args[i] isKindOfClass:[NSString class]]) {
                    sqlite3_bind_text(stmt, i + 1, [args[i] UTF8String], -1, nil);
                } else {
                    sqlite3_bind_int(stmt, i + 1, [args[i] integerValue]);
                }
            }
            
            //4.执行sql语句
            result = sqlite3_step(stmt);
            
            //创建一个可变的数组存放所有的数据
            NSMutableArray *dataList = [NSMutableArray array];
            while (result == SQLITE_ROW) {
                //创建一个可变的字典,存放所有的数据
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                
                //便利stmt里面的数据(一条数据里面的内容)
                //获取该数据有多少个字段
                int column_count = sqlite3_column_count(stmt);
                for (int j = 0; j < column_count;j++) {
                    //获取当前字段的名字
                    char *charName = (char *)sqlite3_column_name(stmt, j);
                    NSString *key = [NSString stringWithUTF8String:charName];
                    
                    //判断当前字段内容的类型
                    if (sqlite3_column_type(stmt, j) == SQLITE_TEXT) {
                        //获取当前字段里面的内容
                        char *charText = (char *)sqlite3_column_text(stmt, j);
                        NSString *value = [NSString stringWithUTF8String:charText];
                        
                        //把该字段信息的内容添加到可变字典里面
                        [dic setObject:value forKey:key];
                    } else {
                        //获取当前字段里面的内容
                        int value = sqlite3_column_int(stmt, j);
                        
                        //把该字段信息的内容添加到可变字典里面
                        [dic setObject:@(value) forKey:key];
                    }
                }
                //把字典添加的数组中
                [dataList addObject:dic];
                
                //让数据句柄游标移动到下一条数据
                result = sqlite3_step(stmt);
            }
            
            //回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                finishedblock(dataList);
            });
            
            
            //关闭数据句柄
            sqlite3_finalize(stmt);
            //关闭数据库
            sqlite3_close(mySqlite);
        }
    });
}

#pragma mark - Update

// 修改语句1
+ (BOOL)updateTableWithSqlString:(NSString *)sql params:(NSArray *)params
{
    //1.打开数据库
    sqlite3 *mySqlite = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySqlite.db"];
    int result = sqlite3_open([path UTF8String], &mySqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }
    
    //2.编译sql语句
    //创建数据句柄
    sqlite3_stmt *stmt = nil;
    result = sqlite3_prepare_v2(mySqlite, [sql UTF8String], -1, &stmt, nil);
    if (result != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //3.填充编译好sql语句中的数据
    //    sqlite3_bind_text(stmt, 1, "654321", -1, nil);
    //    sqlite3_bind_text(stmt, 2, "王五", -1, nil);
    //    sqlite3_bind_int(stmt, 3, 18);
    
    //便利参数
    for (int i = 0; i < params.count; i++) {
        //判断数据类型
        if ([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i + 1, [params[i] UTF8String], -1, nil);
        } else {
            sqlite3_bind_int(stmt, i + 1, [params[i] integerValue]);
        }
    }
    
    //4.执行sql语句
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"插入失败!");
        //关闭数据句柄
        sqlite3_finalize(stmt);
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //关闭数据句柄
    sqlite3_finalize(stmt);
    //关闭数据库
    sqlite3_close(mySqlite);
    
    return YES;
}

// 修改语句2
+ (BOOL)updateTableWithSqlString:(NSString *)sql WithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    //1.打开数据库
    sqlite3 *mySqlite = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySqlite.db"];
    int result = sqlite3_open([path UTF8String], &mySqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }
    
    //2.编译sql语句
    //创建数据句柄
    sqlite3_stmt *stmt = nil;
    result = sqlite3_prepare_v2(mySqlite, [sql UTF8String], -1, &stmt, nil);
    if (result != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //3.填充编译好sql语句中的数据
    // 挨个的获取参数
    NSMutableArray *args = [NSMutableArray array];
    // 定义一个指向参数的列表指针
    va_list params;
    va_start(params, firstObj);
    if (firstObj) {
        //把第一个参数添加到数组里面
        [args addObject:firstObj];
        
        id arg;
        //va_list 指向下一个地址
        while ((arg = va_arg(params, id)))
        {
            if (arg) {
                [args addObject:arg];
            }
        }
        //置空
        va_end(params);
    }
    
    //便利参数
    for (int i = 0; i < args.count; i++) {
        //判断数据类型
        if ([args[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i + 1, [args[i] UTF8String], -1, nil);
        } else {
            sqlite3_bind_int(stmt, i + 1, [args[i] integerValue]);
        }
    }
    
    //4.执行sql语句
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"插入失败!");
        //关闭数据句柄
        sqlite3_finalize(stmt);
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //关闭数据句柄
    sqlite3_finalize(stmt);
    //关闭数据库
    sqlite3_close(mySqlite);
    
    
    return YES;
}

#pragma mark - Delete

// 删除语句1
+ (BOOL)deleteTableWithSqlString:(NSString *)sql params:(NSArray *)params
{
    //1.打开数据库
    sqlite3 *mySqlite = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySqlite.db"];
    int result = sqlite3_open([path UTF8String], &mySqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }
    
    //2.编译sql语句
    //创建数据句柄
    sqlite3_stmt *stmt = nil;
    result = sqlite3_prepare_v2(mySqlite, [sql UTF8String], -1, &stmt, nil);
    if (result != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //3.填充编译好sql语句中的数据
    //    sqlite3_bind_text(stmt, 1, "654321", -1, nil);
    //    sqlite3_bind_text(stmt, 2, "王五", -1, nil);
    //    sqlite3_bind_int(stmt, 3, 18);
    
    //便利参数
    for (int i = 0; i < params.count; i++) {
        //判断数据类型
        if ([params[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i + 1, [params[i] UTF8String], -1, nil);
        } else {
            sqlite3_bind_int(stmt, i + 1, [params[i] integerValue]);
        }
    }
    
    //4.执行sql语句
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"插入失败!");
        //关闭数据句柄
        sqlite3_finalize(stmt);
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //关闭数据句柄
    sqlite3_finalize(stmt);
    //关闭数据库
    sqlite3_close(mySqlite);
    
    return YES;
}

// 删除语句2
+ (BOOL)deleteTableWithSqlString:(NSString *)sql WithObjects:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    //1.打开数据库
    sqlite3 *mySqlite = nil;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/mySqlite.db"];
    int result = sqlite3_open([path UTF8String], &mySqlite);
    if (result != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }
    
    //2.编译sql语句
    //创建数据句柄
    sqlite3_stmt *stmt = nil;
    result = sqlite3_prepare_v2(mySqlite, [sql UTF8String], -1, &stmt, nil);
    if (result != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //3.填充编译好sql语句中的数据
    // 挨个的获取参数
    NSMutableArray *args = [NSMutableArray array];
    // 定义一个指向参数的列表指针
    va_list params;
    va_start(params, firstObj);
    if (firstObj) {
        //把第一个参数添加到数组里面
        [args addObject:firstObj];
        
        id arg;
        //va_list 指向下一个地址
        while ((arg = va_arg(params, id)))
        {
            if (arg) {
                [args addObject:arg];
            }
        }
        //置空
        va_end(params);
    }
    
    //便利参数
    for (int i = 0; i < args.count; i++) {
        //判断数据类型
        if ([args[i] isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(stmt, i + 1, [args[i] UTF8String], -1, nil);
        } else {
            sqlite3_bind_int(stmt, i + 1, [args[i] integerValue]);
        }
    }
    
    //4.执行sql语句
    result = sqlite3_step(stmt);
    if (result == SQLITE_ERROR || result == SQLITE_MISUSE) {
        NSLog(@"插入失败!");
        //关闭数据句柄
        sqlite3_finalize(stmt);
        //关闭数据库
        sqlite3_close(mySqlite);
        return NO;
    }
    
    //关闭数据句柄
    sqlite3_finalize(stmt);
    //关闭数据库
    sqlite3_close(mySqlite);
    
    
    return YES;

}

@end
