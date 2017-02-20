//
//  ViewController.m
//  XmppChat
//
//  Created by zhipeng on 17/2/18.
//  Copyright © 2017年 com.baidu.dev. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XmppChat-Swift.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
//@property(nonatomic,weak) XMPPStream* xmppStream;


@property(nonatomic,assign)BOOL flag;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[XMPPRoster alloc] initWithRosterStorage:[XMPPRosterCoreDataStorage sharedInstance]];
//    AppDelegate* app =  [UIApplication sharedApplication].delegate;
//    self.xmppStream =  app.xmppStream;
    [Utils.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];

    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)login:(id)sender {
    
    [self connect];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connect {
    NSLog(@"===%@",self.pwd.text);
        if (![Utils.xmppStream isConnected]) {
        
             NSString *jid = [[NSString alloc] initWithFormat:@"%@@%@", self.userName.text, @"192.168.0.1"];
        [Utils.xmppStream setMyJID:[XMPPJID jidWithString:jid]];
//                [self.xmppStream setMyJID:jid];
                [Utils.xmppStream setHostName:@"192.168.0.102"];
                NSError *error = nil;
        
                if (![Utils.xmppStream connectWithTimeout:10 error:&error]) {
                        NSLog(@"Connect Error: %@", [[error userInfo] description]);
                    }else{
                
                                NSLog(@"-=-----链接成功-");
                
            }
        
            
    }
}

// 链接成功调用  socketDidConnect
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket{
    NSLog(@"socketDidConnect");
            NSError *error = nil;
    

}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    NSLog(@"xmppStreamDidConnect");
            NSError *error = nil;

    if([Utils.xmppStream isConnected] && !self.flag){
       // [self registerUser];
        if (![Utils.xmppStream registerWithPassword:self.pwd.text error:&error])
        {
            NSLog(@"注册失败");
            
        }
    }else{
        [sender authenticateWithPassword:self.pwd.text error:&error];
 
    }

}
// 上线
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [Utils.xmppStream sendElement:presence];
    //跳转到好友列表
     UIViewController*  vc =  [Utils  getViewContollerByStoryboaardID:@"NewChatViewController"];
    [self presentModalViewController:vc animated:YES];
    
//    [self presentViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#> completion:<#^(void)completion#> :YES completion:nil];
//    
    
}
       
//注册
-(void) registerUser{
   NSString *jid = [[NSString alloc] initWithFormat:@"%@@%@", @"wa44ngti3e4t3ao", @"192.168.0.1"];
    [Utils.xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    NSError *error=nil;
    if (![Utils.xmppStream registerWithPassword:self.pwd.text error:&error])
    {
        NSLog(@"注册失败");

    }else{
        NSLog(@"注册成功");
        XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
        [Utils.xmppStream sendElement:presence];
//               XMPPJID *jid = [XMPPJID jidWithUser:@"" domain:@"lizhen" resource:@"iphone"];
//                [self.xmppStream setMyJID:jid];
//                [self.xmppStream setHostName:@"192.168.0.102"];
//                NSError *error = nil;
        [Utils.xmppStream disconnect];
                if (![Utils.xmppStream connectWithTimeout:10 error:&error]) {
                        NSLog(@"Connect Error: %@", [[error userInfo] description]);
                    }else{
                NSLog(@"-=-----链接成功-");
                self.flag = YES;
                
            }
    }
}

- (void)disconnect {
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [Utils.xmppStream sendElement:presence];
    
    [Utils.xmppStream disconnect];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    NSLog(@"%@",error);

}

- (void)xmppStreamDidRegister:(XMPPStream *)sender

{
            XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
            [Utils.xmppStream sendElement:presence];
    
    [Utils.xmppStream disconnect];
    self.flag = YES;
    [self connect];
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSString *presenceType = [presence type];
    NSString *presenceFromUser = [[presence from] user];
    if (![presenceFromUser isEqualToString:[[sender myJID] user]]) {
        if ([presenceType isEqualToString:@"available"]) {
            //
        } else if ([presenceType isEqualToString:@"unavailable"]) {
            //
        }
    }
}

- (void)sendMessage:(NSString *) message2 toUser:(NSString *) user {
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:message2];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    NSString *to = [NSString stringWithFormat:@"%@@example.com", user];
    [message addAttributeWithName:@"to" stringValue:to];
    [message addChild:body];
    [Utils.xmppStream sendElement:message];
}

@end
