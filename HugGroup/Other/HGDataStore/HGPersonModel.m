//
//  HGPersonModel.m
//  HugGroup
//
//  Created by wcshinestar on 4/20/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

#import "HGPersonModel.h"

@implementation HGPersonModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(instancetype)personWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        //[self setValuesForKeysWithDictionary:dict];
        self.userid = dict[@"phone"];
        self.name = dict[@"name"];
        self.sex = dict[@"sex"];
        self.location = dict[@"location"];
        self.portraitUri = dict[@"portraitUri"];
    }
    
    return self;
}

@end
