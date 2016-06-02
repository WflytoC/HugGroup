//
//  HGDataBaseManager.h
//  HugGroup
//
//  Created by wcshinestar on 4/20/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.

#import <Foundation/Foundation.h>

@class HGPersonModel;
@class HGGroupModel;

@interface HGDataBaseManager: NSObject

+ (HGDataBaseManager*)shareInstance;
-(void)insertUserToDB:(HGPersonModel*)user;
-(HGPersonModel*) getUserByUserId:(NSString*)userId;
-(void)insertGroupToDB:(HGGroupModel *)group;
-(HGGroupModel*) getGroupByGroupId:(NSString*)groupId;
-(NSArray *) getAllGroups;
-(void)clearGroupsData;
-(void)clearPersonsData;

@end
