//
//  CoreDataDBHelper.m
//  demo3
//
//  Created by zsm on 14-10-31.
//  Copyright (c) 2014年 zsm. All rights reserved.
//

#import "CoreDataDBHelper.h"

@implementation CoreDataDBHelper

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 1.数据模型对象
        NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:MODEL_NAME withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        
        // 2.创建本地持久文件对象
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
        // 设置本地数据的保存位置
        NSURL *fileUrl = [NSURL fileURLWithPath:PATH];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:fileUrl options:nil error:nil];
        
        // 3.管理数据对象
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:_persistentStoreCoordinator];
    }
    return self;
}


// 设计成单例模式
+ (CoreDataDBHelper *)shareCoreDataDBHelper
{
    static CoreDataDBHelper *coreDataDBHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataDBHelper = [[CoreDataDBHelper alloc] init];
    });
    
    return coreDataDBHelper;
}

// 添加数据的方法
/*
    params : @{ 
                  @"name":@"张三"，
                  @"age":@20
             }
 */
- (BOOL)insertDataWithModelName:(NSString *)modelName
             setAttributWithDic:(NSDictionary *)params
{
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:modelName inManagedObjectContext:_managedObjectContext];
    
    // 遍历参数字典
    for (NSString *key in params) {
        SEL selector = [self selWithKeyName:key];
        if ([entity respondsToSelector:selector]) {
            [entity performSelector:selector withObject:params[key]];
        }
    }
    [_managedObjectContext insertObject:entity];
    
    // 保存到本地
    return [_managedObjectContext save:nil];
}

// 查看
/*
 modelName           :实体对象类的名字
 predicateString     :谓词条件
 identifers          :排序字段集合
 ascending           :是否升序
 */
- (NSArray *)selectDataWithModelName:(NSString *)modelName
                     predicateString:(NSString *)predicateString
                                sort:(NSArray *)identifers
                           ascending:(BOOL)ascending
{
    // 1.创建实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:modelName inManagedObjectContext:_managedObjectContext];
    
    // 2.创建一个查询对象
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // 告诉查询对象你要查询的数据类型
    [request setEntity:entity];
    
    // 添加查询条件
    if (predicateString != nil || [predicateString isEqualToString:@""]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
        [request setPredicate:predicate];
    }
    
    
    // 3.设置排序
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    for (NSString *identifer in identifers) {
        // 创建排序对象
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:identifer ascending:ascending];
        // 把排序对象添加到数组中
        [sortDescriptors addObject:sortDescriptor];
    }
    // 把排序对象设置到查询对象里面
    [request setSortDescriptors:sortDescriptors];
    
    // 3.开始查询
    return [_managedObjectContext executeFetchRequest:request error:nil];
}


// 修改
- (BOOL)updateDataWithModelName:(NSString *)modelName
                predicateString:(NSString *)predicateString
             setAttributWithDic:(NSDictionary *)params
{
    // 获取所有需要修改实体对象
    NSArray *entitys = [self selectDataWithModelName:modelName predicateString:predicateString sort:nil ascending:NO];
    
    // 遍历所有的实体对象
    for (NSEntityDescription *entity in entitys) {
        // 修改对象的属性
        for (NSString *key in params) {
            SEL selector = [self selWithKeyName:key];
            if ([entity respondsToSelector:selector]) {
                [entity performSelector:selector withObject:params[key]];
            }
        }
    }
    
    return [_managedObjectContext save:nil];
    
}

// 删除
- (BOOL)deleteDataWithModelName:(NSString *)modelName
                predicateString:(NSString *)predicateString
{
    // 获取所有需要修改实体对象
    NSArray *entitys = [self selectDataWithModelName:modelName predicateString:predicateString sort:nil ascending:NO];
    
    // 遍历所有的实体对象
    for (NSEntityDescription *entity in entitys) {
        // 删除对象
        [_managedObjectContext deleteObject:entity];
        
    }
    
    return [_managedObjectContext save:nil];
}


// 通过一个字符串反回一个set方法
- (SEL)selWithKeyName:(NSString *)keyName
{
    NSString *first = [[keyName substringToIndex:1] uppercaseString];
    NSString *end = [keyName substringFromIndex:1];
    NSString *selString = [NSString stringWithFormat:@"set%@%@:",first,end];
    return NSSelectorFromString(selString);
}

#pragma mark - Core Data Saving support









@end
