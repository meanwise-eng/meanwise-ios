//
//  CommentCell.m
//  MeanWiseUX
//
//  Created by Hardik on 12/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "CommentCell.h"
#import "APIObjects_CommentObj.h"
#import "HMPlayerManager.h"
#import "GUIScaleManager.h"
#import "ProfileWindowControl.h"
#import "UIColor+Hexadecimal.h"

@implementation CommentCell
-(void)setTarget:(id)targetReceived andOnDelete:(SEL)deleteFunc;
{
    target=targetReceived;
    commentDeleteFunc=deleteFunc;
    
}

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    
    if(self)
    {
        self.clipsToBounds=YES;
        
        

        self.backgroundColor=[UIColor whiteColor];
        self.layer.cornerRadius=3;
        
        self.profileIMGVIEW=[[UIImageHM alloc] initWithFrame:CGRectMake(11, 11, 18, 18)];
        [self addSubview:self.profileIMGVIEW];
        self.profileIMGVIEW.contentMode=UIViewContentModeScaleAspectFill;
        self.profileIMGVIEW.clipsToBounds=YES;
        self.profileIMGVIEW.layer.cornerRadius=18/2;
        
        self.personNameLBL=[[UILabel alloc] initWithFrame:CGRectMake(35,11, self.frame.size.width*0.6, 18)];
        [self addSubview:self.personNameLBL];
        self.personNameLBL.text=@"Marry Ideal";
        self.personNameLBL.textColor=[UIColor colorWithHexString:@"14171A"];
        self.personNameLBL.textAlignment=NSTextAlignmentLeft;
        self.personNameLBL.font=[UIFont fontWithName:k_fontSemiBold size:12];
        self.personNameLBL.numberOfLines=0;

        
        
        self.nameLBL=[[TTTAttributedLabel alloc] initWithFrame:CGRectMake(11,35, self.frame.size.width-80, 100)];
        [self addSubview:self.nameLBL];
        self.nameLBL.text=@"Awesome! How do you do that?";
        self.nameLBL.textColor=[UIColor colorWithHexString:@"14171A"];
        self.nameLBL.textAlignment=NSTextAlignmentLeft;
        self.nameLBL.font=[UIFont fontWithName:k_fontRegular size:11];
        self.nameLBL.numberOfLines=0;
        
        self.timeLBL=[[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-50, 11, 40, 18)];
        [self addSubview:self.timeLBL];
        self.timeLBL.text=@"3h";
        self.timeLBL.textColor=[UIColor colorWithHexString:@"657786"];
        self.timeLBL.textAlignment=NSTextAlignmentRight;
        self.timeLBL.font=[UIFont fontWithName:k_fontRegular size:11];
        self.timeLBL.numberOfLines=0;

        self.customDeleteBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-50, 25, 40, 40)];
        [self.customDeleteBtn setTitle:@"..." forState:UIControlStateNormal];
        [self addSubview:self.customDeleteBtn];
        self.customDeleteBtn.backgroundColor=[UIColor clearColor];
        [self.customDeleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.customDeleteBtn.titleLabel.font=[UIFont fontWithName:k_fontBold size:20];
        self.customDeleteBtn.clipsToBounds=YES;
        self.customDeleteBtn.layer.cornerRadius=20;
        self.customDeleteBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self.customDeleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.customDeleteBtn.hidden=true;
        self.customDeleteBtn.enabled=false;
        
        
      
        
      //  self.layer.borderWidth=1;
        
    }
    return self;
}
-(void)deleteBtnClicked:(id)sender
{
    FCAlertView *alert = [[FCAlertView alloc] init];
    //alert.blurBackground = YES;
    [alert showAlertWithTitle:@"Delete Comment"
                 withSubtitle:@"Are you sure want to delete this comment?"
              withCustomImage:nil
          withDoneButtonTitle:@"Cancel"
                   andButtons:nil];
    [alert addButton:@"Delete" withActionBlock:^{
        
        
        [target performSelector:commentDeleteFunc withObject:self.commentId afterDelay:0.01];
        NSLog(@"delete");
        
        // Put your action here
    }];
    [alert doneActionBlock:^{
        
        
        NSLog(@"done");
        
    }];
    alert.titleColor=[UIColor redColor];
    alert.firstButtonTitleColor = [UIColor redColor];
}

-(void)setProfileImageURLString:(NSString *)stringPath
{
    [self.profileIMGVIEW setUp:stringPath];
    
}
-(NSAttributedString *)getStatusAttributeStrings:(APIObjects_CommentObj *)obj
{
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc] initWithString:obj.comment_text];
    
    
    for(int i=0;i<obj.mentioned_users.count;i++)
    {
        
        id dict=[obj.mentioned_users objectAtIndex:i];
        
        
        if([dict isKindOfClass:[NSDictionary class]])
        {
            NSString *userOne=[[[obj.mentioned_users objectAtIndex:i] valueForKey:@"username"] lowercaseString];
            userOne=[NSString stringWithFormat:@"@%@",userOne];
            NSLog(@"%@",userOne);
            NSRange range=[obj.comment_text rangeOfString:userOne];
            [string addAttribute:NSUnderlineStyleAttributeName value:@1 range:range];
        }
        
        
        
        
    }
    
    return string;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    if([url.absoluteString hasPrefix:@"USER://"])
    {
        
        NSString *userId=[[url.absoluteString componentsSeparatedByString:@"//"] lastObject];
        
        NSDictionary *userDict=@{
                                 @"user_firstname":@"",
                                 @"user_lastname":@"",
                                 @"user_profile_photo_small":@"",
                                 @"user_profession":@"",
                                 @"user_id":userId,
                                 @"user_cover_photo":@"",
                                 };
        
        
        
        
        
        CGRect rect=CGRectMake(0, RX_mainScreenBounds.size.height, self.frame.size.width, self.frame.size.height/3);
        [[HMPlayerManager sharedInstance] MX_setLastPlayerPaused:TRUE];
        
        
        NSDictionary *dict=@{@"cover_photo":@"",@"user_id":userId};
        ProfileWindowControl *control=[[ProfileWindowControl alloc] init];
        [control setUp:dict andSourceFrame:rect];
        [control setTarget:self onClose:@selector(ProfilecloseBtnClicked:)];

        
            //    [HMPlayerManager sharedInstance].All_isPaused=true;
            
        
            
            
            NSLog(@"%@",userDict);
        
    }
    
    
}
-(void)ProfilecloseBtnClicked:(id)sender
{
   
    
    //    [HMPlayerManager sharedInstance].All_isPaused=false;
    
    NSLog(@"closed");
    
}

-(void)setNameLBLText:(APIObjects_CommentObj *)obj
{
    NSString *text = obj.comment_text;
    self.nameLBL.delegate=self;
    self.nameLBL.text=text;
    self.nameLBL.linkAttributes=@{NSUnderlineStyleAttributeName:@1,NSForegroundColorAttributeName:[UIColor blueColor]};
    

    BOOL enableLink=[Constant isAppDebugModeOn];
    
    if(enableLink)
    {
    for(int i=0;i<obj.mentioned_users.count;i++)
    {
        id dict=[obj.mentioned_users objectAtIndex:i];
        if([dict isKindOfClass:[NSDictionary class]])
        {
            NSString *userOne=[[[obj.mentioned_users objectAtIndex:i] valueForKey:@"username"] lowercaseString];
            userOne=[NSString stringWithFormat:@"@%@",userOne];
            NSLog(@"%@",userOne);
            NSRange range=[obj.comment_text rangeOfString:userOne];
            
            [self.nameLBL addLinkToURL:[NSURL URLWithString:[NSString stringWithFormat:@"USER://%d",[[[obj.mentioned_users objectAtIndex:i] valueForKey:@"id"] intValue]]] withRange:range];
        }
    }
    }
    
    

    
    CGFloat fixedWidth = self.nameLBL.frame.size.width;
    CGSize newSize = [self.nameLBL sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    
    
    self.nameLBL.frame=CGRectMake(11,35, self.frame.size.width-80, 100);
    
    CGRect newFrame = self.nameLBL.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        self.nameLBL.frame = newFrame;
        
    
   // self.separatorView.frame=CGRectMake(0,newFrame.size.height-1,self.frame.size.width,1);
    
}



@end

