//
//  KRAnnotationView.m
//  
//
//  Created by Kalvar on 13/3/6.
//  Copyright (c) 2013年 Kuo-Ming Lin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KRAnnotationView.h"
#import "KRAnnotationProtocol.h"

@interface KRAnnotationView ()

@end

@interface KRAnnotationView (fixPrivate)

-(UIImage *)_imageNamedNoCache:(NSString *)_imageName;
-(BOOL)_didAlreadyMakeContent;

@end

@implementation KRAnnotationView (fixPrivate)

-(UIImage *)_imageNamedNoCache:(NSString *)_imageName
{
    return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], _imageName]];
}

//設定左側主圖的白色邊框
-(void)_setupBorderWithImageView:(UIImageView *)_imageView
{
    //添加邊框
    CALayer *_imageViewLayer      = [_imageView layer];
    //預設白色邊框
    _imageViewLayer.borderColor   = [[UIColor whiteColor] CGColor];
    //設定邊框
    _imageViewLayer.borderWidth   = 2.0f;
    //設定邊框陰影 4 邊陰影
    _imageViewLayer.shadowColor   = [[UIColor blackColor] CGColor];
    _imageViewLayer.shadowOffset  = CGSizeMake(0, 0);
    _imageViewLayer.shadowOpacity = 0.5;
    _imageViewLayer.shadowRadius  = 5.0;
    
}

/*
 * @ 判斷是否已製作過要顯示註釋( Callout )的內容了
 */
-(BOOL)_didAlreadyMakeContent
{
    if( self.leftCalloutAccessoryView.subviews )
    {
        if( [self.leftCalloutAccessoryView.subviews count] > 0 )
        {
            //NSLog(@"self.leftCalloutAccessoryView.subviews : %@", self.leftCalloutAccessoryView.subviews);
            return YES;
        }
    }
    return NO;
}

@end

@implementation KRAnnotationView

@synthesize leftImageView     = _leftImageView;
@synthesize customContentView = _customContentView;

-(id)initWithAnnotation:(KRAnnotationProtocol *)_krAnnotation reuseIdentifier:(NSString *)_reuseIdentifier
{
    self = [super initWithAnnotation:_krAnnotation reuseIdentifier:_reuseIdentifier];
    if( self )
    {
        /*
         * @ 設定大頭針的圖片
         */
        ///*
        self.image        = [self _imageNamedNoCache:@"pin_sample.png"];
        self.centerOffset = CGPointMake(self.image.size.width / 2,
                                        self.image.size.height / 2);
        //*/
        self.leftImageView     = nil;
        self.customContentView = nil;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

-(void)drawRect:(CGRect)rect
{
    
}

#pragma My Methods
-(void)makeCustomContent
{
    if( ![self _didAlreadyMakeContent] )
    {
        KRAnnotationProtocol *_krAnnotation = (KRAnnotationProtocol *)self.annotation;
        if( !self.customContentView )
        {
            /*
             * @ customContentView 如要能符合 Apple 原生規範，則最佳允許在寬 260.0f，高 38.0f 的範圍裡。
             */
            _customContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 260, 38.0f)];
            [_customContentView setBackgroundColor:[UIColor clearColor]];
        }
        /*
         * @ 左邊代表圖
         */
        if( !self.leftImageView )
        {
            /*
             * @ 如果沒有左側圖
             *   - 就將 customContentView 的寬度加大
             */
            CGRect _frame = self.customContentView.frame;
            _frame.size.width += 38.0f;
            [_customContentView setFrame:_frame];
        }
        else
        {
            /*
             * @ 有圖片就重新校準圖片位置
             */
            [_leftImageView setFrame:CGRectMake(0.0f, -4.0f, 38.0f, 38.0f)];
            [self _setupBorderWithImageView:_leftImageView];
            [_leftImageView.layer setCornerRadius:8.0f];
            [_leftImageView.layer setMasksToBounds:YES];
            [_customContentView addSubview:_leftImageView];
        }
        
        /*
         * @ 如果在 KRAnnotationProtocol 裡有設定 customTitle 和 customSubtitle
         */
        if( _krAnnotation.customTitle )
        {
            CGRect _titleLabelFrame = CGRectMake(40.0f, -4.0f, 215, 20.0f);
            if( self.leftImageView )
            {
                _titleLabelFrame.origin.x = _leftImageView.frame.size.width + 5.0f;
            }
            else
            {
                CGFloat _leftImageWidth = 38.0f;
                _titleLabelFrame.size.width += _leftImageWidth;
                _titleLabelFrame.origin.x   -= _leftImageWidth;
            }
            UILabel *_titleLabel = [[UILabel alloc]initWithFrame:_titleLabelFrame];
            [_titleLabel setText:_krAnnotation.customTitle];
            [_titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
            [_titleLabel setTextColor:[UIColor whiteColor]];
            [_titleLabel setTextAlignment:NSTextAlignmentLeft];
            [_titleLabel setBackgroundColor:[UIColor clearColor]];
            [_customContentView addSubview:_titleLabel];
        }
        
        if( _krAnnotation.customSubtitle )
        {
            CGRect _subtitleLabelFrame = CGRectMake(40.0f, -4.0f, 215, 18.0f);
            if( self.leftImageView )
            {
                _subtitleLabelFrame.origin.x = _leftImageView.frame.size.width + 5.0f;
            }
            else
            {
                CGFloat _leftImageWidth = 38.0f;
                _subtitleLabelFrame.size.width += _leftImageWidth;
                _subtitleLabelFrame.origin.x   -= _leftImageWidth;
            }
            _subtitleLabelFrame.origin.y = 20.0f + _subtitleLabelFrame.origin.y;
            
            
            UILabel *_subtitleLabel = [[UILabel alloc]initWithFrame:_subtitleLabelFrame];
            [_subtitleLabel setText:_krAnnotation.customSubtitle];
            [_subtitleLabel setFont:[UIFont systemFontOfSize:14.0f]];
            [_subtitleLabel setTextColor:[UIColor whiteColor]];
            [_subtitleLabel setTextAlignment:NSTextAlignmentLeft];
            [_subtitleLabel setBackgroundColor:[UIColor clearColor]];
            [_customContentView addSubview:_subtitleLabel];
        }
        //
        self.leftCalloutAccessoryView  = _customContentView;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}
*/

@end
