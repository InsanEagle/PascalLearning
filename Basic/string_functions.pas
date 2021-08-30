program string_functions;

var a, b, c :string;
    num :integer;
    code :word;

// Analog to LowerCase function
function LCase(str: string):string;

var
    l, i:integer;
begin
    l := length(str);
    for i := 1 to l do
       if (str[i] >= 'A') and (str[i] <= 'Z') then
            str[i] := chr(ord(str[i]) + 32);
    LCase := str;
end;

// Analog to UpCase function
function UCase(str: string):string;

var
    l, i:integer;
begin
    l := length(str);
    for i := 1 to l do
       if (str[i] >= 'a') and (str[i] <= 'z') then
            str[i] := chr(ord(str[i]) - 32);
    UCase := str;
end;

// Analog to copy function
function CopyStr(str: string; start, number: integer):string;

var
    l, i:integer;
begin
    CopyStr := '';
    l := length(str);
    if (start + number) >= l then
        for i := start to l do
            CopyStr := CopyStr + str[i]
    else
        for i := start to start + number - 1 do
            CopyStr := CopyStr + str[i]
end;

// Analog to delete function
procedure DeleteStr(var a: string; start, number: integer);

var
    l, i:integer;
begin
    l := length(a);
    if (start + number) >= l then
        SetLength(a, start)    
    else
        begin
            for i := start to start + number -2 do
                a[i] := a[i + number];
            i := l - number;
            SetLength(a, i);
        end;         
end;

// Analog to insert function
procedure InsertStr(str: string; var a: string; start: integer);

var
    l, l2, lsum, i:integer;
begin
    l := length(a);
    l2 := length(str);
    lsum := l + l2;
    SetLength(a, lsum);
    if start > l then     
        a := a + str
    else
        begin
            for i := start to start + l2 - 1 do
                a[i + l2] := a[i];
            for i := 1 to l2 do
                a[start - 1 + i] := str[i];
        end;         
end;

// Analog to pos function
function PosStr(str, a: string):integer;

var
    l, l2, i, k, pos, check:integer;
    done: boolean;

label success; 

begin
    l := length(a);
    l2 := length(str);
    for i := 1 to l - l2 + 1 do
    begin
        check := 0;
        pos := i;
        for k := 1 to l2 do 
        begin
            if str[k] = a[pos] then
                check := check + 1;
            if check = l2 then
            begin
                done := true;
                goto success;
            end;
            pos := pos + 1;      
        end;
    end;
    success: 
    if not done then
        PosStr := 0
    else 
        PosStr := pos - l2 + 1;
end;

// Analog to val function
procedure ValStr(str: string; var num: integer; var Code: word);

var
    l, i, k, check, start:integer;
    canceled: boolean;

label error;

begin
    l := length(str);
    k := 1;
    check := 1;
    canceled := false;
    num := 0;
    while (str[k] = ' ') or (str[k] = #9) do
        k := k + 1;
    start := k;
    if ((str[k] < '0') or (str[k] > '9')) and (str[k] <> '-') then
        begin
            canceled := true;
            goto error;
        end   
    else if str[k] = '-' then
        check := 2;
    for i := k + 1 to l do
        if (str[i] < '0') or (str[i] > '9') then
            begin
                canceled := true;
                goto error;
            end;
    if check = 1 then
        for i := start to l do
            num := ord(str[i]) + num*10 - ord('0')
    else 
        begin
            for i := start + 1 to l do
                num := ord(str[i]) + num*10 - ord('0');
            num := -num;  
        end;
    error:
    if canceled then 
        begin
            Code := 1;
            num := 0;
        end 
    else
        Code := 0;
end;

begin
    writeln('Type string: ');
    readln(a);
 //   writeln('Type second string: ');
 //   readln(c);
    b := a;
    num := 10;
    ValStr(a, num, code);
 //   writeln(pos(c,a));
 //   writeln(PosStr(c,b));
 //   insert('PQR', a, 4);
 //   InsertStr('PQR', b, 4);
 //   writeln(copy(a, 10, 5));
 //   writeln(CopyStr(a, 10, 5));
 //   delete(a, 5, 4);
 //   DeleteStr(b, 5, 4);
    writeln(num);
    writeln(code);
 //   writeln(b);
end.
