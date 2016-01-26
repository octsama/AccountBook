//
//  XSDBManager.m
//  AccountBook
//
//  Created by 君の神様 on 16/1/26.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "XSDBManager.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface XSDBManager ()

@property (nonatomic, strong)NSString *databasePath;

@end

@implementation XSDBManager

static dispatch_once_t onceToken;

+ (instancetype)dbManager {
    static XSDBManager *dbManager = nil;
    dispatch_once(&onceToken, ^{
        dbManager = [[XSDBManager alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        dbManager.databasePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"database.sqlite"]];
        [dbManager createTables];
    });
    return dbManager;
}

- (FMDatabase *)database {
    FMDatabase *db = [FMDatabase databaseWithPath:_databasePath];
    if (![db open]) {
        return nil;
    }
    return db;
}

- (void)createTables {
    FMDatabase *db = [self database];
    if (db) {
        [db executeUpdate:@"create table if not exists account (id integer primary key AutoIncrement, budgetPerMonth integer, budgetToday integer, budgetPerDay integer)"];
        [db close];
    }
}

@end
