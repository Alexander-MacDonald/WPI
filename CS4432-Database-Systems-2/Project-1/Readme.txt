Alexander MacDonald
251091836

SECTION 1: Compilation & Execution Instructions
Compile inline:
    1. javac Main.java
    2. java Main <n>
        n is an integer and the size of the buffer pool

There are 7 Commands for this program:
    1. HELP
        Displays all commands for the program
    2. EXIT
        Exits program (does not save sets as sets are saved when the buffer pool brings in new blocks to memory)
    3. PRINT
        Prints all blocks in memory (Displays base info if frame is empty0
    4. GET recordNum
        Gets info regarding record <recordNum>
    5. SET recordNum "exampleString"
        Sets content of record <recordNum> to specified string
    6. PIN blockNum
        Pins block with blockID <blockNum>
    7. UNPIN blockNum
        Unpins block with blockID <blockNum>

SECTION 2: Test Cases
!! Output has been tabbed for legibility !!

..\DB2\Project1V2> cd src
..\DB2\Project1V2\src>
..\DB2\Project1V2\src> javac Main.java
..\DB2\Project1V2\src> java Main 3
    OUTPUT: Initialized Buffer Pool Size: 3
The program is ready for the next command:
Set 430 "F05-Rec450, Jane Do, 10 Hill Rd, age020."
    OUTPUT: Brought Block #5 into Frame #1
    OUTPUT: Record #430: F05-Rec430, Name430, address430, age430
    OUTPUT: CHANGED TO
    OUTPUT: Record #430: F05-Rec450, Jane Do, 10 Hill Rd, age020.
The program is ready for the next command:
Get 430
    OUTPUT: The corresponding block #5 already exist in frame #1
    OUTPUT: Record #430: F05-Rec450, Jane Do, 10 Hill Rd, age020
The program is ready for the next command:
Get 20
    OUTPUT: Brought Block #1 into Frame #2
    OUTPUT: Record #20: F01-Rec020, Name020, address020, age020
The program is ready for the next command:
Set 430 "F05-Rec450, John Do, 23 Lake Ln, age056."
    OUTPUT: The corresponding block #5 already exist in frame #1
    OUTPUT: Record #430:
    OUTPUT: CHANGED TO
    OUTPUT: Record #430: F05-Rec450, John Do, 23 Lake Ln, age056.
The program is ready for the next command:
Pin 5
    OUTPUT: File 5 pinned in Frame #1; Not already pinned
The program is ready for the next command:
Unpin 3
    OUTPUT: The corresponding block 3 cannot be unpinned because it is not in memory
The program is ready for the next command:
Get 430
    OUTPUT: The corresponding block #5 already exist in frame #1
    OUTPUT: Record #430: F05-Rec450, John Do, 23 Lake Ln, age056
The program is ready for the next command:
Pin 5
    OUTPUT: File 5 pinned in Frame #1; Already pinned
The program is ready for the next command:
Get 646
    OUTPUT: Brought Block #7 into Frame #3
    OUTPUT: Record #646: F07-Rec646, Name646, address646, age646
The program is ready for the next command:
Pin 3
    OUTPUT: Removed block #1 from frame #2
    OUTPUT: No data writing necessary
    OUTPUT: Brought Block #3 into Frame #2
The program is ready for the next command:
Set 10 "F01-Rec010, Tim Boe, 09 Deer Dr, age009."
    OUTPUT: Removed block #7 from frame #3
    OUTPUT: No data writing necessary
    OUTPUT: Brought Block #1 into Frame #3
    OUTPUT: Record #10: F01-Rec010, Name010, address010, age010
    OUTPUT: CHANGED TO
    OUTPUT: Record #10: F01-Rec010, Tim Boe, 09 Deer Dr, age009.
The program is ready for the next command:
Unpin 1
    OUTPUT: File 1 unpinned in Frame #3; Already unpinned
The program is ready for the next command:
Get 355
    OUTPUT: Removed block #1 from frame #3
    OUTPUT: Wrote block #1 data to disk
    OUTPUT: Brought Block #4 into Frame #3
    OUTPUT: Record #355: F04-Rec355, Name355, address355, age355
The program is ready for the next command:
Pin 2
    OUTPUT: Removed block #4 from frame #3
    OUTPUT: No data writing necessary
    OUTPUT: Brought Block #2 into Frame #3
The program is ready for the next command:
Get 156
    OUTPUT: The corresponding block #2 already exist in frame #3
    OUTPUT: Record #156: F02-Rec156, Name156, address156, age156
The program is ready for the next command:
Set 10 "F01-Rec010, No Work, 31 Hill St, age100."
    OUTPUT: The corresponding block #1 cannot be accessed from disk because the memory buffers are full; Write was unsuccessful
The program is ready for the next command:
Pin 7
    OUTPUT: The corresponding block #7 cannot be accessed from disk because the memory buffers are full; Pin was unsuccessful
The program is ready for the next command:
Get 10
    OUTPUT: The corresponding block #1 cannot be accessed from disk because the memory buffers are full; Read was unsuccessful
The program is ready for the next command:
Unpin 3
    OUTPUT: File 3 unpinned in Frame #2; Not already unpinned
The program is ready for the next command:
Unpin 2
    OUTPUT: File 2 unpinned in Frame #3; Not already unpinned
The program is ready for the next command:
Get 10
    OUTPUT: Removed block #3 from frame #2
    OUTPUT: No data writing necessary
    OUTPUT: Brought Block #1 into Frame #2
    OUTPUT: Record #10: F01-Rec010, Tim Boe, 09 Deer Dr, age009
The program is ready for the next command:
Pin 6
    OUTPUT: Removed block #2 from frame #3
    OUTPUT: No data writing necessary
    OUTPUT: Brought Block #6 into Frame #3
The program is ready for the next command:
exit
    OUTPUT: Exiting Program

SECTION 3: Design Decisions Beyond Specs
    1. Main Class
        LOGIC: Added command handling logic for any case commands as well as data extraction ease
    2. Frame Class
        VARIABLE: Added timestamp variable to make LRU easier to implement
    3. BufferPool Class
        METHOD: getFile
            returns file # based on record # - made reading & writing easier
        METHOD: printFrames
            prints all frames' data - made debugging easier
