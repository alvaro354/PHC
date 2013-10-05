//
//  MessageTableViewCell.h
//  PushChatStarter
//
//  Created by Kauserali on 28/03/13.
//  Copyright (c) 2013 Ray Wenderlich. All rights reserved.
//
#import "Mensajes.h"
@class Mensajes;

// Table view cell that displays a Message. The message text appears in a
// speech bubble; the sender name and date are shown in a UILabel below that.
@interface MessageTableViewCell : UITableViewCell

- (void)setMessage:( Mensajes*)message;

@end
