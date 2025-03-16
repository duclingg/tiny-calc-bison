# tiny-calc-bison
Justin Hoang  

## Flex vs Yacc/Bison Comparison
With flex alone, it was diffcult to properly handle complex expression grammar with nested structures and precedence rules. In the HW2 implementation, I used state varaibles and complex conditional logic to track the parsing state. With yacc/bison we can define a formal grammar that naturally handles these structures. 
1. Operator Precedence  
By declaratively defining operator precedence using directives like `%left`, `%right`, and `%nonassoc`, it makes the implementation cleaner and less error-prone.
2. Nested Expressions with Parentheses  
With yacc/bison, we can easily define recursive grammar rules.  
`factor: NUMBER | LPAREN expr RPAREN | ...`
3. Error Recovery  
With yacc/bison we can detect and recover from syntactic errors with the error token and `yyerrok` mechanism, allowing the calculator to continue processing after encountering an error. In flex, error handling was limited to detecting and reporting errors at the token level.
4. Variable Management  
yacc/bison allows proper integration of variable declarations and references in the grammar.
5. Abstract Syntax Tree  
Flex alone cannot build a proper parse tree or abstract syntax tree. With yacc/bison, we can naturally construct a syntax tree through the grammar rules and semantic actions, making evaluation of complex expressions more straight forward. (Used ChatGPT for help with this answer)
6. Type Checking  
In yacc/bison, we can use the `%union` directive to define different types of values, allowing for proper type checking and conversion. This is much harder to implement correct in flex alone.

## Program
This program uses `(f)lex` and `yacc/bison` to process arthimetic expressions and variable assignments. It supports:  
1. Basic Arthimetic Operations  
    - Addition (+)
    - Subtraction (-)
    - Multiplication (*)
    - Division (/)
    - Exponentiation (^)
2. Variable Management  
Defining and using variables in expressions.  
3. Expression Evaluation  
Respects standard operator precedence and associativity rules.  
4. Error Handling  
Detecting and reporting syntax errors, undefined variables, and divison by zero.  

## How it works
This calculator is implemented using two tools:  
1. `(f)lex` (lexical analyzer) which breaks the input into tokens
2. `yacc/bison` (parser generator) which defines the grammar and evaluation rules

### Parsing with yacc/bison
The `tiny-calc.y` file defines the grammar rules and the actions to take when those rules are matched.  
1. Token declarations  
Define the types of tokens that can appear in the input
2. Precedence rules  
Specify how operators associate and their relative precedence
3. Grammar rules  
Define how tokens can be combined into valid expressions
4. Semantic actions  
Code that executes when a rule is matched, typically calculating values  

The parser works through the input bottom-up, combining tokens into larger grammatical structures according to the rules. This naturally handles operator precedence and nested expressions. 

### Program Flow
1. Initialization: The `main()` function starts the parser and displays the initial prompt
2. Tokenization: `(f)lex` breaks the input into tokens (numbers, operators, etc.)
3. Parsing: `yacc/bison` applies grammar rules to the token stream
4. Evaluation: As rules are matched, the associated semantic actions calculate results
5. Ouput: Results are displayed to the user
6. Loop: The program continues accepting and processing input

## How to Run
1. Navigate to the project directory `tiny-calc-bison`  
`cd tiny-calc-bison`  
2. Run the command `make` in the Terminal
   - The program will compile the necessary components
3. Start the program using `make run`
   - This starts the program for the user
4. The program will take in a single line input: an arthimetic expression, variable definition
   - It will either calculate the given expression (if accepted), or store the variable definition (if accepted)
5. The exit the program, enter `control + c` (Mac) in the Terminal
6. To start the program again, run `make clean` in the Terminal. Then go through steps 2-4 again.

## Example Output
![image](<Screenshot 2025-03-16 at 14.26.49.png>)