//
//  HGPersonModel.h
//  HugGroup
//
//  Created by wcshinestar on 4/20/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGPersonModel : NSObject

//用户的id
@property(nonatomic,strong)NSString* userid;

//用户名
@property(nonatomic,strong)NSString* name;

//用户头像
@property(nonatomic,strong)NSString* portraitUri;

//用户性别
@property(nonatomic,strong)NSString* sex;

//用户地址
@property(nonatomic,strong)NSString* location;

+ (instancetype)personWithDict:(NSDictionary *)dict;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
