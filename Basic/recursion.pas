program recursion;

var x: longint;

function DoReverseNumber(n, m: longint):longint;
begin
    if n = 0 then
        DoReverseNumber := m
    else
        DoReverseNumber := 
            DoReverseNumber(n div 10, m * 10 + n mod 10)    
end;

function ReverseNumber(x: longint):longint;
begin
    ReverseNumber := DoReverseNumber(x, 0)
end;

begin
    writeln('Type number to be reversed');
    readln(x);
    x := ReverseNumber(x);
    writeln(x);
end.