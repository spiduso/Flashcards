{ Flashcards }
{ Hoang Anh Tuan, I. ročník, Softwarové a datové inženýrství }
{ Zimní semestr 2018/19 }
{ Programování NPRG030 }

program flashcards;

uses
  Crt,
  SysUtils;

type
  PFlash = ^Flash;
  PList = ^ListSection;

  Flash = record
    Front: string;
    Back: string;
    Next: PFlash;
  end;

  ListSection = record
    Name: string;
    Next: ^ListSection;
  end;

var
  main, temp: TextFile;
  section, i, ValEdit, ValMenu: string;
  FirstCard: PFlash;

  // finds where in line begin arrow between two words
  function FindArrow(line: string): integer;
  var
    i: integer;
  begin
    i := 1;
    while (copy(line, i, 3) <> '-->') do
    begin
      Inc(i);
    end;
    Result := i;
  end;

  // renames main.txt to temp.txt and temp.txt to main.txt
  procedure SwitchNames();
  begin
    if not RenameFile('temp.txt', 'main1.txt') then
      Writeln('Errors happen, notify me please');

    if not RenameFile('main.txt', 'temp.txt') then
      Writeln('Errors happen, notify me please');

    if not RenameFile('main1.txt', 'main.txt') then
      Writeln('Errors happen, notify me please');
  end;

  procedure InsertWordToSection();
  var
    input, front, back, reading: string;
    ThisSection: boolean;
  begin
    ThisSection := False;
    AssignFile(main, 'main.txt');
    AssignFile(temp, 'temp.txt');
    Rewrite(temp);
    Reset(main);

    section := '#' + section;

    while not EOF(main) do
    begin
      readln(main, reading);

      if (reading[1] = '#') and (ThisSection) then
      begin
        repeat
          writeln('Write front side of your card');
          readln(front);
          writeln('Write back side of your card');
          readln(back);
          input := front + '-->' + back;
          writeln(temp, input);

          writeln('Do you want to add another card?');
          writeln('1 Yes');
          writeln('0 No');
          readln(input);
        until input = '0';
        ThisSection := False;
      end
      else if reading = section then
        ThisSection := True;
      writeln(temp, reading);
    end;

    Close(main);
    Close(temp);
    SwitchNames();
  end;

  // prints each word in section
  procedure PrintSection(section: string);
  var
    reading: string;
    counter: integer;
  begin
    AssignFile(main, 'main.txt');
    Reset(main);

    section := '#' + section;
    while (not EOF(main)) and (reading <> section) do
    begin
      readln(main, reading);
    end;
    readln(main, reading);
    counter := 1;
    while (not EOF(main)) and (reading[1] <> '#') do
    begin
      writeln(counter, ' ', reading);
      readln(main, reading);
      Inc(counter);
    end;
    Close(main);
  end;

  procedure DeleteWordInSection();
  var
    reading: string;
    i, ValWord: integer;
  begin
    Assign(main, 'main.txt');
    Assign(temp, 'temp.txt');

    ClrScr;
    PrintSection(section);
    writeln('What word do you want to edit?');
    Readln(ValWord);

    reset(main);
    rewrite(temp);

    readln(main, reading);
    while (not EOF(main) and (reading <> ('#' + section))) do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;

    i := 0;
    while ((not EOF(main)) and (i < ValWord)) do
    begin
      writeln(temp, reading);
      readln(main, reading);
      Inc(i);
    end;

    readln(main, reading);
    while (not EOF(main)) do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;
    writeln(temp, reading);
    Close(main);
    Close(temp);
    SwitchNames();
  end;

  procedure EditWordInSection();
  var
    front, back, input, reading: string;
    i, ValWord: integer;
  begin
    Assign(main, 'main.txt');
    Assign(temp, 'temp.txt');

    ClrScr;
    PrintSection(section);
    writeln('What word do you want to delete?');
    Readln(ValWord);

    reset(main);
    rewrite(temp);

    readln(main, reading);
    while (not EOF(main) and (reading <> ('#' + section))) do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;

    i := 0;
    while ((not EOF(main)) and (i < ValWord)) do
    begin
      writeln(temp, reading);
      readln(main, reading);
      Inc(i);
    end;

    i := FindArrow(reading);
    front := copy(reading, 1, i - 1);
    back := copy(reading, i + 3, 255);
    ClrScr;
    writeln(reading);
    Writeln('Do you want to edit front text?');
    Writeln('* Enter text to edit');
    Writeln('0 No');
    readln(input);

    if input <> '0' then
      front := input;

    Writeln('Do you want to edit back text?');
    Writeln('* Enter text to edit');
    Writeln('0 No');
    readln(input);

    if input <> '0' then
      back := input;

    reading := front + '-->' + back;

    while (not EOF(main)) do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;
    writeln(temp, reading);
    Close(main);
    Close(temp);
    SwitchNames();
  end;

  procedure InsertSection();
  var
    reading, SectionName: string;
  begin
    AssignFile(main, 'main.txt');
    AssignFile(temp, 'temp.txt');
    Rewrite(temp);
    Reset(main);

    readln(main, reading);
    writeln(temp, reading);
    readln(main, reading);
    while (not EOF(main)) and (reading <> '.') do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;

    writeln('Insert name of your new section');
    readln(SectionName);
    writeln(temp, SectionName);
    writeln(temp, '.');
    writeln;

    readln(main, reading);
    while (not EOF(main)) and (reading <> '#') do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;
    writeln(temp, reading, SectionName);

    writeln('exit insert mode with "end."');
    writeln;
    writeln('Write front side of your card');
    readln(reading);
    while reading <> 'end.' do
    begin
      Write(temp, reading, '-->');
      writeln('Write back side of your card');
      readln(reading);
      writeln(temp, reading);
      writeln('Write front side of your card');
      readln(reading);
    end;
    writeln(temp, '#');
    Close(main);
    Close(temp);
    SwitchNames();
    Writeln('Saved!');
  end;

  procedure RenameSection();
  var
    input, reading: string;
  begin
    Assign(main, 'main.txt');
    Assign(temp, 'temp.txt');

    ClrScr;
    PrintSection(section);
    writeln('Choose unique name to rename section');
    readln(input);

    reset(main);
    readln(main, reading);
    readln(main, reading);
    while (not EOF(main) and (reading <> '.') and (input <> reading)) do
    begin
      readln(main, reading);
    end;

    if (input = reading) then
    begin
      writeln('Choose UNIQUE name to rename section');
      readln(input);

      reset(main);
      readln(main, reading);
      readln(main, reading);
      while (not EOF(main) and (reading <> '.') and (input <> reading)) do
      begin
        readln(main, reading);
      end;
    end;


    if (input <> reading) then
    begin

      reset(main);
      rewrite(temp);

      readln(main, reading);
      while (not EOF(main) and (reading <> section)) do
      begin
        writeln(temp, reading);
        readln(main, reading);
      end;

      readln(main, reading);
      writeln(temp, input);
      while (not EOF(main) and (reading <> ('#' + section))) do
      begin
        writeln(temp, reading);
        readln(main, reading);
      end;

      readln(main, reading);
      writeln(temp, '#' + input);
      while (not EOF(main)) do
      begin
        writeln(temp, reading);
        readln(main, reading);
      end;
      writeln(temp, reading);

      Close(main);
      Close(temp);
      SwitchNames();

    end
    else
    begin
      writeln('Name not changed');
      writeln('Press key to continue');
      readln;
    end;
  end;

  procedure DeleteSection(SectionName: string);
  var
    reading: string;
  begin
    Assign(main, 'main.txt');
    Assign(temp, 'temp.txt');
    Reset(main);
    Rewrite(temp);

    readln(main, reading);
    while (not EOF(main)) and (reading <> SectionName) do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;

    readln(main, reading);
    while (not EOF(main)) and (reading <> ('#' + SectionName)) do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;

    readln(main, reading);
    while (not EOF(main)) and (reading[1] <> '#') do
    begin
      readln(main, reading);
    end;

    while (not EOF(main)) do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;

    writeln(temp, reading);

    Close(main);
    Close(temp);
    SwitchNames();
  end;

  // Loads words from section to list
  function PrepareGame(section: string): PFlash;
  var
    counter: integer;
    reading: string;
    beggining, card: PFlash;
  begin
    Assign(main, 'main.txt');
    Reset(main);
    readln(main, reading);
    while (not EOF(main) and (reading <> ('#' + section))) do
    begin
      readln(main, reading);
    end;

    readln(main, reading);
    new(card);
    beggining := card;
    counter := Findarrow(reading);
    card^.Front := copy(reading, 1, counter - 1);
    card^.Back := copy(reading, counter + 3, 255);

    readln(main, reading);
    while ((not EOF(main)) and (reading[1] <> '#')) do
    begin
      new(card^.Next);
      card := card^.Next;
      counter := Findarrow(reading);
      card^.Front := copy(reading, 1, counter - 1);
      card^.Back := copy(reading, counter + 3, 255);
      readln(main, reading);
    end;

    card^.Next := beggining;
    Result := card;
    Close(main);
  end;

  function ChooseSection(): string;
  var
    First, ListOfSections: PList;
    ChosenSection, i, counter: integer;
    reading: string;
  begin
    Assign(main, 'main.txt');
    Reset(main);
    counter := 1;

    Writeln('Choose section');

    new(ListOfSections);
    First := ListOfSections;
    readln(main, reading);
    readln(main, reading);
    ListOfSections^.Name := reading;


    while ((not EOF(main)) and (reading <> '.')) do
    begin
      new(ListOfSections^.Next);
      ListOfSections := ListOfSections^.Next;
      ListOfSections^.Name := reading;
      writeln(counter, ' ', reading);
      readln(main, reading);
      Inc(counter);
    end;
    ListOfSections^.Next := nil;

    readln(ChosenSection);

    for i := 1 to ChosenSection do
    begin
      First := First^.Next;
    end;
    Result := First^.Name;
    Close(main);
  end;

  function Gameplay(SecondTry: boolean): boolean;
  var
    Answer: string;
    First: boolean;
    current, firstcar, correction: PFlash;
  begin
    First := True;
    while (FirstCard^.Next <> nil) do
    begin
      ClrScr;

      current := FirstCard^.Next;

      if FirstCard^.Next^.Next <> FirstCard^.Next then
        FirstCard^.Next := FirstCard^.Next^.Next
      else
        FirstCard^.Next^.Next := nil;

      current^.Next := nil;

      writeln(current^.Front);
      writeln('---------------');
      readln(Answer);

      if (Answer = current^.Back) then
      begin
        writeln('Correct!');
        dispose(current);
      end
      else
      begin
        writeln('Incorrect :( Correct answer is: ', current^.Back);
        if First = True then
        begin
          First := False;

          new(correction);
          new(firstcar);
          correction := current;
          firstcar := correction;
        end
        else
        begin
          correction^.Next := current;
          correction := correction^.Next;
        end;
      end;

      writeln('Press enter to continue');
      readln;
    end;

    ClrScr;
    if First = True then
    begin
      Writeln('Perfect Score!');
      Result := False;
    end
    else if (SecondTry = False) then
    begin
      writeln('Do you want to replay with incorrect cards?');
      writeln('1 Yes');
      writeln('2 No');
      readln(Answer);
      if Answer = '1' then
      begin
        Result := True;

        correction^.Next := firstcar;

        FirstCard := correction;
      end
      else
        Result := False;
    end
    else
      Writeln('Better luck next time, Repetition is the mother of wisdom!');

    Writeln('Press enter to continue...');
    readln;
  end;

  // enables second calling of Gameplay()
  procedure Game();
  var
    section: string;
  begin
    section := ChooseSection;
    FirstCard := PrepareGame(section);
    ClrScr;

    if gameplay(False) = True then
      gameplay(True);

  end;

  procedure LoadFile();
  var
    reading, filename: string;
    loading: TextFile;
  begin
    Assign(main, 'main.txt');
    Assign(temp, 'temp.txt');
    Reset(main);
    Rewrite(temp);

    Writeln('Move file to this directory, press enter to continue');
    readln;
    Writeln('write name of your text file (without ".txt")');
    readln(filename);
    Assign(loading, filename + '.txt');
    Reset(loading);

    Writeln('Select name for your section');
    readln(filename);

    readln(main, reading);
    writeln(temp, reading);

    readln(main, reading);
    while ((not EOF(main)) and (reading <> '.')) do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;
    writeln(temp, filename);

    while ((not EOF(main)) and (reading <> '#')) do
    begin
      writeln(temp, reading);
      readln(main, reading);
    end;
    writeln(temp, '#' + filename);



    while (not EOF(loading)) do
    begin
      readln(loading, reading);
      writeln(temp, reading);
    end;

    writeln(temp, '#');
    Close(main);
    Close(temp);
    Close(loading);
    SwitchNames;
    writeln('Finished');
  end;

begin
  repeat  // repeating cycle (Main Menu) until '0' is entered
    ClrScr;
    Writeln('FlashCards <3');
    Writeln('---------------');
    Writeln('1 Start Game');
    Writeln('2 Edit Section');
    Writeln('3 Load Section');
    Writeln('4 Tutorial');
    Writeln('0 Exit');
    readln(ValMenu);
    ClrScr;
    case ValMenu of
      '1': // Start Game
      begin
        Game();
      end;
      '2': // Edit Section
      begin
        section := ChooseSection;
        ClrScr;
        PrintSection(section);
        Writeln('What now?');
        Writeln('1 Edit word');
        Writeln('2 Add word');
        Writeln('3 Delete word');
        Writeln('4 Rename section');
        Writeln('5 Delete section');
        readln(ValEdit);
        case ValEdit of
          '1': EditWordInSection;
          '2': InsertWordToSection;
          '3': DeleteWordInSection;
          '4': RenameSection;
          '5': DeleteSection(section);
        end;
      end;
      '3': // Load Section
      begin
        Writeln('Choose type of loading');
        Writeln('1 Load manually');
        Writeln('2 Import from text file');
        readln(i);
        case i of
          '1': InsertSection;
          '2': LoadFile;
        end;
      end;
      '4': // Tutorial
      begin
        Writeln('-----TUTORIAL-----');
        Writeln('-----TUTORIAL-----');
        Writeln('Press enter to continue to main menu');
        readln;
      end;
      '0': // Exit
      begin
        WriteLn('Goodnight');
        Writeln('press enter to exit');
        readln;
      end
      else
        ClrScr;
        Writeln('choose correct option!');
    end;
  until ValMenu = '0';
end.
