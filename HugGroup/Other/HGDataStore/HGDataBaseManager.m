//
//  HGDataBaseManager.m
//  HugGroup
//
//  Created by wcshinestar on 4/20/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.

#import "HGDataBaseManager.h"
#import "DBHelper.h"
#import "HGGroupModel.h"
#import "HGPersonModel.h"

@implementation HGDataBaseManager

static NSString * const personTableName = @"table_persons";
static NSString * const groupTableName = @"table_groups";

+ (HGDataBaseManager*)shareInstance
{
    static HGDataBaseManager* instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
        [instance CreateUserTable];
    });
    return instance;
}

//创建用户存储表
-(void)CreateUserTable
{
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return;
    }
    [queue inDatabase:^(FMDatabase *db) {
        
        if (![DBHelper isTableOK: groupTableName withDB:db]) {
            NSLog(@"createTableSQL");
            NSString *createTableSQL = @"CREATE TABLE table_groups (groupid text,groupname text, groupportraituri text,groupinfo text,creator text,time text,groupclass text,grouptype text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_groupid ON table_groups(groupid);";
            [db executeUpdate:createIndexSQL];
        }
        if (![DBHelper isTableOK: personTableName withDB:db]) {
            NSString *createTableSQL = @"CREATE TABLE table_persons (userid text,name text, portraitUri text,sex text,location text)";
            [db executeUpdate:createTableSQL];
            NSString *createIndexSQL=@"CREATE unique INDEX idx_personid ON table_persons(userid);";
            [db executeUpdate:createIndexSQL];
        }
        
    }];
    
}

//存储用户信息
-(void)insertUserToDB:(HGPersonModel*)user
{
    NSString *insertSql = @"REPLACE INTO table_persons (userid, name, portraitUri,sex,location) VALUES (?, ?, ?, ?, ?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];

    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:insertSql,user.userid,user.name,user.portraitUri,user.sex,user.location];
    }];
}



//从表中获取用户信息
-(HGPersonModel*) getUserByUserId:(NSString*)userId
{
    __block HGPersonModel *model = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return nil;
    }
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM table_persons where userid = ?",userId];
        while ([rs next]) {
            model = [[HGPersonModel alloc] init];
            model.userid = [rs stringForColumn:@"userid"];
            model.name = [rs stringForColumn:@"name"];
            model.portraitUri = [rs stringForColumn:@"portraitUri"];
            model.sex = [rs stringForColumn:@"sex"];
            model.location = [rs stringForColumn:@"location"];
        }
        [rs close];
    }];
    return model;
}


//存储群组信息
-(void)insertGroupToDB:(HGGroupModel *)group
{
    
    NSString *insertSql = @"REPLACE INTO table_groups (groupid, groupname,groupportraituri,groupinfo,creator,time,groupclass,grouptype) VALUES (?,?,?,?,?,?,?,?)";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
        if (queue==nil) {
            return;
        }
    [queue inDatabase:^(FMDatabase *db) {
        
        [db executeUpdate:insertSql,group.groupid, group.groupname,group.groupportraituri,group.groupinfo,group.creator,group.time,group.groupclass,[NSString stringWithFormat:@"%d",group.grouptype]];
    }];
}
//从表中获取群组信息
-(HGGroupModel*) getGroupByGroupId:(NSString*)groupId
{
    __block HGGroupModel *model = nil;
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM table_groups where groupid = ?",groupId];
        while ([rs next]) {
            model = [[HGGroupModel alloc] init];
            model.groupid = [rs stringForColumn:@"groupid"];
            model.groupname = [rs stringForColumn:@"groupname"];
            model.groupportraituri = [rs stringForColumn:@"groupportraituri"];
            model.groupinfo=[rs stringForColumn:@"groupinfo"];
            model.creator=[rs stringForColumn:@"creator"];
            model.time=[rs stringForColumn:@"time"];
            model.groupclass=[rs stringForColumn:@"groupclass"];
            model.grouptype=[rs stringForColumn:@"grouptype"].intValue;
            
        }
        [rs close];
    }];
    return model;
}

//获取所有的群组信息
-(NSArray *) getAllGroups
{
    NSMutableArray *allGroups = [NSMutableArray new];
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM table_groups"];
        while ([rs next]) {
            HGGroupModel *model;
            model = [[HGGroupModel alloc] init];
            model.groupinfo = [rs stringForColumn:@"groupinfo"];
            model.groupname = [rs stringForColumn:@"groupname"];
            model.groupportraituri = [rs stringForColumn:@"groupportraituri"];
            model.groupid=[rs stringForColumn:@"groupid"];
            model.creator=[rs stringForColumn:@"creator"];
            model.time=[rs stringForColumn:@"time"];
            model.groupclass=[rs stringForColumn:@"groupclass"];
            model.grouptype=[rs stringForColumn:@"grouptype"].intValue;
            [allGroups addObject:model];
        }
        [rs close];
    }];
    return allGroups;
}



//清空群组缓存数据
-(void)clearGroupsData
{
    NSString *deleteSql = @"DELETE FROM table_groups";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}

//清空用户缓存数据
-(void)clearPersonsData
{
    NSString *deleteSql = @"DELETE FROM table_persons";
    FMDatabaseQueue *queue = [DBHelper getDatabaseQueue];
    if (queue==nil) {
        return ;
    }
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:deleteSql];
    }];
}



@end
