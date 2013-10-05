//
//  ComentariosCell.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 29/09/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "ComentariosCell.h"
#import "Mensajes.h"

static UIColor* color = nil;
static UIFont* font = nil;


const CGFloat VertPaddingC = 4;       // additional padding around the edges
const CGFloat HorzPaddingC = 4;

const CGFloat TextLeftMarginC = 17;   // insets for the text
const CGFloat TextRightMarginC = 15;
const CGFloat TextTopMarginC = 10;
const CGFloat TextBottomMarginC = 11;

const CGFloat MinBubbleWidthC = 50;   // minimum width of the bubble
const CGFloat MinBubbleHeightC = 40;  // minimum height of the bubble

const CGFloat WrapWidthC = 200;


@interface ComentariosCell() {

	
    
}
@end


@implementation ComentariosCell
@synthesize imagen;

+ (void)initialize
{
	if (self == [ComentariosCell class])
	{
  
	//	color = [UIColor colorWithRed:219/255.0 green:226/255.0 blue:237/255.0 alpha:1.0];
        color= [UIColor whiteColor];
         	font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
	}
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imagen = [[UIImageView alloc]init];
        imagen.clipsToBounds=YES;
        imagen.layer.cornerRadius = 8.0;
        imagen.layer.borderWidth=1.5;
        imagen.layer.borderColor=[UIColor blackColor].CGColor;
        [self.contentView addSubview:imagen];
           [self reloadInputViews];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        imagen = [[UIImageView alloc]init];
        imagen.clipsToBounds=YES;
        imagen.layer.cornerRadius = 8.0;
        imagen.layer.borderWidth=1.5;
        imagen.layer.borderColor=[UIColor blackColor].CGColor;
        [self.contentView addSubview:imagen];
        [self reloadInputViews];
    /*    label = [[UILabel alloc] initWithFrame:CGRectZero];
		_label.backgroundColor = color;
		_label.opaque = YES;
		_label.clearsContextBeforeDrawing = NO;
		_label.contentMode = UIViewContentModeRedraw;
		_label.autoresizingMask = 0;
		_label.font = [UIFont systemFontOfSize:13];
		_label.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
		[self.contentView addSubview:_label];
     */

    }
    return self;
}

- (void)layoutSubviews
{
	// This is a little trick to set the background color of a table view cell.
	[super layoutSubviews];
	self.backgroundColor = color;


}
-(void)prepareForReuse
{
   fecha=nil;
    texto=nil;
    nombre=nil;
    imagen =nil;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGSize)sizeForText:(NSString*)text
{
	CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(WrapWidthC, 9999)
                           lineBreakMode:NSLineBreakByWordWrapping];
    
	CGSize bubbleSize;
	bubbleSize.width = textSize.width + TextLeftMarginC + TextRightMarginC;
	bubbleSize.height = textSize.height + TextTopMarginC + TextBottomMarginC;
    
	if (bubbleSize.width < MinBubbleWidthC)
		bubbleSize.width = MinBubbleWidthC;
    
	if (bubbleSize.height < MinBubbleHeightC)
		bubbleSize.height = MinBubbleHeightC;
    
	bubbleSize.width += HorzPaddingC*2;
	bubbleSize.height += VertPaddingC*2;
    
	return bubbleSize;
}
- (void)setMessage:(Mensajes*)message image:(UIImage*)image
{
    imagen= [[UIImageView alloc]initWithImage:image];
    imagen.frame = CGRectMake(8, 8, 56, 56);
    imagen.clipsToBounds=YES;
    imagen.layer.cornerRadius = 8.0;
    //image.layer.masksToBounds=YES;
    imagen.layer.borderWidth=1;
    imagen.layer.borderColor=[UIColor blackColor].CGColor;
    [self.contentView addSubview:imagen];
    
	CGPoint point = CGPointZero;

	// We display messages that are sent by the user on the right-hand side of
	// the screen. Incoming messages are displayed on the left-hand side.
	

		nombre.text = message.sender;
		fecha.textAlignment = NSTextAlignmentRight;


	// Resize the bubble view and tell it to display the message text
	/*CGRect rect;
	rect.origin = point;
	rect.size = [ComentariosCell sizeForText:message.Texto];
    
    texto.frame=CGRectMake(texto.frame.origin.x, texto.frame.origin.y, texto.frame.size.width, rect.size.height);

    [texto setLineBreakMode:NSLineBreakByWordWrapping];
  
  
    [texto sizeToFit];
    [self addSubview:texto];
     */
    
    //texto.textAlignment   = UITextAlignmentLeft;
 
    CGSize maximumLabelSize = CGSizeMake(280,1000);
    
    // use font information from the UILabel to calculate the size
    CGSize expectedLabelSize = [message.Texto sizeWithFont:font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    // create a frame that is filled with the UILabel frame data
    CGRect newFrame = texto.frame;
    
    // resizing the frame to calculated size
    newFrame.size.height = expectedLabelSize.height;
    
    // put calculated frame into UILabel frame
    texto.frame = newFrame;
    texto.lineBreakMode= NSLineBreakByWordWrapping;	// Format the message date
    [texto setNumberOfLines:0];
    texto.text=message.Texto;
    [texto sizeToFit];
    
	NSString* dateString = [[NSString alloc] initWithString:message.Fecha];
    
	// Set the sender's name and date on the label
	fecha.text = [NSString stringWithFormat:@"%@",dateString];
	[fecha sizeToFit];
    
	fecha.frame = CGRectMake(8, message.bubbleSize.height, self.contentView.bounds.size.width - 16, 16);
    nombre.adjustsFontSizeToFitWidth=YES;
    fecha.adjustsFontSizeToFitWidth=YES;
    
    
}
- (void)resizeFontForLabel:(UILabel*)aLabel maxSize:(int)maxSize minSize:(int)minSize lblWidth: (float)lblWidth lblHeight: (float)lblHeight {
    // use font from provided label so we don't lose color, style, etc
    UIFont *font = aLabel.font;
    
    // start with maxSize and keep reducing until it doesn't clip
    for(int i = maxSize; i >= minSize; i--) {
        font = [font fontWithSize:i];
        CGSize constraintSize = CGSizeMake(lblWidth, MAXFLOAT);
        
        //        NSString* string = [aLabel.text stringByAppendingString:@"..."];
        CGSize labelSize = [aLabel.text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:aLabel.lineBreakMode];
        
        if(labelSize.height <= lblHeight)
            break;
    }
    
    // Set the UILabel's font to the newly adjusted font.
    aLabel.font = font;
    
}
- (void)setFoto:(UIImage*)image{
    NSLog(@"Poner Foto");
    imagen = [[UIImageView alloc]init];
    imagen.backgroundColor= [UIColor blueColor];

    imagen.clipsToBounds=YES;
    imagen.layer.cornerRadius = 8.0;
    //image.layer.masksToBounds=YES;
    imagen.layer.borderWidth=1;
    imagen.layer.borderColor=[UIColor blackColor].CGColor;
    [imagen setImage:image];
     [self.contentView addSubview:imagen];
    [self reloadInputViews];
}

@end
