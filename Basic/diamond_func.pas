program diamond_func;

procedure PrintSpaces(count: integer);
var i: integer;
begin
    for i := 1 to count do
            write(' ');
end;

procedure PrintLineOfDiamond(k, n: integer);
begin
    PrintSpaces(n + 1 - k);
    write('*');
    if k >1 then
    begin
        PrintSpaces(2*k - 3);
        write('*')
    end;
    writeln()
end;

function NegotiateHalfSize: integer;
var x: integer;
begin
    writeln('Type odd height of diamond (>1)');
    readln(x);
    while (x <= 0) or (x mod 2 = 0) do begin
        writeln('Your number is uncorrect. Type odd height of diamond (>1)');
        readln(x);
    end;
    NegotiateHalfSize := x div 2;   
end;

var 
    k, n: integer;

begin
// Entering odd x
n := NegotiateHalfSize;
// Upper part
    for k := 1 to n + 1 do 
        PrintLineOfDiamond (k, n);  
// Lower part
    for k := n downto 1 do 
        PrintLineOfDiamond (k, n);
end.
