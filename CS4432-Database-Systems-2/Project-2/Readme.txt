Alexander MacDonald
251091836

SECTION 1: Compilation & Execution Instructions
Compile inline:
    1. javac Main.java
    2. java Main

There are 4 commands in this program with some variations:
1. EXIT
    Exits program
2. PRINT
    Prints out indices if they are created
3. CREATE INDEX ON Project2Dataset (RandomV)
    The specs did not specify that more needed to be required as the directory & column name are static
    so technically all you need is "create index on" to get the command to work.
4. SELECT * FROM Project2Dataset WHERE ...
    4a. RandomV = 915
    4b. RandomV != 915
    4c. RandomV > 20 AND RandomV < 25
        As long as argc (# of args) matches the base case the command will function. The specs did not specify more
        in depth implementation and range is EXCLUSIVE according to the specs.
        ex:
            Equality, argc = 8 (delimiter = " ")
            Inequality, argc = 8 (delimiter = " ")
            Range, argc = 12 (delimited = " ")
        Example commands can be found in "exampleCommands.txt" which were more or less copied from the specs

SECTION 2: Test Cases
As of 4:57 PM 4/18/2023 there were no test cases provided

As far as I can tell there are no issues with this program from my testing

SECTION 3: Design Decisions Beyond Specs
    1. Helper Functions
        Simple exit and print functions for debugging and QOL
