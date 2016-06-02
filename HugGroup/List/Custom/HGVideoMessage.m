//
//  HGVideoMessage.m
//  HugGroup
//
//  Created by wcshinestar on 4/19/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

#import "HGVideoMessage.h"

@implementation HGVideoMessage

+ (instancetype)messageWithImageURL:(NSString *)imageURL videoURL:(NSString *)videoURL {
    
    HGVideoMessage *text = [[HGVideoMessage alloc] init];
    if (text) {
        
        text.imageURL = imageURL;
        text.videoURL = videoURL;
    }
    
    return text;
}

+ (RCMessagePersistent)persistentFlag {
    
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        self.imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        self.videoURL = [aDecoder decodeObjectForKey:@"videoURL"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.videoURL forKey:@"videoURL"];
}

- (NSData *)encode {
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setObject:self.imageURL forKey:@"imageURL"];
    [dataDict setObject:self.videoURL forKey:@"videoURL"];
    
    if (self.senderUserInfo) {
        NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
        if (self.senderUserInfo.name) {
            [userInfoDic setObject:self.senderUserInfo.name forKeyedSubscript:@"name"];
        }
        if (self.senderUserInfo.portraitUri) {
            [userInfoDic setObject:self.senderUserInfo.portraitUri forKeyedSubscript:@"portrait"];
        }
        if (self.senderUserInfo.userId) {
            [userInfoDic setObject:self.senderUserInfo.userId forKeyedSubscript:@"id"];
        }
        [dataDict setObject:userInfoDic forKey:@"user"];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:kNilOptions error:nil];
    return data;
}

+(NSString *)getObjectName {
    
    return HGViedoMessageTypeIdentifier;
}

- (void)decodeWithData:(NSData *)data {
    
    if (data) {
        __autoreleasing NSError *error = nil;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        
        if (dictionary) {
            self.imageURL = dictionary[@"imageURL"];
            self.videoURL = dictionary[@"videoURL"];
            
            NSDictionary *userinfoDic = dictionary[@"user"];
            [self decodeUserInfo:userinfoDic];
        }
    }
    

}



@end
