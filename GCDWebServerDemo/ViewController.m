//
//  ViewController.m
//  GCDWebServerDemo
//
//  Created by wangzexin on 2024/8/15.
//

#import "ViewController.h"
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <WebKit/WebKit.h>

@interface ViewController ()

///<##>
@property (nonatomic, strong) GCDWebServer *webServer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webServer = [[GCDWebServer alloc] init];
    [self.webServer addDefaultHandlerForMethod:@"GET" requestClass:[GCDWebServerRequest class] processBlock:^GCDWebServerResponse * _Nullable(__kindof GCDWebServerRequest * _Nonnull request) {
        NSString *html = @"<html><body>欢迎访问</body></html>";
        return [GCDWebServerDataResponse responseWithHTML:html];
    }];
    
    [self.webServer addGETHandlerForBasePath:@"/sandbox/" directoryPath:NSHomeDirectory() indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
    
    if (!self.webServer.isRunning) {
        NSError *error = nil;
        if (![self.webServer startWithOptions:@{GCDWebServerOption_Port: @8092} error:&error]) {
            NSLog(@"服务器启动失败: %@", error.localizedDescription);
        } else {
            NSLog(@"服务启动成功了：%@", self.webServer.serverURL);
        }
    } else {
        NSLog(@"服务器已经在运行");
    }
    
    WKWebViewConfiguration *webConfiguration = [WKWebViewConfiguration new];
    WKWebView *webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:webConfiguration];
    NSString *urlStr = @"https://www.baidu.com";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];

}


@end
