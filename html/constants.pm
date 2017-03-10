#===============================================================================
#       Константы
#===============================================================================

package WebGear::HTML::Constants;
use strict;

use Exporter qw(import);

our @EXPORT = do {
    no strict 'refs';
    map { /[A-Z]/ ? "\$$_" : "\@$_" } keys %{__PACKAGE__ . '::'};
};

our $UNKNOWN = 0;
our $NULL    = 0;
our $FALSE   = 0; 
our $TRUE    = 1;

our $NODE_TYPE_ELEMENT       =  1;
our $NODE_TYPE_START_TAG     =  1;
our $NODE_TYPE_ATTRIBUTE     =  2;
our $NODE_TYPE_TEXT          =  3;
our $NODE_TYPE_COMMENT       =  8;
our $NODE_TYPE_DOCUMENT      =  9;
our $NODE_TYPE_DOCUMENT_TYPE = 10;
our $NODE_TYPE_EVENT         = 12;
our $NODE_TYPE_END_TAG       = 13;                
our $NODE_TYPE_EOF           = 14;

our $NODE_FLAG_WHITESPACE    = 1; 
our $NODE_FLAG_SELFCLOSING   = 1;  
our $NODE_FLAG_FORCE_QUIRKS  = 1; 

#----- Флаги парсера -----------------------------------------------------------
#-------------------------------------------------------------------------------

# our $PARSER_FLAG_SCRIPTING           =  1;
our $PARSER_FLAG_QUIRKS_MODE_QUIRKS  =  2;
our $PARSER_FLAG_QUIRKS_MODE_LIMITED =  4;
our $PARSER_FLAG_FOSTER_PARENTING    =  8;
our $PARSER_FLAG_FRAMESET_OK         = 16;

#----- Параметры обработки RAW-данных ------------------------------------------
#-------------------------------------------------------------------------------

our @raw = (
    {'state' => \&WebGear::HTML::Scanner::scanner_state_rawdata,     'chref' => $FALSE, 'len' => 6,  'name' => [unpack("C*", "iframe")]}, 
    {'state' => \&WebGear::HTML::Scanner::scanner_state_foreigndata, 'chref' => $FALSE, 'len' => 4,  'name' => [unpack("C*", "math")]}, 
    {'state' => \&WebGear::HTML::Scanner::scanner_state_rawdata,     'chref' => $FALSE, 'len' => 7,  'name' => [unpack("C*", "noembed")]},
    {'state' => \&WebGear::HTML::Scanner::scanner_state_rawdata,     'chref' => $FALSE, 'len' => 8,  'name' => [unpack("C*", "noframes")]}, 
    {'state' => \&WebGear::HTML::Scanner::scanner_state_rawdata,     'chref' => $FALSE, 'len' => 8,  'name' => [unpack("C*", "noscript")]}, 
    {'state' => \&WebGear::HTML::Scanner::scanner_state_plaintext,   'chref' => $FALSE, 'len' => 10, 'name' => [unpack("C*", "palaintext")]},
    {'state' => \&WebGear::HTML::Scanner::scanner_state_script,      'chref' => $FALSE, 'len' => 6,  'name' => [unpack("C*", "script")]}, 
    {'state' => \&WebGear::HTML::Scanner::scanner_state_rawdata,     'chref' => $FALSE, 'len' => 5,  'name' => [unpack("C*", "style")]}, 
    {'state' => \&WebGear::HTML::Scanner::scanner_state_foreigndata, 'chref' => $FALSE, 'len' => 3,  'name' => [unpack("C*", "svg")]},
    {'state' => \&WebGear::HTML::Scanner::scanner_state_rawdata,     'chref' => $TRUE,  'len' => 8,  'name' => [unpack("C*", "textarea")]}, 
    {'state' => \&WebGear::HTML::Scanner::scanner_state_rawdata,     'chref' => $TRUE,  'len' => 5,  'name' => [unpack("C*", "title")]},     
    {'state' => \&WebGear::HTML::Scanner::scanner_state_rawdata,     'chref' => $FALSE, 'len' => 3,  'name' => [unpack("C*", "xmp")]}
);

#----- Текст -------------------------------------------------------------------
#-------------------------------------------------------------------------------

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Определение типов и преобразование ASCII символов
#
# http://www.asciitable.com/
# http://www.ascii-code.com/
#
# our @chs = (
#      ...
#     [0x00, 0x00, 0x00], # [10] -> Индекс соответствует символу в таблице ASCII.
#       |     |     |      
#       |     |     +---> Тип символа.
#       |     |     
#       |     |           +---+---+---+---+---+---+---+---+                     
#       |     |           | 7 | 6 | 5 | 4 | 3 | 2 | 1 | 0 |                   
#       |     |           +---+---+---+---+---+---+---+---+                     
#       |     |                             |   |   |   | 
#       |     |                             |   |   |   +-> DEC   - Десятичная цифра: 0-9.
#       |     |                             |   |   +-----> HEX   - Шестнадцатиричная цифра: 1-9A-Fa-f.
#       |     |                             |   +---------> ALPHA - Буква: A-Za-z
#       |     |                             +-------------> SPACE - Пробельный символ: CR, TAB, LF, FF, SPACE.                             
#       |     +---------> Цифра соответствующая символу.              
#       +---------------> Символ в нижнем регистре.
#      ...
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
our @chars = (
    [0x00, 0x00, 0x00], [0x01, 0x00, 0x00], [0x02, 0x00, 0x00], [0x03, 0x00, 0x00], [0x04, 0x00, 0x00], [0x05, 0x00, 0x00],
    [0x06, 0x00, 0x00], [0x07, 0x00, 0x00], [0x08, 0x00, 0x00], [0x09, 0x00, 0x08], [0x0a, 0x00, 0x08], [0x0b, 0x00, 0x00],
    [0x0c, 0x00, 0x08], [0x0d, 0x00, 0x08], [0x0e, 0x00, 0x00], [0x0f, 0x00, 0x00], [0x10, 0x00, 0x00], [0x11, 0x00, 0x00],
    [0x12, 0x00, 0x00], [0x13, 0x00, 0x00], [0x14, 0x00, 0x00], [0x15, 0x00, 0x00], [0x16, 0x00, 0x00], [0x17, 0x00, 0x00],
    [0x18, 0x00, 0x00], [0x19, 0x00, 0x00], [0x1a, 0x00, 0x00], [0x1b, 0x00, 0x00], [0x1c, 0x00, 0x00], [0x1d, 0x00, 0x00],
    [0x1e, 0x00, 0x00], [0x1f, 0x00, 0x00], [0x20, 0x00, 0x08], [0x21, 0x00, 0x00], [0x22, 0x00, 0x00], [0x23, 0x00, 0x00],
    [0x24, 0x00, 0x00], [0x25, 0x00, 0x00], [0x26, 0x00, 0x00], [0x27, 0x00, 0x00], [0x28, 0x00, 0x00], [0x29, 0x00, 0x00],
    [0x2a, 0x00, 0x00], [0x2b, 0x00, 0x00], [0x2c, 0x00, 0x00], [0x2d, 0x00, 0x00], [0x2e, 0x00, 0x00], [0x2f, 0x00, 0x00],
    [0x30, 0x00, 0x03], [0x31, 0x01, 0x03], [0x32, 0x02, 0x03], [0x33, 0x03, 0x03], [0x34, 0x04, 0x03], [0x35, 0x05, 0x03],
    [0x36, 0x06, 0x03], [0x37, 0x07, 0x03], [0x38, 0x08, 0x03], [0x39, 0x09, 0x03], [0x3a, 0x00, 0x00], [0x3b, 0x00, 0x00],
    [0x3c, 0x00, 0x00], [0x3d, 0x00, 0x00], [0x3e, 0x00, 0x00], [0x3f, 0x00, 0x00], [0x40, 0x00, 0x00], [0x61, 0x0a, 0x06],
    [0x62, 0x0b, 0x06], [0x63, 0x0c, 0x06], [0x64, 0x0d, 0x06], [0x65, 0x0e, 0x06], [0x66, 0x0f, 0x06], [0x67, 0x00, 0x04],
    [0x68, 0x00, 0x04], [0x69, 0x00, 0x04], [0x6a, 0x00, 0x04], [0x6b, 0x00, 0x04], [0x6c, 0x00, 0x04], [0x6d, 0x00, 0x04],
    [0x6e, 0x00, 0x04], [0x6f, 0x00, 0x04], [0x70, 0x00, 0x04], [0x71, 0x00, 0x04], [0x72, 0x00, 0x04], [0x73, 0x00, 0x04],
    [0x74, 0x00, 0x04], [0x75, 0x00, 0x04], [0x76, 0x00, 0x04], [0x77, 0x00, 0x04], [0x78, 0x00, 0x04], [0x79, 0x00, 0x04],
    [0x7a, 0x00, 0x04], [0x5b, 0x00, 0x00], [0x5c, 0x00, 0x00], [0x5d, 0x00, 0x00], [0x5e, 0x00, 0x00], [0x5f, 0x00, 0x00],
    [0x60, 0x00, 0x00], [0x61, 0x0a, 0x06], [0x62, 0x0b, 0x06], [0x63, 0x0c, 0x06], [0x64, 0x0d, 0x06], [0x65, 0x0e, 0x06],
    [0x66, 0x0f, 0x06], [0x67, 0x00, 0x04], [0x68, 0x00, 0x04], [0x69, 0x00, 0x04], [0x6a, 0x00, 0x04], [0x6b, 0x00, 0x04],
    [0x6c, 0x00, 0x04], [0x6d, 0x00, 0x04], [0x6e, 0x00, 0x04], [0x6f, 0x00, 0x04], [0x70, 0x00, 0x04], [0x71, 0x00, 0x04],
    [0x72, 0x00, 0x04], [0x73, 0x00, 0x04], [0x74, 0x00, 0x04], [0x75, 0x00, 0x04], [0x76, 0x00, 0x04], [0x77, 0x00, 0x04],
    [0x78, 0x00, 0x04], [0x79, 0x00, 0x04], [0x7a, 0x00, 0x04], [0x7b, 0x00, 0x00], [0x7c, 0x00, 0x00], [0x7d, 0x00, 0x00],
    [0x7e, 0x00, 0x00], [0x7f, 0x00, 0x00], [0x80, 0x00, 0x00], [0x81, 0x00, 0x00], [0x82, 0x00, 0x00], [0x83, 0x00, 0x00],
    [0x84, 0x00, 0x00], [0x85, 0x00, 0x00], [0x86, 0x00, 0x00], [0x87, 0x00, 0x00], [0x88, 0x00, 0x00], [0x89, 0x00, 0x00],
    [0x8a, 0x00, 0x00], [0x8b, 0x00, 0x00], [0x8c, 0x00, 0x00], [0x8d, 0x00, 0x00], [0x8e, 0x00, 0x00], [0x8f, 0x00, 0x00],
    [0x90, 0x00, 0x00], [0x91, 0x00, 0x00], [0x92, 0x00, 0x00], [0x93, 0x00, 0x00], [0x94, 0x00, 0x00], [0x95, 0x00, 0x00],
    [0x96, 0x00, 0x00], [0x97, 0x00, 0x00], [0x98, 0x00, 0x00], [0x99, 0x00, 0x00], [0x9a, 0x00, 0x00], [0x9b, 0x00, 0x00],
    [0x9c, 0x00, 0x00], [0x9d, 0x00, 0x00], [0x9e, 0x00, 0x00], [0x9f, 0x00, 0x00], [0xa0, 0x00, 0x00], [0xa1, 0x00, 0x00],
    [0xa2, 0x00, 0x00], [0xa3, 0x00, 0x00], [0xa4, 0x00, 0x00], [0xa5, 0x00, 0x00], [0xa6, 0x00, 0x00], [0xa7, 0x00, 0x00],
    [0xa8, 0x00, 0x00], [0xa9, 0x00, 0x00], [0xaa, 0x00, 0x00], [0xab, 0x00, 0x00], [0xac, 0x00, 0x00], [0xad, 0x00, 0x00],
    [0xae, 0x00, 0x00], [0xaf, 0x00, 0x00], [0xb0, 0x00, 0x00], [0xb1, 0x00, 0x00], [0xb2, 0x00, 0x00], [0xb3, 0x00, 0x00],
    [0xb4, 0x00, 0x00], [0xb5, 0x00, 0x00], [0xb6, 0x00, 0x00], [0xb7, 0x00, 0x00], [0xb8, 0x00, 0x00], [0xb9, 0x00, 0x00],
    [0xba, 0x00, 0x00], [0xbb, 0x00, 0x00], [0xbc, 0x00, 0x00], [0xbd, 0x00, 0x00], [0xbe, 0x00, 0x00], [0xbf, 0x00, 0x00],
    [0xc0, 0x00, 0x00], [0xc1, 0x00, 0x00], [0xc2, 0x00, 0x00], [0xc3, 0x00, 0x00], [0xc4, 0x00, 0x00], [0xc5, 0x00, 0x00],
    [0xc6, 0x00, 0x00], [0xc7, 0x00, 0x00], [0xc8, 0x00, 0x00], [0xc9, 0x00, 0x00], [0xca, 0x00, 0x00], [0xcb, 0x00, 0x00],
    [0xcc, 0x00, 0x00], [0xcd, 0x00, 0x00], [0xce, 0x00, 0x00], [0xcf, 0x00, 0x00], [0xd0, 0x00, 0x00], [0xd1, 0x00, 0x00],
    [0xd2, 0x00, 0x00], [0xd3, 0x00, 0x00], [0xd4, 0x00, 0x00], [0xd5, 0x00, 0x00], [0xd6, 0x00, 0x00], [0xd7, 0x00, 0x00],
    [0xd8, 0x00, 0x00], [0xd9, 0x00, 0x00], [0xda, 0x00, 0x00], [0xdb, 0x00, 0x00], [0xdc, 0x00, 0x00], [0xdd, 0x00, 0x00],
    [0xde, 0x00, 0x00], [0xdf, 0x00, 0x00], [0xe0, 0x00, 0x00], [0xe1, 0x00, 0x00], [0xe2, 0x00, 0x00], [0xe3, 0x00, 0x00],
    [0xe4, 0x00, 0x00], [0xe5, 0x00, 0x00], [0xe6, 0x00, 0x00], [0xe7, 0x00, 0x00], [0xe8, 0x00, 0x00], [0xe9, 0x00, 0x00],
    [0xea, 0x00, 0x00], [0xeb, 0x00, 0x00], [0xec, 0x00, 0x00], [0xed, 0x00, 0x00], [0xee, 0x00, 0x00], [0xef, 0x00, 0x00],
    [0xf0, 0x00, 0x00], [0xf1, 0x00, 0x00], [0xf2, 0x00, 0x00], [0xf3, 0x00, 0x00], [0xf4, 0x00, 0x00], [0xf5, 0x00, 0x00],
    [0xf6, 0x00, 0x00], [0xf7, 0x00, 0x00], [0xf8, 0x00, 0x00], [0xf9, 0x00, 0x00], [0xfa, 0x00, 0x00], [0xfb, 0x00, 0x00],
    [0xfc, 0x00, 0x00], [0xfd, 0x00, 0x00], [0xfe, 0x00, 0x00], [0xff, 0x00, 0x00]);

1;
