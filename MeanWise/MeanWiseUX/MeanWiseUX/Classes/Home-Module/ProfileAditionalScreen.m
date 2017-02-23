//
//  ProfileAditionalScreen.m
//  MeanWiseUX
//
//  Created by Hardik on 13/01/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "ProfileAditionalScreen.h"
#import "CGGeometryExtended.h"
#import "PostFullCell.h"

@implementation ProfileAditionalScreen

-(void)setUpProfileObj:(APIObjects_ProfileObj *)obj;
{
    profileObj=obj;
    
}
-(void)setDelegate:(id)delegate andFunc1:(SEL)func1;
{
    target=delegate;
    closeBtnClickedFunc=func1;
}
-(void)setUp
{
    
    coverView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [self addSubview:coverView];

    shadowImage=[[UIImageView alloc] initWithFrame:self.bounds];
    [coverView addSubview:shadowImage];
    shadowImage.userInteractionEnabled=false;
    shadowImage.image=[UIImage imageNamed:@"BlackShadow.png"];
    shadowImage.contentMode=UIViewContentModeScaleToFill;

    
    masterScrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:masterScrollView];
    masterScrollView.contentSize=CGSizeMake(0, self.frame.size.height*4);
    masterScrollView.canCancelContentTouches=false;
    masterScrollView.bounces=false;
    masterScrollView.delegate=self;
    masterScrollView.pagingEnabled=true;
    masterScrollView.decelerationRate=0;
    masterScrollView.showsHorizontalScrollIndicator=false;
    masterScrollView.showsVerticalScrollIndicator=false;
    
    coverOverlayView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:coverOverlayView];

    
    storyView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:storyView];
    storyView.backgroundColor=[Constant colorGlobal:0];

    introVideoView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*2, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:introVideoView];
    introVideoView.backgroundColor=[Constant colorGlobal:1];

    postView=[[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height*3, self.bounds.size.width, self.bounds.size.height)];
    [masterScrollView addSubview:postView];
    postView.backgroundColor=[Constant colorGlobal:2];

    
    
    
    

    shadowImage.alpha=0.2;
    
    [self addCoverViewItems];
    [self addStoryViewItems];
    [self setUpIntroVideoItems];
    [self setUpPostViewItems];
    
    
    closeBtn=[[UIButton alloc] initWithFrame:CGXRectMake(0, 0, 45, 45)];
    [self addSubview:closeBtn];
    closeBtn.center=CGXPointMake(CGX_ScreenMaxWidth()/2, CGX_ScreenMaxHeight()-50);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"closeBtn.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.1];
    closeBtn.layer.cornerRadius=45/2*CGX_scaleFactor();
    closeBtn.clipsToBounds=YES;
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];


}
-(void)closeBtnClicked:(id)sender
{
    [target performSelector:closeBtnClickedFunc withObject:nil afterDelay:0.01];
    
}
-(void)setUpIntroVideoItems
{
    UILabel *label=[[UILabel alloc] initWithFrame:self.bounds];
    label.textAlignment=NSTextAlignmentCenter;
    [introVideoView addSubview:label];
    label.text=@"Intro-Video";
    
    NSURL *videoURL = [[NSBundle mainBundle] URLForResource:@"mag_app_reducedvid" withExtension:@"mp4"];

    
    player=[[VideoLoopPlayer alloc] initWithFrame:self.bounds];
    [introVideoView addSubview:player];
    [player setUpWithURL:videoURL.absoluteString];
    
    
}


-(void)addStoryViewItems
{
    //
//    UILabel *story_titleLBL;
//    UILabel *story_descLBL;
//    UILabel *story_tagsLBL;
    
    story_titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 50, self.frame.size.width-50, 150)];
    story_titleLBL.text=@"Nunchuck skills, bow hunting skills, computer hacking skills";
    [storyView addSubview:story_titleLBL];
    story_titleLBL.numberOfLines=4;
    story_titleLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:40];
    story_titleLBL.adjustsFontSizeToFitWidth=YES;
    story_titleLBL.textColor=[UIColor whiteColor];

    story_descLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 220, self.frame.size.width-50, 250)];
    story_descLBL.numberOfLines = 0;
    [storyView addSubview:story_descLBL];
    story_descLBL.textColor=[UIColor whiteColor];
    NSString* string = @"The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. Junk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, bad nymph, for quick jigs vex! Fox nymphs grab quick-jived waltz. Brick quiz whangs jumpy veldt fox. Bright vixens jump; dozy fowl quack. Quick wafting zephyrs vex bold Jim.";
    
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 25.0f;
    style.maximumLineHeight = 25.0f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,NSFontAttributeName:[UIFont fontWithName:k_fontSemiBold size:14]};
    story_descLBL.attributedText = [[NSAttributedString alloc] initWithString:string
                                                             attributes:attributtes];
    [story_descLBL sizeToFit];

    
    story_tagsLBL=[[UILabel alloc] initWithFrame:CGRectMake(25, 50+220+250, self.frame.size.width-50, 150)];
    story_tagsLBL.text=@"#boHunting #nunchucks #painting #art #imagination";
    [storyView addSubview:story_tagsLBL];
    story_tagsLBL.numberOfLines=4;
    story_tagsLBL.font=[UIFont fontWithName:k_fontBold size:16];
    story_tagsLBL.adjustsFontSizeToFitWidth=YES;
    story_tagsLBL.textColor=[UIColor whiteColor];
    
    
   
    story_tagsLBL.frame=CGRectMake(25, story_descLBL.frame.origin.y+story_descLBL.frame.size.height+10, self.frame.size.width-50, 100);
    

    
}
-(void)addCoverViewItems
{
    
    cover_titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(40, 250, self.frame.size.width-80, 200)];
    [coverView addSubview:cover_titleLBL];
    cover_titleLBL.numberOfLines=2;
    
    cover_titleLBL.text=[NSString stringWithFormat:@"Hey,\n I'm %@",profileObj.first_name];
    cover_titleLBL.font=[UIFont fontWithName:k_fontAvenirNextHeavy size:80];
    cover_titleLBL.adjustsFontSizeToFitWidth=YES;
    cover_titleLBL.textColor=[UIColor whiteColor];
    
    cover_shortDescLBL=[[UILabel alloc] initWithFrame:CGRectMake(40, 250+200, self.frame.size.width-80, 50)];
    [coverView addSubview:cover_shortDescLBL];
    cover_shortDescLBL.numberOfLines=2;
    cover_shortDescLBL.text=[NSString stringWithFormat:@"%@\nPreston,ldaho",profileObj.profession];
    cover_shortDescLBL.font=[UIFont fontWithName:k_fontRegular size:20];
    cover_shortDescLBL.adjustsFontSizeToFitWidth=YES;
    cover_shortDescLBL.textColor=[UIColor whiteColor];
    
    
    
    cover_connectionCount=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    cover_connectionCount.textColor=[UIColor whiteColor];
    cover_connectionCount.textAlignment=NSTextAlignmentCenter;
    cover_connectionCount.text=@"50K";
    [coverView addSubview:cover_connectionCount];
    cover_connectionCount.font=[UIFont fontWithName:k_fontBold size:14];
    
    cover_connectionLabel=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    cover_connectionLabel.textColor=[UIColor whiteColor];
    cover_connectionLabel.textAlignment=NSTextAlignmentCenter;
    cover_connectionLabel.text=@"connections";
    [coverView addSubview:cover_connectionLabel];
    cover_connectionLabel.font=[UIFont fontWithName:k_fontSemiBold size:12];
    
    cover_profileViewCount=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    cover_profileViewCount.textColor=[UIColor whiteColor];
    cover_profileViewCount.textAlignment=NSTextAlignmentCenter;
    cover_profileViewCount.text=@"750K";
    [coverView addSubview:cover_profileViewCount];
    cover_profileViewCount.font=[UIFont fontWithName:k_fontBold size:14];
    
    cover_profileLabel=[[UILabel alloc] initWithFrame:CGXRectMake(0, 0, 100, 20)];
    cover_profileLabel.textColor=[UIColor whiteColor];
    cover_profileLabel.textAlignment=NSTextAlignmentCenter;
    cover_profileLabel.text=@"profile views";
    [coverView addSubview:cover_profileLabel];
    cover_profileLabel.font=[UIFont fontWithName:k_fontSemiBold size:12];
    
    

    
    cover_addBtn=[[UIButton alloc] initWithFrame:CGXRectMake(CGX_ScreenMaxWidth()-25, 25, 45, 45)];
    [coverView addSubview:cover_addBtn];
    cover_addBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-40, 58);
    [cover_addBtn setBackgroundImage:[UIImage imageNamed:@"addBtn.png"] forState:UIControlStateNormal];
    

    cover_connectionCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-95);
    cover_connectionLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2-85, CGX_ScreenMaxHeight()-80);
    cover_profileViewCount.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-95);
    cover_profileLabel.center=CGXPointMake(CGX_ScreenMaxWidth()/2+85, CGX_ScreenMaxHeight()-80);
    
    cover_addBtn.center=CGXPointMake(CGX_ScreenMaxWidth()-40, 58);
    
    
  
    
    cover_addBtn.alpha=1;
    
    cover_connectionCount.alpha=1;
    cover_connectionLabel.alpha=1;
    cover_profileViewCount.alpha=1;
    cover_profileLabel.alpha=1;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y>100)
    {
        scrollView.canCancelContentTouches=true;
        
    }
    else
    {
        scrollView.canCancelContentTouches=false;
    }
    NSLog(@"ended %f",scrollView.contentOffset.y);
 
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
    if(scrollView.contentOffset.y>self.frame.size.height*2)
    {
        closeBtn.hidden=true;
    }
    else
    {
        closeBtn.hidden=false;
    }
    
    
}
-(void)setUpPostViewItems
{
    UILabel *label=[[UILabel alloc] initWithFrame:self.bounds];
    label.textAlignment=NSTextAlignmentCenter;
    [postView addSubview:label];
    label.text=@"posts";
    
    [self setUpDataRecordsForPosts];
    
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    CGRect collectionViewFrame = self.bounds;
    galleryView = [[UICollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:layout];
    galleryView.delegate = self;
    galleryView.dataSource = self;
    galleryView.pagingEnabled = YES;
    galleryView.showsHorizontalScrollIndicator = NO;
    galleryView.delaysContentTouches=NO;
    galleryView.canCancelContentTouches=YES;
    galleryView.directionalLockEnabled=YES;
    
    [galleryView registerClass:[PostFullCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    
    [postView addSubview:galleryView];

    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PostFullCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    
    //    [cell setImage:[NSString stringWithFormat:@"post_%d.jpeg",(int)indexPath.row%5+3]];
    //  cell.postIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"thumb%d.png",(int)indexPath.row%5+1]];
    
    // cell.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"profile%d.jpg",(int)indexPath.row%5+3]];
    
    //[cell setURL:[videoURLArray objectAtIndex:indexPath.row%videoURLArray.count]];
    
    
    
    cell.profileIMGVIEW.image=[UIImage imageNamed:[NSString stringWithFormat:@"profile%d.jpg",(int)indexPath.row%5+3]];
    
    int mediaType=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"postType"] intValue];
    
    int colorN=[[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"color"] intValue];
    
    
    
    [cell setUpMediaType:mediaType andColorNumber:colorN];
    
   
    if(mediaType!=0)
    {
        NSString *imgURL=[[dataRecords objectAtIndex:indexPath.row] valueForKey:@"imageURL"];
        cell.postIMGVIEW.image=[UIImage imageNamed:imgURL];
    }
    else
    {
        
    }
    
    //
    
    return cell;
    
}



-(void)setUpDataRecordsForPosts
{
    dataRecords=[[NSMutableArray alloc] init];
    
    
    for(int i=0;i<1;i++)
    {
        
        
        NSDictionary *dict1=@{@"postType":[NSNumber numberWithInt:1],
                              @"imageURL":@"post_3.jpeg",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              @"videoURL":@""};
        
        [dataRecords addObject:dict1];
        
      /*  NSDictionary *dict42=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr11.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_mxlga0gj0e1shsvoe.mp4"};
        
        [dataRecords addObject:dict42];*/
        
        
        
        
        NSDictionary *dict2=@{@"postType":[NSNumber numberWithInt:1],
                              @"imageURL":@"post_4.jpeg",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              @"videoURL":@""};
        
        [dataRecords addObject:dict2];
        
        NSDictionary *dict5=@{@"postType":[NSNumber numberWithInt:0],
                              @"imageURL":@"post_5.jpeg",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              @"videoURL":@""};
        
        [dataRecords addObject:dict5];
        
        
        NSDictionary *dict3=@{@"postType":[NSNumber numberWithInt:1],
                              @"imageURL":@"post_7.jpeg",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              @"videoURL":@""};
        
        [dataRecords addObject:dict3];
        
        
        NSDictionary *dict41=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr1.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_oi00kfkvMq1vrn2g4_480.mp4"};
        
        [dataRecords addObject:dict41];
        
        NSDictionary *dict43=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr12.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_oi4mtbbrHS1vwm5np.mp4"};
        
        [dataRecords addObject:dict43];
        
        {
            NSDictionary *dict5=@{@"postType":[NSNumber numberWithInt:0],
                                  @"imageURL":@"post_5.jpeg",
                                  @"color":[NSNumber numberWithInt:arc4random()%14],
                                  @"videoURL":@""};
            
            [dataRecords addObject:dict5];
        }
        
        NSDictionary *dict44=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr7.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_oi3y37m7az1vo8xre_480.mp4"};
        
        [dataRecords addObject:dict44];
        
        
        
        NSDictionary *dict45=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr14.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_ohkwqixP5j1u3ehw5.mp4"};
        
        [dataRecords addObject:dict45];
        
        {
            NSDictionary *dict3=@{@"postType":[NSNumber numberWithInt:1],
                                  @"imageURL":@"post_5.jpeg",
                                  @"color":[NSNumber numberWithInt:arc4random()%14],
                                  @"videoURL":@""};
            
            [dataRecords addObject:dict3];
            
        }
        
        NSDictionary *dict46=@{@"postType":[NSNumber numberWithInt:2],
                               @"imageURL":@"pqr8.jpg",
                               @"color":[NSNumber numberWithInt:arc4random()%14],
                               @"videoURL":@"https://vt.media.tumblr.com/tumblr_oi3vig8Lqp1qbct3j.mp4"};
        
        [dataRecords addObject:dict46];
        
        
        NSDictionary *dict4=@{@"postType":[NSNumber numberWithInt:2],
                              @"imageURL":@"thumb1.png",
                              @"color":[NSNumber numberWithInt:arc4random()%14],
                              
                              @"videoURL":@"https://player.vimeo.com/external/121377179.hd.mp4?s=383ab10c2c3229be7e818ccf30888ba8dbb59b26&profile_id=119&oauth2_token_id=57447761"};
        
        [dataRecords addObject:dict4];
        
        
    }
    
}

@end
