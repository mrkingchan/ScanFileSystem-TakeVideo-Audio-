//
//  kInitUI.h
//  APIDemo
//
//  Created by Macx on 2018/6/28.
//  Copyright © 2018年 Chan. All rights reserved.
//

#ifndef kInitUI_h
#define kInitUI_h

// MARK: - 初始化UI

CG_INLINE UICollectionView *kInsertCollectionView(id superView,CGRect rec,id <UICollectionViewDataSource>dataSource,id <UICollectionViewDelegate>delegate ,CGFloat lineSpacing,CGFloat interItemSpacing, CGSize itemSize,Class cellClass) {
    UICollectionViewFlowLayout *layout  = [UICollectionViewFlowLayout new];
    layout.itemSize = itemSize;
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rec collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    if (superView) {
        [superView addSubview:collectionView];
    }
    if (dataSource) {
        collectionView.dataSource = dataSource;
    }
    if (delegate) {
        collectionView.delegate = delegate;
    }
    if (cellClass) {
        [collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    }
    return collectionView;
}


// MARK:  -- UIWindow
CG_INLINE UIWindow *kInsertWindow(UIViewController *rootViewController) {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    window.rootViewController = rootViewController;
    return window;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

// MARK: UIAlertView
CG_INLINE UIAlertView *SimpleAlert(UIAlertViewStyle style, NSString *title, NSString *message, NSInteger tag, id delegate, NSString *cancel, NSString *ok) {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    alertview.alertViewStyle = style;
    alertview.tag = tag;
    [alertview show];
    alertview.opaque = YES;
    
    return alertview;
}

CG_INLINE UIAlertView *ActivityIndicatiorAlert(NSString *message, NSInteger tag, id delegate) {
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:message message:nil delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil];
    alertview.tag = tag;
    [alertview show];
    
    alertview.opaque = YES;
    
    //Adjust the indicator so it is up a few pixels from the bottom of the alert
    NSInteger x = alertview.bounds.size.width / 2;
    NSInteger y = alertview.bounds.size.height - 50.0;
    if (x == 0 || y == -50)
    {
        return nil;
    }
    
    __autoreleasing    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(x, y);
    [indicator startAnimating];
    
    [alertview addSubview:indicator];
    
    return alertview;
}

CG_INLINE UIAlertView *AlertSetString(NSString *title, NSString *cancel, NSString *ok, NSString *set, NSInteger tag, id delegate, SEL selector) {
    __strong UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:title message:@"\r\r" delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    alertview.tag = tag;
    [alertview show];
    
    alertview.opaque = YES;
    
    NSInteger x = alertview.bounds.size.width;
    NSInteger y = alertview.bounds.size.height;
    if (x == 0 || y == 0)
    {
        alertview = nil;
        return nil;
    }
    
    UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(x * 0.04, y - 110, x * 0.91, 25)];
    myTextField.text = set;
    [myTextField addTarget:delegate action:selector forControlEvents:UIControlEventEditingDidEndOnExit];
    //[alert setTransform:myTransform];
    myTextField.tag = 100;
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    
    [alertview addSubview:myTextField];
    
    return alertview;
}

#pragma clang diagnostic pop

// MARK: UIDatePicker
CG_INLINE UIDatePicker *SetDate(UIView *view, NSInteger tag, id delegate, UIInterfaceOrientation orientation)
{
    NSString *title = UIDeviceOrientationIsLandscape(orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n";
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:delegate
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    actionsheet.tag = tag;
    [actionsheet showInView:view];
    
    actionsheet.opaque = YES;
    
    __autoreleasing    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:actionsheet.bounds];
    datePicker.tag = 101;
    
    [actionsheet addSubview:datePicker];
    
    return datePicker;
}

// MARK: UIScrollView
CG_INLINE UIScrollView *kInsertScrollView(UIView *superView, CGRect rect, NSInteger tag,id<UIScrollViewDelegate> delegate)
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.tag = tag;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = delegate;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    scrollView.opaque = YES;
    
    if (superView) {
        [superView addSubview:scrollView];
    }
    
    return scrollView;
}

// MARK: UILabel

CG_INLINE UILabel *kInsertLabelWithShadow(id superView, CGRect cRect, NSTextAlignment align, NSString *contentStr, UIFont *textFont, UIColor *textColor, BOOL resize, BOOL shadow, UIColor *shadowColor, CGSize shadowOffset)
{
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:cRect];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.textAlignment = align;
    tempLabel.textColor = textColor;
    tempLabel.font = textFont;
    tempLabel.text = contentStr;
    [tempLabel setNumberOfLines:1];
    
    tempLabel.opaque = YES;
    
    if (superView)
    {
        [superView addSubview:tempLabel];
    }
    
    // 自适应大小
    if (resize && nil != contentStr)
    {
        [tempLabel setNumberOfLines:0];
        tempLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        CGSize labelsize = [contentStr boundingRectWithSize:CGSizeMake(cRect.size.width, 9999.9) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        //        CGSize size = CGSizeMake(cRect.size.width, 9999.9);
        //        CGSize labelsize = [contentStr sizeWithFont:textFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        tempLabel.frame = CGRectMake(cRect.origin.x, cRect.origin.y, labelsize.width, labelsize.height);
    }
    
    if (shadow)
    {
        if (shadowColor)
        {
            tempLabel.shadowColor = shadowColor;
        }
        tempLabel.shadowOffset = shadowOffset;
    }
    
    return tempLabel;
}

CG_INLINE CATextLayer *kInsertLabelWithCAText(id superView, id superLayer, CGRect cRect, NSString *align, NSString *contentStr, UIFont *textFont, UIColor *textColor)
{
    CATextLayer *tempLayer = [[CATextLayer alloc] init];
    tempLayer.frame = cRect;
    tempLayer.backgroundColor = [UIColor clearColor].CGColor;
    tempLayer.contentsScale = [UIScreen mainScreen].scale;
    tempLayer.truncationMode = kCATruncationNone;
    tempLayer.foregroundColor = textColor.CGColor;
    
    CFStringRef fontName = (__bridge CFStringRef)textFont.fontName;
    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
    tempLayer.font = fontRef;
    tempLayer.fontSize = textFont.pointSize;
    CGFontRelease(fontRef);
    tempLayer.alignmentMode = kCAAlignmentLeft;
    tempLayer.delegate = superView;
    tempLayer.alignmentMode = align;
    tempLayer.string = contentStr;
    tempLayer.wrapped = YES;
    
    tempLayer.opaque = YES;
    
    if (superView)
    {
        [superLayer addSublayer:tempLayer];
    }
    
    return tempLayer;
}

// MARK: UIWebView
CG_INLINE UIWebView *kInsertWebView(id superView,CGRect cRect, id<UIWebViewDelegate>delegate, NSInteger tag)
{
    UIWebView *tempWebView = [[UIWebView alloc] initWithFrame:cRect];
    tempWebView.tag = tag;
    [tempWebView setOpaque:NO];
    tempWebView.backgroundColor = [UIColor clearColor];
    tempWebView.delegate = delegate;
    tempWebView.scalesPageToFit = YES;
    tempWebView.scrollView.scrollEnabled = YES;
    
    tempWebView.opaque = YES;
    
    if (superView)
    {
        [superView addSubview:tempWebView];
    }
    
    return tempWebView;
}

CG_INLINE void WebSimpleLoadRequest(UIWebView *web, NSString *strURL)
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    
    [web loadRequest:request];
}

CG_INLINE void WebSimpleLoadRequestWithCookie(UIWebView *web, NSString *strURL, NSString *cookies)
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:strURL]];
    [request addValue:cookies forHTTPHeaderField:@"Cookie"];
    [web loadRequest:request];
}

// MARK: UIbutton
CG_INLINE UIButton *kInsertButtonRoundedRect(id view,  CGRect rc, NSInteger tag, NSString *title, id target, SEL action)
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = rc;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTag:tag];
    
    btn.opaque = YES;
    
    if (view)
    {
        [view addSubview:btn];
    }
    
    return btn;
}

CG_INLINE UIButton *kInsertImageButton(id view, CGRect rc, NSInteger tag, UIImage *img, UIImage *imgH, id target, SEL action)
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rc;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:tag];
    
    if (nil != img)
    {
        [btn setImage:img forState:UIControlStateNormal];
    }
    
    if (nil != imgH)
    {
        [btn setImage:imgH forState:UIControlStateHighlighted];
    }
    
    btn.opaque = YES;
    
    if (view)
    {
        [view addSubview:btn];
    }
    
    return btn;
}

CG_INLINE UIButton *kInsertImageButtonWithTitle(id view, CGRect rc, NSInteger tag, UIImage *img, UIImage *imgH, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action)
{
    UIButton *btn = kInsertImageButton(view, rc, tag, img, imgH, target, action);
    
    if (nil != font)
    {
        btn.titleLabel.font = font;
    }
    if (nil != color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (nil != title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    
    btn.opaque = YES;
    
    btn.titleEdgeInsets = edgeInsets;
    
    return btn;
}

CG_INLINE UIButton *kInsertTitleAndImageButton(id view, CGRect rc, NSInteger tag, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, UIColor *colorH, UIImage *img, UIImage *imgH, id target, SEL action)
{
    UIButton *btn = kInsertImageButton(view, rc, tag, img, imgH, target, action);
    
    if (nil != font)
    {
        btn.titleLabel.font = font;
    }
    if (nil != color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    if (nil != colorH)
    {
        [btn setTitleColor:colorH forState:UIControlStateHighlighted];
    }
    
    if (nil != title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    
    btn.opaque = YES;
    
    btn.titleEdgeInsets = edgeInsets;
    
    return btn;
}

CG_INLINE UIButton *kInsertImageButtonWithSelectedImage(id view, CGRect rc, NSInteger tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, id target, SEL action)
{
    UIButton *btn = kInsertImageButton(view, rc, tag, img, imgH, target, action);
    [btn setBackgroundImage:imgSelected forState:UIControlStateSelected];
    btn.selected = selected;
    
    btn.opaque = YES;
    
    return btn;
}

CG_INLINE UIButton *kInsertImageButtonWithSelectedImageAndTitle(id view, CGRect rc, NSInteger tag, UIImage *img, UIImage *imgH, UIImage *imgSelected, BOOL selected, NSString *title, UIEdgeInsets edgeInsets, UIFont *font, UIColor *color, id target, SEL action)
{
    UIButton *btn = kInsertImageButtonWithSelectedImage(view, rc, tag, img, imgH, imgSelected, selected, target, action);
    
    if (nil != font)
    {
        btn.titleLabel.font = font;
    }
    if (nil != color)
    {
        [btn setTitleColor:color forState:UIControlStateNormal];
    }
    
    if (nil != title)
    {
        [btn setTitle:title forState:UIControlStateNormal];
    }
    btn.titleEdgeInsets = edgeInsets;
    
    btn.opaque = YES;
    
    return btn;
}

CG_INLINE UIButton *kInsertButtonWithType(id view, CGRect rc, NSInteger tag, id target, SEL action, UIButtonType type)
{
    UIButton *btn = [UIButton buttonWithType:type];
    btn.frame = rc;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTag:tag];
    btn.backgroundColor = [UIColor clearColor];
    
    btn.opaque = YES;
    
    if (view)
    {
        [view addSubview:btn];
    }
    
    return btn;
}

// MARK: UITableView
CG_INLINE UITableView *kInsertTableView(id superView, CGRect rect, id<UITableViewDataSource> dataSoure, id<UITableViewDelegate> delegate, UITableViewStyle style, UITableViewCellSeparatorStyle cellStyle)
{
    UITableView *tabView = [[UITableView alloc] initWithFrame:rect style:style];
    //    tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    tabView.bounces = NO;
    
    if (dataSoure)
    {
        tabView.dataSource = dataSoure;
    }
    if (delegate)
    {
        tabView.delegate = delegate;
    }
    tabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //tabView.separatorInset = UIEdgeInsetsMake(0, AutoWHGetWidth(15), 0, 0);
    //tabView.separatorColor = kLySeparatorColor;
    tabView.showsVerticalScrollIndicator = NO;
    tabView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //tabView.backgroundColor = kLyBgColor;
    //[DataHelper setExtraCellLineHidden:tabView];
    
    tabView.separatorStyle = cellStyle;
    tabView.backgroundView = nil;
    
    tabView.opaque = YES;
    
    if (superView)
    {
        [superView addSubview:tabView];
    }
    
    return tabView;
}

// MARK: UITextField

CG_INLINE UITextField *kInsertTextFieldWithBorderAndCorRadius(id view, id delegate, CGRect rc, NSString *placeholder, UIFont *font, NSTextAlignment textAlignment, UIControlContentVerticalAlignment contentVerticalAlignment, float borderwidth, UIColor *bordercolor, UIColor *textFieldColor, float cornerRadius)
{
    UITextField *myTextField = [[UITextField alloc] initWithFrame:rc];
    myTextField.delegate = delegate;
    myTextField.placeholder = placeholder;
    myTextField.font = font;
    myTextField.textAlignment = textAlignment;
    myTextField.contentVerticalAlignment = contentVerticalAlignment;
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    myTextField.opaque = YES;
    
    if (!textFieldColor)
    {
        myTextField.textColor = [UIColor whiteColor];
    }
    else
    {
        myTextField.textColor = textFieldColor;
    }
    
    if (bordercolor && 0.0 != borderwidth)
    {
        myTextField.layer.borderWidth = borderwidth;
        myTextField.layer.borderColor = bordercolor.CGColor;
    }
    
    if (0.0 != cornerRadius)
    {
        myTextField.layer.cornerRadius = cornerRadius;
    }
    
    if (view)
    {
        [view addSubview:myTextField];
    }
    
    return myTextField;
}

// MARK: UITextView

CG_INLINE UITextView *kInsertTextViewWithBorderAndCorRadius(id view, id delegate, CGRect rc, UIFont *font, NSTextAlignment textAlignment, float borderwidth, UIColor *bordercolor, UIColor *textcolor, float cornerRadius)
{
    UITextView *textview = [[UITextView alloc] initWithFrame:rc];
    textview.delegate = delegate;
    textview.font = font;
    textview.textAlignment = textAlignment;
    textview.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textview.autocorrectionType = UITextAutocorrectionTypeNo;
    
    if (!textcolor)
    {
        textview.textColor = [UIColor whiteColor];
    }
    else
    {
        textview.textColor = textcolor;
    }
    
    if (bordercolor && 0.0 != borderwidth)
    {
        textview.layer.borderWidth = borderwidth;
        textview.layer.borderColor = bordercolor.CGColor;
    }
    
    if (0.0 != cornerRadius)
    {
        textview.layer.cornerRadius = cornerRadius;
    }
    
    textview.opaque = YES;
    
    if (view)
    {
        [view addSubview:textview];
    }
    
    return textview;
}

// MARK: UISwitch
CG_INLINE UISwitch *kInsertSwitch(id view, CGRect rc)
{
    UISwitch *sw = [[UISwitch alloc] initWithFrame:rc];
    
    sw.opaque = YES;
    
    if (view)
    {
        [view addSubview:sw];
    }
    
    return sw;
}

// MARK: UIImageView
CG_INLINE UIImageView *kInsertImageView(id view, CGRect rect, UIImage *image)
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    
    imageView.opaque = YES;
    
    if (image)
    {
        [imageView setImage:image];
    }
    
    imageView.userInteractionEnabled = YES;
    
    if (view)
    {
        [view addSubview:imageView];
    }
    
    return imageView;
}

CG_INLINE UIView *kInsertViewWithBorderAndCorRadius(id view, CGRect rect, UIColor *backColor, CGFloat borderwidth, UIColor *bordercolor, CGFloat corRadius)
{
    UIView *_view = [[UIView alloc] initWithFrame:rect];
    _view.backgroundColor = backColor;
    
    if (view)
    {
        [view addSubview:_view];
    }
    
    if (bordercolor && 0.0 != borderwidth)
    {
        _view.layer.borderWidth = borderwidth;
        _view.layer.borderColor = bordercolor.CGColor;
    }
    
    if (0.0 != corRadius)
    {
        _view.layer.cornerRadius = corRadius;
    }
    
    return _view;
}
// MARK:  -- UITableView
// MARK: UIPickerView
CG_INLINE UIPickerView *kInsertPickerView(id view, CGRect rect)
{
    UIPickerView *_view = [[UIPickerView alloc] initWithFrame:rect];
    _view.showsSelectionIndicator = YES;
    
    if (view)
    {
        [view addSubview:_view];
    }
    
    return _view;
}

// MARK: UIProgressView
CG_INLINE UIProgressView *kInsertProgressView(id view, CGRect rect, UIProgressViewStyle style, CGFloat progressValue, UIColor *progressColor, UIColor *backColor)
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:rect];
    
    if (view)
    {
        [view addSubview:progressView];
    }
    
    progressView.backgroundColor = [UIColor clearColor];
    progressView.progressViewStyle = style;
    progressView.progress = progressValue;
    
    if (progressColor && [progressView respondsToSelector:@selector(setProgressTintColor:)])
    {
        progressView.progressTintColor = progressColor;
    }
    
    if (backColor && [progressView respondsToSelector:@selector(setTrackTintColor:)])
    {
        progressView.trackTintColor = backColor;
    }
    
    return progressView;
}

// MARK: UIActivityIndicatorView
CG_INLINE UIActivityIndicatorView *kInsertActivityIndicatorView(id view, CGRect rect, UIColor *backColor, UIColor *styleColor, UIActivityIndicatorViewStyle style)
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:rect];
    
    // 添加到父视图
    if (view)
    {
        [view addSubview:activityView];
    }
    
    // 背景颜色
    activityView.backgroundColor = (backColor ? backColor : [UIColor clearColor]);
    
    // 类型
    activityView.activityIndicatorViewStyle = style;
    
    // 转圈圈图标颜色（iOS5.0以下才支持颜色设置）
    if (styleColor && [activityView respondsToSelector:@selector(setColor:)])
    {
        activityView.color = styleColor;
    }
    
    return activityView;
}

// MARK: UIActionSheet
// 两个按钮（取消与确定）
// 三个按钮（取消与其他）
CG_INLINE UIActionSheet *kInsertActionSheetWithTwoSelected(id view, id delegate, UIActionSheetStyle style, NSString *title, NSString *canael, NSString *confirm, NSString *firstBtn, NSString *sectionBtn)
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:delegate
                                                    cancelButtonTitle:canael
                                               destructiveButtonTitle:confirm
                                                    otherButtonTitles:firstBtn, sectionBtn, nil];
    
    if (view)
    {
        [actionSheet showInView:view];
    }
    
    actionSheet.actionSheetStyle = style;
    
    return actionSheet;
}

// MARK: UISearchBar
// 搜索视图（可自定义样式）
CG_INLINE UISearchBar *kInsertSearchBarWithStyle(id view, CGRect rect, id delegate, NSString *placeholder, UISearchBarStyle style, UIColor *tintColor, UIColor *barColor, UIImage *backImage)
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:rect];
    
    if (view)
    {
        [view addSubview:searchBar];
    }
    
    searchBar.delegate = delegate;
    searchBar.placeholder = placeholder;
    
    if (0 != style && [searchBar respondsToSelector:@selector(setSearchBarStyle:)])
    {
        searchBar.searchBarStyle = UISearchBarStyleProminent;
    }
    
    if (tintColor && [searchBar respondsToSelector:@selector(setTintColor:)])
    {
        searchBar.tintColor = tintColor;
    }
    
    if (barColor && [searchBar respondsToSelector:@selector(setBarTintColor:)])
    {
        searchBar.barTintColor = barColor;
    }
    
    if (backImage && [searchBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        searchBar.backgroundImage = backImage;
    }
    
    return searchBar;
}

// MARK: UIPageControl
CG_INLINE UIPageControl *kInsertPageControl(id view, CGRect rect, NSInteger pageCounts, NSInteger currentPage, UIColor *backColor, UIColor *pageColor, UIColor *currentPageColor)
{
    UIPageControl *pageCtr = [[UIPageControl alloc] initWithFrame:rect];
    
    if (view)
    {
        [view addSubview:pageCtr];
    }
    
    pageCtr.backgroundColor = (backColor ? backColor : [UIColor clearColor]);
    
    pageCtr.numberOfPages = pageCounts;
    pageCtr.currentPage = currentPage;
    
    if (pageColor && [pageCtr respondsToSelector:@selector(setPageIndicatorTintColor:)])
    {
        pageCtr.pageIndicatorTintColor = pageColor;
    }
    
    if (currentPageColor && [pageCtr respondsToSelector:@selector(setCurrentPageIndicatorTintColor:)])
    {
        pageCtr.currentPageIndicatorTintColor = currentPageColor;
    }
    
    return pageCtr;
}

// MARK: UISlider
// 创建UISlider（自定义最大最小值，及颜色，图标显示）
CG_INLINE UISlider *kInsertSliderWithValueAndColorAndImage(id view, CGRect rect, id target, SEL action, CGFloat minVlaue, CGFloat maxValue, UIColor *minColor, UIColor *maxColor, UIColor *thumbTintColor, UIImage *minImage, UIImage *maxImage)
{
    UISlider *sliderView = [[UISlider alloc] initWithFrame:rect];
    
    if (view)
    {
        [view addSubview:sliderView];
    }
    
    sliderView.backgroundColor = [UIColor clearColor];
    
    if (minVlaue != maxValue)
    {
        sliderView.minimumValue = minVlaue;
        sliderView.maximumValue = maxValue;
    }
    
    if (minColor && [sliderView respondsToSelector:@selector(setMinimumTrackTintColor:)])
    {
        sliderView.minimumTrackTintColor = minColor;
    }
    
    if (maxColor && [sliderView respondsToSelector:@selector(setMaximumTrackTintColor:)])
    {
        sliderView.maximumTrackTintColor = maxColor;
    }
    
    if (thumbTintColor && [sliderView respondsToSelector:@selector(setThumbTintColor:)])
    {
        sliderView.thumbTintColor = thumbTintColor;
    }
    
    if (minImage && [sliderView respondsToSelector:@selector(setMinimumValueImage:)])
    {
        sliderView.minimumValueImage = minImage;
    }
    
    if (maxImage && [sliderView respondsToSelector:@selector(setMaximumValueImage:)])
    {
        sliderView.maximumValueImage = maxImage;
    }
    
    [sliderView addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
    return sliderView;
}

// MARK: UISegmentedControl

// 创建UISegmentedControl（设置颜色及被始化被选择索引）
CG_INLINE UISegmentedControl *kInsertSegmentWithSelectedIndexAndColor(id view, NSArray *titleArray, CGRect rect, id target, SEL action, NSInteger selectedIndex, UIColor *tintColor)
{
    UISegmentedControl *segmentCtr = [[UISegmentedControl alloc] initWithItems:titleArray];
    
    if (view)
    {
        [view addSubview:segmentCtr];
    }
    
    segmentCtr.backgroundColor = [UIColor clearColor];
    segmentCtr.frame = rect;
    segmentCtr.momentary = YES;
    
    if (tintColor && [segmentCtr respondsToSelector:@selector(setTintColor:)])
    {
        segmentCtr.tintColor = tintColor;
    }
    
    segmentCtr.selectedSegmentIndex = selectedIndex;
    
    [segmentCtr addTarget:target action:action forControlEvents:UIControlEventValueChanged];
    
    return segmentCtr;
}

// MARK: UIImagePickerController
CG_INLINE UIImagePickerController *kInsertImagePicker(UIImagePickerControllerSourceType style, id delegate, UIImage *navImage)
{
    UIImagePickerController *imagePickCtr = [[UIImagePickerController alloc] init];
    imagePickCtr.sourceType = style;
    imagePickCtr.delegate = delegate;
    if (navImage && [imagePickCtr respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [imagePickCtr.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    }
    
    return imagePickCtr;
}

/****************************************************************/

// MARK: - 父视图或父视图控制器的操作

CG_INLINE void AddSubController(UIView *view, UIViewController *ctrl, BOOL animation)
{
    [ctrl viewWillAppear:animation];
    [view addSubview:ctrl.view];
    [ctrl viewDidAppear:animation];
}

CG_INLINE void RemoveSubController(UIViewController *ctrl, BOOL animation)
{
    [ctrl viewWillDisappear:animation];
    [ctrl.view removeFromSuperview];
    [ctrl viewDidDisappear:animation];
}

CG_INLINE void RemoveAllSubviews(UIView *view)
{
    for (NSInteger i = (NSInteger)view.subviews.count; i > 0; i--)
    {
        [[view.subviews objectAtIndex:i-1] removeFromSuperview];
    }
}

/****************************************************************/

// MARK: - 设置时间定时器

CG_INLINE NSTimer *SetTimer(NSTimeInterval timeElapsed, id target, SEL selector)
{
    NSTimer *ret = [NSTimer timerWithTimeInterval:timeElapsed target:target selector:selector userInfo:nil repeats:YES];
    if (nil == ret)
    {
        return nil;
    }
    
    [[NSRunLoop currentRunLoop] addTimer:ret forMode:NSDefaultRunLoopMode];
    
    return ret;
}

CG_INLINE NSTimer *SetTimerWithUserData(NSTimeInterval timeElapsed, id data, id target, SEL selector)
{
    NSTimer *ret = [NSTimer timerWithTimeInterval:timeElapsed target:target selector:selector userInfo:data repeats:YES];
    if (nil == ret)
    {
        return nil;
    }
    
    [[NSRunLoop currentRunLoop] addTimer:ret forMode:NSDefaultRunLoopMode];
    
    return ret;
}

CG_INLINE void KillTimer(NSTimer *timer)
{
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
}

CG_INLINE UIViewController *kBuildViewControllerwithConfiguration(Class className,NSString *titleStr,UIImage* normalImage,UIImage *selectedImage) {
    assert(![className isSubclassOfClass:[UIViewController class]]);
    UIViewController *viewController = [className new];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:titleStr
                                                       image:normalImage
                                               selectedImage:selectedImage];
    viewController.tabBarItem = item;
    return viewController;
}

#endif /* kInitUI_h */
