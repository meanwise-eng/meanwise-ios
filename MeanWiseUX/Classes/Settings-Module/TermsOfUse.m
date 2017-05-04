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
    
    
    NSString *htmlStr=@"<div id=\"terms\" style=\"font-family:'Open Sans';font-size:12px;padding:10px;\"> <h2> Web Site Terms and Conditions of Use </h2> <h3> 1. Terms </h3> <p> By accessing this web site, you are agreeing to be bound by these web site Terms and Conditions of Use, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. If you do not agree with any of these terms, you are prohibited from using or accessing this site. The materials contained in this web site are protected by applicable copyright and trade mark law. </p><h3> 2. Use License </h3> <ol type=\"a\"> <li> Permission is granted to temporarily download one copy of the materials (information or software) on MEANWISE.io's web site for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not: <ol type=\"i\"> <li>modify or copy the materials;</li><li>use the materials for any commercial purpose, or for any public display (commercial or non-commercial);</li><li>attempt to decompile or reverse engineer any software contained on MEANWISE.io's web site;</li><li>remove any copyright or other proprietary notations from the materials; or</li><li>transfer the materials to another person or \"mirror\" the materials on any other server.</li></ol> </li><li> This license shall automatically terminate if you violate any of these restrictions and may be terminated by MEANWISE.io at any time. Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials in your possession whether in electronic or printed format. </li></ol> <h3> 3. Disclaimer </h3> <ol type=\"a\"> <li> The materials on MEANWISE.io's web site are provided \"as is\". MEANWISE.io makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties, including without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights. Further, MEANWISE.io does not warrant or make any representations concerning the accuracy, likely results, or reliability of the use of the materials on its Internet web site or otherwise relating to such materials or on any sites linked to this site. </li></ol> <h3> 4. Limitations </h3> <p> In no event shall MEANWISE.io or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption,) arising out of the use or inability to use the materials on MEANWISE.io's Internet site, even if MEANWISE.io or a MEANWISE.io authorized representative has been notified orally or in writing of the possibility of such damage. Because some jurisdictions do not allow limitations on implied warranties, or limitations of liability for consequential or incidental damages, these limitations may not apply to you. </p><h3> 5. Revisions and Errata </h3> <p> The materials appearing on MEANWISE.io's web site could include technical, typographical, or photographic errors. MEANWISE.io does not warrant that any of the materials on its web site are accurate, complete, or current. MEANWISE.io may make changes to the materials contained on its web site at any time without notice. MEANWISE.io does not, however, make any commitment to update the materials. </p><h3> 6. Links </h3> <p> MEANWISE.io has not reviewed all of the sites linked to its Internet web site and is not responsible for the contents of any such linked site. The inclusion of any link does not imply endorsement by MEANWISE.io of the site. Use of any such linked web site is at the user's own risk. </p><h3> 7. Site Terms of Use Modifications </h3> <p> MEANWISE.io may revise these terms of use for its web site at any time without notice. By using this web site you are agreeing to be bound by the then current version of these Terms and Conditions of Use. </p><h3> 8. Governing Law </h3> <p> Any claim relating to MEANWISE.io's web site shall be governed by the laws of the State of INDIA without regard to its conflict of law provisions. </p><p> General Terms and Conditions applicable to Use of a Web Site. </p><h2> Privacy Policy </h2> <p> Your privacy is very important to us. Accordingly, we have developed this Policy in order for you to understand how we collect, use, communicate and disclose and make use of personal information. The following outlines our privacy policy. </p><ul> <li> Before or at the time of collecting personal information, we will identify the purposes for which information is being collected. </li><li> We will collect and use of personal information solely with the objective of fulfilling those purposes specified by us and for other compatible purposes, unless we obtain the consent of the individual concerned or as required by law. </li><li> We will only retain personal information as long as necessary for the fulfillment of those purposes. </li><li> We will collect personal information by lawful and fair means and, where appropriate, with the knowledge or consent of the individual concerned. </li><li> Personal data should be relevant to the purposes for which it is to be used, and, to the extent necessary for those purposes, should be accurate, complete, and up-to-date. </li><li> We will protect personal information by reasonable security safeguards against loss or theft, as well as unauthorized access, disclosure, copying, use or modification. </li><li> We will make readily available to customers information about our policies and practices relating to the management of personal information. </li></ul> <p> We are committed to conducting our business in accordance with these principles in order to ensure that the confidentiality of personal information is protected and maintained. </p></div>";
    
    
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