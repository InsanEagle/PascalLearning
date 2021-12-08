{
    Things i wanna add:
    1) Borders which user can choose (program will ask which walls 
    he wanna see and he will type something like "url" for upper right
    and left borders)
    2) Different head and tale (Done)
    3) Score (Done)
    4) Obstakles (probably random, probably map creator in txt file)
    5) User to choose colors and probably symbols for snake, apples, obstackles, borders
    6) Level changing after reaching certain score
}



program Snake;
uses crt;
const
    DelayDuration : array [1..3] of integer = (100, 50, 200);
    MaxLength = 255;
    Growth = 3;
    StartLength = 5;

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

procedure ShowHead(var sh: SnakeHead);
begin
    GotoXY(sh.CurX, sh.CurY);
    write('🙂');
    GotoXY(1, 1)
end;

procedure MoveStar(var sh: SnakeHead);
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

procedure SetDirection(var sh: SnakeHead; dx, dy: integer; var st: array of SnakeTail);
begin
    if (sh.CurX + dx <> st[1].CurX) or (sh.CurY + dy <> st[1].CurY) then
    begin
        sh.dx := dx;
        sh.dy := dy;
    end;
end;

procedure SetStartPos(var sh: SnakeHead);
begin
    sh.CurX := ScreenWidth div 2;
    sh.CurY := ScreenHeight div 2;
end;

procedure HideTail(var st: array of SnakeTail; var tlength: integer);
begin
    GotoXY(st[tlength].CurX, st[tlength].CurY);
    write(' ');
    GotoXY(1, 1)
end;

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

procedure CheckAndMoveTail (var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer);
begin
    if (sh.dx <> 0) or (sh.dy <> 0) then
        MoveTail(st, sh, tlength);
end;

procedure ShowTail (var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer);
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

procedure CheckCollision (var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer);
var
    i: integer;
begin
    if tlength >= 4 then
        for i := 4 to tlength do
        begin
            if (st[i].CurX = sh.CurX) and (st[i].CurY = sh.CurY) then
            begin
                clrscr;
                halt;
            end;  
        end; 
end;

procedure CheckApple(var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer; var app: Apple);
var
    i: integer;
    done: boolean;
begin
    if app.eaten then 
    begin
        repeat
            done := true;
            app.CurX := random(ScreenWidth - 2) + 3;
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
        app.eaten := false;
    end;
end;

procedure GenerateApple (var app: Apple);
begin
    GotoXY(app.CurX, app.CurY);
    write('🍎');
    GotoXY(1, 1);
end;

procedure IfEatenApple (var sh: SnakeHead; var app: Apple; var score: integer);
begin
    if (sh.CurX = app.CurX) and (sh.CurY = app.CurY) then
    begin
        app.eaten := true; 
        GotoXY(app.CurX, app.CurY);
        write('🙂');
        GotoXY(1,1);
        score := score + 1;
    end;
    
end;

procedure SnakeGrowth (var app: Apple; var tlength: integer);
begin
    if app.eaten then
        if tlength <= MaxLength then          
            tlength := tlength + Growth;
end;

procedure AppleProcedure (var st: array of SnakeTail; var sh: SnakeHead; var tlength: integer; var app: Apple; var score: integer);
begin
    CheckApple(st, sh, tlength, app);
    GenerateApple(app);
    IfEatenApple(sh, app, score);
    SnakeGrowth(app, tlength);
end;

procedure SetScoreUI (var score: integer; var speed: integer; var gamemode: integer);
begin
    GotoXY((ScreenWidth div 3) - 10,1);
    write('Score: ', score);
    GotoXY((ScreenWidth div 2) - 5,1);
    write('Gamemode: ', gamemode);
    GotoXY((ScreenWidth - (ScreenWidth div 3)) + 3,1);
    write('Speed: ', speed);
    GotoXY(1,1)
end;

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

procedure SetUI (var score: integer; var speed: integer; var gamemode: integer);
begin
    SetScoreUI(score, speed, gamemode);
    SetBordersUI();
end;

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

procedure PageOne ();
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

var
    sh: SnakeHead;
    c, tlength, score, prevc, speed, gamemode: integer;
    st: array [1..MaxLength] of SnakeTail;
    app: Apple;
    cleared: boolean;
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
    c := 32;
    cleared := false;
    prevc := 0;
    speed := 1;
    gamemode := 1337;
    while true do
    begin
        if not KeyPressed then
        begin
            if c = 32 then
            begin
                PauseMenu(cleared);
                prevc := c;
            end
            else if (c = 49) and (prevc = 32) then
            begin
                  PageOne();
                  prevc := c;
            end
            else if (c = 49) and (prevc = 49) then
                speed := 1
            else if (c = 50) and (prevc = 49) then
                speed := 2 
            else if (c = 51) and (prevc = 49) then
                speed := 3        
            else
            begin
                if cleared = false then
                begin
                    clrscr;
                    cleared := true;
                end;
                SetUI(score, speed, gamemode);
                CheckAndMoveTail(st, sh, tlength);
                ShowTail(st, sh, tlength);
                MoveStar(sh);
                AppleProcedure(st, sh, tlength, app, score); 
                CheckCollision(st, sh, tlength); 
                prevc := c;    
            end; 
            delay(DelayDuration[speed]);
            continue
        end;
        GetKey(c);
        case c of
            -75: SetDirection(sh, -1, 0, st);         { left arrow }
            -77: SetDirection(sh, 1, 0, st);         { right arrow }
            -72: SetDirection(sh, 0, -1, st);           { up arrow }
            -80: SetDirection(sh, 0, 1, st);          { down arrow }
             32: SetDirection(sh, 0, 0, st);   { space bar (pause) }             
             27:  break                            { escape (exit) }
        end
    end;
    clrscr
end.
