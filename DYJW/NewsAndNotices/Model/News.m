//
//  News.m
//  DYJW
//
//  Created by 风筝 on 15/11/3.
//  Copyright © 2015年 Doge Studio. All rights reserved.
//

#import "News.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "StringBodyRequestSerialization.h"
#import "OCGumbo+Query.h"

@interface News () <NSXMLParserDelegate>

@end

@implementation News
+ (void)newsWithPath:(NSString *)path andPage:(NSInteger)page {
    NSString *url;
    // 通过传入的path值的第一位判断该板块属于东油新闻还是教务通知
    if([[path substringToIndex:1] isEqualToString:@"3"]) {
        url = @"http://glbm1.nepu.edu.cn/jwc/dwr/call/plaincall/portalAjax.getNewsXml.dwr";
    } else if([[path substringToIndex:1] isEqualToString:@"5"]) {
        url = @"http://news.nepu.edu.cn/dwr/call/plaincall/portalAjax.getNewsXml.dwr";
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 通过传入的path值生成相应的参数
    NSString *param = [NSString stringWithFormat:@"callCount=1\npage=/jwc/type/%@\nhttpSessionId=0\nscriptSessionId=0\nc0-scriptName=portalAjax\nc0-methodName=getNewsXml\nc0-id=0\nc0-param0=string:%@\nc0-param1=string:%@\nc0-param2=string:news_\nc0-param3=number:15\nc0-param4=number:%ld\nc0-param5=null:null\nc0-param6=null:null\nbatchId=0", path, [path substringToIndex:4], [path substringToIndex:6], page];
    // 将requestSerializer替换成自定制的StringBodyRequestSerialization
    manager.requestSerializer = [StringBodyRequestSerialization serializer];
    [manager POST:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        // 获取到服务器响应后将二进制流转为字符串并截取其中的XML部分的内容
        data = [data substringFromIndex:[data rangeOfString:@"<?xml"].location];
        data = [data substringToIndex:data.length - 5];
        NSMutableString *xml = [data mutableCopy];
        NSRange range = [xml rangeOfString:@"\\\""];
        while (range.location != NSNotFound) {
            [xml replaceCharactersInRange:range withString:@"\""];
            range = [xml rangeOfString:@"\\\""];
        }
        range = [xml rangeOfString:@"\\n"];
        while (range.location != NSNotFound) {
            [xml replaceCharactersInRange:range withString:@"\n"];
            range = [xml rangeOfString:@"\\n"];
        }
        // 将截取到的内容中的Unicode编码字符转为中文并进行XML解析
        NSArray *newsArray = [self parseXML:[[self replaceUnicode:xml] dataUsingEncoding:NSUTF8StringEncoding]];
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"NEWS_%@", path] object:newsArray];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

+ (void)newsWithURL:(NSString *)url {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *html = [[NSString alloc] initWithData:responseObject encoding:enc];
        
        OCGumboDocument *doc = [[OCGumboDocument alloc] initWithHTMLString:html];
//        NSString *xw = doc.Query(@"div.mainframe_1_1_3").first().html();
//        xw = [NSString stringWithFormat:@"<link rel=\"stylesheet\" id=\"cssLink\" href=\"http://news.nepu.edu.cn/style/news.css\" type=\"text/css\" media=\"all\">%@", xw];
        NSString *xwcon = doc.Query(@"div.xwcon").first().html();
        NSString *title = doc.Query(@"div.title").first().Query(@"h3").first().text();
        NSString *puber = doc.Query(@"div.title").first().Query(@"h4").first().Query(@"span.puber").first().text();
        NSString *pubtime = doc.Query(@"div.title").first().Query(@"h4").first().Query(@"span.pubtime").first().text();
        NSString *xw = [NSString stringWithFormat:
                        @"<html>"
                        "<head>"
                        "<style>"
                        "body {"
                        "   margin: 0px;"
                        "   background: #efefef;"
                        "}"
                        "img {"
                        "   box-shadow: 0px 2px 5px #aaaaaa;"
                        "}"
                        ".main {"
                        "   margin-top: 8px;"
                        "   padding: 8px;"
                        "}"
                        "</style>"
                        "</head>"
                        "<body>"
                        "<div class=\"main\">"
                        "<span style=\"font-size:22px;\">%@</span><br /><br />"
                        "<span style=\"font-size:15px;\">%@</span>&nbsp;&nbsp;"
                        "<span style=\"font-size:15px;\">%@</span>"
                        "</div>"
                        "<hr/>"
                        "<div style=\"padding-left:10px;padding-right:10px;\">"
                        "%@"
                        "</div>"
                        "<script type=\"text/javascript\">"
                        "function ResizeImages() { "
                        "   var myimg, oldwidth;"
                        "   var maxwidth = %d.0;"
                        "   for(i=0;i <document.images.length;i++){"
                        "       myimg = document.images[i];"
                        "       if(myimg.width > maxwidth){"
                        "           oldwidth = myimg.width;"
                        "           myimg.width = maxwidth;"
                        "           myimg.height = myimg.height * maxwidth / oldwidth;"
                        "       }"
                        "   }"
                        "}"
                        "ResizeImages();"
                        "</script>"
                        "</body>"
                        "</html>", title, puber, pubtime, xwcon, (int)[UIScreen mainScreen].bounds.size.width - 20];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWS_CONTENT" object:xw];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

// 开始进行XML解析
+ (NSArray *)parseXML:(NSData *)data {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    News *news = [[News alloc] init];
    parser.delegate = news;
    if ([parser parse]) {
        NSLog(@"解析成功");
    } else {
        NSLog(@"%@", parser.parserError);
    }
    return news.parserObjects;
}

+ (NSString *)replaceUnicode:(NSString *)str {
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *str3 = [[@"\"" stringByAppendingString:str2] stringByAppendingString:@"\""];
    NSData *data = [str3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
    result = [result stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    result = [result stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    return result;
}


//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.parserObjects = [[NSMutableArray alloc]init];
}

//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.currentText = [[NSMutableString alloc]init];
    if ([elementName isEqualToString:@"item"]) {
        NSMutableDictionary *newNode = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.twitterDic = newNode;
        [self.parserObjects addObject:newNode];
    } else if(self.twitterDic) {
        NSMutableString *string = [[NSMutableString alloc] initWithCapacity:0];
        [self.twitterDic setObject:string forKey:elementName];
        self.currentElementName = elementName;
    }
}

//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.currentText appendString:string];
}

//step 4 ：解析完当前节点
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        self.twitterDic = nil;
    } else {
        if ([elementName isEqualToString:self.currentElementName]) {
            if (self.cdata) {
                [self.twitterDic setObject:self.cdata forKey:self.currentElementName];
            }else {
                NSRange range = [self.currentText rangeOfString:@"\\n"];
                if (range.location != NSNotFound) {
                    [self.currentText replaceCharactersInRange:range withString:@""];
                }
                if ([elementName isEqualToString:@"pubDate"]) {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"E, dd MMM yyyy HH:mm:ss z";
                    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                    NSDate *date = [formatter dateFromString:self.currentText];
                    formatter.dateFormat = @"yyyy-MM-dd";
                    NSString *dateStr = [formatter stringFromDate:date];
                    self.currentText = [dateStr mutableCopy];
                }
                [self.twitterDic setObject:self.currentText forKey:self.currentElementName];
            }
        }
        self.cdata = nil;
    }
}

//获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
    self.cdata =[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
}
@end
