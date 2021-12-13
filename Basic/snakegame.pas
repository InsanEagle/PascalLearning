{
    Snake fixes to do:

1. Test how st array works:
    1.1. Check values out tlength
    1.2. Check how growth works                                                                     (Done)
    1.3. Maybe make dynamic structure for tail
2. Make GenerateApple procedure works only once                                                     (Done)
3. Optimize ShowTail (Don't need to write '*' if it already shown)                                  (Done)
4. CheckCollision optimization (maybe?)
5. Rewrite UI procedure:
    5.1. Separate menu and game borders and info (Everything draw only once)                        (Done)
    5.2. Separate Delay for menu and game itself                                                    (Done) (Optimized)
    5.3. Make menu in .txt (maybe?)
6. Fix ASCII symbols
7. Rewrite procedures and functions (reduce the use of big data where one variable is needed)
8. Add commentaries                                                                                 (Done)

    Snake features to do:

1. Make different gamemodes (reference google's snake)
2. Some type of map creator in .txt
3. Work with crt colours and ASCII (some type of customization)
4. Level or/and speed changing after sertain score (randomly generated or prepared map from .txt)
5. Make tool to change controls manually
6. Records to and from .txt (Ask name if record is made and add to table)
7. Score calculating depends on speed
8. Adding changing max length of snake (Short, normal, long campaign) 

    Menu looks like:

1. Navigation with arrows ('↑' '↓'), Enter and ESC
2. Current bar highlights (Color, bgColor, adding symbols etc.)
3. When try to quit game ask if user sure (Enter for 'Yes' and ESC for 'No')
4. When loses, go to main menu with score 
}


program Snake;
uses crt;
const
    DelayDuration : array [1..3] of integer = (100, 50, 200); // 3 types of speed (Normal, Fast, Slow)
    MaxLength = 255;                                          // Max size of Snake tail
    Growth = 3;                                               // Growt of the tail when eating
    StartLength = 5;                                          // Start size of Snake tail

type
    SnakeHead = record
        CurX, CurY, dx, dy: integer;
    end;
    SnakeTail = record
        CurX, CurY: integer;
    end;
    Apple = record
        CurX, CurY: integer;
        eaten: boolean;
    end;

procedure ExitGame ();
begin
    clrscr;
    halt;
end;

// Simple char input including checking for 2-char symbols
procedure GetKey(var code: integer);
var
    c: char;
begin
    c := ReadKey;
    if c = #0 then
    begin
        c := ReadKey;
        code := -ord(c)
    end
    else
    begin
        code := ord(c)
    end
end;

// Drawing head
procedure ShowHead(var sh: SnakeHead);
begin
    GotoXY(sh.CurX, sh.CurY);
    write('#');
    GotoXY(1, 1)
end;

// 'No walls' realization. Will be added some gamemodes with different movement and obstacles
procedure MoveHead(var sh: SnakeHead);
begin
    sh.CurX := sh.CurX + sh.dx;
    if sh.CurX > ScreenWidth - 1 then
        sh.CurX := 3
    else
    if sh.CurX < 3 then
        sh.CurX := ScreenWidth - 1;
    sh.CurY := sh.CurY + sh.dy;
    if sh.CurY > ScreenHeight - 2 then
        sh.CurY := 3
    else
    if sh.CurY < 3 then
        sh.CurY := ScreenHeight - 2;
    ShowHead(sh)
end;

// Initialization of Snake head. Will be added same for tail
procedure SetStartPos(var sh: SnakeHead);
begin
    sh.CurX := ScreenWidth div 2;
    sh.CurY := ScreenHeight div 2;
end;

// Last tail part replacing with whitespace 
procedure HideTail(var st: array of SnakeTail; var tlength: integer);
begin
    GotoXY(st[tlength].CurX, st[tlength].CurY);
    write(' ');
    GotoXY(1, 1)
end;

// Replaces current position of tail part with previous part. First tail part takes Snake head position
procedure MoveTail(var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer);
var
    i: integer;
begin
    HideTail(st, tlength);
    for i := tlength downto 2 do 
    begin
        st[i].CurX := st[i-1].CurX;
        st[i].CurY := st[i-1].CurY;
    end;
    st[1].CurX := sh.CurX;
    st[1].CurY := sh.CurY;
end;

// Moving tail if only Snake head is moving
procedure CheckAndMoveTail (var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer);
begin
    if (sh.dx <> 0) or (sh.dy <> 0) then
        MoveTail(st, sh, tlength);
end;

// Drawing only first part of tail because next parts will be going through route of stars
// which made by this one. We don't need to replace star with another star 
procedure ShowTail (var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer);
begin
    GotoXY(st[1].CurX, st[1].CurY);
    write('*');
    GotoXY(1,1);
end;

// We need separate procedure to draw all parts of Snake tail after 'clrscr' procedure in MainMenu
procedure ShowTailAfterPause (var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer);
var
    i: integer;
begin
    for i := 1 to tlength do
    begin
        GotoXY(st[i].CurX,st[i].CurY);
        write('*');
        GotoXY(1,1);
    end;
end;

// Every step we need to check if Snake head is colliding with tail.
// We don't need to check first 3 parts of Snake tail because it is impossible
// to hit them.  Will be added checks for obstacles
procedure CheckCollision (var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer);
var
    i: integer;
begin
        for i := 4 to tlength do
        begin
            if (st[i].CurX = sh.CurX) and (st[i].CurY = sh.CurY) then
            ExitGame();
        end; 
end;

// Checks if apple is eated and generates new one. Can't be placed in Snake. Works only once after apple is eated.
// Can be optimized to not to be called every step.
procedure CheckAndGenerateApple(var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer; var app: Apple);
var
    i: integer;
    done: boolean;
begin
    if app.eaten then 
    begin
        repeat
            done := true;
            app.CurX := random(ScreenWidth - 2) + 2;
            app.CurY := random(ScreenHeight - 4) + 3;
            if (sh.CurX = app.CurX) and (sh.CurY = app.CurY) then
            begin
                done := false;
                continue;
            end; 
            for i := 1 to tlength do
            begin
                if (st[i].CurX = app.CurX) and (st[i].CurY = app.CurY) then
                begin
                    done := false;
                    break;
                end;   
            end;           
        until (done);
        GotoXY(app.CurX, app.CurY);
        write('@');
        GotoXY(1, 1);
        app.eaten := false;
    end;
end;

// Making prevous procedure works. Also adding score and drawing it for eating.
procedure IfEatenApple (var sh: SnakeHead; var app: Apple; var score: integer);
begin
    if (sh.CurX = app.CurX) and (sh.CurY = app.CurY) then
    begin
        app.eaten := true; 
        score := score + 1;
        GotoXY((ScreenWidth div 3) - 10 + 7, 1);
        write(score);
        GotoXY(1,1);
    end;
end;

// Probably useless check for MaxLength.
procedure SnakeGrowth (var app: Apple; var tlength: integer);
begin
    if app.eaten then
        if tlength <= MaxLength then          
            tlength := tlength + Growth;
end;

// Sumarize prevous parts 
procedure AppleProcedure (var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer; var app: Apple; var score: integer);
begin
    CheckAndGenerateApple(st, sh, tlength, app);
    IfEatenApple(sh, app, score);
    SnakeGrowth(app, tlength);
end;

// Need to be used only once
procedure ShowAppleAfterPause (var app: Apple);
begin
    GotoXY(app.CurX, app.CurY);
    write('@');
    GotoXY(1, 1);
end;

// Drawing score, gamemode and speed 
procedure SetScoreUI (var speed: integer; var gamemode: integer);
begin
    GotoXY((ScreenWidth div 3) - 10, 1);
    write('Score: ');
    GotoXY((ScreenWidth div 2) - 5, 1);
    write('Gamemode: ', gamemode);
    GotoXY((ScreenWidth - (ScreenWidth div 3)) + 3, 1);
    write('Speed: ', speed);
    GotoXY(1,1)
end;

// Drawing playing arena for Snake 
procedure SetBordersUI ();
var
    i: integer;
begin
    for i := 2 to ScreenWidth - 2 do
    begin
        GotoXY(i,2);
        write('-');
        GotoXY(i,ScreenHeight - 1);
        write('-');
    end;
    for i := 3 to ScreenHeight - 1  do
    begin
        GotoXY(2,i);
        write('|');
        GotoXY(ScreenWidth,i);
        write('|');
    end;
    GotoXY(2,2);
    write('+');
    GotoXY(2,ScreenHeight - 1);
    write('+');
    GotoXY(ScreenWidth,2);
    write('+');
    GotoXY(ScreenWidth,ScreenHeight - 1);
    write('+'); 
    GotoXY(1,1)
end;

// Sumaraze visual stuff
procedure SetUI (var speed: integer; var gamemode: integer);
begin
    SetScoreUI(speed, gamemode);
    SetBordersUI();
end;

// The same code as in 'IfEatenApple' procedure
procedure ShowScoreAfterPause (var score: integer);
begin
    GotoXY((ScreenWidth div 3) - 10 + 7, 1);
    write(score);
    GotoXY(1,1);
end;

// Parts of previous menu 
{ 
procedure PauseMenu (var cleared: boolean);
begin
    clrscr;
    GotoXY((ScreenWidth - 10) div 2,(ScreenHeight - 9) div 2);
    write('SNAKE GAME');
    GotoXY((ScreenWidth - 9) div 2,WhereY + 2);
    write('Controls:');
    GotoXY((ScreenWidth - 13) div 2,WhereY + 1);
    write('→  Move right');
    GotoXY((ScreenWidth - 12) div 2,WhereY + 1);
    write('←  Move left');
    GotoXY((ScreenWidth - 10) div 2,WhereY + 1);
    write('↑  Move up');
    GotoXY((ScreenWidth - 12) div 2,WhereY + 1);
    write('↓  Move down');
    GotoXY((ScreenWidth - 17) div 2,WhereY + 1);
    write('SPACE  Pause menu');
    GotoXY((ScreenWidth - 9) div 2,WhereY + 1);
    write('ESC  Quit');
    GotoXY((ScreenWidth - 15) div 2,WhereY + 1);
    write('1  Change speed');
    GotoXY((ScreenWidth - 18) div 2,WhereY + 1);
    write('2  Change gamemode');
    cleared := false;
    GotoXY(1,1);
end;
}
{
procedure SelectSpeed ();
begin
    clrscr;
    GotoXY((ScreenWidth - 10) div 2,(ScreenHeight - 9) div 2);
    write('SNAKE GAME');
    GotoXY((ScreenWidth - 9) div 2,WhereY + 2);
    write('Set speed:');
    GotoXY((ScreenWidth - 13) div 2,WhereY + 1);
    write('1  Normal speed');
    GotoXY((ScreenWidth - 12) div 2,WhereY + 1);
    write('2  Fast speed');
    GotoXY((ScreenWidth - 10) div 2,WhereY + 1);
    write('3  Slow speed');
    GotoXY((ScreenWidth - 17) div 2,WhereY + 1);
    write('SPACE  Pause menu');
    GotoXY((ScreenWidth - 9) div 2,WhereY + 1);
    write('ESC  Quit');
    GotoXY(1,1);
end;
}
{
procedure SelectGamemode ();
begin
    clrscr;
    GotoXY((ScreenWidth - 10) div 2,(ScreenHeight - 9) div 2);
    write('SNAKE GAME');
    GotoXY((ScreenWidth - 13) div 2,WhereY + 2);
    write('Set gamemode:');
    GotoXY((ScreenWidth - 16) div 2,WhereY + 1);
    write('1  Without walls');
    GotoXY((ScreenWidth - 13) div 2,WhereY + 1);
    write('2  With walls');
    GotoXY((ScreenWidth - 16) div 2,WhereY + 1);
    write('3  Some gamemode');
    GotoXY((ScreenWidth - 17) div 2,WhereY + 1);
    write('SPACE  Pause menu');
    GotoXY((ScreenWidth - 9) div 2,WhereY + 1);
    write('ESC  Quit');
    GotoXY(1,1);
end;
}

// Included check for inverted movement which is ignored
procedure ControlsGame (var c: integer; var sh: SnakeHead; var st: array of SnakeTail; var inmenu: boolean);
    procedure SetDirection(var sh: SnakeHead; dx, dy: integer; var st: array of SnakeTail);
    begin
        if (sh.CurX + dx <> st[1].CurX) or (sh.CurY + dy <> st[1].CurY) then
        begin
            sh.dx := dx;
            sh.dy := dy;
        end;
    end;
begin
    case c of
        -75: SetDirection(sh, -1, 0, st);         { left arrow }
        -77: SetDirection(sh, 1, 0, st);         { right arrow }
        -72: SetDirection(sh, 0, -1, st);           { up arrow }
        -80: SetDirection(sh, 0, 1, st);          { down arrow }
         32: SetDirection(sh, 0, 0, st);   { space bar (pause) }             
         27: inmenu := true;             { escape (go to menu) }
    end
end;

// Probably some type of procedure to make strings in menu
{
procedure MenuAlign (str: string);
begin
    
end;
}

// Need to make some work here
procedure MainMenu(var c: integer; var inmenu: boolean);
{
    type
    MenuPos = record
       CurX, CurY: integer;
    end;
var
    page: byte;
    mpos: array [1..10] of integer;
}
begin
    clrscr;
    GotoXY((ScreenWidth - 10) div 2,(ScreenHeight - 9) div 2);
    write('SNAKE GAME');
    GotoXY((ScreenWidth - 15) div 2,WhereY + 1);
    write('Enter  Continue');
    GotoXY((ScreenWidth - 9) div 2,WhereY + 1);
    write('ESC  Quit');
    GotoXY(1,1);
    while True do
    begin
        GetKey(c);
        case c of
//        -72: ;            { up arrow }
//        -80: ;          { down arrow }
         13: break;                          { enter (confirm) }             
         27: ExitGame();                       { escape (exit) }        
        end;
    end;
    inmenu := false;
    clrscr;
end;

var
    sh: SnakeHead;
    c, tlength, score, speed, gamemode: integer; // c - char input; tlength - tail length; 
    st: array [1..MaxLength] of SnakeTail;       // st - snake tail
    app: Apple;
    inmenu: boolean;                             // check to switch between MainMenu and game cycle

begin
    randomize;
    clrscr;
    tlength := StartLength;
    SetStartPos(sh);
    sh.dx := 0;
    sh.dy := 0;
    app.eaten := true;
    ShowHead(sh);
    score := 0;
    speed := 1;
    gamemode := 1337;
    inmenu := true;
    while true do
    begin
         if not inmenu then
         begin
            if not KeyPressed then
            begin
                CheckAndMoveTail(st, sh, tlength);
                MoveHead(sh);
                ShowTail(st, sh, tlength);
                AppleProcedure(st, sh, tlength, app, score); 
                CheckCollision(st, sh, tlength);   
                delay(DelayDuration[speed]);
                continue
            end;
            GetKey(c);
            ControlsGame(c, sh, st, inmenu);
        end
        else
        begin
            MainMenu(c, inmenu);
            ShowTailAfterPause(st, sh, tlength);
            ShowAppleAfterPause(app);
            ShowScoreAfterPause(score);
            SetUI(speed, gamemode);
        end;       
    end;
    clrscr;
end.
