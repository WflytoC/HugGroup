//
//  HGGroupModel.m
//  HugGroup
//
//  Created by wcshinestar on 4/20/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

#import "HGGroupModel.h"

@implementation HGGroupModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+(instancetype)groupWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

-(instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    
    return self;
}

@end
