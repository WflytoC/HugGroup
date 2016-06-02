//
//  HGGroupModel.h
//  HugGroup
//
//  Created by wcshinestar on 4/20/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGGroupModel : NSObject

//团的id
@property(nonatomic,strong)NSString* groupid;

//团的名称
@property(nonatomic,strong)NSString* groupname;

//团的头像地址
@property(nonatomic,strong)NSString* groupportraituri;//

//团的介绍
@property(nonatomic,strong)NSString* groupinfo;

//团的创建者的userID
@property(nonatomic,strong)NSString* creator;

//团的创建时间
@property(nonatomic,strong)NSString* time;

//团的详细分类
@property(nonatomic,strong)NSString* groupclass;

//团的总体分类：共有团与私有团
@property(nonatomic,assign)int grouptype;

+ (instancetype)groupWithDict:(NSDictionary *)dict;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
