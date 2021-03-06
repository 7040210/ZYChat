//
//  GJGCChatFriendDriftBottleCell.m
//  ZYChat
//
//  Created by ZYVincent QQ:1003081775 on 15/6/30.
//  Copyright (c) 2015年 ZYProSoft.  QQ群:219357847  All rights reserved.
//

#import "GJGCChatFriendDriftBottleCell.h"
#import "GJGCPlaceHolderImageView.h"

@interface GJGCChatFriendDriftBottleCell ()

@property (nonatomic,strong)UIImageView *bubbleFrontImageView;

@property (nonatomic,strong)GJCFCoreTextContentView *contentLabel;

@property (nonatomic,strong)UIImageView *contentStateBack;

@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UILabel *iconLabel;

@end

@implementation GJGCChatFriendDriftBottleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.bubbleFrontImageView = [[UIImageView alloc]init];
        self.bubbleFrontImageView.gjcf_size = CGSizeZero;
        UIImage *bubbleFrontImage = [UIImage imageNamed:@"im-bg-漂流瓶蒙层"];
        bubbleFrontImage = GJCFImageResize(bubbleFrontImage,25, 26, 20, 21);
        self.bubbleFrontImageView.image = bubbleFrontImage;
        
        self.contentLabel = [[GJCFCoreTextContentView alloc]init];
        self.contentLabel.gjcf_size = CGSizeZero;
        [self.bubbleBackImageView addSubview:self.contentLabel];
        
        CGFloat contentInnerMargin = 12.f;
        CGFloat bubbleToBordMargin = 56;
        CGFloat maxContentWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 2*contentInnerMargin;
        CGFloat maxTextContentWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 13 - 5.5 - 2*contentInnerMargin;

        self.bubbleFrontImageView.gjcf_width = maxContentWidth;
        self.bubbleBackImageView.gjcf_width = self.bubbleFrontImageView.gjcf_width;

        self.contentImageView.gjcf_width = self.bubbleFrontImageView.gjcf_width;
        self.contentImageView.gjcf_height = self.bubbleFrontImageView.gjcf_width - 5.5f;
        self.contentImageView.backgroundColor = GJCFQuickHexColor(@"e6e6e6");
        
        self.contentLabel.contentBaseWidth = maxTextContentWidth;
        self.contentLabel.contentBaseHeight = 10.f;
        
        self.contentStateBack = [[UIImageView alloc]init];
        self.contentStateBack.gjcf_size = CGSizeZero;
        self.contentStateBack.backgroundColor = [UIColor whiteColor];
        self.contentStateBack.gjcf_width = maxContentWidth;
        [self.bubbleBackImageView insertSubview:self.contentStateBack belowSubview:self.contentLabel];
        
        [self.bubbleBackImageView addSubview:self.bubbleFrontImageView];

        self.iconImageView = [[UIImageView alloc]init];
        UIImage *iconImage = [UIImage imageNamed:@"标签-bg-漂流瓶"];
        iconImage = GJCFImageResize(iconImage,iconImage.size.height/2,iconImage.size.height/2,iconImage.size.width/2,iconImage.size.width/2);
        self.iconImageView.image = iconImage;
        [self.bubbleFrontImageView addSubview:self.iconImageView];
        
        self.iconLabel = [[UILabel alloc]init];
        self.iconLabel.backgroundColor = [UIColor clearColor];
        self.iconLabel.font = [UIFont systemFontOfSize:11.f];
        self.iconLabel.text = @"漂流瓶";
        self.iconLabel.textColor = [UIColor whiteColor];
        [self.iconLabel sizeToFit];
        [self.iconImageView addSubview:self.iconLabel];
        
        self.iconImageView.gjcf_width = self.iconLabel.gjcf_width + 11*2;
        self.iconImageView.gjcf_height = self.iconLabel.gjcf_height + 5.f;
        self.iconLabel.gjcf_centerX = self.iconImageView.gjcf_width/2;
        self.iconLabel.gjcf_centerY = self.iconImageView.gjcf_height/2;
        self.iconImageView.gjcf_right = self.bubbleFrontImageView.gjcf_width-1;
        self.iconImageView.gjcf_top = self.bubbleFrontImageView.gjcf_top+1;
        
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnSelf:)];
        [self addGestureRecognizer:tapR];
    }
    
    return self;
}

- (void)setContentModel:(GJGCChatContentBaseModel *)contentModel
{
    [super setContentModel:contentModel];
    
    self.bubbleBackImageView.image = nil;
    self.bubbleBackImageView.highlightedImage = nil;
    
    GJGCChatFriendContentModel *driftModel = (GJGCChatFriendContentModel *)contentModel;

    //图片调整
    CGFloat contentInnerMargin = 12.f;
    CGFloat bubbleToBordMargin = 56;
    CGFloat maxContentWidth = GJCFSystemScreenWidth - bubbleToBordMargin - 40 - 3 - 2*contentInnerMargin;

    self.contentImageView.gjcf_left = 0.f;
    self.contentImageView.gjcf_top = 0.f;
    self.contentImageView.gjcf_width = maxContentWidth;
    self.contentImageView.gjcf_height = maxContentWidth - 5.5f;
    
    self.blankImageView.gjcf_size = CGSizeMake(86.5, 81);
    self.blankImageView.image = [UIImage imageNamed:@"im-img-漂流瓶"];
    self.blankImageView.gjcf_centerX = 5.5 + self.contentImageView.gjcf_height/2;
    self.blankImageView.gjcf_centerY = self.contentImageView.gjcf_height/2;
    
    self.imgUrl = driftModel.imageMessageUrl;
    
    NSString *localCachePath = [[GJCFCachePathManager shareManager] mainImageCacheFilePathForUrl:self.imgUrl];
    UIImage *cachedImage = GJCFQuickImageByFilePath(localCachePath);
    if (cachedImage) {
        self.contentImageView.image = cachedImage;
        self.blankImageView.hidden = YES;
        self.contentImageView.backgroundColor = [UIColor clearColor];
    }else{
        self.blankImageView.hidden = NO;
        self.contentImageView.image = nil;
        self.contentImageView.backgroundColor = GJCFQuickHexColor(@"e6e6e6");
    }    

    //计算文本大小
    CGSize theContentSize = [GJCFCoreTextContentView contentSuggestSizeWithAttributedString:driftModel.driftBottleContentString forBaseContentSize:self.contentLabel.contentBaseSize];
    
    self.contentLabel.gjcf_size = theContentSize;
    
    self.contentStateBack.gjcf_height = theContentSize.height + 2*12;
    self.contentStateBack.gjcf_top = self.contentImageView.gjcf_bottom;
    
    self.contentLabel.contentAttributedString = driftModel.driftBottleContentString;
    
    self.contentLabel.gjcf_left = self.contentStateBack.gjcf_left + 12.f;
    
    self.contentLabel.gjcf_top = self.contentStateBack.gjcf_top+12;
    
    self.bubbleBackImageView.gjcf_height = self.contentStateBack.gjcf_bottom;
    
    self.bubbleFrontImageView.gjcf_height = self.bubbleBackImageView.gjcf_height;
    
}

- (void)tapOnSelf:(UITapGestureRecognizer *)tapR
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatCellDidTapOnDriftBottleCard:)]) {
        
        [self.delegate chatCellDidTapOnDriftBottleCard:self];
    }
}

@end
