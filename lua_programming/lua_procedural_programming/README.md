# Lua Procedural Programming

## Principles
- Seperated data and code, avoid OOP
- Data have no private fields (can field with _ prefix to mark as avoid modified without clear purposes)
- Define data as transparent fields table, when reading code you can see structure of data
- Function just do logic and transform data
- Avoid object and interface if you don't really needed. Every problems can be still solve by concrete code
- Avoid generic function too, don't make you function work on many type paremeters if you don't really needed
- Thinking deeply, you will see theses rules like Data Oriented Programming (the book), but truely just solve the problems, avoid dogma
- By making function handle logic, we can enhance theses rules with Goal-oriented programming (work perfect for gamedev, see Hades game Lua scripts)
- And about Luau or type hint language compile to Lua, if you can follow theses rules, type hint maybe just optional

## But without OOP, we hard to implement bindings
- Nope, basically, bindings without metatable, the performance can be better
- Function call make the code clear more than method call
- If you don't need method, you can use lightuserdata for more performance, no need to deference to get and pointer and deference again to get data

## Compressing-oriented programming
- Simple ideas: Just code what you need to solve the problem first. Then if the code repeat many times, make a function for it. Done!
- Note: you do not need to replace the repeat with function immediately, just fill the features into the game/app. You can do refactor later! (This is what refactor mean, for later after the problems are really solved)

## Goal-oriented programming
- One of most important goal of all scripting language. But they don't tell you about this much.
- Work very well with DoP or Functional
- Both theses styles can be use as extended procedural programming
- And Goal-oriented programming are perfect for gamedev and complex state application
- State machine, behaviour, logic programming,... all is about goal-oriented
- If you follow procedural programming, seperated data and code, you can do GoP easily
- Let examples: 
    - Define event handle with On<EventName> function, register for what type of event
    - Define state of enemy with transparent table
    - Use function to update state, handle logic
    - In GUI, just define a function, and call it when have appreciate user input
- It's too much simple, that I cant define this programming paradigm is exactly sentence, just try it yourself\

## Conclusion
You see, nothing are needed of OOP, they are just data and code. You need data to work with, you need code to make the data moving/transforming. Scripting (GoP or DoP), is creating scenario how your game/app can behave, and what the users will interacting with.

## Additional resources
- [Lua programming paradigms](https://www.inf.puc-rio.br/~roberto/docs/ry09-03.pdf)