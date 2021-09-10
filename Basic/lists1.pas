program lists1;

type
    itemptr = ^item;
    item = record
        data: integer;
        next: itemptr;
    end;

procedure ReverseList(var item: itemptr);
begin
    if item^.next <> nil then
        ReverseList(item^.next);
    writeln(item^.data);
end;

var 
    first, tmp, last: itemptr;
    n: integer;

begin
    writeln('Adding elemets to the start of list');
    first := nil;
    while not SeekEof do 
    begin
        read(n);
        new(tmp);
        tmp^.data := n;
        tmp^.next := first;
        first := tmp;
    end;
    writeln('Standart output');
    tmp := first;
    while tmp <> nil do
    begin
        writeln(tmp^.data);
        tmp := tmp^.next;
    end;
    writeln('Reversed output');
    ReverseList(first);
    while first <> nil do 
    begin
        tmp := first^.next;
        dispose(first);
        first := tmp;
    end;
    {   Same role as previous cycle
    while first <> nil do 
    begin
        tmp := first;
        first := first^.next;
        dispose(tmp);
    end;
    }
    writeln('Adding elemets to the end of list');
    first := nil;
    while not SeekEof do
    begin
        read(n);
        if first = nil then
        begin
            new(first);
            last := first
        end
        else
        begin
            new(last^.next);
            last := last^.next;
        end;
        last^.data := n;
        last^.next := nil;
    end;
    writeln('Standart output');
    tmp := first;
    while tmp <> nil do
    begin
        writeln(tmp^.data);
        tmp := tmp^.next;
    end;
end.