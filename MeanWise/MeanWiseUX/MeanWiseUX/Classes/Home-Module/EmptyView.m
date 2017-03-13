//
//  EmptyView.m
//  MeanWiseUX
//
//  Created by Hardik on 30/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "EmptyView.h"

@implementation EmptyView

- (void)baseInit {
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self baseInit];
        

        self.backgroundColor=[UIColor clearColor];
        
        
        self.msgLBL=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20)];
        [self addSubview:self.msgLBL];
        self.msgLBL.textAlignment=NSTextAlignmentCenter;
        
        self.msgLBL.font=[UIFont fontWithName:k_fontRegular size:20];
        self.msgLBL.text=@"No data found";
        
        
        
        self.reloadBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        [self addSubview:self.reloadBtn];
        [self.reloadBtn setTitle:@"Refresh" forState:UIControlStateNormal];
        [self.reloadBtn addTarget:self action:@selector(reloadBtnclicked:) forControlEvents:UIControlEventTouchUpInside];
        self.reloadBtn.titleLabel.adjustsFontSizeToFitWidth=YES;
        
        self.reloadBtn.clipsToBounds=YES;
        self.reloadBtn.layer.cornerRadius=5;
        self.reloadBtn.layer.borderWidth=1;
        
        
        self.reloadBtn.titleLabel.font=[UIFont fontWithName:k_fontRegular size:15];
        
        [self setUIForWhite];
        [self setFrame:frame];
        
        
        
    }
    return self;
}
-(void)setDelegate:(id)delegate onReload:(SEL)func
{
    onReloadFunc=func;
    target=delegate;
    
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.msgLBL.frame=CGRectMake(10,0, frame.size.width-20, 30);
    self.reloadBtn.frame=CGRectMake(0,0, frame.size.width/3+100, 30);

    self.reloadBtn.center=CGPointMake(frame.size.width/2, frame.size.height/2+30);
    self.msgLBL.center=CGPointMake(frame.size.width/2, frame.size.height/2-30);
    
    
    
}
-(void)setUIForBlack
{
    self.msgLBL.textColor=[UIColor whiteColor];
    [self.reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.reloadBtn.layer.borderColor=[UIColor whiteColor].CGColor;


}
-(void)setUIForWhite
{
    self.msgLBL.textColor=[UIColor grayColor];
    [self.reloadBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.reloadBtn.layer.borderColor=[UIColor grayColor].CGColor;

    
}
-(void)reloadBtnclicked:(id)sender
{
 
    self.hidden=true;
    [target performSelector:onReloadFunc withObject:nil afterDelay:0.01];
    
}

@end
