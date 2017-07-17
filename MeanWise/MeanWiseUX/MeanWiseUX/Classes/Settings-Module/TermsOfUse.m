//
//  TermsOfUse.m
//  MeanWiseUX
//
//  Created by Hardik on 10/12/16.
//  Copyright © 2016 Hardik. All rights reserved.
//

#import "MessageContactCell.h"
#import "ChatThreadComponent.h"
#import "TermsOfUse.h"


@implementation TermsOfUse

-(void)setUp
{
    
    
    
    
    
    
    self.blackOverLayView=[[UIImageView alloc] initWithFrame:CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
    
    self.blackOverLayView.backgroundColor=[UIColor blackColor];
    [self addSubview:self.blackOverLayView];
    self.blackOverLayView.alpha=0;
    
    
    
    
    
    navBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 65)];
    [self addSubview:navBar];
    navBar.backgroundColor=[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.00];
    
    navBarTitle=[[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 65-20)];
    [navBar addSubview:navBarTitle];
    navBarTitle.text=@"Terms";
    navBarTitle.textColor=[UIColor colorWithRed:0.59 green:0.11 blue:1.00 alpha:1.00];
    navBarTitle.textAlignment=NSTextAlignmentCenter;
    navBarTitle.font=[UIFont fontWithName:k_fontSemiBold size:18];
    
    
    
    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(10, 60, 25, 25)];
    [backBtn setShowsTouchWhenHighlighted:YES];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"BackPlainForNav.png"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    backBtn.center=CGPointMake(10+25/2, 20+65/2-10);
    
    
    
    
    content=[[UIWebView alloc] initWithFrame:CGRectMake(0, 65, self.frame.size.width, self.frame.size.height-65)];
    [self addSubview:content];
    
    
    NSString *htmlStr=@"<div id=\"terms\" style=\"font-family:'Proxima Nova';font-size:12px;padding:10px;\"> <h1>Terms of Service</h1><h2>1. Terms</h2><p>By accessing the website at http://meanwise.com, you are agreeing to be bound by these terms of service, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this site. The materials contained in this website are protected by applicable copyright and trademark law.</p><h2>2. Use License</h2><p>a - Permission is granted to temporarily download one copy of the materials (information or software) on Meanwise, Inc.'s website for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:modify or copy the materials;use the materials for any commercial purpose, or for any public display (commercial or non-commercial);attempt to decompile or reverse engineer any software contained on Meanwise, Inc.'s website;remove any copyright or other proprietary notations from the materials; ortransfer the materials to another person or 'mirror' the materials on any other server.</p><p>b - This license shall automatically terminate if you violate any of these restrictions and may be terminated by Meanwise, Inc. at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format.</p><h2>3. Disclaimer</h2>The materials on Meanwise, Inc.'s website are provided on an 'as is' basis. Meanwise, Inc. makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, Meanwise, Inc. does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its website or otherwise relating to such materials or on any sites linked to this site.<h2>4. Limitations</h2>In no event shall Meanwise, Inc. or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on Meanwise, Inc.'s website, even if Meanwise, Inc. or a Meanwise, Inc. authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you.<h2>5. Accuracy of materials</h2>The materials appearing on Meanwise, Inc.'s website could include technical, typographical, or photographic errors. Meanwise, Inc. does not warrant that any of the materials on its website are accurate, complete or current. Meanwise, Inc. may make changes to the materials contained on its website at any time without notice. However Meanwise, Inc. does not make any commitment to update the materials.<h2>6. Links</h2>Meanwise, Inc. has not reviewed all of the sites linked to its website and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by Meanwise, Inc. of the site. Use of any such linked website is at the user's own risk.<h2>7. Modifications</h2>Meanwise, Inc. may revise these terms of service for its website at any time without notice. By using this website you are agreeing to be bound by the current version of these Terms of Service.<h2>8. Governing Law</h2>These terms and conditions are governed by and construed in accordance with the laws of California and you irrevocably submit to the exclusive jurisdiction of the courts in that State or location. <h1>TERMS OF USE</h1> <p>1. You must be at least 13 years old to create a Meanwise account.</p><p>2. You must not post violent, nude, partially nude, discriminatory, unlawful, infringing, hateful, pornographic or sexually suggestive photos or other content.</p><p>3. You must accept responsibility for all actions made through your account.</p><p>4. You must accept that videos and photos posted on Meanwise are public by default and can include location data.</p><p>5. Accounts created through unauthorized means, including but not limited to, by using an automated device, script, bot, spider, crawler or scraper will not be accepted. Meanwise reserves the right to suspend or remove any accounts created in this manner. </p><p>6. Meanwise reserves the right to store and utilize user's Behavioral Data / Cookie Data for the purpose of improving the platform and/or sharing with advertising partners. </p><p>7. Meanwise reserves the right to remove parts of data that can identify the user and share anonymized data when sharing with other parties. We may also combine user information with other information in a way that it is no longer associated with the user and share that aggregated information with third parties. </p><p>8. The user must not create or submit unwanted email, comments, likes or other forms of commercial or harassing communications (a/k/a 'spam') on Meanwise. </p><p>9. You must not plagiarize original work posted by other users, including but not limited to, songs, literature, footage, and concepts. </p><p>10. You must not use content created by other users for unauthorized commercial purposes. </p><p>11. You must not attempt to restrict another user from using or enjoying the Service and you must not encourage or facilitate violations of these Terms of Use or any other Meanwise terms. </p><p>12. Meanwise reserves the right to terminate a user’s Meanwise account in the case of the user violation of these Terms of Use. </p></div>";
    
    
    [content loadHTMLString:htmlStr baseURL:nil];
    
    
    
    // msgContactTable.bounces=false;
    
}


-(void)setTarget:(id)target andBackFunc:(SEL)func
{
    delegate=target;
    backBtnClicked=func;
    
}
-(void)backBtnClicked:(id)sender
{
    [delegate performSelector:backBtnClicked withObject:nil afterDelay:0.02];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame=CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}





@end
