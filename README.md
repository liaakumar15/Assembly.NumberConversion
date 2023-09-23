# Assembly.NumberConversion
//Completed Project for Computer Architecture Course: Fall 2023
//Written in MIPS assembly language for the MARS simulator

Program Outline:
1. Initialize an accumulator (variable or register) to zero.
2. Display a prompt to the user: “Enter a number: “
3. Use the system call function to read a string into a buffer.
4. If the first character in your buffer is the New Line character
A. Go to step 9.
5. If the first character in your buffer is the minus sign, remember that so you can reverse the sign
of the number.
6. Convert the number to a binary integer*, one digit at a time. If there are any characters other
than decimal digits:
A. If it is not a New Line, show an error message and go back to step 2.
B. If it is a new line, continue to 7.
7. Add the binary number to your accumulator.
8. Go to step 2
9. Print the sum of the numbers, the total number of valid numbers entered, and the total number
of errors.
10. Exit the program.

*Conversion to binaryy process:
1. Set an accumulator to 0. 
2. Multiply your accumulator by 10, then add the new digit. 
3. Convert an ASCII digit to binary by subtracting the character 0
4. Program verifies that what was entered was an actual digit, between 0 and 9, inclusive.
5. Program ends this process when it encounters a New Line character.
