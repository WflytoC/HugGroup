//
//  HGVideoMessageCell.m
//  HugGroup
//
//  Created by wcshinestar on 4/19/16.
//  Copyright © 2016 com.onesetp.WflytoC. All rights reserved.
//

#import "HGVideoMessageCell.h"
#import "HGVideoMessage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation HGVideoMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    self.backView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.backView.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideo:)];
    [self.backView addGestureRecognizer:tap];
    
    [self.messageContentView addSubview:self.backView];
    
    self.playBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.backView addSubview:self.playBtn];
}

- (void)setDataModel:(RCMessageModel *)model {
    
    [super setDataModel:model];
    
    HGVideoMessage *message = (HGVideoMessage *)self.model.content;
    if (message) {
        
        NSLog(@"Hello,World%@",message.videoURL);
        [self.backView sd_setImageWithURL:[NSURL URLWithString: message.imageURL]];
        self.backView.backgroundColor = [UIColor orangeColor];
        [self.playBtn setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
    }
    
    self.backView.frame = CGRectMake(18, 5, 180, 120);
    self.playBtn.frame = CGRectMake(80, 36, 42, 42);
    
}

- (void)playVideo:(id)sender {
        
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

@end
