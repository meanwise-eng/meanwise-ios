//
//  SuggestionTextViewBox.m
//  VideoPlayerDemo
//
//  Created by Hardik on 11/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import "UITextViewSuggestionHelper.h"
#import "APIManager.h"
#import "FTIndicator.h"
#import "Constant.h"


@implementation UITextViewSuggestionsBox


-(void)searchWithAPI:(NSString *)searchTerm
{
    NSDictionary *dict;
    if(autoCompleteType==1)
    {
        dict=@{@"searchFor":@"tag",@"searchTerm":searchTerm};
        
    }
    else
    {
        dict=@{@"searchFor":@"username",@"searchTerm":searchTerm};
        
        
    }
    
    
    
    APIManager *manager=[[APIManager alloc] init];
    [manager sendRequestGenericAutoCompleteAPI:dict Withdelegate:self andSelector:@selector(resultData:)];
    
    
    
}
-(void)resultData:(APIResponseObj *)responseObj
{
    int p=0;
    
    NSString *string=[responseObj.response valueForKey:@"searchTerm"];
    
    if(ifTypingOtherWord==false && [searchString isEqualToString:string])
    {
        self.hidden=false;
        
        resultData =[responseObj.response valueForKey:@"data"];
        
        int sizeCount=(int)resultData.count;
        if(sizeCount>maxVisibleRecords)
        {
            sizeCount=maxVisibleRecords;
        }
        
        if(isPositionUp==false)
        {
            self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, sizeCount*50);
        }
        else
        {
            
            NSArray *arraytemp=[NSArray arrayWithArray:resultData];
            
            resultData = [NSMutableArray arrayWithArray:[[arraytemp reverseObjectEnumerator] allObjects]];
            
            self.frame=CGRectMake(0, textViewRect.origin.y+selectionStartRect.origin.y-sizeCount*50,self.frame.size.width, sizeCount*50);
            
            
        }
        
        
        resultListView.frame=self.bounds;
        [resultListView reloadData];
        
        if(isPositionUp==true)
        {
            
            CGFloat yOffset = 0;
            
            if (resultListView.contentSize.height > resultListView.bounds.size.height) {
                yOffset = resultListView.contentSize.height - resultListView.bounds.size.height;
            }
            
            [resultListView setContentOffset:CGPointMake(0, yOffset) animated:NO];

        }
        
        
    }
    
    
    
    
    
}
-(void)search2:(NSString *)string
{
    NSLog(@"API call for %@",string);
    
    
    NSString *path=[NSString stringWithFormat:@"query=%@",string];
    
    NSString *finalURL=[NSString stringWithFormat:@"%@%@",@"https://autocomplete.clearbit.com/v1/companies/suggest?",path];
    NSURL *url = [NSURL URLWithString:finalURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPMethod:@"GET"];
    
    
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    // NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //[urlRequest setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        
        if(error==nil)
        {
            NSError *Jerror = nil;
            NSDictionary* jsonDict =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:&Jerror];
            if(Jerror!=nil)
            {
                
                NSLog(@"json error:%@",Jerror);
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    if(ifTypingOtherWord==false)
                    {
                        self.hidden=false;
                        
                        resultData =[NSJSONSerialization
                                     JSONObjectWithData:data
                                     options:kNilOptions
                                     error:nil];
                        
                        
                        if(isPositionUp==false)
                        {
                            self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, resultData.count*50);
                        }
                        else
                        {
                            
                            NSArray *arraytemp=[NSArray arrayWithArray:resultData];
                            
                            resultData = [NSMutableArray arrayWithArray:[[arraytemp reverseObjectEnumerator] allObjects]];
                            
                            self.frame=CGRectMake(0, textViewRect.origin.y+selectionStartRect.origin.y-resultData.count*50,self.frame.size.width, resultData.count*50);
                            
                        }
                        
                        
                      
                    }
                    
                    
                    
                });
                
            }
        }
        else
        {
            NSLog(@"Error %ld",error.code);
            NSLog(@"Error %@",error.localizedDescription);
        }
        
        
        
    }];
    
    [postDataTask resume];
    
}


-(void)setIfTypingOtherWord:(BOOL)flag;
{
    ifTypingOtherWord=flag;
}
-(void)setUp
{
    ifTypingOtherWord=true;
    autoCompleteType=-1;
    isPositionUp=true;
    isDarkTheme=true;
    maxVisibleRecords=3;
    
    searchString=@"";
    
    
    
    resultListView=[[UITableView alloc] initWithFrame:self.bounds];
    [self addSubview:resultListView];
    resultListView.delegate=self;
    resultListView.dataSource=self;
    resultListView.rowHeight=50;
    resultListView.backgroundColor=[UIColor clearColor];
    
    self.clipsToBounds=YES;

    
   
    
}
-(void)setMaxVisibleRecordsShow:(int)maxRecord;
{
    maxVisibleRecords=maxRecord;
}
-(void)setPotisionUp:(BOOL)positionUp andThemeDark:(BOOL)flag
{
    isPositionUp=positionUp;
    isDarkTheme=flag;
    
    if(isDarkTheme==true)
    {
        self.backgroundColor=[UIColor blackColor];
        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [resultListView setSeparatorColor:[UIColor lightGrayColor]];
        self.layer.borderWidth=0.5;

    }
    else
    {
        self.backgroundColor=[UIColor whiteColor];
        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [resultListView setSeparatorColor:[UIColor colorWithWhite:1 alpha:0.2]];
        self.layer.borderWidth=0.5;

        
    }

}
-(void)searchTermChange:(NSString *)newString withTextView:(UITextView *)textView andType:(int)type
{
    
    
    autoCompleteType=type;
    
    self.hidden=true;
    
    UITextRange * selectionRange = [textView selectedTextRange];
    
    selectionStartRect = [textView caretRectForPosition:selectionRange.start];
    selectionEndRect = [textView caretRectForPosition:selectionRange.end];
    textViewRect=textView.frame;
    
    if(isPositionUp==false)
    {
        self.frame=CGRectMake(self.frame.origin.x, textViewRect.origin.y+selectionEndRect.origin.y+selectionEndRect.size.height,self.frame.size.width, 50);
        resultListView.frame=self.bounds;
    }
    else
    {
        self.frame=CGRectMake(self.frame.origin.x, textViewRect.origin.y+selectionStartRect.origin.y-50,self.frame.size.width, 50);
        resultListView.frame=self.bounds;
        
    }
    
    
    newString = [newString stringByReplacingOccurrencesOfString:@"@" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    NSString *searchWordProtection = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (searchWordProtection.length != 0 && ![searchString isEqualToString:searchWordProtection]) {
        
        
        searchString=searchWordProtection;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        
        [self performSelector:@selector(searchWithAPI:) withObject:searchWordProtection afterDelay:0.2f];
        
        
    }
    
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return resultData.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if([[resultData objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
    {
        UITextViewSuggestionsOptionCell *cell = [resultListView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (!cell) {
            cell = [[UITextViewSuggestionsOptionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }

        [cell setHashTagDict:[NSString stringWithFormat:@"#%@",[resultData objectAtIndex:indexPath.row]] withDarkTheme:isDarkTheme];
        

        return cell;
    }
    else
    {
        
        UITextViewSuggestionsOptionCell *cell = [resultListView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (!cell) {
            cell = [[UITextViewSuggestionsOptionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        }

        [cell setUserDict:[resultData objectAtIndex:indexPath.row] withDarkTheme:isDarkTheme];
         

       
        
        return cell;
        
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    [target performSelector:onSuggestionSelect withObject:[resultData objectAtIndex:indexPath.row] afterDelay:0.01];
    
    autoCompleteType=-1;
    
    
}

-(void)setTarget:(id)targetReceived onSelect:(SEL)func
{
    target=targetReceived;
    onSuggestionSelect=func;
}
@end
@implementation UITextViewAutoSuggestionsDataSource

-(NSMutableArray *)getAllUserMentions
{
        [self manuallyVerifyMentions:nil];
    return userMentionCount;
}
-(NSMutableArray *)getAllUserMentionsIds
{
        [self manuallyVerifyMentions:nil];
    return MentionUserIds;
}
-(NSMutableArray *)getAllUniqueUserMentionsIds
{
    NSSet *set=[NSSet setWithArray:[self getAllUserMentionsIds]];
    NSArray *array=set.allObjects;
    
    NSMutableArray *arrayUnique=[NSMutableArray arrayWithArray:array];
    return arrayUnique;
    
}
-(NSMutableArray *)getAllHashTagWords
{
        [self manuallyVerifyMentions:nil];
    return hashTagWords;
}
-(void)setShouldDisableHashTags:(BOOL)flag;
{
    shouldDisableHashTags=flag;
}
-(void)setTextView:(UITextView *)textView; 
{
    
    lastRect=textView.frame;
    lastRect=CGRectMake(textView.frame.origin.x, lastRect.origin.y+42*2, textView.frame.size.width, 42*2);
    keyTextView=textView;
    keyTextView.spellCheckingType=UITextSpellCheckingTypeNo;
    
}
-(void)setSuggestionView:(UITextViewSuggestionsBox *)suView;
{
    suggestionView=suView;
}
-(void)setUp
{
    userMentionCount=[[NSMutableArray alloc] init];
    userRecordsDB=[[NSMutableArray alloc] init];
    isAutoresizeFromTop=false;
    shouldDisableHashTags=false;
}
-(NSDictionary *)attributeForHashTag
{
    NSDictionary *dict=@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00]};
    return dict;
}
-(NSDictionary *)attributeForMention
{

    if(shouldDisableHashTags==false)
    {
    NSDictionary *dict=@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00]};
    return dict;
    }
    else
    {
        NSDictionary *dict=@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.76 blue:0.89 alpha:1.00],NSFontAttributeName:[UIFont fontWithName:k_fontSemiBold size:15]};
        return dict;
    }
}
-(NSDictionary *)attributeByDefault
{
    if(shouldDisableHashTags==false)
    {
        NSDictionary *dict=@{NSForegroundColorAttributeName:[UIColor colorWithRed:0.53 green:0.62 blue:0.66 alpha:1.00],NSFontAttributeName:[UIFont fontWithName:k_fontRegular size:20]};
        return dict;
    }
    else
    {
        NSDictionary *dict=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:k_fontRegular size:15]};
        return dict;
        
    }
  
}


-(void)addIntoUserDB:(id)selectedItem
{
    if(![userRecordsDB containsObject:selectedItem])
    {
        [userRecordsDB addObject:selectedItem];
    }
    
}

-(void)manuallyVerifyMentions:(id)sender
{
    NSMutableArray *newUserMentionCount=[[NSMutableArray alloc] init];
    //Remove mention if not exists in autosuggestion
    
    
    
    for(int i=0;i<userMentionCount.count;i++)
    {
        NSString *item=[userMentionCount objectAtIndex:i];
        
        NSString *word=[item substringFromIndex:1];
        
        if([mentionWords containsObject:word])
        {
            [newUserMentionCount addObject:item];
        }
        else
        {
            NSLog(@"Removed %@",item);
        }
    }
    
    userMentionCount=[[NSMutableArray alloc] initWithArray:newUserMentionCount];
    //    [self updateDebugLabel];
    
    MentionUserIds=[[NSMutableArray alloc] init];
    for(int i=0;i<userMentionCount.count;i++)
    {
        NSString *item=[userMentionCount objectAtIndex:i];
        NSString *word=[item substringFromIndex:1];
        
        for(int k=0;k<[userRecordsDB count];k++)
        {
            NSDictionary *userRecord=[userRecordsDB objectAtIndex:k];
            if([[word lowercaseString] isEqualToString:[[userRecord valueForKey:@"username"] lowercaseString]])
            {
                [MentionUserIds addObject:[userRecord valueForKey:@"user_id"]];
            }
            
        }
        
    }
    
    int p=0;
    //    debugInfo2.text=[MentionUserIds componentsJoinedByString:@","];
    
}
-(void)cancelSearch
{
    suggestionView.hidden=true;
}


- (void)textViewDidChange:(UITextView *)textView
{
   
    
    [self reformatTextView:textView.text];
}

-(void)suggestionSelected:(id)selectedItem
{
    if([selectedItem isKindOfClass:[NSString class]])
    {
        NSRange originalRange=[keyTextView selectedRange];
        NSRange range=originalRange;
        range=NSMakeRange(range.location-lastTypedWordStr.length,lastTypedWordStr.length);
        
        
        NSString *stringNew=[NSString stringWithFormat:@"#%@",selectedItem];
        
        NSString *string = [keyTextView.text stringByReplacingCharactersInRange:range withString:stringNew];
        
        [self reformatTextView:string];
        
        NSRange newRange=NSMakeRange(originalRange.location+stringNew.length-lastTypedWordStr.length, 0);
        keyTextView.selectedRange=newRange;
        
        suggestionView.hidden=true;
    }
    else
    {
        NSRange originalRange=[keyTextView selectedRange];
        NSRange range=originalRange;
        range=NSMakeRange(range.location-lastTypedWordStr.length,lastTypedWordStr.length);
        
        NSString *stringNew=[NSString stringWithFormat:@"@%@",[[selectedItem valueForKey:@"username"] lowercaseString]];
        
        if(![[stringNew lowercaseString] isEqualToString:[[keyTextView.text substringWithRange:range] lowercaseString]])
        {
            [userMentionCount addObject:stringNew];
        }
        else if(![userMentionCount containsObject:stringNew])
        {
            [userMentionCount addObject:stringNew];
        }
        else
        {
            [FTIndicator showToastMessage:@"Already added"];
        }
        
        
        //        [self updateDebugLabel];
        
        [self addIntoUserDB:selectedItem];
        
        NSString *string = [keyTextView.text stringByReplacingCharactersInRange:range withString:stringNew];
        
        [self reformatTextView:string];
        
        NSRange newRange=NSMakeRange(originalRange.location+stringNew.length-lastTypedWordStr.length, 0);
        keyTextView.selectedRange=newRange;
        
        suggestionView.hidden=true;
    }
    
    
    
}



-(void)reformatTextView:(NSString *)string
{
    
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:string];
    
    
    [hogan addAttributes:[self attributeByDefault] range:NSMakeRange(0, string.length)];
    
    
    
    NSError *error1 = nil;
    NSError *error2 = nil;
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error1];
    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"@(\\w+)" options:0 error:&error2];
    
    NSArray *matches1 = [regex1 matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    NSArray *matches2 = [regex2 matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    
    
    
    mentionWords=[[NSMutableArray alloc] init];
    hashTagWords=[[NSMutableArray alloc] init];
    
    
    if(shouldDisableHashTags==false)
    {
    for (NSTextCheckingResult *match in matches1)
    {
        NSRange wordRange = [match rangeAtIndex:0];
        NSString* word = [string substringWithRange:wordRange];
        // NSLog(@"Found tag %@", word);
        
        [hogan addAttributes:[self attributeForMention] range:wordRange];
        
        
        NSRange hashTagRange = [match rangeAtIndex:1];
        NSString* hashTag = [string substringWithRange:hashTagRange];
        
        [hashTagWords addObject:hashTag];
        
    }
    }
    
    
    
    
    //Highlight only words which are selected by autosuggestion for Mention
    
    for (NSTextCheckingResult *match in matches2)
    {
        NSRange wordRange = [match rangeAtIndex:0];
        NSString* word = [string substringWithRange:wordRange];
        NSLog(@"Found tag %@", word);
        
        if([userMentionCount containsObject:word])
        {
            [hogan addAttributes:[self attributeForMention] range:wordRange];
            
        }
        
        NSRange topicRange = [match rangeAtIndex:1];
        NSString* topicName = [string substringWithRange:topicRange];
        
        [mentionWords addObject:topicName];
        
        
        
    }
    
    
    
    //    [self updateDebugLabel];
    
    
    NSRange selectedRange = keyTextView.selectedRange;
    keyTextView.attributedText=hogan;
    keyTextView.selectedRange = selectedRange;
    
    [self manuallyVerifyMentions:nil];
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //Un-commend this check below :If you want to detect the word only while new line or white space charactor input
    
    
    if (![text isEqualToString:@" "] && ![text isEqualToString:@"\n"])
    {
        NSString * stringToRange = [textView.text substringWithRange:NSMakeRange(0,range.location)];
        
        // Appending the currently typed charactor
        stringToRange = [stringToRange stringByAppendingString:text];
        
        stringToRange = [stringToRange stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        // Processing the last typed word
        NSArray *wordArray       = [stringToRange componentsSeparatedByString:@" "];
        NSString * wordTyped     = [wordArray lastObject];
        
        // wordTyped will give you the last typed object
        NSLog(@"\nWordTyped :  %@",wordTyped);
        lastTypedWordStr=wordTyped;
        
        if([wordTyped hasPrefix:@"@"] || ([wordTyped hasPrefix:@"#"] && shouldDisableHashTags==false))
        {
            [suggestionView setIfTypingOtherWord:FALSE];
            
            //        CGPoint selectionCenterPoint = (CGPoint){(selectionStartRect.origin.x + selectionEndRect.origin.x)/2,(selectionStartRect.origin.y + selectionStartRect.size.height / 2)};
            
            if([wordTyped hasPrefix:@"#"])
            {
                [suggestionView searchTermChange:wordTyped withTextView:textView andType:1];
            }
            else if([wordTyped hasPrefix:@"@"])
            {
                [suggestionView searchTermChange:wordTyped withTextView:textView andType:2];
                
            }
            
        }
        else
        {
            [suggestionView setIfTypingOtherWord:TRUE];
            
            suggestionView.hidden=true;
        }
        
    }
    else
    {
        suggestionView.hidden=true;
        [suggestionView setIfTypingOtherWord:TRUE];
        
    }
    
    
    return YES;
}

@end
@implementation UITextViewSuggestionsOptionCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.backgroundColor=[UIColor clearColor];
        
        userThumbView=[[UIImageHM alloc] initWithFrame:CGRectMake(15, 5, 40, 40)];
        [self addSubview:userThumbView];
        userThumbView.layer.cornerRadius=40/2;
        userThumbView.clipsToBounds=YES;
        [userThumbView clearImageAll];
        
        
        titleLBL=[[UILabel alloc] initWithFrame:CGRectMake(60+8, 5, self.frame.size.width-60-10-20, 20)];
        [self addSubview:titleLBL];
        
        subTitleLBL=[[UILabel alloc] initWithFrame:CGRectMake(60+8, 25, self.frame.size.width-60-10-20, 20)];
        [self addSubview:subTitleLBL];
        
        fullTitleLBL=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, self.frame.size.width-30, 40)];
        [self addSubview:fullTitleLBL];
        
        titleLBL.font=[UIFont fontWithName:@"Avenir-Roman" size:12];
        subTitleLBL.font=[UIFont fontWithName:@"Avenir-Black" size:15];

        fullTitleLBL.font=[UIFont fontWithName:@"Avenir-Roman" size:15];

        self.separatorInset = UIEdgeInsetsZero;

    }
    return self;
    
}
-(void)setUserDict:(NSDictionary *)dict withDarkTheme:(BOOL)flag
{
    self.separatorInset = UIEdgeInsetsZero;

    userThumbView.hidden=false;
    titleLBL.hidden=false;
    subTitleLBL.hidden=false;
    fullTitleLBL.hidden=true;
    
    if(flag==true)
    {
        titleLBL.textColor=[UIColor whiteColor];
        subTitleLBL.textColor=[UIColor whiteColor];
    }
    else
    {
        titleLBL.textColor=[UIColor blackColor];
        subTitleLBL.textColor=[UIColor blackColor];
        
    }
    
    
    titleLBL.text=[NSString stringWithFormat:@"@%@",[[dict valueForKey:@"username"] lowercaseString]];
    
    subTitleLBL.text=[NSString stringWithFormat:@"%@ %@",[dict valueForKey:@"first_name"],[dict valueForKey:@"last_name"]];
    

    [userThumbView clearImageAll];
    [userThumbView setUp:[dict valueForKey:@"profile_photo_small"]];


}
-(void)setHashTagDict:(NSString *)string withDarkTheme:(BOOL)flag
{
    self.separatorInset = UIEdgeInsetsZero;

    userThumbView.hidden=true;
    titleLBL.hidden=true;
    subTitleLBL.hidden=true;
    fullTitleLBL.hidden=false;
    
    if(flag==true)
    {
        fullTitleLBL.textColor=[UIColor whiteColor];
    }
    else
    {
        fullTitleLBL.textColor=[UIColor blackColor];
        
    }

    fullTitleLBL.text=string;
    
    
}

@end





