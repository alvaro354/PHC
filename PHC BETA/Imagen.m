//
//  Imagen.m
//  PHC BETA
//
//  Created by Alvaro Lancho on 16/05/13.
//  Copyright (c) 2013 LanchoSoftware. All rights reserved.
//

#import "Imagen.h"

@implementation Imagen
@synthesize ID,IDusuario,imagen,Etiquetas,Nombre, Fecha,perfil, comentarios, publico,altura,XML,URL;
-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:ID forKey:@"ID"];
    [encoder encodeObject:IDusuario forKey:@"IDusuario"];
    [encoder encodeObject:imagen forKey:@"imagen"];
    [encoder encodeObject:Etiquetas forKey:@"Etiquetas"];
    [encoder encodeObject:Nombre forKey:@"Nombre"];
    [encoder encodeObject:Fecha forKey:@"Fecha"];
   [encoder encodeObject:perfil forKey:@"perfil"];
       [encoder encodeObject:comentarios forKey:@"comentarios"];
    [encoder encodeObject:publico forKey:@"publico"];
    [encoder encodeObject:altura forKey:@"altura"];
     [encoder encodeObject:XML forKey:@"xml"];
    [encoder encodeObject:URL forKey:@"URL"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    ID = [decoder decodeObjectForKey:@"ID"];
    IDusuario = [decoder decodeObjectForKey:@"IDusuario"];
    imagen = [decoder decodeObjectForKey:@"imagen"];
    Etiquetas = [decoder decodeObjectForKey:@"Etiquetas"];
    Fecha = [decoder decodeObjectForKey:@"Fecha"];
    Nombre = [decoder decodeObjectForKey:@"Nombre"];
    perfil=[decoder decodeObjectForKey:@"perfil"];
    comentarios= [decoder decodeObjectForKey:@"comentarios"];
    publico= [decoder decodeObjectForKey:@"publico"];
    altura= [decoder decodeObjectForKey:@"altura"];
    XML= [decoder decodeObjectForKey:@"xml"];
    URL= [decoder decodeObjectForKey:@"URL"];
    
    return self;
}
@end


