program diamond_proc;

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

var 
    k, n, x: integer;

begin
// Entering odd x
writeln('Type odd height of diamond (>1)');
readln(x);
writeln(x mod 2);
while (x <= 0) or (x mod 2 = 0) do begin
    writeln('Your number is uncorrect. Type odd height of diamond (>1)');
    readln(x);  
end;
n := x div 2;
// Upper part
    for k := 1 to n + 1 do 
        PrintLineOfDiamond (k, n);  
// Lower part
    for k := n downto 1 do 
        PrintLineOfDiamond (k, n);
end.
