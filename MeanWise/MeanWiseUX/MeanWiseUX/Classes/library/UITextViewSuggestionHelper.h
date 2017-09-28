//
//  SuggestionTextViewBox.h
//  VideoPlayerDemo
//
//  Created by Hardik on 11/08/17.
//  Copyright © 2017 Hardik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageHM.h"

@interface UITextViewSuggestionsBox : UIView <UITableViewDelegate,UITableViewDataSource>
{
    
    
    UITableView *resultListView;
    NSMutableArray *resultData;
    NSString *searchString;
    
    id target;
    SEL onSuggestionSelect;
    
    
    
    CGRect selectionStartRect;
    CGRect selectionEndRect;
    CGRect textViewRect;
    
    int autoCompleteType;
    
    BOOL ifTypingOtherWord;
    
    BOOL isPositionUp;
    BOOL isDarkTheme;
    
    int maxVisibleRecords;

}
-(void)searchTermChange:(NSString *)newString withTextView:(UITextView *)textView andType:(int)type;
-(void)setTarget:(id)targetReceived onSelect:(SEL)func;
-(void)setUp;
-(void)setPotisionUp:(BOOL)positionUp andThemeDark:(BOOL)flag;
-(void)setMaxVisibleRecordsShow:(int)maxRecord;
-(void)setIfTypingOtherWord:(BOOL)flag;
@end



@interface UITextViewAutoSuggestionsDataSource : NSObject
{
    UITextView *keyTextView;
    UITextViewSuggestionsBox *suggestionView;
    
    NSString *lastTypedWordStr;
    NSMutableArray *userMentionCount;
    NSMutableArray *mentionWords;
    NSMutableArray *hashTagWords;
    NSMutableArray *userRecordsDB;
    NSMutableArray *MentionUserIds;
    
    BOOL isAutoresizeFromTop;
    CGRect lastRect;
    
    BOOL shouldDisableHashTags;
    
}

-(NSMutableArray *)getAllUserMentions;
-(NSMutableArray *)getAllUserMentionsIds;
-(NSMutableArray *)getAllHashTagWords;
-(NSMutableArray *)getAllUniqueUserMentionsIds;

-(void)setShouldDisableHashTags:(BOOL)flag;

-(void)setTextView:(UITextView *)textView;
-(void)setSuggestionView:(UITextViewSuggestionsBox *)suView;
-(void)setUp;
-(NSDictionary *)attributeForHashTag;
-(NSDictionary *)attributeForMention;
-(NSDictionary *)attributeByDefault;
-(void)addIntoUserDB:(id)selectedItem;
-(void)manuallyVerifyMentions:(id)sender;
- (void)textViewDidChange:(UITextView *)textView;
-(void)suggestionSelected:(id)selectedItem;
-(void)reformatTextView:(NSString *)string;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
-(void)cancelSearch;




@end

@interface UITextViewSuggestionsOptionCell : UITableViewCell
{
    UIImageHM *userThumbView;
    UILabel *titleLBL;
    UILabel *subTitleLBL;
    UILabel *fullTitleLBL;
    
    BOOL isDarkTheme;
    
}
-(void)setUserDict:(NSDictionary *)dict withDarkTheme:(BOOL)flag;
-(void)setHashTagDict:(NSString *)string withDarkTheme:(BOOL)flag;



@end
