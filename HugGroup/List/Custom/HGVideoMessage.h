//
//  HGVideoMessage.h
//  HugGroup
//
//  Created by wcshinestar on 4/19/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define HGViedoMessageTypeIdentifier @"HG: VDMsg"

@interface HGVideoMessage : RCMessageContent <NSCoding>

@property(nonatomic,strong) NSString *imageURL;

@property(nonatomic,strong) NSString *videoURL;


+ (instancetype)messageWithImageURL:(NSString *)imageURL videoURL:(NSString *)videoURL;








@end
